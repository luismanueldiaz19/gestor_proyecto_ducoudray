<?php

require_once('../conn.php');
require_once('../utils.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $input = json_decode(file_get_contents('php://input'), true);

    $fields = [
    'nombre'       => trim($input['nombre'] ?? ''),
    'direccion'    => trim($input['direccion'] ?? ''),
    'telefono'     => trim($input['telefono'] ?? ''),
    'email'        => trim($input['email'] ?? ''),
    'tipo_cliente' => trim($input['tipo_cliente'] ?? ''),
    ];

    $empty_fields=[];

    foreach($fields as $key=>$value) {
        if($value==='') {
            $empty_fields[]=$key;
        }
    }

    if(!empty($empty_fields)) {
        echo json_encode([
            'success'=> false,
            'message'=> 'Campos obligatorios faltantes',
            'data'   => $empty_fields
        ]);
        exit;
    }

    $query='INSERT INTO clientes (nombre,direccion,telefono,email,tipo_cliente)
            VALUES ($1,$2,$3,$4,$5)
            RETURNING cliente_id';

    $params=[
    $fields['nombre'],
    $fields['direccion'],
    $fields['telefono'],
    $fields['email'],
    $fields['tipo_cliente'],
    ];

    $result=pg_query_params($conn, $query, $params);

    if($result) {

        $id=pg_fetch_result($result, 0, 0);

        echo json_encode([
            'success'=> true,
            'message'=> 'Registro creado correctamente',
            'data'   => ['cliente_id'=>$id]
        ]);

    } else {

        echo json_encode([
            'success'=> false,
            'message'=> pg_last_error($conn),
            'data'   => []
        ]);

    }

    pg_close($conn);

} else {

    echo json_encode([
    'success'=> false,
    'message'=> 'Metodo no permitido',
    'data'   => []
    ]);

}
