<?php

include "../connect.php";

$recognized_text = filterRequest("recognized_text");
$result = filterRequest("result");
$user_id = filterRequest("user_id");

$file_path = imageUpload("file");

$stmt = $con->prepare("SELECT COUNT(*) FROM users WHERE users_id = ?");
$stmt->execute([$user_id]);
$userExists = $stmt->fetchColumn();

if ($userExists) {
    $data = array(
        "file_path" => $file_path,
        "recognized_text" => $recognized_text,
        "result" => $result,
        "user_id" => $user_id
    );

    insertData("scanhistory", $data);
} else {
    echo "Error: user_id does not exist.";
}