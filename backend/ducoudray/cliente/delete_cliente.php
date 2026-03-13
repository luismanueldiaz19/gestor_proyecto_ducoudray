<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');
    require_once('../utils.php');

    // Leer JSON
    $input = json_decode(file_get_contents('php://input'), true);

    $fields = [
        'cliente_id' => $input['cliente_id'] ?? ''
    ];

    // Escapar datos
    foreach ($fields as $key => $value) {
        if ($value !== null) {
            $fields[$key] = pg_escape_string($conn, $value);
        }
    }

    // Validar campo obligatorio
    if (empty($fields['cliente_id'])) {
        echo json_encode([
            'success' => false,
            'message' => 'cliente_id es obligatorio'
        ]);
        exit;
    }

    // 1️⃣ Verificar si existe
    $query_check  = 'SELECT cliente_id FROM public.clientes WHERE cliente_id = $1';
    $result_check = pg_query_params($conn, $query_check, [$fields['cliente_id']]);

    if (pg_num_rows($result_check) == 0) {
        echo json_encode([
            'success' => false,
            'message' => 'El cliente no existe'
        ]);
        exit;
    }

    // 2️⃣ Eliminar cliente
    $delete_query = 'DELETE FROM public.clientes WHERE cliente_id = $1';

    $result_delete = pg_query_params($conn, $delete_query, [
        $fields['cliente_id']
    ]);

    if ($result_delete) {
        echo json_encode([
            'success' => true,
            'message' => 'Cliente eliminado correctamente'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Error al eliminar: ' . pg_last_error($conn)
        ]);
    }

    pg_close($conn);

} else {

    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido'
    ]);

}
