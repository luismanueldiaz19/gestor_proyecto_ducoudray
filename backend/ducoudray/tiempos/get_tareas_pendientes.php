<?php

require_once('../conn.php');
header('Content-Type: application/json');

date_default_timezone_set('America/Santo_Domingo');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Recibir el usuario opcionalmente
    $usuario = isset($_POST['usuario']) ? trim($_POST['usuario']) : null;

    $sql = "
        SELECT
            t.creado_en,
            t.estado,
            t.tarea_id,
            t.titulo,
            t.descripcion,
            t.feedback,
            t.registed_by,
            t.usuario AS hecho_por,
            COALESCE(SUM(EXTRACT(EPOCH FROM (tt.fin - tt.inicio)) / 3600), 0) AS horas,
            EXISTS (
                SELECT 1
                FROM public.tarea_tiempo tt2
                WHERE tt2.tarea_id = t.tarea_id
                AND tt2.fin IS NULL
            ) AS tiempo_abierto
        FROM public.tarea t
        LEFT JOIN public.tarea_tiempo tt ON t.tarea_id = tt.tarea_id
        WHERE t.estado <> 'completado'
    ";

    // Si enviaron usuario, agregamos condición
    if (!empty($usuario)) {
        $usuario = strtolower(pg_escape_string($conn, $usuario)); // convertir a minúscula
        $sql .= " AND LOWER(t.usuario) = '{$usuario}'"; // comparar en minúscula
    }

    $sql .= '
        GROUP BY t.creado_en,t.estado,t.descripcion,t.feedback,
            t.registed_by, t.tarea_id, t.titulo, t.usuario
        ORDER BY t.creado_en, t.usuario ASC
    ';

    $result = pg_query($conn, $sql);

    if (!$result) {
        echo json_encode([
            'success' => false,
            'message' => 'Error al obtener tareas: ' . pg_last_error($conn)
        ]);
        exit;
    }

    $data = [];
    while ($row = pg_fetch_assoc($result)) {
        $row['horas']          = (float)$row['horas'];
        $row['tiempo_abierto'] = ($row['tiempo_abierto'] === 't');
        $data[]                = $row;
    }

    echo json_encode([
        'success' => true,
        'data'    => $data
    ]);

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido'
    ]);
}
