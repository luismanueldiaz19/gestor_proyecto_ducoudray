<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');
    require_once('../utils.php');

    $input = json_decode(file_get_contents('php://input'), true);

    // Campos esperados
    $fields = [
        'licencia_chofer_id' => $input['licencia_chofer_id'] ?? '',
        'usuario_id'         => $input['usuario_id']         ?? '',
        'nombre_chofer'      => $input['nombre_chofer']      ?? '',
        'categoria'          => $input['categoria']          ?? '',
        'restrinciones'      => $input['restrinciones']      ?? '',
        'fecha_emision'      => $input['fecha_emision']      ?? '',
        'first_emision'      => $input['first_emision']      ?? '',
        'estatura'           => $input['estatura']           ?? '',
        'peso'               => $input['peso']               ?? '',
        'sexo'               => $input['sexo']               ?? '',
        'tipo_sangre'        => $input['tipo_sangre']        ?? '',
        'nacimiento'         => $input['nacimiento']         ?? '',
        'vence'              => $input['vence']              ?? '',
        'id_cedula'          => $input['id_cedula']          ?? '',
    ];

    // Escapar valores
    foreach ($fields as $key => $value) {
        $fields[$key] = pg_escape_string($conn, $value);
    }

    // Validar ID
    if (empty($fields['licencia_chofer_id'])) {
        echo json_encode([
            'success' => false,
            'message' => 'licencia_chofer_id es obligatorio'
        ]);
        exit;
    }

    // Query UPDATE
    $update_query = 'UPDATE public.licencia_chofer SET 
        usuario_id = $1,
        nombre_chofer = $2,
        categoria = $3,
        restrinciones = $4,
        fecha_emision = $5,
        first_emision = $6,
        estatura = $7,
        peso = $8,
        sexo = $9,
        tipo_sangre = $10,
        nacimiento = $11,
        vence = $12,
        id_cedula = $13
    WHERE licencia_chofer_id = $14';

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
        $fields['id_cedula'],
        $fields['licencia_chofer_id']
    ];

    $result = pg_query_params($conn, $update_query, $params);

    if ($result && pg_affected_rows($result) > 0) {
        echo json_encode(['success' => true, 'message' => 'Licencia actualizada correctamente.']);
    } else {
        echo json_encode(['success' => false, 'message' => 'No se encontró registro o no se actualizó.']);
    }

    pg_close($conn);
    exit;
}

header('HTTP/1.1 405 Method Not Allowed');
echo json_encode(['success' => false, 'message' => 'Método no permitido']);
