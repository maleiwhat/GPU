<?php

function count_records($table) {
  $querycount = "SELECT count(*) from $table;";
  $resultcount=mysql_query($querycount);
  if ($resultcount!="") {
    $nbrecords=mysql_result($resultcount,0,'count(*)');
  } else $nbrecords=0;
  
  return $nbrecords;
}

function call_superserver_phone() {
  // a connection needs to be established
  include("../conf/config.inc.php"); 
  include("../utils/constants.inc.php");

  // collect data for the phone call
  $activenodes  = count_records("tbclient");
  $jobinqueue   = count_records("tbjobqueue");
  
  $timeout = 6;
  $old = ini_set('default_socket_timeout', $timeout);
  
  //TODO: define $superserver in a loop of existing superservers
  //TODO: retrieve my_server_id from tbparameter
  //TODO: calculate uptime and totaluptime from parameters
  $handle = fopen("http://$serverurl/supercluster/phone_call.php?serverid=$my_server_id&servername=$my_server_name&serverurl=$my_server_url&chatchannel=$my_chat_channel&version=$server_version&uptime=$uptime&totaluptime=$totaluptime&longitude=$my_longitude&latitude=$my_latitude&activenodes=$activenodes&jobinqueue=$jobinqueue", 'r');
  ini_set('default_socket_timeout', $old);
  stream_set_timeout($handle, $timeout);
  stream_set_blocking($handle, 0); 
  fclose($handle);

  //die("<b>Server name and url: $my_server_name $my_server_url</b>");
}

function superserver_answers_phone($serverid, $servername, $serverurl, $chatchannel, $version, $superserver, $uptime, $totaluptime, $longitude, $latitude, $activenodes, $jobinqueue, $ip) {
  include("../conf/config.inc.php");
  
  $debug=0;	
  mysql_connect($dbserver, $username, $password);
  @mysql_select_db($database) or die("ERROR: Unable to select database, please check settings in conf/config.inc.php");					
  $query="SELECT id FROM tbserver WHERE serverid='$serverid' LIMIT 1";  
  $result=mysql_query($query);
  if ($result!="") { $num=mysql_numrows($result); } else { $num=0; } 
  
  if ($num==0) {
	   // we do an INSERT
       $queryinsert="INSERT INTO tbserver (id, serverid, servername, serverurl, chatchannel, version, superserver,
	                                       uptime, totaluptime, activenodes, jobinqueue
										   longitude, latitude, ip,
										   create_dt, update_dt)
									VALUES('', '$serverid', '$servername', '$serverurl', '$chatchannel', $version, $superserver,
                                            $uptime, $totaluptime, $activenodes, $jobinqueue,
											$longitude, $latitude, '$ip',						   
										    NOW(), NOW()
										   );";
       $resultinsert=mysql_query($queryinsert);
	   if ($debug==1) echo "Insert statement is: $queryinsert\n";
	    
       // at the moment we set $id to -1, later we might retrieve $id with a query
       // if necessary
       $id=-1;	   
	} else {
	  // we do an UPDATE
	  $id=mysql_result($result,0,"id");
	  $queryupdate="UPDATE tbserver SET 
	                servername='$servername', serverurl='$serverurl', chatchannel='$chatchannel', superserver=$superserver
					uptime=$uptime, totaluptime=$totaluptime, activenodes=$activenodes, jobinqueue=$jobinqueue
					ip='$ip', localip='$localip', port='$port', acceptincoming=$acceptincoming,
					longitude=$longitude, latitude=$latitude, ip='$ip',
                    version=$version, 					
					update_dt=NOW()
					WHERE id=$id;"; 
      $resultupdate=mysql_query($queryupdate);
	  if ($debug==1) echo "Update statement is: $queryupdate\n";
    }
	mysql_close();
	
    echo "OK";
	return $id;	
}



?>