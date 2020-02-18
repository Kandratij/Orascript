WITH stepbystep(n,id,parent_id,name) AS
 (SELECT 1 n, g.id, g.master_id, g.name way
    FROM goods g
   INNER JOIN goods mg
      on mg.id = g.master_id
   WHERE g.id = 952000000024087
  
  UNION ALL
  SELECT n + 1 n, g.id, g.master_id, s.name||'/'||g.name way
    FROM goods g
   INNER JOIN stepbystep s
      ON (g.master_id=s.id))
SELECT n,id,parent_id,name FROM stepbystep


WITH hier_org (lvl,cnt_id,id,master_id) AS
 (SELECT 1 lvl,cnt_id,id,master_id
    FROM organization
   WHERE cnt_id=952000000012204
  UNION ALL
  SELECT lvl + 1 lvl, o.cnt_id, o.id, o.master_id
    FROM hier_org ho, organization o
   where  (o.master_id=ho.id))
SELECT * FROM hier_org


select * from organization
 start with cnt_id=952000000012204
 connect by master_id=prior id;
