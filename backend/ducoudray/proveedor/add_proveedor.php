<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php'); // tu archivo pg_connect()
    require_once('../utils.php');

    // Leer JSON del body
    $input = json_decode(file_get_contents('php://input'), true);

    // Campos recibidos
    $fields = [
        'nombre_proveedor' => $input['nombre_proveedor'] ?? '',
        'rnc'              => $input['rnc']              ?? '',
        'telefono'         => $input['telefono']         ?? '',
        'correo'           => $input['correo']           ?? '',
        'direccion'        => $input['direccion']        ?? '',
        'tipo_proveedor'   => $input['tipo_proveedor']   ?? '',
        'registrado_por'   => $input['registrado_por']   ?? '',
    ];

    // Sanitizar/escapar
    foreach ($fields as $k => $v) {
        $fields[$k] = pg_escape_string($conn, $v);
    }

    // Validación obligatoria
    $required = ['nombre_proveedor', 'registrado_por'];

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

    // ------------------------------------------
    // 🔍 VALIDAR SI YA EXISTE EL NOMBRE
    // ------------------------------------------
    $sql_check = 'SELECT id_proveedor 
                  FROM public.proveedores 
                  WHERE LOWER(nombre_proveedor) = LOWER($1)
                  LIMIT 1';

    $result_check = @pg_query_params($conn, $sql_check, [$fields['nombre_proveedor']]);

    if ($result_check && pg_num_rows($result_check) > 0) {
        echo json_encode([
            'success' => false,
            'existe'  => true,
            'message' => 'Este proveedor ya está registrado.'
        ]);
        exit;
    }

    // INSERT
    $query = '
        INSERT INTO public.proveedores (
            nombre_proveedor, rnc, telefono, correo, direccion,
            tipo_proveedor, registrado_por
        )
        VALUES ($1,$2,$3,$4,$5,$6,$7)
        RETURNING id_proveedor;
    ';

    $params = [
        $fields['nombre_proveedor'],
        $fields['rnc'],
        $fields['telefono'],
        $fields['correo'],
        $fields['direccion'],
        $fields['tipo_proveedor'],
        $fields['registrado_por']
    ];

    $result = @pg_query_params($conn, $query, $params);

    if ($result) {
        $row = pg_fetch_assoc($result);
        echo json_encode([
            'success'       => true,
            'message'       => 'Proveedor registrado correctamente.',
            'id_proveedor'  => $row['id_proveedor']
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
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido'
    ]);
}
