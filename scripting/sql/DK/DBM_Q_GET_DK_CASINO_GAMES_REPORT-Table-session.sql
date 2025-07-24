-- SelectXcGamesCompletedForPeriodStmtsql
-- DBM_Q_GET_DK_CASINO_GAMES_REPORT

-- SelectXcGamesCompletedForPeriodStmt stmt(*this, dbmObj->getDynSqlHelper(), eLicenceDenmark, start, end, excludeTestAccounts);
-- class SelectXcGamesCompletedForPeriodStmt : public SelectXcGamesBaseStmt

-- start: 2024-07-30 20:00:00
-- end:   2024-07-31 19:59:59

DECLARE GLOBAL TEMPORARY TABLE SESSION.temp_RMCOMPLETEDGAMES
(
    gameId 				BIGINT NOT NULL,
    userIntId			INTEGER NOT NULL,
    xcLoginId			BIGINT NOT NULL,
    tableId 			BIGINT NOT NULL,
    tableTypeId 		INTEGER NOT NULL,
    gameTypeId 			SMALLINT NOT NULL,
    isPlayMoney 		BOOLEAN NOT NULL,
    currency 			VARCHAR(4) NOT NULL,
    reservedFunds 		INTEGER NOT NULL,
    flags INTEGER 		NOT NULL,
    restoreGameId 		BIGINT NOT NULL,
    ipAddr 				VARCHAR(40) NOT NULL,
    psLoginId 			BIGINT NOT NULL,
    xcStarted 			TIMESTAMP NOT NULL,
    psStarted 			TIMESTAMP NOT NULL,
    xcCompleted 		TIMESTAMP NOT NULL,
    psCompleted 		TIMESTAMP NOT NULL,
    status 				SMALLINT NOT NULL,
    unresolvedBet 		INTEGER NOT NULL,
    lastHandId 			BIGINT NOT NULL,
    selfLimit 			INTEGER NOT NULL,
    termCode 			SMALLINT NOT NULL,
    errCode 			SMALLINT NOT NULL,
    variantType 		SMALLINT NOT NULL,
    minBet 				INTEGER NOT NULL,
    userRollId 			INTEGER NOT NULL,
    rollReservedFunds 	INTEGER NOT NULL,
    rollUnresolvedBet 	INTEGER NOT NULL,
    specialAmount 		INTEGER NOT NULL,
    allocated 			BIGINT NOT NULL,
    brandId 			INTEGER NOT NULL,
    appLoginId 			BIGINT NOT NULL,
    lastHandStarted 	TIMESTAMP NOT NULL,
    unresolvedWin 		BIGINT NOT NULL,
    rollUnresolvedWin 	INTEGER NOT NULL,
    licenseId 			INTEGER NOT NULL,
    rollAllocated 		INTEGER NOT NULL,
    jpUnresolvedWin 	BIGINT NOT NULL,
    HANDSCOUNT          BIGINT NOT NULL,
    HANDSTRANSCOUNT     BIGINT NOT NULL,
    GAMEBETS            BIGINT NOT NULL,
    GAMEREWARDS         BIGINT NOT NULL,
    JACKPOTTOTALCONTRIB BIGINT NOT NULL,
    JACKPOTTOTALWIN     BIGINT NOT NULL

)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.temp_RMCOMPLETEDGAMES
WITH RMCOMPLETEDGAMES AS
(
  SELECT
    G.GAMEID
   ,G.USERINTID
   ,G.XCLOGINID
   ,G.TABLEID
   ,G.TABLETYPEID
   ,G.GAMETYPEID
   ,G.ISPLAYMONEY
   ,G.CURRENCY
   ,G.RESERVEDFUNDS
   ,G.FLAGS
   ,G.RESTOREGAMEID
   ,G.IPADDR
   ,G.PSLOGINID
   ,G.XCSTARTED
   ,G.PSSTARTED
   ,G.XCCOMPLETED
   ,G.PSCOMPLETED
   ,G.STATUS
   ,G.UNRESOLVEDBET
   ,G.LASTHANDID
   ,G.SELFLIMIT
   ,G.TERMCODE
   ,G.ERRCODE
   ,G.VARIANTTYPE
   ,G.MINBET
   ,G.USERROLLID
   ,G.ROLLRESERVEDFUNDS
   ,G.ROLLUNRESOLVEDBET
   ,G.SPECIALAMOUNT
   ,G.ALLOCATED
   ,G.BRANDID
   ,G.APPLOGINID
   ,G.LASTHANDSTARTED
   ,G.UNRESOLVEDWIN
   ,G.ROLLUNRESOLVEDWIN
   ,U.LICENSEID
   ,G.ROLLALLOCATED
   ,G.JPUNRESOLVEDWIN
   -- insert new XcGames columns here
  FROM XCGAMES G
  JOIN USERFIRSTTIMEEVENTS UFTE ON G.USERINTID=UFTE.USERINTID
  JOIN USERS U ON G.USERINTID=U.USERINTID AND U.LICENSEID=UFTE.LICENSEID
	AND (${excludeTestAccounts}$ = 0
			or
			(
				bitand(U.privileges, 128) = 0 -- privAdmin
				and bitand(U.privileges2, 512+2305843009213693952+33554432+2251799813685248) = 0 -- priv2PSRelated+priv2NjTesting+priv2BetaTester+priv2BizAccount)
			)
		)
  WHERE U.LICENSEID=256 --@LICENSE_ID@ -- eLicenceDenmark        = ( 1 << 8 ),	//	256
	 AND UFTE.WHEN <= G.PSCOMPLETED
     AND G.ISPLAYMONEY=0 AND G.PSCOMPLETED BETWEEN '${start}$' AND '${end}$'
)
SELECT
    G.GAMEID                                                              GAMEID
   ,MIN(G.USERINTID)                                                      USERINTID
   ,MIN(G.XCLOGINID)                                                      XCLOGINID
   ,MIN(G.TABLEID)                                                        TABLEID
   ,MIN(G.TABLETYPEID)                                                    TABLETYPEID
   ,MIN(G.GAMETYPEID)                                                     GAMETYPEID
   ,MIN(G.ISPLAYMONEY)                                                    ISPLAYMONEY
   ,MIN(G.CURRENCY)                                                       CURRENCY
   ,MIN(G.RESERVEDFUNDS)                                                  RESERVEDFUNDS
   ,MIN(G.FLAGS)                                                          FLAGS
   ,MIN(G.RESTOREGAMEID)                                                  RESTOREGAMEID
   ,MIN(G.IPADDR)                                                         IPADDR
   ,MIN(G.PSLOGINID)                                                      PSLOGINID
   ,MIN(G.XCSTARTED)                                                      XCSTARTED
   ,MIN(G.PSSTARTED)                                                      PSSTARTED
   ,MIN(G.XCCOMPLETED)                                                    XCCOMPLETED
   ,MIN(G.PSCOMPLETED)                                                    PSCOMPLETED
   ,MIN(G.STATUS)                                                         STATUS
   ,MIN(G.UNRESOLVEDBET)                                                  UNRESOLVEDBET
   ,MIN(G.LASTHANDID)                                                     LASTHANDID
   ,MIN(G.SELFLIMIT)                                                      SELFLIMIT
   ,MIN(G.TERMCODE)                                                       TERMCODE
   ,MIN(G.ERRCODE)                                                        ERRCODE
   ,MIN(G.VARIANTTYPE)                                                    VARIANTTYPE
   ,MIN(G.MINBET)                                                         MINBET
   ,MIN(G.USERROLLID)                                                     USERROLLID
   ,MIN(G.ROLLRESERVEDFUNDS)                                              ROLLRESERVEDFUNDS
   ,MIN(G.ROLLUNRESOLVEDBET)                                              ROLLUNRESOLVEDBET
   ,MIN(G.SPECIALAMOUNT)                                                  SPECIALAMOUNT
   ,MIN(G.ALLOCATED)                                                      ALLOCATED
   ,MIN(G.BRANDID)                                                        BRANDID
   ,MIN(G.APPLOGINID)                                                     APPLOGINID
   ,MIN(G.LASTHANDSTARTED)                                                LASTHANDSTARTED
   ,MIN(G.UNRESOLVEDWIN)                                                  UNRESOLVEDWIN
   ,MIN(G.ROLLUNRESOLVEDWIN)                                              ROLLUNRESOLVEDWIN
   ,MIN(G.LICENSEID)                                                      LICENSEID
   ,MIN(G.ROLLALLOCATED)                                                  ROLLALLOCATED
   ,MIN(G.JPUNRESOLVEDWIN)                                                JPUNRESOLVEDWIN

   -- insert new XcGames columns here
   ,COUNT(DISTINCT(T.HANDID))                                             HANDSCOUNT
   ,COUNT                                                                 HANDSTRANSCOUNT
   ,SUM(CASE WHEN T.TRANSTYPE=1 THEN BIGINT(T.DELTAGAME) ELSE 0 END)      GAMEBETS
   ,SUM(CASE WHEN T.TRANSTYPE=2 THEN BIGINT(T.DELTAGAME) ELSE 0 END)      GAMEREWARDS
   ,MIN(VALUE((SELECT SUM(TOTALCONTRIB) FROM XCGAMEJACKPOTS WHERE GAMEID = G.GAMEID),0))          JACKPOTTOTALCONTRIB
   ,MIN(VALUE((SELECT SUM(TOTALWIN) FROM XCGAMEJACKPOTS WHERE GAMEID = G.GAMEID),0))              JACKPOTTOTALWIN
