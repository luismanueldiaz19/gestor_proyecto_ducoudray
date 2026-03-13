<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

$input=json_decode(file_get_contents('php://input'),true);

if(!isset($input['id_factura'])){

echo json_encode([
'success'=>false,
'message'=>'ID requerido',
'data'=>[]
]);

exit;

}

$query='UPDATE facturacion SET
cliente_id = $1,id_proyecto = $2,fecha = $3,monto = $4,estado = $5
WHERE id_factura=$6';

$params=[
$input['cliente_id'] ?? null,
$input['id_proyecto'] ?? null,
$input['fecha'] ?? null,
$input['monto'] ?? null,
$input['estado'] ?? null,
$input['id_factura']
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