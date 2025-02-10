<?php


include "../connect.php";

$id = filterRequest("id");

$user_id = filterRequest("user_id");
$data = array(
    "user_id" => $user_id,
    "allergy_id" =>  $id,

);
insertData("userallergen" , $data) ; 

?>