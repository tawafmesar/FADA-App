<?php


include "../connect.php";

$id = filterRequest("id");

$user_id = filterRequest("user_id");


deleteData("userallergen" , "user_id  = $user_id AND  allergy_id  = $id") ; 


?>