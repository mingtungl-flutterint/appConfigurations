-- DBM_Q_GET_PT_EXTENDED_LIABILITY.sql
--
-- Reportable balance for Portugal:
-- Money on bankroll +
-- money on table (allocated) +
-- money in unfinished xcGames (reserved + bet)
-- money in unfinished sport games
--
-- start = start of day in PT (Western European Time zone)
-- end   = start of next day in PT
-- convert start & end to ET (WET/WEST - 5)
-- e.g. reportingDate = 2022-01-01
-- ${startPeriod}$ = 2021-12-31-19.00.01
-- ${endPeriod}$   = 2022-01-01-19.00.00

-- FindPortugalCropTakenTimeStmt
-- typeExtLbtyUsrMoneyOnTblRecur = 149
SELECT MIN(croptime) as taken FROM DAEMONTIMELOG WHERE croptype = 149 AND croptime BETWEEN ${startPeriod}$ AND ${endPeriod}$ AND licenseid=131072;

-- SelectPortugalUserBalanceDailyFromUserAccountStmt
SELECT c.userintid, c.userid, c.chips - c.owedchips as amount, c.tchips, c.ttt, c.acceptedRoll, c.taken
FROM userchipsdaily c
-- join users because of currently 1 PROD user whose license was changed to 0
JOIN users u ON (c.userintid=u.userintid AND u.licenseid=131072)
JOIN userfirsttimeevents ufte ON (c.userintid+0=ufte.userintid AND ufte.licenseid=131072 AND ufte.when <= c.taken)
WHERE c.currency = 'EUR' --AND c.taken=${taken}$
  AND c.taken = (SELECT MIN(croptime) FROM DAEMONTIMELOG WHERE croptype = 149 AND croptime BETWEEN ${startPeriod}$ AND ${endPeriod}$ AND licenseid=131072)
;
