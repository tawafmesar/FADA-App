<?php


include "../connect.php";


$id = filterRequest("id");


getAllData("scanhistory", "user_id  = ?  ", array($id));

