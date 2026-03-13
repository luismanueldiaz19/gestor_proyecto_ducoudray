<?php

require_once('../conn.php');
header('Content-Type: application/json');

// Zona horaria
date_default_timezone_set('America/Santo_Domingo');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $input = json_decode(file_get_contents('php://input'), true);

    $date1 = $input['date1'] ?? null;
    $date2 = $input['date2'] ?? null;

    if (!$date1 || !$date2) {
        echo json_encode(['success' => false, 'message' => 'date1 y date2 son requeridos']);
        exit;
    }

    $sql = '
        SELECT
            t.estado,
            t.tarea_id,
            t.titulo,
            t.descripcion,
            t.usuario AS hecho_por,
            t.registed_by,
            t.feedback,
            COALESCE(SUM(EXTRACT(EPOCH FROM (tt.fin - tt.inicio)) / 3600), 0) AS horas,
            t.creado_en
        FROM public.tarea t
        LEFT JOIN public.tarea_tiempo tt ON t.tarea_id = tt.tarea_id
        WHERE t.estado = \'completado\'
        AND DATE(t.creado_en) BETWEEN $1 AND $2
        GROUP BY t.estado, t.tarea_id, t.titulo,t.descripcion, t.usuario, t.creado_en, t.registed_by, t.feedback
        ORDER BY t.tarea_id
    ';

    $result = pg_query_params($conn, $sql, [$date1, $date2]);

    if (!$result) {
        echo json_encode([
            'success' => false,
            'message' => 'Error al consultar: ' . pg_last_error($conn)
        ]);
        exit;
    }

    $data = [];
    while ($row = pg_fetch_assoc($result)) {
        $row['horas'] = (float)$row['horas'];
        $data[]       = $row;
    }

    if (count($data) === 0) {
        echo json_encode([
            'success' => false,
            'message' => 'No hay registros en ese rango',
            'data'    => []
        ]);
    } else {
        echo json_encode([
            'success' => true,
            'data'    => $data
        ]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
