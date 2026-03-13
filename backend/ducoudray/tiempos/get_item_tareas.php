<?php

require_once('../conn.php');
header('Content-Type: application/json');

// Zona horaria
date_default_timezone_set('America/Santo_Domingo');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $input = json_decode(file_get_contents('php://input'), true);

    $tarea_id = (int)($input['tarea_id'] ?? 0);

    if ($tarea_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'tarea_id es requerido']);
        exit;
    }

    // 1️⃣ Validar que la tarea exista
    $check = pg_query_params($conn, 'SELECT 1 FROM tarea WHERE tarea_id=$1', [$tarea_id]);

    if (!$check || pg_num_rows($check) === 0) {
        echo json_encode(['success' => false, 'message' => 'La tarea no existe']);
        exit;
    }

    // 2️⃣ Obtener los tiempos de la tarea
    $sql = '
        SELECT
            tiempo_id,
            tarea_id,
            inicio,
            fin,
            CASE 
                WHEN fin IS NOT NULL THEN EXTRACT(EPOCH FROM (fin - inicio)) / 3600
                ELSE NULL
            END AS horas
        FROM public.tarea_tiempo
        WHERE tarea_id = $1
        ORDER BY tiempo_id ASC
    ';

    $result = pg_query_params($conn, $sql, [$tarea_id]);

    if (!$result) {
        echo json_encode([
            'success' => false,
            'message' => 'Error al consultar: ' . pg_last_error($conn)
        ]);
        exit;
    }

    $data = [];
    while ($row = pg_fetch_assoc($result)) {
        $row['horas'] = $row['horas'] !== null ? round((float)$row['horas'], 2) : null;
        $data[]       = $row;
    }

    echo json_encode([
        'success' => true,
        'data'    => $data
    ]);

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
