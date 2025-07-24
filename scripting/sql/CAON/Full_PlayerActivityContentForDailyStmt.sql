-- InsertCaonPlayersTempTableStmt.sql
DECLARE GLOBAL TEMPORARY TABLE SESSION.CAON_PLAYERS (
USERINTID INTEGER  not null,                   
WHENRMOK TIMESTAMP not null,
LASTACTIVEDATE DATE not null
) WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.CAON_PLAYERS
select ufte.USERINTID,
       ufte.WHEN WHENRMOK,
	   coalesce((select max(taken) from usertadaily ud where ud.userintid = ufte.userintid and taken <= '${TAKEN}$' and tr_action in (2000,2010,2013,2200,2210,2213,3000,3001,3002,3005,3025,3045,3046,3080,7101,7102,7221)),date(ufte.WHEN)) lastactivedate
from USERFIRSTTIMEEVENTS ufte 
join users u on ufte.userintid+0 = u.userintid  
where ufte.LICENSEID = 16777222 
and ufte.WHEN< '$[TIMETO}$' -- V2
and (bitand(u.flags,32)=0 
	 or exists (select 1 from userchipsdaily ucd where ucd.userintid = ufte.userintid and taken = '${TIMEFROM}$' and chips > 0) 
	 or exists (select 1 from userchanges uc where ufte.userintid = uc.userintid and WHEN >= '${TIMEFROM}$' and updatedfield = 12 and bitand(db2admin.hex2bigint(oldvalue),32)= 0) 
)
AND (BITAND(privileges, 128)=0 and BITAND(privileges2, 2308094809027379712)=0) 
--and userintid in (${uiids}$)
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
--and userintid in (${uiids}$)
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
--and userintid in (${uiids}$)
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
--where userintid in (${uiids}$)
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
--and userintid in (${uiids}$)
group by uh.userintid
;

-- CAON SelectPlayerActivityContentForDailyStmt.sql
--
-- #DBA_REVIEWED #SRE-39040 AlexSlobidker 2022.Main.09
-- TIMEFROM = 2023-05-21-00.00.00
-- TIMETO	= 2023-06-20-23.59.59
-- uiids	= 55454630

