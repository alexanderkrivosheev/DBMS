-- list all available connecitons
SELECT * FROM sys.dm_exec_connections

--list sessions and conncetions
SELECT
    c.connection_id,
    c.session_id,    
    c.client_net_address AS connection_ip,
    s.login_name,
    s.status,
    s.host_name,
    s.program_name,
    s.login_time,
    s.last_request_start_time,
    s.last_request_end_time
FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
ORDER BY c.connection_id, c.client_net_address, s.login_time;

--list requests for target session
SELECT
    c.connection_id,
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    r.cpu_time AS cpu_time_ms,
    r.database_id,
    --r.memory_usage * 8 AS memory_usage_kb,
    r.total_elapsed_time AS elapsed_time_ms,
    r.status,
    r.command,
    r.blocking_session_id,
    c.client_net_address AS connection_ip,
    t.text AS query_text
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s ON r.session_id = s.session_id
JOIN sys.dm_exec_connections AS c ON s.session_id = c.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
ORDER BY r.cpu_time DESC;
--ORDER BY r.cpu_time DESC, r.memory_usage DESC;

select * FROM sys.dm_exec_requests AS r where session_id = 75

--Get current session id
SELECT @@SPID AS CurrentSessionID;

--Kill target session
KILL 60;