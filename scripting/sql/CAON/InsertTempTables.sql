-- InsertCaonPlayersTempTableStmt.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.CAON_PLAYERS (
USERINTID INTEGER  not null,                   
WHENRMOK TIMESTAMP not null,
LASTACTIVEDATE DATE not null
) WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.CAON_PLAYERS
select ufte.USERINTID,
       ufte.WHEN WHENRMOK,
	   coalesce((select max(taken) from usertadaily ud where ud.userintid = ufte.userintid and taken <= '@TAKEN@' and tr_action in (2000,2010,2013,2200,2210,2213,3000,3001,3002,3005,3025,3045,3046,3080,7101,7102,7221)),date(ufte.WHEN)) lastactivedate
from USERFIRSTTIMEEVENTS ufte 
join users u on ufte.userintid+0 = u.userintid  
where ufte.LICENSEID = 16777222 
and ufte.WHEN< '$[TIMETO}$' -- V2
and (bitand(u.flags,32)=0 
	 or exists (select 1 from userchipsdaily ucd where ucd.userintid = ufte.userintid and taken = '${TIMEFROM}$' and chips > 0) 
	 or exists (select 1 from userchanges uc where ufte.userintid = uc.userintid and WHEN >= '${TIMEFROM}$' and updatedfield = 12 and bitand(db2admin.hex2bigint(oldvalue),32)= 0) 
)
AND (BITAND(privileges, 128)=0 and BITAND(privileges2, 2308094809027379712)=0) 
and userintid in (${uiids}$)
;

-- InsertCaonXcNumGameSessionsTempTableStmt.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.CAON_XC_NUM_GAMESESSIONS (
--TAKEN DATE not null,
USERINTID INTEGER  not null,                   
COUNT_SESSIONS INTEGER not null
) WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.CAON_XC_NUM_GAMESESSIONS
select 
g.userintid
,count as COUNT_SESSIONS
from xcgames g 
join SESSION.CAON_PLAYERS u on g.userintid = u.userintid and u.WHENRMOK <= g.psstarted
where g.psstarted >='${TIMEFROM}$' and g.psstarted <= '$[TIMETO}$'
and userintid in (${uiids}$)
group by g.userintid
;

-- InsertCaonTournGameSessionsWagersTempTableStmt.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.CAON_TOURN_GAMESESSIONS_WAGERS (
--TAKEN DATE not null,
USERINTID INTEGER  not null,                   
COUNT_SESSIONS INTEGER not null,
COUNT_WAGERS INTEGER not null
) WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.CAON_TOURN_GAMESESSIONS_WAGERS
with dailyTourns AS
(SELECT t.tournid , 
        CASE WHEN t.status < 2 THEN 0 ELSE 1 END AS cancelled,
        CASE WHEN SATELLITETARGET > 0 THEN 1 ELSE 0 END AS satellite,
		startdatetime		
FROM tourns t
WHERE t.startdatetime >='$[TIMEFROM}$' and t.startdatetime <= '$[TIMETO}$' 
AND isplaymoney=0 
AND (t.tournflags/1048576 - t.tournflags/2097152*2) = 0
AND BITAND(T.TOURNFLAGS2, 1536)=0
and userintid in (${uiids}$)
)

SELECT 
tu.userintid
,count as COUNT_SESSIONS
,count + sum(numaddons) + sum(numrebuys) as COUNT_WAGERS
FROM dailyTourns t 
JOIN tournUsers tu on tu.tournamentId = t.tournId
JOIN SESSION.CAON_PLAYERS u ON tu.userintid = u.userintid and u.WHENRMOK <= tu.registered
group by tu.userintid
;

-- InsertCaonPokerHandsTempTableStmt.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.CAON_POKER_HANDS (
USERINTID INTEGER  not null,
HAND_TYPE SMALLINT not null, -- 0-cash, 2-tourn                   
COUNT_HANDS INTEGER not null,
DURATION_MINUTES SMALLINT not null
) 
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.CAON_POKER_HANDS
select userintid,
	   isplaymoney,
	   count num,
	   round(dec(sum(timestampdiff(2,finished-started)))/60) duration
from SESSION.TEMP_HANDS
where userintid in (${uiids}$)
group by userintid,isplaymoney
;

-- InsertCaonXcHandsTempTableStmt.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.CAON_XC_HANDS (
USERINTID INTEGER  not null,             
COUNT_HANDS INTEGER not null,
DURATION_MINUTES SMALLINT not null
) 
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;
INSERT INTO SESSION.CAON_XC_HANDS
SELECT uh.userintid,
	   count num,
	   round(dec(sum(timestampdiff(2,uh.endtime-uh.starttime)))/60) duration
FROM xc_hands_rm_cur h
JOIN xc_userhands_rm_cur uh on h.handid = uh.handid
JOIN users u on u.userintid = uh.userintid and u.licenseid = 16777222
WHERE h.endtime BETWEEN '$[TIMEFROM}$' AND '$[TIMETO}$'
and userintid in (${uiids}$)
group by uh.userintid
;
