<?php

require_once('../conn.php');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $input     = json_decode(file_get_contents('php://input'), true);
    $tiempo_id = (int)($input['tiempo_id'] ?? 0);

    if ($tiempo_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'tiempo_id es requerido']);
        exit;
    }

    // Validar que existe el tiempo
    $check = pg_query_params($conn, 'SELECT 1 FROM tarea_tiempo WHERE tiempo_id=$1', [$tiempo_id]);
    if (!$check || pg_num_rows($check) === 0) {
        echo json_encode(['success' => false, 'message' => 'El tiempo no existe']);
        exit;
    }

    // Eliminar
    $sql    = 'DELETE FROM tarea_tiempo WHERE tiempo_id=$1';
    $result = pg_query_params($conn, $sql, [$tiempo_id]);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Tiempo eliminado correctamente']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al eliminar: ' . pg_last_error($conn)]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
