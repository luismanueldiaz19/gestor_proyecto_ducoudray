<?php

require_once('../conn.php');

require_once('../utils.php');

// Obtener datos del cuerpo de la petición
$data = json_decode(file_get_contents('php://input'), true);

// Validación básica
if (!isset($data['usuario_id']) || !is_array($data['roles'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Datos incompletos o inválidos']);
    exit;
}

$usuario_id = $data['usuario_id'];
$roles      = $data['roles'];

try {
    // Eliminar roles anteriores del usuario (si quieres sobrescribir)
    $stmtDelete = $pdo->prepare('DELETE FROM usuario_rol WHERE usuario_id = :usuario_id');
    $stmtDelete->execute([':usuario_id' => $usuario_id]);

    // Insertar nuevos roles
    $stmtInsert = $pdo->prepare('INSERT INTO usuario_rol (usuario_id, rol_id) VALUES (:usuario_id, :rol_id)');

    foreach ($roles as $rol_id) {
        $stmtInsert->execute([
            ':usuario_id' => $usuario_id,
            ':rol_id'     => $rol_id
        ]);
    }

    echo json_encode([
        'success' => true,
        'message' => 'Roles asignados correctamente'
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error al asignar roles: ' . $e->getMessage()
    ]);
}
