<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');
    require_once('../utils.php');

    $input = json_decode(file_get_contents('php://input'), true);

    $licencia_chofer_id = $input['licencia_chofer_id'] ?? '';

    if (empty($licencia_chofer_id)) {
        echo json_encode([
            'success' => false,
            'message' => 'licencia_chofer_id es obligatorio'
        ]);
        exit;
    }

    $delete_query = 'DELETE FROM public.licencia_chofer WHERE licencia_chofer_id = $1';
    $result       = pg_query_params($conn, $delete_query, [$licencia_chofer_id]);

    if ($result && pg_affected_rows($result) > 0) {
        echo json_encode(['success' => true, 'message' => 'Licencia eliminada correctamente.']);
    } else {
        echo json_encode(['success' => false, 'message' => 'No se encontró el registro o no se pudo eliminar.']);
    }

    pg_close($conn);
    exit;
}

header('HTTP/1.1 405 Method Not Allowed');
echo json_encode(['success' => false, 'message' => 'Método no permitido']);
