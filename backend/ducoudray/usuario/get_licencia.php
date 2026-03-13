<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');
    require_once('../utils.php');

    $input = json_decode(file_get_contents('php://input'), true);

    $usuario_id = $input['usuario_id'] ?? '';

    if (empty($usuario_id)) {
        echo json_encode([
            'success' => false,
            'message' => 'usuario_id es obligatorio'
        ]);
        exit;
    }

    $query = 'SELECT 
        licencia_chofer_id, 
        usuario_id, 
        nombre_chofer, 
        categoria, 
        restrinciones, 
        fecha_emision, 
        first_emision, 
        estatura, 
        peso, 
        sexo, 
        tipo_sangre,
        nacimiento, 
        vence, 
        id_cedula
    FROM public.licencia_chofer
    WHERE usuario_id = $1
    LIMIT 1';

    $result = pg_query_params($conn, $query, [$usuario_id]);

    if ($result && pg_num_rows($result) > 0) {
        $data = pg_fetch_assoc($result); // 👈 devuelve un solo registro

        echo json_encode([
            'success' => true,
            'message' => 'Datos encontrados.',
            'data'    => $data
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'No se encontraron registros.'
        ]);
    }

    pg_close($conn);
    exit;
}

header('HTTP/1.1 405 Method Not Allowed');
echo json_encode(['success' => false, 'message' => 'Método no permitido']);
