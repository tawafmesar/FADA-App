<?php 

include "../connect.php" ; 

$id = filterRequest("id") ; 
$user_id = filterRequest("user_id") ; 


deleteData("allergydb" , "id   = $id AND created_by_user_id = $user_id") ; 