with utd as (
select caon.userintid,
	   lastactivedate,
	   whenrmok,
	   COALESCE(currency,'CAD') currency, -- V4 inactive CAONPLAYERS will be reported under CAD currency
	   sum(case when tr_action in (4040,4060,4061,4062,4063,4070,4071,4072,4073,4303,4306,4307,5000,5001,5008,5009,5011,5014,5015,5016,5019,5021,5026,5040,5046,5060,5061,5062,5063,5128,7010) and assettype = 1 then amount else 0 end) 
		    + sum(case when tr_action in (3010,3011,3012) and bitand(subtype,1)!=0 and assettype = 1 then amount else 0 end) deposits,
	   sum(case when tr_action in (4302,4308,5010,5013,5052,5053,5054,5055,5074,7000) and assettype = 1 then amount else 0 end)
		    + sum(case when tr_action in (3000,3001,3002) and bitand(subtype,1)!=0 and assettype = 1 then amount else 0 end) withdrawals,
	   sum(case when tr_action in (3013,3014,3065,3077,4000,4002,4005,4006,4008,4009,4210,4211,4301,4304,4305,4403,4405,4406,4407,5002,5022,5024,5030,5042,5045,5066,5068,5078,5081,5230,7094,7096,7099,7112,7114,7119,7203,9301,9302,9303,9321,9323,9326) and assettype = 1 then amount else 0 end) adj,
	   sum(case when tr_action in (2000,2010,2013,2200,2210,2213,3000,3001,3002,3005,3010,3011,3012,3025,3030,3031,3033,3045,3046,3080,3200,3201,7101,7102,7103,7105,7106,7107,7221,7226) and assettype = 1 then amount else 0 end)  
			+sum(case when tr_action in (7228) and assettype = 1 and bitand(subtype,8)!=0 then amount else 0 end) wagers,
	   sum(case when tr_action in (2020,2021,2031,2032,2220,2221,3021,3023,3027,3032,3057,3063,3064,3066,3068,3069,3071,3072,3079,3085,3086,3087,3088,3202,3203,3206,3207,3208,7104,7222,7225) and assettype = 1 and bitand(subtype,512)=0 then amount else 0 end) 
			+sum(case when tr_action in (7228) and assettype = 1 and bitand(subtype,8)=0 then amount else 0 end) wins,
	   sum(case when tr_action in (7228) and assettype = 1 and bitand(subtype,8)=0 then amount else 0 end) unsettledwagers, 
	   sum(case when tr_action in (3058,3067,3069,3072,7116,7117,7121) and assettype = 1  then amount else 0 end)
			+sum(case when tr_action in (3021,3023,3027,3032,3059,3063,3079,3085,3086,3087,7222,7225) and assettype = 1 and bitand(subtype,512)!=0 then amount else 0 end) withdrawablewins,
	   sum(case when tr_action in (1,3,4,9,19,23,24,28,34,35,36,99,3013,3014,3065,3078,4000,4002,4005,4006,4210,4211,4301,4304,4305,4311,4403,4405,4406,4407,5022,5024,5030,5042,5045,5078,5081,7112,7114,7115,7116,7117,7119,7121,7122,7203,7209,9301,9302,9303,9304,9321,9322,9323,9324,9326,9327) and assettype != 1  then amount else 0 end) promoadj,
	   sum(case when tr_action in (8,13,42,43,3000,3001,3002,3005,3010,3011,3012,3025,3030,3031,3033,3045,3046,3080,3200,3201,7101,7102,7103,7105,7106,7107,7221,7223,7226) and assettype != 1   then amount else 0 end)  
			+sum(case when tr_action in (7228) and assettype != 1 and bitand(subtype,8)!=0 then amount else 0 end) promowagers, 
	   sum(case when tr_action in (7228) and assettype != 1 and bitand(subtype,8)=0 then amount else 0 end) promounsettledwagers,
	   sum(case when tr_action in (2,6,3021,3023,3027,3032,3057,3059,3063,3066,3067,3068,3069,3071,3072,3079,3085,3086,3087,3088,3202,3203,3206,3207,3208,7104,7222,7225) and assettype != 1  then amount else 0 end) 
			+sum(case when tr_action in (7228) and assettype != 1 and bitand(subtype,8)=0 then amount else 0 end) promowins, 
	   sum(case when tr_action in (7101,7102,7103,7105,7106,7107) and bitand(subtype,80)=16 then amount else 0 end) wagersslots,
	   sum(case when tr_action in (7101,7102,7103,7105,7106,7107) and bitand(subtype,80)=64 then amount else 0 end) wagerstables,
	   sum(case when tr_action in (7101,7102,7103,7105,7106,7107) and bitand(subtype,80)=80 then amount else 0 end) wagerslivedealer,
	   sum(case when tr_action in (7101,7102,7103,7105,7106,7107) and bitand(subtype,80)=0  then amount else 0 end) wagersother,
	   sum(case when tr_action in (7221,7226) then amount else 0 end)
			+sum(case when tr_action in (7228) and bitand(subtype,8)!=0 then amount else 0 end) wagerssb,	
	   sum(case when tr_action in (8,13,42,43,2000,2010,2013,2200,2210,2213,3000,3001,3002,3005,3010,3011,3012,3025,3030,3031,3033,3045,3046,3080,3200,3201) then amount else 0 end)  wagerspoker,
       sum(case when tr_action in (8,13,42,43,2000,2010,2013,2200,2210,2213,3000,3001,3002,3005,3010,3011,3012,3025,3030,3031,3033,3045,3046,3080,3200,3201,7101,7102,7103,7105,7106,7107,7221,7226) and bitand(subtype,256)!=0 then amount else 0 end)  
			+sum(case when tr_action in (7228) and bitand(subtype,256)!=0 and bitand(subtype,8)!=0 then amount else 0 end) wagersmobile,	
	   sum(case when tr_action in (8,13,42,43,2000,2010,2013,2200,2210,2213,3000,3001,3002,3005,3010,3011,3012,3025,3030,3031,3033,3045,3046,3080,3200,3201,7101,7102,7103,7105,7106,7107,7221,7226) and bitand(subtype,256)=0 then amount else 0 end)  
			+sum(case when tr_action in (7228) and bitand(subtype,256)=0 and bitand(subtype,8)!=0 then amount else 0 end) wagerspc,
            	   
	   sum(case when tr_action in (2000,2200) then TR_COUNT else 0 end) pokernumsessions, 
	   sum(case when tr_action in (7221) then TR_COUNT else 0 end) -- V13
			-sum(case when tr_action in (7226) then TR_COUNT else 0 end) -- V13
			+sum(case when tr_action in (7228) and bitand(subtype,8)!=0 then TR_COUNT else 0 end) sbnumwagers, -- V13

	   sum(case when tr_action in (7101,7102,7103,7105,7106,7107) and assettype = 1 then amount else 0 end)	casinowagers,
	   sum(case when tr_action in (7104) and assettype = 1 and bitand(subtype,512)=0 then amount else 0 end) casinowins,

	   sum(case when tr_action in (7221,7226) and assettype = 1 then amount else 0 end)
			+sum(case when tr_action in (7228) and assettype = 1 and bitand(subtype,8)!=0 then amount else 0 end) sbwagers,
	   sum(case when tr_action in (7222,7225) and assettype = 1 and bitand(subtype,512)=0 then amount else 0 end)
			+sum(case when tr_action in (7228) and assettype = 1 and bitand(subtype,8)=0 then amount else 0 end) sbwins

from session.CAON_PLAYERS caon
left join usertadaily ud on ud.userintid = caon.userintid and date(caon.whenrmok) <= ud.taken and taken = '${TAKEN}$' and bitand(subtype,32768)=0 -- V2 V4, to include CAON_PLAYERS regardless V5 bug
group by caon.userintid,
	   lastactivedate,
	   whenrmok,
	   currency	   
)

