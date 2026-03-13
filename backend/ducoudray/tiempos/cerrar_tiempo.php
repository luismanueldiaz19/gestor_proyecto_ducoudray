<?php

require_once('../conn.php');
header('Content-Type: application/json');

// Zona horaria recomendada
date_default_timezone_set('America/Santo_Domingo');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $input = json_decode(file_get_contents('php://input'), true);

    $tarea_id = (int)($input['tarea_id'] ?? 0);

    if ($tarea_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'tarea_id es requerido']);
        exit;
    }

    // 1️⃣ Validar que la tarea existe
    $check_tarea = pg_query_params($conn, 'SELECT 1 FROM tarea WHERE tarea_id=$1', [$tarea_id]);
    if (!$check_tarea || pg_num_rows($check_tarea) === 0) {
        echo json_encode(['success' => false, 'message' => 'La tarea no existe']);
        exit;
    }

    // 2️⃣ Validar que exista un tiempo abierto
    $check_abierto = pg_query_params(
        $conn,
        'SELECT tiempo_id FROM tarea_tiempo WHERE tarea_id=$1 AND fin IS NULL',
        [$tarea_id]
    );

    if (!$check_abierto || pg_num_rows($check_abierto) === 0) {
        echo json_encode([
            'success' => false,
            'message' => 'No hay un tiempo abierto para esta tarea'
        ]);
        exit;
    }

    $tiempo_id = pg_fetch_result($check_abierto, 0, 0);

    $fin = date('Y-m-d H:i:s');

    // 3️⃣ Cerrar tiempo
    $sql = '
        UPDATE tarea_tiempo
        SET fin = $1
        WHERE tiempo_id = $2
    ';
    $result = pg_query_params($conn, $sql, [$fin, $tiempo_id]);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Tiempo cerrado correctamente']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al cerrar: ' . pg_last_error($conn)]);
    }

    pg_close($conn);
} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
