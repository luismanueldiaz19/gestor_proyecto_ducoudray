<?php

require_once('../conn.php');
header('Content-Type: application/json');

// Zona horaria usada por PHP (por si usamos date más adelante)
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

    // 2️⃣ Validar que NO haya un tiempo abierto
    $check_abierto = pg_query_params(
        $conn,
        'SELECT 1 FROM tarea_tiempo WHERE tarea_id=$1 AND fin IS NULL',
        [$tarea_id]
    );

    if ($check_abierto && pg_num_rows($check_abierto) > 0) {
        echo json_encode([
            'success' => false,
            'message' => 'Ya existe un tiempo abierto para esta tarea'
        ]);
        exit;
    }

    $inicio = date('Y-m-d H:i:s');

    // 3️⃣ Insertar tiempo (inicio se toma automático con DEFAULT NOW())
    $sql = '
        INSERT INTO public.tarea_tiempo (tarea_id,inicio)
        VALUES ($1,$2)
        RETURNING tiempo_id, inicio
    ';
    $result = pg_query_params($conn, $sql, [$tarea_id,$inicio]);

    if ($result) {
        $row = pg_fetch_assoc($result);
        echo json_encode([
            'success'   => true,
            'message'   => 'Tiempo iniciado',
            'tiempo_id' => $row['tiempo_id'],
            'inicio'    => $row['inicio'] // Se devuelve la hora que guardó Postgres
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al iniciar: ' . pg_last_error($conn)]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
