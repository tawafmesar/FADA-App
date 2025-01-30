<?php

include "../connect.php";


$ingredient_name = filterRequest("ingredient_name");
$description = filterRequest("description");
$created_by_user_id = filterRequest("created_by_user_id");


    $data = array(
        "ingredient_name" => $ingredient_name,
        "description" =>  $description,
        "created_by_user_id" => $created_by_user_id,
        "is_system" => 0,

    );
    insertData("allergydb" , $data) ; 

