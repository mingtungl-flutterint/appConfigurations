-- TournTickets
DECLARE GLOBAL TEMPORARY TABLE SESSION.tournticketIds
(
    ticketid        integer not null,
    tickettypeid    integer not null,
    USERINTID       INTEGER NOT NULL,
    flags           INTEGER NOT NULL,
    licenseid       INTEGER NOT NULL,
    value           INTEGER NOT NULL,
    issued          TIMESTAMP NOT NULL,
    expdate         TIMESTAMP,
    used            TIMESTAMP,
    currency        varchar(4) not null
)
WITH REPLACE ON COMMIT PRESERVE ROWS NOT LOGGED;

INSERT INTO SESSION.tournticketIds
select ticketid,tickettypeid,USERINTID,flags,licenseid,value,issued,expdate,used,currency
from db2admin.tourntickets
where userintid in (${uiids}$) and issued > '${issuedDate}$' --'2024-09-20'
;

--select * from SESSION.tournticketIds;

--select * from db2admin.tournticketsaudit1
select * from db2admin.tournticketsaudit2
where ticketid in (select ticketid from SESSION.tournticketIds where action=22)
order by when desc;

select * from db2admin.tournticketsauditandtransid 
where ticketid in (select ticketid from SESSION.tournticketIds where action=22)
order by when desc;

drop table SESSION.tournticketIds;
