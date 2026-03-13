<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');
    require_once('../utils.php');

    // Leer JSON
    $input = json_decode(file_get_contents('php://input'), true);

    $fields = [
        'cliente_id'   => $input['cliente_id']   ?? '',
        'nombre'       => $input['nombre']       ?? '',
        'direccion'    => $input['direccion']    ?? '',
        'telefono'     => $input['telefono']     ?? '',
        'email'        => $input['email']        ?? null,
        'tipo_cliente' => $input['tipo_cliente'] ?? null
    ];

    // Escapar datos
    foreach ($fields as $key => $value) {
        if ($value !== null) {
            $fields[$key] = pg_escape_string($conn, $value);
        }
    }

    // Campos obligatorios
    $required = ['cliente_id','nombre'];

    $empty_fields = [];

    foreach ($required as $field) {
        if (empty($fields[$field])) {
            $empty_fields[] = $field;
        }
    }

    if (!empty($empty_fields)) {
        echo json_encode([
            'success'      => false,
            'message'      => 'Campos obligatorios incompletos',
            'empty_fields' => $empty_fields
        ]);
        exit;
    }

    // Query
    $update_query = '
        UPDATE public.clientes SET 
            nombre = $1,
            direccion = $2,
            telefono = $3,
            email = $4,
            tipo_cliente = $5
        WHERE cliente_id = $6
    ';

    $params = [
        $fields['nombre'],
        $fields['direccion'],
        $fields['telefono'],
        $fields['email'],
        $fields['tipo_cliente'],
        $fields['cliente_id']
    ];

    $result = pg_query_params($conn, $update_query, $params);

    if ($result) {
        echo json_encode([
            'success' => true,
            'message' => 'Cliente actualizado correctamente.'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Error al actualizar: ' . pg_last_error($conn)
        ]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido'
    ]);
}
