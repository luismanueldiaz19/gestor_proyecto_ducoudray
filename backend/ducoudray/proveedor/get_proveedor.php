<?php

require_once('../conn.php');
require_once('../utils.php');

// Solo aceptar método POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

// Consulta
$sql = 'SELECT id_proveedor, nombre_proveedor, rnc, telefono, correo, direccion, tipo_proveedor, registrado_por, fecha_registro, statu
	    FROM public.proveedores order by nombre_proveedor ASC';

$result = pg_query($conn, $sql);

if (!$result) {
    echo json_encode(['success' => false, 'message' => 'Error en la consulta']);
    exit;
}

$data = pg_fetch_all($result) ?? [];

echo json_encode([
    'success' => true,
    'data'    => $data
]);
