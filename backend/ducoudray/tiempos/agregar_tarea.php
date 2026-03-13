<?php

require_once('../conn.php'); // tu conexión PostgreSQL

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Leer JSON entrante
    $input = json_decode(file_get_contents('php://input'), true);

    $titulo      = trim($input['titulo'] ?? '');
    $descripcion = $input['descripcion'] ?? null;
    $usuario     = $input['usuario']     ?? '';
    $creado_en   = $input['creado_en']   ?? date('Y-m-d H:i:s');
    $registed_by = $input['registed_by'] ?? null;

    // Validar campos requeridos
    $empty_fields = [];
    if ($titulo === '') {
        $empty_fields[] = 'titulo';
    }
    if ($usuario === '') {
        $empty_fields[] = 'usuario';
    }

    if (!empty($empty_fields)) {
        echo json_encode([
            'success'      => false,
            'message'      => 'Campos obligatorios faltantes',
            'empty_fields' => $empty_fields
        ]);
        exit;
    }

    // Insertar tarea
    $sql = '
        INSERT INTO public.tarea (titulo, descripcion, usuario, creado_en,registed_by)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING tarea_id
    ';

    $params = [$titulo, $descripcion, $usuario, $creado_en,$registed_by];
    $result = pg_query_params($conn, $sql, $params);

    if ($result) {
        $id = pg_fetch_result($result, 0, 0);
        echo json_encode([
            'success'  => true,
            'message'  => 'Tarea registrada correctamente',
            'tarea_id' => $id
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Error al insertar: ' . pg_last_error($conn)
        ]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
