<?php
require_once("../config/database.php");
header("Content-Type: application/json");

try {
    $stmt = $pdo->query("
        SELECT 
            r.rol_id,
            r.nombre AS rol_nombre,
            r.descripcion,
            p.permiso_id,
            p.nombre AS permiso_nombre
        FROM roles r
        LEFT JOIN rol_permiso rp ON r.rol_id = rp.rol_id
        LEFT JOIN permisos p ON rp.permiso_id = p.permiso_id
        ORDER BY r.rol_id
    ");

    $filas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $roles = [];

    foreach ($filas as $fila) {
        $id = $fila['rol_id'];

        if (!isset($roles[$id])) {
            $roles[$id] = [
                'rol_id' => $id,
                'nombre' => $fila['rol_nombre'],
                'descripcion' => $fila['descripcion'],
                'permisos' => []
            ];
        }

        if ($fila['permiso_id']) {
            $roles[$id]['permisos'][] = [
                'permiso_id' => $fila['permiso_id'],
                'nombre' => $fila['permiso_nombre']
            ];
        }
    }

    // Reindexar como lista
    $roles = array_values($roles);

    echo json_encode([
        "success" => true,
        "roles" => $roles
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "error" => "Error al obtener roles y permisos: " . $e->getMessage()
    ]);
}
?>
