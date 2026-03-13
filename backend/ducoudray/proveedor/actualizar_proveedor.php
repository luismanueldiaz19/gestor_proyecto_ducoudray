<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');
    require_once('../utils.php');

    $input = json_decode(file_get_contents('php://input'), true);

    $fields = [
        'id_proveedor'     => $input['id_proveedor']     ?? '',
        'nombre_proveedor' => $input['nombre_proveedor'] ?? '',
        'rnc'              => $input['rnc']              ?? '',
        'telefono'         => $input['telefono']         ?? '',
        'correo'           => $input['correo']           ?? '',
        'direccion'        => $input['direccion']        ?? '',
        'tipo_proveedor'   => $input['tipo_proveedor']   ?? '',
    ];

    foreach ($fields as $k => $v) {
        $fields[$k] = pg_escape_string($conn, $v);
    }

    if (empty($fields['id_proveedor'])) {
        echo json_encode([
            'success' => false,
            'message' => 'id_proveedor'
        ]);
        exit;
    }

    // 🔎 Verificar si ya existe otro proveedor con el mismo nombre
    $checkQuery = '
        SELECT 1 
        FROM public.proveedores 
        WHERE LOWER(nombre_proveedor) = LOWER($1) 
          AND id_proveedor <> $2
        LIMIT 1
    ';
    $checkParams = [$fields['nombre_proveedor'], $fields['id_proveedor']];
    $checkResult = pg_query_params($conn, $checkQuery, $checkParams);

    if (pg_num_rows($checkResult) > 0) {
        echo json_encode([
            'success' => false,
            'message' => 'El nombre del proveedor ya existe en otro registro.'
        ]);
        pg_close($conn);
        exit;
    }

    // ✅ Si no existe duplicado, proceder con el UPDATE
    $query = '
        UPDATE public.proveedores
        SET nombre_proveedor = $2,
            rnc              = $3,
            telefono         = $4,
            correo           = $5,
            direccion        = $6,
            tipo_proveedor   = $7
        WHERE id_proveedor = $1
    ';

    $params = [
        $fields['id_proveedor'],
        $fields['nombre_proveedor'],
        $fields['rnc'],
        $fields['telefono'],
        $fields['correo'],
        $fields['direccion'],
        $fields['tipo_proveedor']
    ];

    $result = pg_query_params($conn, $query, $params);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Proveedor actualizado correctamente.']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al actualizar: ' . pg_last_error($conn)]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