FROM XCTRANS T
JOIN RMCOMPLETEDGAMES G ON T.GAMEID=G.GAMEID
WHERE T.TRANSTYPE in (1,2) -- either bet or hand result (equals to filter handid!=0)
      AND T.ERRCODE=0 -- PYR-45426 don't count in rejected bets (pays are never rejected)
      AND G.STATUS<>9 -- PYR-188112: exclude purged games (eXcGameStatus_AdminForceRemoved)
GROUP BY G.GAMEID
ORDER BY CURRENCY
;

select sum(t.handscount) handscount
    , sum(t.gamebets) gamebets
    , sum(t.gamerewards) rewards
    , sum(t.jackpottotalcontrib) jpcontrib
    , sum(t.jackpottotalwin) jpwin
    , 'single' gametype
from SESSION.temp_RMCOMPLETEDGAMES
where bitand(t.flags, 128)=0
group by t.currency
;

select sum(t.handscount) handscount
    , sum(t.gamebets) gamebets
    , sum(t.gamerewards) rewards
    , sum(t.jackpottotalcontrib) jpcontrib
    , sum(t.jackpottotalwin) jpwin
    , 'multi' gametype
from SESSION.temp_RMCOMPLETEDGAMES
where bitand(t.flags, 128)=128
group by t.currency
;

drop TABLE SESSION.temp_RMCOMPLETEDGAMES;
