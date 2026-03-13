<?php

require_once('../conn.php');
require_once('../utils.php'); // ya incluye headers JSON

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['success' => false, 'message' => 'Método no permitido'], 405);
}

// Leer JSON
$input = json_decode(file_get_contents('php://input'), true);

$usuario          = $input['usuario']          ?? null;
$contrasena       = $input['contrasena']       ?? null;
$nombre_completo  = $input['nombre_completo']  ?? null;
$occupacion       = $input['occupacion']       ?? 'N/A';
$fecha_ingreso    = $input['fecha_ingreso']    ?? date('Y-m-d');
$fecha_vacaciones = $input['fecha_vacaciones'] ?? date('Y-m-d');

// Validar obligatorios
$empty = [];

if (!$usuario) {
    $empty[] = 'usuario';
}
if (!$contrasena) {
    $empty[] = 'contrasena';
}
if (!$nombre_completo) {
    $empty[] = 'nombre_completo';
}

if (!empty($empty)) {
    json_response([
        'success'      => false,
        'message'      => 'Campos obligatorios faltantes',
        'empty_fields' => $empty
    ]);
}

// Verificar si el usuario ya existe
$check_query = 'SELECT usuario_id FROM usuarios WHERE usuario = $1 LIMIT 1';
$check       = pg_query_params($conn, $check_query, [$usuario]);

if ($check && pg_num_rows($check) > 0) {
    json_response([
        'success' => false,
        'message' => 'El usuario ya existe'
    ]);
}

// Encriptar contraseña (opcional pero recomendado)
$hashed_pass = password_hash($contrasena, PASSWORD_BCRYPT);

// INSERT
$sql = '
    INSERT INTO usuarios (usuario, contrasena, nombre_completo, occupacion, fecha_ingreso, fecha_vacaciones)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING usuario_id;
';

$params = [
    $usuario,
    $hashed_pass,
    $nombre_completo,
    $occupacion,
    $fecha_ingreso,
    $fecha_vacaciones
];

$result = pg_query_params($conn, $sql, $params);

if (!$result) {
    json_response([
        'success' => false,
        'message' => pg_last_error($conn)
    ]);
}

$row = pg_fetch_assoc($result);

json_response([
    'success'    => true,
    'message'    => 'Usuario creado correctamente',
    'usuario_id' => $row['usuario_id']
]);


// {
//   "usuario": "jdoe",
//   "contrasena": "123456",
//   "nombre_completo": "John Doe",
//   "status": true,
//   "occupacion": "Operador",
//   "fecha_ingreso": "2024-12-10",
//   "fecha_vacaciones": "2024-12-10"
// }
