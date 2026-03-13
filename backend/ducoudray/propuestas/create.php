<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

$input = json_decode(file_get_contents('php://input'), true);

$fields = [
'cliente_id' => trim($input['cliente_id'] ?? ''),
'fecha' => trim($input['fecha'] ?? ''),
'descripcion' => trim($input['descripcion'] ?? ''),
'archivo_pdf' => trim($input['archivo_pdf'] ?? ''),
'estado' => trim($input['estado'] ?? ''),
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

$query='INSERT INTO propuestas (cliente_id,fecha,descripcion,archivo_pdf,estado)
VALUES ($1,$2,$3,$4,$5)
RETURNING id_propuesta';

$params=[
$fields['cliente_id'],
$fields['fecha'],
$fields['descripcion'],
$fields['archivo_pdf'],
$fields['estado'],
];

$result=pg_query_params($conn,$query,$params);

if($result){

    $id=pg_fetch_result($result,0,0);

    echo json_encode([
        'success'=>true,
        'message'=>'Registro creado correctamente',
        'data'=>['id_propuesta'=>$id]
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