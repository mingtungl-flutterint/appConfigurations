-- sportbooks_reportdenmarkdaily.sql
-- DBM_Q_GET_DK_SPORSBOOK_REPORT
--
with DistinctConclusions as
(
     select distinct refId as betId
       from SB_WALLETAPI_TRANSACTS  as W
 inner join SB_BETS as B on B.betId=W.refId
      where W.createTime between '${start}' and '${end}'
        and W.tranType in (7202,7205,7206,7208) and B.licenseId = ${licenseId}
		and (${excludeTestAccounts} = 0
			or exists(select 1
					  from Users U
                      where U.userIntId=W.userIntId
						and bitand(U.privileges, 128) = 0 -- privAdmin
                        and bitand(U.privileges2, 512+2305843009213693952+33554432+2251799813685248) = 0 -- priv2PSRelated+priv2NjTesting+priv2BetaTester+priv2BizAccount)
					 )
		    )
)
, ConclusionHistory as
(
     select Y.betId, W.userIntId, W.transactionId, W.tranType, W.createTime, W.cashAmount, W.currency, 0 as clientPlatform, null as expectSettle
       from DistinctConclusions     as Y
  left join SB_WALLETAPI_TRANSACTS  as W on Y.betId=W.refId and W.tranType in (7202,7205,7206,7208)
)
, OldPlacements as
(
     select Y.betId, W.userIntId, W.transactionId, W.tranType, W.createTime, B.cashAmount, W.currency, B.clientPlatform, B.expectSettle
       from DistinctConclusions     as Y
 inner join SB_BETS                 as B on Y.betId=B.betId
 inner join SB_PARENTBETS           as P on B.parentBetId = P.parentBetId
 inner join SB_BETSLIPS             as S on S.betSlipId = P.betSlipId
 inner join SB_WALLETAPI_TRANSACTS  as W on W.refId = S.betSlipId and W.tranWAPI = S.tranWAPI
      where W.createTime < '${start}' and W.tranType = 7201
)
, NewPlacements as
(
     select B.betId, W.userIntId, W.transactionId, W.tranType, W.createTime, B.cashAmount, W.currency, B.clientPlatform, B.expectSettle
       from SB_WALLETAPI_TRANSACTS  as W
 inner join SB_BETSLIPS             as S on S.betSlipId = W.refId and W.tranWAPI = S.tranWAPI
 inner join SB_PARENTBETS           as P on S.betSlipId = P.betSlipId
 inner join SB_BETS                 as B on B.parentBetId = P.parentBetId
      where W.createTime between '${start}' and '${end}'
        and W.tranType = 7201 and S.licenseId = ${licenseId} and B.licenseId = ${licenseId}
		and (${excludeTestAccounts} = 0
			or exists(select 1
					  from Users U
                      where U.userIntId=W.userIntId
						and bitand(U.privileges, 128) = 0 -- privAdmin
                        and bitand(U.privileges2, 512+2305843009213693952+33554432+2251799813685248) = 0 -- priv2PSRelated+priv2NjTesting+priv2BetaTester+priv2BizAccount)
					 )
			)
)
          select * from OldPlacements
union all select * from NewPlacements
union all select * from ConclusionHistory
        order by betId, transactionId
;
