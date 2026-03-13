<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

$input=json_decode(file_get_contents('php://input'),true);

if(!isset($input['id_propuesta'])){

echo json_encode([
'success'=>false,
'message'=>'ID requerido',
'data'=>[]
]);

exit;

}

$query='UPDATE propuestas SET
cliente_id = $1,fecha = $2,descripcion = $3,archivo_pdf = $4,estado = $5
WHERE id_propuesta=$6';

$params=[
$input['cliente_id'] ?? null,
$input['fecha'] ?? null,
$input['descripcion'] ?? null,
$input['archivo_pdf'] ?? null,
$input['estado'] ?? null,
$input['id_propuesta']
];

$result=pg_query_params($conn,$query,$params);

if($result){

echo json_encode([
'success'=>true,
'message'=>'Registro actualizado',
'data'=>[]
]);

}else{

echo json_encode([
'success'=>false,
'message'=>pg_last_error($conn),
'data'=>[]
]);

}

pg_close($conn);

}else{

echo json_encode([
'success'=>false,
'message'=>'Metodo no permitido',
'data'=>[]
]);

}
?>