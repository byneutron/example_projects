<?php
error_reporting(0);
include 'conn.php';
$flag = $_POST['flag'];
(int) $flag;

switch ($flag) {

 case 1:

 $Idno = $_POST['idno'];
 $Password = md5($_POST['password']);
 $fcm_token = $_POST['fcm_token'];
 $query = "SELECT * FROM [user] WHERE Idno='$Idno' AND Password='$Password' AND status=1";  
 $result = sqlsrv_query( $connect, $query);  
 if( $result === false)  
 {  
   echo "Error in query preparation/execution.\n";  
   die( print_r( sqlsrv_errors(), true));  
 }  
 if(sqlsrv_has_rows($result)>0){
   while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))  
   {  
     $json['value'] = 1;
     $json['message'] = '';
   }  
 }else{

   $json['value'] = 0;
   $json['message'] = '';
   
 }
 break;
 case 2:
 $Name = $_POST['name'];
 $Idno = $_POST['idno'];
 $Email = $_POST['email'];
 $Password = md5($_POST['password']);
 $Date = $_POST['date'];
 $fcm_token = $_POST['fcm_token'];
 $query = "SELECT * FROM [user] WHERE Idno='$Idno'";
 $result = sqlsrv_query($connect, $query);
 if( $result === false ) {
  die( print_r( sqlsrv_errors(), true));
}
if(sqlsrv_has_rows($result)>0){
 $json['value'] = 2;
 $json['message'] = $Idno;

}else{
 $query = "INSERT INTO [user] (Name, Idno, Email, Password, Date, fcm_token,status) VALUES (?, ?, ?, ?, ?, ?,1)";
 $params = array($Name,$Idno,$Email,$Password,$Date,$fcm_token);
 $inserted = sqlsrv_query( $connect, $query, $params);
 if($inserted == true ){
  $json['value'] = 1;
  $json['message'] = '';
}
else{
  $json['value'] = 0;
  $json['message'] = '';

}
}
break;

case 3:
$SurveyID = $_POST['SurveyID'];
$One = $_POST['One'];
$Two = $_POST['Two'];
$Tree = $_POST['Tree'];
$Four = $_POST['Four'];
$Five = $_POST['Five'];
$Six = $_POST['Six'];
$Seven = $_POST['Seven'];
$Date = $_POST['Date'];
$fcm_token = $_POST['fcm_token'];
$query = "INSERT INTO [survey] (SurveyID, One, Two, Tree, Four, Five, Six, Seven, Date, fcm_token, status) VALUES (?,?,?,?,?,?,?,?,?,?,1)";
$params = array($SurveyID,$One,$Two,$Tree,$Four,$Five,$Six,$Seven,$Date,$fcm_token);
$inserted = sqlsrv_query( $connect, $query, $params);
if( $inserted === false ) {
 die( print_r( sqlsrv_errors(), true));
 $json['value'] = 0;
 $json['message'] = '';
}
else
{ 
  $json['value'] = 1;
  $json['message'] = '';
}

break;

case 4:

$Idno = $_POST['idno'];
$Name = $_POST['name'];
$Email = $_POST['email'];
$Password = md5($_POST['password']);
$fcm_token = $_POST['fcm_token'];
$query = "SELECT * FROM [user] WHERE Idno='$Idno' AND status=1 ";
$result = sqlsrv_query($connect, $query);
if( $result === false ) {
  die( print_r( sqlsrv_errors(), true));
}
if(sqlsrv_has_rows($result)>0){

 while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))  {
  $query =  "UPDATE [user] SET Name = ? ,Email = ? ,Password = ? ,fcm_token = ? WHERE id ='".$row['id']."'";
  $params = array($Name,$Email,$Password,$fcm_token);
  $inserted = sqlsrv_query( $connect, $query, $params);
  $json['value'] = 1;
  $json['message'] = 'GiriÅ BaÅarÄ±lÄ±!';
  $json['name'] = $row['Name'];
  $json['email'] = $row['email'];
  $json['password'] = $row['password'];
  $json['id'] = $row['id'];
}
}
else
{ 
  $json['value'] = 0;
  $json['message'] = 'GiriÅ BaÅarÄ±sÄ±z!';

}
break;

case 5:

$Idno = $_POST['idno'];
$fcm_token = $_POST['fcm_token'];
$query = "SELECT * FROM [user] WHERE Idno='$Idno' AND status=1 ";
$result = sqlsrv_query($connect, $query);

if( $result === false ) {
  die( print_r( sqlsrv_errors(), true));
}
if(sqlsrv_has_rows($result)>0){

  while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))  {

    $json['value'] = 1;
    $json['idnom'] = $row['Idno'];
    $json['namem'] = $row['Name'];
    $json['emailm'] = $row['Email'];
    $json['datem'] = $row['Date'];

  }

}else{

  $json['value'] = 0;
  $json['message'] = 'GiriÅ BaÅarÄ±sÄ±z!';

}

break;

case 6:

$SurveyID = $_POST['SurveyID'];
$fcm_token = $_POST['fcm_token'];
$query = "SELECT * FROM [survey] WHERE SurveyID='$SurveyID' AND status=1 ORDER BY id DESC";
$result = sqlsrv_query($connect, $query);

if( $result === false ) {
  die( print_r( sqlsrv_errors(), true));
}
$xArray=array();

if(sqlsrv_has_rows($result)>0){

 $index=0; 
 while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))  {

   $xArray[$index]=$row['Date'];
   $index ++;
 }
 $json['value'] = 1;
 $json['datem'] =$xArray;

}else{

 $json['value'] = 0;
 $json['message'] = 'GiriÅ BaÅarÄ±sÄ±z!';

}

break;

case 7:

$Idno = $_POST['idno'];
$Email = $_POST['email'];
$fcm_token = $_POST['fcm_token'];
$query = "SELECT * FROM [user] WHERE Idno='$Idno' AND Email ='$Email' AND status=1 ";
$result = sqlsrv_query($connect, $query);

if( $result === false ) {
  die( print_r( sqlsrv_errors(), true));
}

if(sqlsrv_has_rows($result)>0){

 while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))   {

  $json['value'] = 1;

}
}else{

  $json['value'] = 0;
  $json['status'] = 'failure';

}

break; 

case 8:
$Idno = $_POST['idno'];
$Email = $_POST['email'];
$Password = md5($_POST['password']);
$fcm_token = $_POST['fcm_token'];
$query = "SELECT * FROM [user] WHERE Idno='$Idno' AND Email='$Email' AND status=1 ";
$result = sqlsrv_query($connect, $query);
if( $result === false ) {
  die( print_r( sqlsrv_errors(), true));
}
if(sqlsrv_has_rows($result)>0){

 while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC))  {
  $query =  "UPDATE [user] SET  Password = ? ,fcm_token = ? WHERE id ='".$row['id']."'";
  $params = array($Password,$fcm_token);
  $inserted = sqlsrv_query( $connect, $query, $params);

  $json['value'] = 1;
  $json['message'] = 'GiriÅ BaÅarÄ±lÄ±!';

}
}
else
{ 
  $json['value'] = 0;
  $json['message'] = 'GiriÅ BaÅarÄ±sÄ±z!';
}
break;   
default:
$inserted == 0;
}    

echo json_encode($json);
sqlsrv_free_stmt($query);  
sqlsrv_close($connect);

?>
