<?php
require_once("../conn.php");
require_once("../utils.php");

try {

    $sql = "SELECT 
        u.usuario_id,
        u.status,
        u.usuario,
        u.nombre_completo,
        r.nombre AS rol,
        p.nombre AS permiso,
        v.vehiculo_asignado_id,
        v.id_vehiculo,
        ve.placas,
        ve.marca,
        ve.ficha
    FROM usuarios u
    LEFT JOIN usuario_rol ur ON u.usuario_id = ur.usuario_id
    LEFT JOIN roles r ON ur.rol_id = r.rol_id
    LEFT JOIN rol_permiso rp ON r.rol_id = rp.rol_id
    LEFT JOIN permisos p ON rp.permiso_id = p.permiso_id
    LEFT JOIN vehiculo_asignado v ON u.usuario_id = v.usuario_id
    LEFT JOIN vehiculo ve ON v.id_vehiculo = ve.id_vehiculo
    ORDER BY u.usuario_id";

    $result = pg_query($conn, $sql);

    if (!$result) {
        throw new Exception(pg_last_error($conn));
    }

    $usuarios = [];

    while ($fila = pg_fetch_assoc($result)) {
        $id = $fila['usuario_id'];

        if (!isset($usuarios[$id])) {
            $usuarios[$id] = [
                'usuario_id' => $id,
                'usuario' => $fila['usuario'],
                'nombre_completo' => $fila['nombre_completo'],
                'status' => $fila['status'],
                'roles' => [],
                'permisos' => [],
                'vehiculos' => []
            ];
        }

        // Roles
        if (!empty($fila['rol']) && !in_array($fila['rol'], $usuarios[$id]['roles'])) {
            $usuarios[$id]['roles'][] = $fila['rol'];
        }

        // Permisos
        if (!empty($fila['permiso']) && !in_array($fila['permiso'], $usuarios[$id]['permisos'])) {
            $usuarios[$id]['permisos'][] = $fila['permiso'];
        }

        // Vehículos asignados
        if (!empty($fila['vehiculo_asignado_id'])) {
            $veh = [
                'vehiculo_asignado_id' => $fila['vehiculo_asignado_id'],
                'id_vehiculo' => $fila['id_vehiculo'],
                'placas' => $fila['placas'],
                'marca' => $fila['marca'],
                'ficha' => $fila['ficha']
            ];

            if (!in_array($veh, $usuarios[$id]['vehiculos'])) {
                $usuarios[$id]['vehiculos'][] = $veh;
            }
        }
    }

    echo json_encode([
        "success" => true,
        "usuarios" => array_values($usuarios)
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "error" => "Error al obtener usuarios: " . $e->getMessage()
    ]);
}
