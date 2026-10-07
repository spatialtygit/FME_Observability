SELECT row_number() OVER (ORDER BY name) AS id,
       name,
       hostname,
       engine_manager_node_name,
       role,
       job_id,
       is_leader,
       numstandardengines
FROM (SELECT
             CASE
                 WHEN fme_engines.name ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_engines.name
                 WHEN fme_engines.name LIKE '%.%'
                     THEN split_part(fme_engines.name, '.', 1)::character varying
                 ELSE split_part(fme_engines.name, '_', 1)::character varying
                 END        AS name,
             CASE
                 WHEN fme_engines.hostname ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_engines.hostname
                 WHEN fme_engines.hostname LIKE '%.%'
                     THEN split_part(fme_engines.hostname, '.', 1)::character varying
                 ELSE split_part(fme_engines.hostname, '_', 1)::character varying
                 END        AS hostname,
             CASE
                 WHEN fme_engines.engine_manager_node_name ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_engines.engine_manager_node_name
                 WHEN fme_engines.engine_manager_node_name LIKE '%.%'
                     THEN split_part(fme_engines.engine_manager_node_name, '.', 1)::character varying
                 ELSE split_part(fme_engines.engine_manager_node_name, '_', 1)::character varying
                 END        AS engine_manager_node_name,
             'Engine'::text AS role,
             fme_engines.job_id,
             NULL::boolean  AS is_leader,
             NULL::integer  AS numstandardengines
      FROM fme_engines
      WHERE fme_engines.type <> 2

      UNION ALL

      SELECT
             CASE
                 WHEN fme_core_node.name ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_core_node.name
                 WHEN fme_core_node.name LIKE '%.%'
                     THEN split_part(fme_core_node.name, '.', 1)::character varying
                 ELSE split_part(fme_core_node.name, '_', 1)::character varying
                 END                 AS name,
             CASE
                 WHEN fme_core_node.name ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_core_node.name
                 WHEN fme_core_node.name LIKE '%.%'
                     THEN split_part(fme_core_node.name, '.', 1)::character varying
                 ELSE split_part(fme_core_node.name, '_', 1)::character varying
                 END                 AS hostname,
             'NA'::character varying AS engine_manager_node_name,
             'Core'::text            AS role,
             NULL::integer           AS job_id,
             fme_core_node.is_leader,
             fme_core_node.numstandardengines
      FROM fme_core_node

      UNION ALL

      SELECT
             CASE
                 WHEN fme_remote_engine_conn.name ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_remote_engine_conn.name
                 WHEN fme_remote_engine_conn.name LIKE '%.%'
                     THEN split_part(fme_remote_engine_conn.name, '.', 1)::character varying
                 ELSE split_part(fme_remote_engine_conn.name, '_', 1)::character varying
                 END                 AS name,
             CASE
                 WHEN fme_remote_engine_conn.name ~ '^\d+\.\d+\.\d+\.\d+$'
                     THEN fme_remote_engine_conn.name
                 WHEN fme_remote_engine_conn.name LIKE '%.%'
                     THEN split_part(fme_remote_engine_conn.name, '.', 1)::character varying
                 ELSE split_part(fme_remote_engine_conn.name, '_', 1)::character varying
                 END                 AS hostname,
             'NA'::character varying AS engine_manager_node_name,
             'Remote Engine'::text   AS role,
             NULL::integer           AS job_id,
             NULL::boolean           AS is_leader,
             fme_remote_engine_conn.numstandardengines
      FROM fme_remote_engine_conn) t;