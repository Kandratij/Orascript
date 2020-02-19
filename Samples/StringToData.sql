--Преобразование строки в набор данных
select id, regexp_substr(t.value, '[^,]+', 1, level) vals
      from (select 1 as id, 'val1,val2,val3,val4,val5' as value from dual) t
     where t.id=1
   connect by level <= length(regexp_replace(t.value, '[^,]+')) + 1; 