, Snaps as (
select caon.userintid, lastactivedate, whenrmok,
       case when currency='' then 'USD' else currency END currency, 
	   chips-owedchips as startbalance,
	   tchips + acceptedroll as promostartbalance,
	   NULL as endbalance,
	   NULL as promoendbalance,
   	   NULL as tktstartbalance, 
	   NULL as tktendbalance,
   	   NULL as fbstartbalance, 
	   NULL as fbendbalance,
   	   NULL as mfchips, 
	   NULL as mftchips
from session.CAON_PLAYERS caon
join userchipsdaily x on x.userintid = caon.userintid and x.taken = '${TIMEFROM}$' -- start
and (chips-owedchips<>0 or (tchips + acceptedroll)<>0)
UNION ALL
select caon.userintid, lastactivedate, whenrmok,
       case when currency='' then 'USD' else currency END currency, 
	   NULL as startbalance,
	   NULL as promostartbalance,
	   chips-owedchips as endbalance,
	   tchips + acceptedroll as promoendbalance,
   	   NULL as tktstartbalance, 
	   NULL as tktendbalance,
   	   NULL as fbstartbalance, 
	   NULL as fbendbalance,
   	   NULL as mfchips, 
	   NULL as mftchips
from session.CAON_PLAYERS caon
join userchipsdaily x on x.userintid = caon.userintid and x.taken = '${TIMETO}$' -- end
and (chips-owedchips<>0 or (tchips + acceptedroll)<>0)
UNION ALL
select caon.userintid, lastactivedate, whenrmok,
       currency, 
	   NULL as startbalance,
	   NULL as promostartbalance,
	   NULL as endbalance,
	   NULL as promoendbalance,
   	   ticketval as tktstartbalance, 
	   NULL as tktendbalance,
   	   NULL as fbstartbalance, 
	   NULL as fbendbalance,
   	   NULL as mfchips, 
	   NULL as mftchips
from session.CAON_PLAYERS caon
join dailytournuserdata x on x.userintid = caon.userintid and Licenseid=16777222 and x.timetaken = '${TIMEFROM}$' -- start
and ticketval<>0
UNION ALL
select caon.userintid, lastactivedate, whenrmok,
       currency, 
	   NULL as startbalance,
	   NULL as promostartbalance,
	   NULL as endbalance,
	   NULL as promoendbalance,
   	   NULL as tktstartbalance, 
	   ticketval as tktendbalance,
   	   NULL as fbstartbalance, 
	   NULL as fbendbalance,
   	   NULL as mfchips, 
	   NULL as mftchips
from session.CAON_PLAYERS caon
join dailytournuserdata x on x.userintid = caon.userintid and Licenseid=16777222 and x.timetaken = '${TIMETO}$' -- end
and ticketval<>0
UNION ALL
select caon.userintid, lastactivedate, whenrmok,
       currency, 
	   NULL as startbalance,
	   NULL as promostartbalance,
	   NULL as endbalance,
	   NULL as promoendbalance,
   	   NULL as tktstartbalance, 
	   NULL as tktendbalance,
   	   SUM(UNUSEDFREEBET) as fbstartbalance, 
	   NULL as fbendbalance,
   	   NULL as mfchips, 
	   NULL as mftchips
from session.CAON_PLAYERS caon
join MONEYINSPORTSBOOK x on x.userintid = caon.userintid and currency = 'CAD' and x.taken = '${TIMEFROM}$' -- start
and UNUSEDFREEBET<>0
GROUP BY caon.userintid, lastactivedate, whenrmok,
       currency
UNION ALL
select caon.userintid, lastactivedate, whenrmok,
       currency, 
	   NULL as startbalance,
	   NULL as promostartbalance,
	   NULL as endbalance,
	   NULL as promoendbalance,
   	   NULL as tktstartbalance, 
	   NULL as tktendbalance,
   	   NULL as fbstartbalance, 
	   SUM(UNUSEDFREEBET) as fbendbalance,
   	   NULL as mfchips, 
	   NULL as mftchips
from session.CAON_PLAYERS caon
join MONEYINSPORTSBOOK x on x.userintid = caon.userintid and currency = 'CAD' and x.taken = '${TIMETO}$' -- end
and UNUSEDFREEBET<>0
GROUP BY caon.userintid, lastactivedate, whenrmok,
       currency
UNION ALL
select caon.userintid, lastactivedate, whenrmok,
       currency, 
	   NULL as startbalance,
	   NULL as promostartbalance,
	   NULL as endbalance,
	   NULL as promoendbalance,
   	   NULL as tktstartbalance, 
	   NULL as tktendbalance,
   	   NULL as fbstartbalance, 
	   NULL as fbendbalance,
   	   mf.chips as mfchips, 
	   mf.tchips as mftchips
from session.CAON_PLAYERS caon
join users u on u.userintid=caon.userintid
join migratedusers x on x.useridto=u.userid and x.useridfrom=x.useridto and NEWLICENSEID=16777222 and ORIGINALLICENSEID<>16777222
and x.completed >= '${TIMEFROM}$' -- start
and x.completed < '${TIMETO}$' -- end
join migratedfunds mf on mf.migrationid=x.migrationid
)
,SnapRow as ( -- combine balances into User/Currency rows
select userintid, lastactivedate, whenrmok,
        currency, 
        sum(coalesce(startbalance,0)) as startbalance,
        sum(coalesce(promostartbalance,0)) promostartbalance,
        sum(coalesce(endbalance,0)) endbalance,
        sum(coalesce(promoendbalance,0)) promoendbalance,
        sum(coalesce(tktstartbalance,0)) tktstartbalance, 
        sum(coalesce(tktendbalance,0)) tktendbalance,
        sum(coalesce(fbstartbalance,0)) fbstartbalance, 
        sum(coalesce(fbendbalance,0)) fbendbalance,
        CASE WHEN sum(CASE WHEN mfchips is not null then 1 else 0 END)>0 THEN sum(coalesce(mfchips,0)) END mfchips, 
        CASE WHEN sum(CASE WHEN mftchips is not null then 1 else 0 END)>0 THEN sum(coalesce(mftchips,0)) END mftchips
from SNAPS Group by userintid, lastactivedate, whenrmok,
       currency
)
,comb as ( -- combine. there may be utd movements without Bal (at least in secondary currencies), there may be Bals without movements.
select coalesce(utd.userintid,sr.userintid) userintid,
		coalesce(utd.lastactivedate,sr.lastactivedate) lastactivedate,
		coalesce(utd.whenrmok,sr.whenrmok) whenrmok,
		coalesce(utd.currency,sr.currency) currency,
	   COALESCE(deposits,0) deposits,
	   COALESCE(withdrawals,0) withdrawals,
       COALESCE(adj,0) adj,
	   COALESCE(wagers, 0) wagers,
	   COALESCE(wins, 0) wins,
	   COALESCE(unsettledwagers, 0) unsettledwagers,
	   COALESCE(promoadj,0) promoadj,
	   COALESCE(promowagers, 0) promowagers,
	   COALESCE(promowins, 0) promowins,
	   COALESCE(promounsettledwagers,0) promounsettledwagers,
	   COALESCE(withdrawablewins,0) withdrawablewins,
	   COALESCE(wagersslots,0) wagersslots,
	   COALESCE(wagerstables,0) wagerstables,
	   COALESCE(wagerslivedealer, 0) wagerslivedealer,
	   COALESCE(wagersother,0) wagersother,
	   COALESCE(wagerspc,0) wagerspc,
	   COALESCE(wagersmobile,0) wagersmobile,
	   COALESCE(wagerssb,0) wagerssb,
	   COALESCE(wagerspoker,0) wagerspoker,
		COALESCE(mfchips,startbalance,0) as startbalance,
		COALESCE(mftchips,
		(COALESCE(promostartbalance,0)+COALESCE(tktstartbalance,0)+COALESCE(fbstartbalance,0))
		,0) as promostartbalance,
		COALESCE(endbalance,0) as endbalance,
		COALESCE(promoendbalance,0)+COALESCE(tktendbalance,0)+COALESCE(fbendbalance,0) as promoendbalance,
		CASE WHEN mftchips is not null THEN COALESCE(fbendbalance,0) END as fbendbalance, -- for possible reconstructive adjustment of promostartbalance at migration
		COALESCE(casinowagers,0) as casinowagers,
		COALESCE(casinowins,0) as casinowins,
		COALESCE(sbwagers,0) as sbwagers,
		COALESCE(sbwins,0) as sbwins
From utd FULL OUTER JOIN SnapRow sr ON utd.userintid=sr.userintid and utd.currency=sr.currency --, lastactivedate, whenrmok,
)
,utdxcur as (-- some crosscurrency totals
select userintid,
	   sum(pokernumsessions) pokernumsessions, 
	   sum(sbnumwagers) sbnumwagers 
from utd group by userintid
)

