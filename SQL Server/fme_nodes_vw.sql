SELECT ROW_NUMBER() OVER (ORDER BY name) AS id,
       name,
       engine_manager_node_name,
       role,
       job_id,
       is_leader,
       numstandardengines
FROM (SELECT n.short_name                  AS name,
             m.short_name                  AS engine_manager_node_name,
             CAST('Engine' AS VARCHAR(50)) AS role,
             e.job_id,
             CAST(NULL AS BIT)             AS is_leader,
             CAST(NULL AS INT)             AS numstandardengines
      FROM fme_engines AS e
               CROSS APPLY (SELECT CASE
                                       WHEN e.name NOT LIKE '%[^0-9.]%' AND e.name LIKE '%.%.%.%'
                                           THEN e.name
                                       WHEN e.name LIKE '%.%'
                                           THEN LEFT(e.name, CHARINDEX('.', e.name) - 1)
                                       ELSE LEFT(e.name, CHARINDEX('_', e.name + '_') - 1)
                                       END AS short_name) AS n
               CROSS APPLY (SELECT CASE
                                       WHEN e.engine_manager_node_name NOT LIKE '%[^0-9.]%' AND e.engine_manager_node_name LIKE '%.%.%.%'
                                           THEN e.engine_manager_node_name
                                       WHEN e.engine_manager_node_name LIKE '%.%'
                                           THEN LEFT(e.engine_manager_node_name, CHARINDEX('.', e.engine_manager_node_name) - 1)
                                       ELSE LEFT(e.engine_manager_node_name, CHARINDEX('_', e.engine_manager_node_name + '_') - 1)
                                       END AS short_name) AS m
      WHERE e.type <> 2

      UNION ALL

      SELECT n.short_name                  AS name,
             CAST('NA' AS VARCHAR(50))     AS engine_manager_node_name,
             CAST('Core' AS VARCHAR(50))   AS role,
             CAST(NULL AS INT)             AS job_id,
             c.is_leader,
             c.numstandardengines
      FROM fme_core_node AS c
               CROSS APPLY (SELECT CASE
                                       WHEN c.name NOT LIKE '%[^0-9.]%' AND c.name LIKE '%.%.%.%'
                                           THEN c.name
                                       WHEN c.name LIKE '%.%'
                                           THEN LEFT(c.name, CHARINDEX('.', c.name) - 1)
                                       ELSE LEFT(c.name, CHARINDEX('_', c.name + '_') - 1)
                                       END AS short_name) AS n) AS combined;