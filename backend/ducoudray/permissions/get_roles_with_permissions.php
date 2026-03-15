<?php
require_once('../conn.php'); // aqui debe existir $conn = pg_connect(...)
header("Content-Type: application/json");

try {

    $sql = "
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
    ";

    $result = pg_query($conn, $sql);

    if (!$result) {
        throw new Exception(pg_last_error($conn));
    }

    $roles = [];

    while ($fila = pg_fetch_assoc($result)) {

        $id = $fila['rol_id'];

        if (!isset($roles[$id])) {
            $roles[$id] = [
                'rol_id' => $id,
                'nombre' => $fila['rol_nombre'],
                'descripcion' => $fila['descripcion'],
                'permisos' => []
            ];
        }

        if (!empty($fila['permiso_id'])) {
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

} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        "error" => "Error al obtener roles y permisos: " . $e->getMessage()
    ]);
}
?>