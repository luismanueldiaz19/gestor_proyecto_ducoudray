<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if($_SERVER['REQUEST_METHOD']==='POST'){

$query='SELECT * FROM propuestas ORDER BY id_propuesta DESC';

$result=pg_query($conn,$query);

$data=[];

if($result){

while($row=pg_fetch_assoc($result)){
$data[]=$row;
}

if(count($data)>0){

echo json_encode([
'success'=>true,
'message'=>'Registros encontrados',
'data'=>$data
]);

}else{

echo json_encode([
'success'=>false,
'message'=>'No hay registros',
'data'=>[]
]);

}

}else{

echo json_encode([
'success'=>false,
'message'=>'Error en consulta',
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