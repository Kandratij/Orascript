--connect tops/njgc@kaisprod.rgs.ru
connect tops/njgc@rdbprd01.rgs.ru


set verify off trimspool on termout on linesize 500 heading off pagesize 0

alter session set current_schema=KAIS_WEB;
alter session set statistics_level = all;
alter session set timed_statistics = true;

spool result_xplan.txt

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor ('&&SQL_ID',NULL,'ADVANCED RUNSTATS_LAST'));
                
spool off

exit

