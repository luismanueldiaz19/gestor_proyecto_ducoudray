<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

$input=json_decode(file_get_contents('php://input'),true);

if(!isset($input['id_oportunidad'])){

echo json_encode([
'success'=>false,
'message'=>'ID requerido',
'data'=>[]
]);

exit;

}

$query='UPDATE oportunidades SET
cliente_id = $1,descripcion = $2,fecha = $3,probabilidad = $4,valor_estimado = $5
WHERE id_oportunidad=$6';

$params=[
$input['cliente_id'] ?? null,
$input['descripcion'] ?? null,
$input['fecha'] ?? null,
$input['probabilidad'] ?? null,
$input['valor_estimado'] ?? null,
$input['id_oportunidad']
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