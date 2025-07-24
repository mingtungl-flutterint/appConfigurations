-- Isp_DenmarkDailyReport.sql
--

with ItgBetIds as
(
        select          unique T.itgBetId
        from            Isp_WalletApi_Transacts         W
        join            Isp_MainDbm_Transacts           T on T.itgWapiTransId=W.itgWapiTransId
        join            Isp_Bets                        B on B.itgBetId=T.itgBetId
        left join       Isp_BsOrders                    O on O.externalCorrelationId=B.ispCorrelationId
        where           W.utcWhenReceived between '${start}$' and '${end}$'
                        and W.wapiTransStatus=1 -- enum Isp_WapiTransStatus::Status::Accepted
                        and W.licenseId=256 -- enum LicenceId::eLicenceDenmark
						and (${excludeTestAccounts}$ = 0
						or exists(select 1
								  from Users U
								  where U.userIntId=W.userIntId
									and bitand(U.privileges, 128) = 0 -- privAdmin
									and bitand(U.privileges2, 512+2305843009213693952+33554432+2251799813685248) = 0) -- priv2PSRelated+priv2NjTesting+priv2BetaTester+priv2BizAccount)
									)
						and (${excludeReconciledBets}$ = 0 or O.externalCorrelationId is not null) -- O.externalCorrelationId is null for reconciled bet
)
select          I.itgBetId, W.itgWapiTransId, W.reqType, W.utcWhenReceived, W.flags, W.licenseId, T.amount, T.currency
from            ItgBetIds               I
join            Isp_MainDbm_Transacts   T       on T.itgBetId=I.itgBetId
join            Isp_WalletApi_Transacts W       on W.itgWapiTransId=T.itgWapiTransId
                                                and W.wapiTransStatus=1 -- enum Isp_WapiTransStatus::Status::Accepted
                                                and W.utcWhenReceived <= '${end}$'
order by        I.itgBetId ASC, W.itgWapiTransId DESC
;

