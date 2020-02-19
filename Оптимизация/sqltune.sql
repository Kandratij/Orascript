connect tops/njgc@ARM4_TST_ODB
--connect develop/develop1@ARM4_TST_ODB
  
set pagesize 0 echo off timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off heading off verify off

ACCEPT sql_id PROMPT SQL_ID:

spool output\sqlmonitor.html

--select dbms_sqltune.report_sql_monitor(type=>'EM',report_level=>'ALL',sql_id=>'&sql_id') monitor_report from dual;
--select dbms_sqltune.report_sql_detail(sql_id=> '&sql_id', type => 'ACTIVE',report_level=>'ALL') from dual;
select dbms_sqltune.report_sql_monitor(sql_id=>'&sql_id', type=>'EM', report_level=>'ALL') monitor_report from dual;

spool off

--spool output\sqldetail.html
--SELECT DBMS_SQLTUNE.report_sql_detail(sql_id=>'&sql_id', type => 'ACTIVE', report_level => 'ALL') AS detail_report from dual;

--spool off
start host output\sqlmonitor.html
--start host output\sqldetail.html

exit;