,final as (
select CAST('${TAKEN}$' as date) taken,
	   c.userintid,
	   lastactivedate,
	   whenrmok,
	   currency,
	   deposits, 
	   withdrawals,
       adj,
	   wagers, 
	   wins, 
	   unsettledwagers, 
	   promoadj,
	   promowagers, 
	   promowins, 
	   promounsettledwagers,
	   wins+wagers winloss,
	   withdrawablewins,
	   wagersslots,
	   wagerstables,
	   wagerslivedealer, 
	   wagersother,
	   wagerspc,
	   wagersmobile,
	   wagerssb,
	   wagerspoker,
	   startbalance,
	   endbalance,
	   promostartbalance,
	   promoendbalance,
	   casinowagers,
	   casinowins,
	   sbwagers,
	   sbwins,
	   coalesce(utdxcur.pokernumsessions,0) + coalesce(xcg.count_sessions,0) + coalesce(tg.count_sessions,0) numgamesessions,
	   coalesce(tg.count_wagers,0) + coalesce(phcash.count_hands,0) + coalesce(xh.count_hands,0) + coalesce(utdxcur.sbnumwagers,0) as numwagers,
	   coalesce(phcash.duration_minutes,0) + coalesce(phtourn.duration_minutes,0) + coalesce(xh.duration_minutes,0) as gameduration
from comb c
left join utdxcur on c.userintid = utdxcur.userintid
left join SESSION.CAON_XC_NUM_GAMESESSIONS xcg on c.userintid = xcg.userintid
left join SESSION.CAON_TOURN_GAMESESSIONS_WAGERS tg on c.userintid = tg.userintid
left join SESSION.CAON_POKER_HANDS phcash on c.userintid = phcash.userintid and phcash.hand_type = 0
left join SESSION.CAON_POKER_HANDS phtourn on c.userintid = phtourn.userintid and phtourn.hand_type = 2
left join SESSION.CAON_XC_HANDS xh on c.userintid = xh.userintid
)

