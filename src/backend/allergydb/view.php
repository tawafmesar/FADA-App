<?php

include "../connect.php";


$id = filterRequest("id");


$stmt = $con->prepare("SELECT 
    a.id AS allergy_id,
    a.ingredient_name,
    a.description AS allergy_description,
    d.id AS derivative_id,
    d.derivative_name,
    d.description AS derivative_description,
    CASE 
        WHEN ua.allergy_id IS NOT NULL THEN 'Activated' 
        ELSE 'Inactive' 
    END AS status,
    CASE  
        WHEN a.is_system = 1 THEN 'System'
        ELSE CONCAT('User (ID: ', a.created_by_user_id, ')')
    END AS created_by
FROM 
    allergydb a
LEFT JOIN 
    allergenic_derivatives d ON a.id = d.allergenic_ingredient_id
LEFT JOIN 
    userallergen ua ON a.id = ua.allergy_id AND ua.user_id = ?
WHERE 
    a.is_system = 1 
    OR a.created_by_user_id = ?
ORDER BY 
    a.id, d.id;

 ");
$stmt->execute(array($id,$id));
$count = $stmt->rowCount();
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else {
    echo json_encode(array("status" => "failure"));
}
