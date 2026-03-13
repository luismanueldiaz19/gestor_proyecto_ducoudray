<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

$input = json_decode(file_get_contents('php://input'), true);

$fields = [
'cliente_id' => trim($input['cliente_id'] ?? ''),
'nombre' => trim($input['nombre'] ?? ''),
'alcance' => trim($input['alcance'] ?? ''),
'entregables' => trim($input['entregables'] ?? ''),
'cronograma' => trim($input['cronograma'] ?? ''),
'fecha_inicio' => trim($input['fecha_inicio'] ?? ''),
'fecha_fin' => trim($input['fecha_fin'] ?? ''),
];

$empty_fields=[];

foreach($fields as $key=>$value){
    if($value===''){
        $empty_fields[]=$key;
    }
}

if(!empty($empty_fields)){
    echo json_encode([
        'success'=>false,
        'message'=>'Campos obligatorios faltantes',
        'data'=>$empty_fields
    ]);
    exit;
}

$query='INSERT INTO proyectos (cliente_id,nombre,alcance,entregables,cronograma,fecha_inicio,fecha_fin)
VALUES ($1,$2,$3,$4,$5,$6,$7)
RETURNING id_proyecto';

$params=[
$fields['cliente_id'],
$fields['nombre'],
$fields['alcance'],
$fields['entregables'],
$fields['cronograma'],
$fields['fecha_inicio'],
$fields['fecha_fin'],
];

$result=pg_query_params($conn,$query,$params);

if($result){

    $id=pg_fetch_result($result,0,0);

    echo json_encode([
        'success'=>true,
        'message'=>'Registro creado correctamente',
        'data'=>['id_proyecto'=>$id]
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