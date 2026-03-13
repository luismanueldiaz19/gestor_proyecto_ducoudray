<?php
require_once("../config/database.php");
header("Content-Type: application/json");

// Leer el JSON del cuerpo de la solicitud
$data = json_decode(file_get_contents("php://input"), true);

// Validación básica
if (!isset($data['usuario_id']) || !is_array($data['roles'])) {
    http_response_code(400);
    echo json_encode(["error" => "Datos incompletos o mal formateados"]);
    exit;
}

$usuario_id = $data['usuario_id'];
$roles = $data['roles'];

try {
    $pdo->beginTransaction();

    // Eliminar todos los roles actuales del usuario
    $stmtDelete = $pdo->prepare("DELETE FROM usuario_rol WHERE usuario_id = :usuario_id");
    $stmtDelete->execute([':usuario_id' => $usuario_id]);

    // Insertar los nuevos roles
    $stmtInsert = $pdo->prepare("INSERT INTO usuario_rol (usuario_id, rol_id) VALUES (:usuario_id, :rol_id)");

    foreach ($roles as $rol_id) {
        $stmtInsert->execute([
            ':usuario_id' => $usuario_id,
            ':rol_id' => $rol_id
        ]);
    }

    $pdo->commit();

    echo json_encode([
        "success" => true,
        "message" => "Roles actualizados correctamente"
    ]);

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode([
        "error" => "Error al actualizar roles: " . $e->getMessage()
    ]);
}
