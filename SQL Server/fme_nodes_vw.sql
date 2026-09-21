SELECT ROW_NUMBER() OVER (ORDER BY name) AS id,
       name,
       engine_manager_node_name,
       role,
       job_id,
       is_leader,
       numstandardengines
FROM (SELECT 
             CASE
                 WHEN CAST(fme_engines.hostname AS VARCHAR(255)) = 'fme26.spatialtylab.com' THEN CAST('FME26' AS VARCHAR(255))
                 WHEN CAST(fme_engines.hostname AS VARCHAR(255)) = 'server121' THEN CAST('Server 12.1' AS VARCHAR(255))
                 ELSE fme_engines.engine_manager_node_name
                 END                        AS "name",
             CASE
                 WHEN CAST(fme_engines.engine_manager_node_name AS VARCHAR(255)) = 'fme26.spatialtylab.com' THEN CAST('FME26' AS VARCHAR(255))
                 ELSE fme_engines.engine_manager_node_name
                 END                        AS engine_manager_node_name,
             CAST('Engine' AS VARCHAR(50)) AS role,
             fme_engines.job_id,
             CAST(NULL AS BIT)             AS is_leader,
             CAST(NULL AS INT)             AS numstandardengines
      FROM fme_engines
      WHERE fme_engines.type <> 2

      UNION ALL

      SELECT CASE
                 WHEN CAST(fme_core_node.name AS VARCHAR(255)) = 'fme26.spatialtylab.com' THEN CAST('FME26' AS VARCHAR(255))
                 ELSE fme_core_node.name
                 END                    AS name,
             CAST('NA' AS VARCHAR(50)) AS engine_manager_node_name,
             CAST('Core' AS VARCHAR(50)) AS role,
             CAST(NULL AS INT)          AS job_id,
             fme_core_node.is_leader,
             fme_core_node.numstandardengines
      FROM fme_core_node) AS combined;