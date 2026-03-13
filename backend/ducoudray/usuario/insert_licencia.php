<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php'); // tu archivo pg_connect()
    require_once('../utils.php');

    // Leer el body JSON
    $input = json_decode(file_get_contents('php://input'), true);

    // Escapar datos del JSON
    $fields = [
        'usuario_id'     => $input['usuario_id']    ?? '',
        'nombre_chofer'  => $input['nombre_chofer'] ?? '',
        'categoria'      => $input['categoria']     ?? '',
        'restrinciones'  => $input['restrinciones'] ?? '',
        'fecha_emision'  => $input['fecha_emision'] ?? '',
        'first_emision'  => $input['first_emision'] ?? '',
        'estatura'       => $input['estatura']      ?? '',
        'peso'           => $input['peso']          ?? '',
        'sexo'           => $input['sexo']          ?? '',
        'tipo_sangre'    => $input['tipo_sangre']   ?? '',
        'nacimiento'     => $input['nacimiento']    ?? '',
        'vence'          => $input['vence']         ?? '',
        'id_cedula'      => $input['id_cedula']     ?? '',
    ];

    // Escapar cada campo
    foreach ($fields as $key => $value) {
        $fields[$key] = pg_escape_string($conn, $value);
    }

    // Validar campos obligatorios
    $required = ['usuario_id', 'nombre_chofer', 'categoria', 'restrinciones', 'fecha_emision', 'first_emision', 'estatura', 'peso', 'sexo', 'tipo_sangre', 'nacimiento', 'vence', 'id_cedula'];

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

    // Verificar si el usuario_id ya existe en la tabla licencia_chofer
    $check_query  = 'SELECT COUNT(*) as count FROM public.licencia_chofer WHERE usuario_id = $1';
    $check_result = pg_query_params($conn, $check_query, [$fields['usuario_id']]);
    $check_row    = pg_fetch_assoc($check_result);

    if ($check_row['count'] > 0) {
        echo json_encode([
            'success' => false,
            'message' => 'El usuario_id ya existe en la tabla licencia_chofer'
        ]);
        exit;
    }

    // Query de inserción
    $insert_query = 'INSERT INTO public.licencia_chofer (usuario_id, nombre_chofer, categoria, restrinciones, fecha_emision, first_emision, estatura, peso, sexo, tipo_sangre, nacimiento, vence, id_cedula)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13) RETURNING licencia_chofer_id;';

    $params = [
        $fields['usuario_id'],
        $fields['nombre_chofer'],
        $fields['categoria'],
        $fields['restrinciones'],
        $fields['fecha_emision'],
        $fields['first_emision'],
        $fields['estatura'],
        $fields['peso'],
        $fields['sexo'],
        $fields['tipo_sangre'],
        $fields['nacimiento'],
        $fields['vence'],
        $fields['id_cedula']
    ];

    $result = pg_query_params($conn, $insert_query, $params);

    if ($result) {
        echo json_encode([
            'success'    => true,
            'message'    => 'Licencia registrado exitosamente.'
        ]);
        exit;
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Error al registrar: ' . pg_last_error($conn)
        ]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