select taken,
	   f.userintid,
	   case when lastactivedate < whenrmok then '1901-01-01' else lastactivedate end lastActiveDate,
	   whenrmok,
	   currency,
	   deposits,  
	   -withdrawals as withdrawals, 
       adj, 
	   -wagers as wagers, 
	   wins,  
	   -unsettledwagers as unsettledwagers, 
	   promoadj, 
	   -promowagers as promowagers, 
	   promowins, 
	   -promounsettledwagers as promounsettledwagers, 
	   winloss, 
	   withdrawablewins, 
	   -wagersslots as wagersslots, 
	   -wagerstables as wagerstables, 
	   -wagerslivedealer as wagerslivedealer, 
	   -wagersother as wagersother, 
	   -wagerspc as wagerspc, 
	   -wagersmobile as wagersmobile, 
	   -wagerssb as wagerssb, 
	   -wagerspoker as wagerspoker, 
	   startbalance, 
	   endbalance, 
	   promostartbalance, 
	   promoendbalance, 
	   numgamesessions, 
	   numwagers,
	   gameduration,
	   case when se.daysactual > 0 and se.daysactual <= 90 then 1 else 0 end breakstatus,
	   case when se.daysactual > 0 and se.daysactual <= 90 then case when se.timefrom between '${TIMEFROM}$' and '${TIMETO}$' then se.timefrom end else null end breakstart,
	   case when se.daysactual > 0 and se.daysactual <= 90 then case when se.timeuntil between '${TIMEFROM}$' and '${TIMETO}$' then se.timeuntil end else null end breakend,
	   case when se.daysactual >= 180 then 1 else 0 end sestatus, --V9
	   case when se.daysactual >= 180 then case when se.timefrom between '${TIMEFROM}$' and '${TIMETO}$' then se.timefrom end else null end sestart, --V9
	   case when se.daysactual >= 180 then case when se.timeuntil between '${TIMEFROM}$' and '${TIMETO}$' then se.timeuntil end else null end seend, --V9
	   COALESCE(timestampdiff(256,timestamp(taken) - timestamp(birthdate)), -1) age, -- V3
	   case when sex = 'M' or sex = 'F' then sex else '' end sex, -- 'M', 'F' OR ''
	   case when length(zipcode)>=6 then substr(zipcode,1,3) else '' end as fsa, -- V3
	   case when greatest(
	    coalesce((select propertyint from userpropaudit where userintid = f.userintid and propertyid = 119 and action in (0,1) and whenchanged < '${TIMETO}$' order by recordid desc fetch first 1 row only),0), --v6
	    coalesce((select propertyint from userpropaudit where userintid = f.userintid and propertyid = 120 and action in (0,1) and whenchanged < '${TIMETO}$' order by recordid desc fetch first 1 row only),0)) > 2 then 1 else 0 end highrisk,
		-casinowagers as casinowagers,
		casinowins as casinowins,
		-sbwagers as sbwagers,
		sbwins as sbwins
from final f
join users u on f.userintid = u.userintid 
left join SESSION.CAON_SE se on f.userintid = se.userintid
where f.userintid in (${uiids}$)
order by taken, f.userintid
;