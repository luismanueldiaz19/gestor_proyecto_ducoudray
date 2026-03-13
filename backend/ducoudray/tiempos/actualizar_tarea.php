<?php

require_once('../conn.php'); // tu conexión PostgreSQL

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Leer JSON entrante
    $input = json_decode(file_get_contents('php://input'), true);

    $tarea_id    = $input['tarea_id']    ?? null;
    $titulo      = trim($input['titulo'] ?? '');
    $descripcion = $input['descripcion']   ?? null;
    $estado      = $input['estado']        ?? null;
    $feedback    = $input['feedback']      ?? null;

    // Validar campos requeridos
    $empty_fields = [];
    if ($tarea_id === null) {
        $empty_fields[] = 'tarea_id';
    }
    if ($titulo === '') {
        $empty_fields[] = 'titulo';
    }
    if ($estado === null) {
        $empty_fields[] = 'estado';
    }

    if (!empty($empty_fields)) {
        echo json_encode([
            'success'      => false,
            'message'      => 'Campos obligatorios faltantes',
            'empty_fields' => $empty_fields
        ]);
        exit;
    }

    // Actualizar tarea
    $sql = '
        UPDATE public.tarea
        SET titulo = $1,
            descripcion = $2,
            estado = $3,
            actualizado_en = NOW() , feedback = $4
        WHERE tarea_id = $5
        RETURNING tarea_id
    ';

    $params = [$titulo, $descripcion, $estado, $feedback, $tarea_id];
    $result = pg_query_params($conn, $sql, $params);

    if ($result && pg_num_rows($result) > 0) {
        $id = pg_fetch_result($result, 0, 0);
        echo json_encode([
            'success'  => true,
            'message'  => 'Tarea actualizada correctamente',
            'tarea_id' => $id
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Error al actualizar: ' . pg_last_error($conn)
        ]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
