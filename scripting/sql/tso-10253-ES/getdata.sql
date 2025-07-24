-- SelectSpainXcJackpotEventsByJackpotId.sql

-- SelectAllXcJpSettings
--SELECT JPKEY,JPREFNAME,NAME,RESET,PRATE, RRATE,GUARANTEED,CURRENCY,PLAYFORFUN,HOSTS,SITES,DISABLED,VENDORID,VENDORJPID,USERESETVALUE, MULTICURRENCY,CREATETIME, CLOSETIME, JPTYPE,JPGROUPID
--FROM XC_JPSETTINGS;

-- SelectSpainXcJackpotEventsByJackpotId
declare global temporary table session.jackpots (
	jpxcreqid		bigint not null,
	refxcreqid		bigint not null,
	eventtype 		smallint not null,
	refpstime		timestamp not null,
	AMOUNT1GAMECUR	bigint not null,
	AMOUNT2GAMECUR	bigint not null,
	AMOUNT2JPCUR	bigint not null,
	RESETJPCUR		bigint not null,
	RESETGAMECUR	bigint not null,
	POOLVALUEJPCUR	bigint not null,
	RESETVALUEJPCUR	bigint not null
)
with replace on commit preserve rows not logged;


insert into session.jackpots
select je.jpxcreqid,je.refxcreqid, je.eventtype, je.refpstime, je.AMOUNT1GAMECUR, je.AMOUNT2GAMECUR, je.AMOUNT2JPCUR, je.RESETJPCUR, je.RESETGAMECUR, je.POOLVALUEJPCUR, je.RESETVALUEJPCUR
from xcjackpotevents je
join xcgames g on je.gameid=g.gameid
where je.jackpotid=19010
  and je.refpstime between timestamp('2021-11-30-18.00.00') - 1 minute and timestamp('2021-12-31-18.00.00') + 1 minute
  and je.jpxctime  between timestamp('2021-11-30-18.00.00')            and timestamp('2021-12-31-18.00.00') - 1 microsecond
;

--select jpxcreqid, eventtype, refpstime, AMOUNT1GAMECUR, AMOUNT2GAMECUR, AMOUNT2JPCUR, POOLVALUEJPCUR from session.jackpots order by refpstime,jpxcreqid;

with bets as (
	select sum(AMOUNT1GAMECUR) total_bets, sum(AMOUNT2GAMECUR) total_jpContrib
	from session.jackpots
	where eventtype=11
)
, pay as (
	select sum(AMOUNT2JPCUR) payout
	from session.jackpots
	where eventtype=13
)
, beginP as (
	select POOLVALUEJPCUR as beginning_pool from session.jackpots order by jpxcreqid asc  fetch first 1 row only
)
, endP as (
	select POOLVALUEJPCUR as ending_POOL from session.jackpots order by jpxcreqid desc fetch first 1 row only
)
select bets.*, pay.*, beginP.*, endP.* from bets, pay, beginp, endp;

--select sum(AMOUNT1GAMECUR) as AMOUNT1GAMECUR_amt_receivedbyserver from session.jackpots where eventtype=11;
--select sum(AMOUNT1GAMECUR) as AMOUNT2GAMECUR_jpContribution from session.jackpots where eventtype=11;
--select sum(AMOUNT2JPCUR) as AMOUNT2JPCUR_jpContributionInJpCurrency from session.jackpots where eventtype=11;
--select sum(RESETJPCUR) as RESETJPCUR_JPresetContribInJpCurrency from session.jackpots where eventtype=11;
--select sum(RESETGAMECUR) as RESETGAMECUR_JPresetContrib from session.jackpots where eventtype=11;

--select POOLVALUEJPCUR as beginning_POOLVALUEJPCUR from session.jackpots order by refpstime asc  fetch first 1 row only;
--select POOLVALUEJPCUR as ending_POOLVALUEJPCUR   from session.jackpots order by refpstime desc fetch first 1 row only;

--select RESETVALUEJPCUR as beginning_RESETpoolVALUEinJPCUR from session.jackpots order by refpstime asc  fetch first 1 row only;
--select RESETVALUEJPCUR as ending_RESETpoolVALUEinJPCUR   from session.jackpots order by refpstime desc fetch first 1 row only;

--select sum(AMOUNT2JPCUR) as payout from session.jackpots where eventtype=13;

--select * from session.jackpots where eventtype=14;

--select jp.jpxcreqid, jp.AMOUNT1GAMECUR, jp.AMOUNT2GAMECUR, jp.AMOUNT2JPCUR, jp.RESETJPCUR, jp.RESETGAMECUR, jp.POOLVALUEJPCUR, jp.RESETVALUEJPCUR
--     , ta.transId, ta.chips, ta.chipsafter
--	 , xt.xctransid
--from session.jackpots jp
--join xctrans xt on xt.xcreqid=jp.jpxcreqid
--join transacts ta on ta.transid=xt.pstransid
--where eventtype=14;

with total_jp as (
	select sum(AMOUNT2JPCUR) jp_total from xcjackpotevents where refpstime < '2021-12-31-23.59.59.000000' and eventtype=11
), total_pay as (
	select sum(AMOUNT2JPCUR) pay_total from xcjackpotevents where refpstime < '2021-12-31-23.59.59.000000' and eventtype=13
)
select t1.jp_total bet, t2.pay_total pay, t1.jp_total - t2.pay_total balance from total_jp t1, total_pay t2;

drop table session.jackpots;