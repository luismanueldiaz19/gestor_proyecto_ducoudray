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

$query='DELETE FROM oportunidades WHERE id_oportunidad=$1';

$result=pg_query_params($conn,$query,[$input['id_oportunidad']]);

if($result){

echo json_encode([
'success'=>true,
'message'=>'Registro eliminado',
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