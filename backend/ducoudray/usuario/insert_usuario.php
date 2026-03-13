<?php
require_once("../config/database.php");
header("Content-Type: application/json");

// Leer datos JSON del cuerpo del request
$data = json_decode(file_get_contents("php://input"), true);

// Validar campos requeridos
if (
    !isset($data['usuario']) ||
    !isset($data['contrasena']) ||
    !isset($data['nombre_completo']) || !isset($data['occupacion'])
) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Faltan campos requeridos."]);
    exit;
}

$usuario = trim($data['usuario']);
$contrasena = $data['contrasena'];
$nombre_completo = trim($data['nombre_completo']);
$occupacion = trim($data['occupacion']);
$status = isset($data['status']) ? (bool)$data['status'] : true;

try {
    // Verificar si el usuario ya existe
    $stmt = $pdo->prepare("SELECT usuario_id FROM usuarios WHERE usuario = :usuario");
    $stmt->execute([':usuario' => $usuario]);
    if ($stmt->fetch()) {
        http_response_code(409);
        echo json_encode(["success" => false, "message" => "El usuario ya existe."]);
        exit;
    }

    // Hashear contraseña
    $hashedPassword = password_hash($contrasena, PASSWORD_BCRYPT);

    // Insertar el nuevo usuario
    $stmt = $pdo->prepare("
        INSERT INTO usuarios (usuario, contrasena, nombre_completo, status, created_at, occupacion)
        VALUES (:usuario, :contrasena, :nombre_completo, :status, NOW(),:occupacion)
    ");

    $stmt->execute([
        ':usuario' => $usuario,
        ':contrasena' => $hashedPassword,
        ':nombre_completo' => $nombre_completo,
        ':status' => $status,
        ':occupacion' => $occupacion,
    ]);

    echo json_encode([
        "success" => true,
        "message" => "Usuario creado correctamente.",
        "usuario_id" => $pdo->lastInsertId()
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Error en el servidor: " . $e->getMessage()]);
}
