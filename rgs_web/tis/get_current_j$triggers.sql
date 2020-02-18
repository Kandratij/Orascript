SET SERVEROUTPUT ON FORMAT WRAPPED SIZE 1000000
SET LINESIZE 1000 VERIFY OFF FEEDBACK OFF PAGESIZE 0 TRIMSPOOL ON 

connect kais_WEB_J_DB/kais_WEB_J_DB@ARM4_DEV_ODB

ACCEPT arm4_tables_list PROMPT 'Enter value for arm4_tables_list:'

spool kais_web_j_triggers.sql_
declare
  type def is record(
    l varchar2(30),
    r varchar2(30));
  type t_list_def is table of def index by binary_integer;
  list_def t_list_def;
  v_text   varchar2(32767);
procedure pl(v_out_str varchar2 default null) is
begin 
 dbms_output.put_line(v_out_str);
end;  
begin
  list_def(1).l := chr(38) || chr(38) || 'usr_kais_web.';
  list_def(1).r := 'KAIS_WEB_DBDEV';
  list_def(2).l := chr(38) || chr(38) || 'usr_kais_web_j.';
  list_def(2).r := 'KAIS_WEB_J_DB';
  list_def(3).l := chr(38) || chr(38) || 'usr_kais_web_i.';
  list_def(3).r := 'KAIS_WEB_I_DBDEV';

  pl('spool ' || chr(38) || chr(38) ||
                       'spool_fn. APPEND');
  pl();
  pl('alter session set plsql_ccflags=''dev_mode:' ||
                       chr(38) || chr(38) || 'dev_mode.'';');
  pl();
  
  for t in (select OWNER,
                   name,
                   line,
                   count(*) over(partition by owner, name) total_line,
                   rtrim(text, chr(10)) text
              from all_source s
             where (s.owner, s.name) in
                   (select owner, name
                      from ALL_DEPENDENCIES
                     where referenced_name in (&&arm4_tables_list.)
                       and referenced_owner = 'KAIS_WEB_DBDEV'
                       and owner = 'KAIS_WEB_J_DB'            
                       and type = 'TRIGGER')
             order by name, line) loop
  
    if t.line = 1
    then
      pl('PROMPT Replace trigger '||t.name);
      pl('PROMPT');
      pl();
      v_text := 'CREATE OR REPLACE TRIGGER '||list_def(2).l||'.'||t.name;
    else
      v_text := t.text;
    end if;
  
    for i in list_def.first .. list_def.last loop
      v_text := replace(v_text, list_def(i).r, list_def(i).l);
    end loop;
  
    pl(v_text);
  
    if t.line = t.total_line
    then
      pl('/');
    end if;
  end loop;
end;
/

spool off

exit