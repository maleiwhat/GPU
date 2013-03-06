PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE tbserver (id AUTOINC_INT PRIMARY KEY , serverid VARCHAR(255) , servername VARCHAR(255) , serverurl VARCHAR(255) , chatchannel VARCHAR(255) , version VARCHAR(255) , online BOOL_INT , updated BOOL_INT , defaultsrv BOOL_INT , superserver BOOL_INT , uptime FLOAT , totaluptime FLOAT , longitude FLOAT , latitude FLOAT , distance FLOAT , activenodes INTEGER , jobinqueue INTEGER , failures INTEGER , create_dt DATETIME , update_dt DATETIME);
INSERT INTO "tbserver" VALUES(1,'paripara','Algol','http://127.0.0.1:8090/algol','algol','0.05',1,1,0,0,99.0,NULL,90.0,90.0,9457842.98290943,13,2,0,41339.7506159954,41339.7526159375);
INSERT INTO "tbserver" VALUES(2,'6e771f4936a0d24bf2448e0d187725a4','Orion','127.0.0.1:8090/server','orion','0.1',1,0,0,0,1693.0,NULL,14.0,10.0,3901976.9261099,0,0,0,41339.7506161806,NULL);
INSERT INTO "tbserver" VALUES(3,'fb4bc9a27a2be5e0b7ce08dc2bf09618','Altos','127.0.0.1:8090/gpu_freedom/src/server','altos','0.1',1,1,1,0,81042.0,NULL,7.0,45.0,0.0,3,12,0,41339.7506165162,41339.7526162963);
CREATE TABLE tbclient (id AUTOINC_INT PRIMARY KEY , nodeid VARCHAR(255) , server_id INTEGER , nodename VARCHAR(255) , country VARCHAR(255) , region VARCHAR(255) , city VARCHAR(255) , zip VARCHAR(255) , description VARCHAR(255) , ip VARCHAR(255) , port VARCHAR(255) , localip VARCHAR(255) , os VARCHAR(255) , cputype VARCHAR(255) , version VARCHAR(255) , acceptincoming BOOL_INT , gigaflops INTEGER , ram INTEGER , mhz INTEGER , bits INTEGER , nbcpus INTEGER , online BOOL_INT , updated BOOL_INT , uptime FLOAT , totaluptime FLOAT , longitude FLOAT , latitude FLOAT , userid VARCHAR(255) , team VARCHAR(255) , create_dt DATETIME , update_dt DATETIME);
INSERT INTO "tbclient" VALUES(1,'4',3,'blabla',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',0,0,0,0,32,0,1,1,0.0,9.0,13.5,14.3,NULL,NULL,41339.7526160648,NULL);
INSERT INTO "tbclient" VALUES(2,'1',3,'andromeda','Switzerland',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Win7',NULL,'0.5',0,0,0,0,0,0,1,1,0.0,0.0,7.0,46.5,NULL,NULL,41339.7526163657,NULL);
CREATE TABLE tbchannel (id AUTOINC_INT PRIMARY KEY , externalid INTEGER , content VARCHAR(255) , user VARCHAR(255) , nodename VARCHAR(255) , nodeid VARCHAR(255) , channame VARCHAR(255) , chantype VARCHAR(255) , server_id INTEGER , create_dt DATETIME , usertime_dt DATETIME);
CREATE TABLE tbretrieved (id AUTOINC_INT PRIMARY KEY , lastmsg INTEGER , msgtype VARCHAR(255) , server_id INTEGER , create_dt DATETIME , update_dt DATETIME);
CREATE TABLE tbjob (id AUTOINC_INT PRIMARY KEY , externalid VARCHAR(255) , jobid VARCHAR(255) , job VARCHAR(255) , status INTEGER , workunitincoming VARCHAR(255) , workunitoutgoing VARCHAR(255) , requests INTEGER , delivered INTEGER , results INTEGER , islocal BOOL_INT , nodeid VARCHAR(255) , nodename VARCHAR(255) , server_id INTEGER , create_dt DATETIME);
CREATE TABLE tbjobresult (id AUTOINC_INT PRIMARY KEY , externalid INTEGER , requestid INTEGER , jobid VARCHAR(255) , job_id INTEGER , jobresult VARCHAR(255) , workunitresult VARCHAR(255) , iserroneous BOOL_INT , errorid INTEGER , errormsg VARCHAR(255) , errorarg VARCHAR(255) , server_id INTEGER , nodeid VARCHAR(255) , nodename VARCHAR(255) , create_dt DATETIME);
CREATE TABLE tbjobqueue (id AUTOINC_INT PRIMARY KEY , job_id INTEGER , requestid INTEGER , server_id INTEGER , create_dt DATETIME);
CREATE TABLE tbparameter (id AUTOINC_INT PRIMARY KEY , paramtype VARCHAR(255) , paramname VARCHAR(255) , paramvalue VARCHAR(255) , create_dt DATETIME , update_dt DATETIME);
INSERT INTO "tbparameter" VALUES(1,'CLIENT','purge_server_after_failures','30',41339.7506155903,41339.7526149884);
INSERT INTO "tbparameter" VALUES(2,'CLIENT','receive_channels_each','120',41339.7506161111,41339.7526162384);
INSERT INTO "tbparameter" VALUES(3,'CLIENT','receive_chat_each','45',41339.7506163773,41339.7526167708);
INSERT INTO "tbparameter" VALUES(4,'CLIENT','receive_jobs_each','120',41339.7506166319,NULL);
INSERT INTO "tbparameter" VALUES(7,'CLIENT','transmit_channels_each','120',41339.7506173148,41339.7526182292);
INSERT INTO "tbparameter" VALUES(8,'CLIENT','transmit_jobs_each','120',41339.7506177083,41339.7526184143);
INSERT INTO "tbparameter" VALUES(9,'CLIENT','transmit_node_each','180',41339.750618044,41339.7526185995);
INSERT INTO "tbparameter" VALUES(10,'CLIENT','receive_nodes_each','120',41339.7526178472,NULL);
INSERT INTO "tbparameter" VALUES(11,'CLIENT','receive_servers_each','3600',41339.752618044,NULL);
COMMIT;