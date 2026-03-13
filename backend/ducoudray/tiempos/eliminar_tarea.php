<?php

require_once('../conn.php');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $input    = json_decode(file_get_contents('php://input'), true);
    $tarea_id = (int)($input['tarea_id'] ?? 0);

    if ($tarea_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'tarea_id es requerido']);
        exit;
    }

    // Validar que la tarea existe
    $check = pg_query_params($conn, 'SELECT 1 FROM tarea WHERE tarea_id=$1', [$tarea_id]);
    if (!$check || pg_num_rows($check) === 0) {
        echo json_encode(['success' => false, 'message' => 'La tarea no existe']);
        exit;
    }

    // Eliminar tarea (sus tiempos caen por cascade)
    $sql    = 'DELETE FROM tarea WHERE tarea_id=$1';
    $result = pg_query_params($conn, $sql, [$tarea_id]);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Tarea eliminada correctamente']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al eliminar: ' . pg_last_error($conn)]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
