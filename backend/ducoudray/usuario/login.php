<?php

session_start();
require_once('../conn.php'); // tu archivo pg_connect()
require_once('../utils.php');

$data = json_decode(file_get_contents('php://input'), true);

// Validación
if (!isset($data['usuario']) || !isset($data['contrasena'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Faltan datos de usuario o contraseña']);
    exit;
}

$usuario    = $data['usuario'];
$contrasena = $data['contrasena'];

// Buscar usuario
$sql = '
    SELECT usuario_id, contrasena, nombre_completo, status, usuario, occupacion
    FROM usuarios
    WHERE usuario = $1
';
$result    = pg_query_params($conn, $sql, [$usuario]);
$usuarioDB = pg_fetch_assoc($result);

if (!$usuarioDB || !password_verify($contrasena, $usuarioDB['contrasena'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Credenciales inválidas'
    ]);
    exit;
}

$usuario_id = $usuarioDB['usuario'];
$status     = $usuarioDB['status'];
$occupacion = $usuarioDB['occupacion'];

// Obtener roles
$sqlRoles = '
    SELECT r.nombre
    FROM roles r
    INNER JOIN usuario_rol ur ON ur.rol_id = r.rol_id
    WHERE ur.usuario_id = $1
';
$resultRoles = pg_query_params($conn, $sqlRoles, [$usuarioDB['usuario_id']]);
$roles       = pg_fetch_all_columns($resultRoles, 0) ?? [];

// Obtener permisos
$sqlPermisos = '
    SELECT DISTINCT p.nombre
    FROM permisos p
    INNER JOIN rol_permiso rp ON rp.permiso_id = p.permiso_id
    INNER JOIN usuario_rol ur ON ur.rol_id = rp.rol_id
    WHERE ur.usuario_id = $1
';
$resultPermisos = pg_query_params($conn, $sqlPermisos, [$usuarioDB['usuario_id']]);
$permisos       = pg_fetch_all_columns($resultPermisos, 0) ?? [];

// Guardar info en sesión
$_SESSION['usuario_id'] = $usuarioDB['usuario_id'];
$_SESSION['roles']      = $roles;
$_SESSION['permisos']   = $permisos;

echo json_encode([
    'success'         => true,
    'usuario_id'      => $usuarioDB['usuario_id'],
    'usuario'         => $usuarioDB['usuario'],
    'status'          => $status,
    'occupacion'      => $occupacion,
    'nombre_completo' => $usuarioDB['nombre_completo'],
    'roles'           => $roles,
    'permisos'        => $permisos,
]);
