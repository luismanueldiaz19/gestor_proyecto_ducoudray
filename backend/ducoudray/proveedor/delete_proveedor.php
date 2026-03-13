<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    require_once('../conn.php');

    $input = json_decode(file_get_contents('php://input'), true);

    $id_proveedor = $input['id_proveedor'] ?? '';

    if (empty($id_proveedor)) {
        echo json_encode([
            'success' => false,
            'message' => 'id_proveedor es obligatorio'
        ]);
        exit;
    }

    $query  = "DELETE FROM public.proveedores WHERE id_proveedor = $1";
    $result = pg_query_params($conn, $query, [$id_proveedor]);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Proveedor eliminado permanentemente (Hard Delete).']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al eliminar: ' . pg_last_error($conn)]);
    }

    pg_close($conn);

} else {
    header("HTTP/1.1 405 Method Not Allowed");
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
