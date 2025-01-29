<?php

include "../connect.php";

$username = filterRequest("username");
$password = sha1($_POST['password']);
$email = filterRequest("email");
$verfiycode     = rand(10000 , 99999);


$stmt = $con->prepare("SELECT * FROM users WHERE users_email = ? ");
$stmt->execute(array($email));
$count = $stmt->rowCount();
if ($count > 0) {
    printFailure("This Email is already registered");
} else {

    $data = array(
        "users_name" => $username,
        "users_password" =>  $password,
        "users_email" => $email,
        "users_verfiycode" => $verfiycode ,
        "users_role" => 1 ,

    );
    sendEmail(
        $email, 
        "Dear User,

We are delighted to assist you through the FADA App.

Your verification code to confirm your account is: $verfiycode
---
If you did not request this code, please disregard this email.

Best regards,
[The FADA App Team]",
        "Account Verification Code - FADA App"
    );
        insertData("users" , $data) ; 

}