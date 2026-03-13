<?php

require_once('../conn.php');
require_once('../utils.php'); // ya incluye headers JSON y CORS

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'Método no permitido'
    ], 405);
}

// Consulta SQL
$sql = 'SELECT cliente_id, nombre, direccion, telefono, email, tipo_cliente FROM public.clientes ORDER BY nombre ASC';

$result = pg_query_params($conn, $sql, []);

if (!$result) {
    json_response([
        'success' => false,
        'message' => 'Error en la consulta: ' . pg_last_error($conn)
    ]);
}

$rows = pg_fetch_all($result);

json_response([
    'success' => true,
    'data'    => $rows ?: []
]);
