<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

$input=json_decode(file_get_contents('php://input'),true);

if(!isset($input['id_proyecto'])){

echo json_encode([
'success'=>false,
'message'=>'ID requerido',
'data'=>[]
]);

exit;

}

$query='UPDATE proyectos SET
cliente_id = $1,nombre = $2,alcance = $3,entregables = $4,cronograma = $5,fecha_inicio = $6,fecha_fin = $7
WHERE id_proyecto=$8';

$params=[
$input['cliente_id'] ?? null,
$input['nombre'] ?? null,
$input['alcance'] ?? null,
$input['entregables'] ?? null,
$input['cronograma'] ?? null,
$input['fecha_inicio'] ?? null,
$input['fecha_fin'] ?? null,
$input['id_proyecto']
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