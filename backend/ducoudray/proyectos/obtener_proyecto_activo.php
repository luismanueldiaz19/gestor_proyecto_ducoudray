<?php

require_once('../conn.php');
header('Content-Type: application/json');

date_default_timezone_set('America/Santo_Domingo');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $sql = "
    SELECT 
    p.id_proyecto,
    p.cliente_id,
    p.nombre,
    p.alcance,
	p.costo_proyecto,
    p.entregables,
    p.cronograma,
    p.fecha_inicio,
    p.fecha_fin,
    p.status,

    t.nombre as nombre_cliente,
	t.direccion,
	t.telefono,
	t.email,
	t.tipo_cliente,
    

    g.id_gasto,
    g.fecha AS gasto_fecha,
    g.concepto,
    g.monto,
    g.tipo,

    e.id_equipo,
    e.nombre_miembro,
    e.rol,
    e.horas_asignadas,

    c.id_cotizacion,
    c.fecha AS cotizacion_fecha,
    c.descripcion,
    c.monto AS cotizacion_monto,
    c.estado

FROM proyectos p
LEFT JOIN gastos g ON g.id_proyecto = p.id_proyecto
LEFT JOIN clientes t ON t.cliente_id = p.cliente_id
LEFT JOIN equipo_proyecto e ON e.id_proyecto = p.id_proyecto
LEFT JOIN cotizaciones c ON c.id_proyecto = p.id_proyecto
WHERE p.status = 'activo'
ORDER BY p.id_proyecto;
    ";

    $result = pg_query($conn, $sql);

    if (!$result) {
        echo json_encode([
            'success' => false,
            'message' => pg_last_error($conn)
        ]);
        exit;
    }

    $proyectos = [];

    while ($row = pg_fetch_assoc($result)) {

        $id = $row['id_proyecto'];

        if (!isset($proyectos[$id])) {

        

            $proyectos[$id] = [
                'id_proyecto' => $row['id_proyecto'],
                'cliente_id' => $row['cliente_id'],
                'nombre' => $row['nombre'],
                'alcance' => $row['alcance'],
                'entregables' => $row['entregables'],
                'cronograma' => $row['cronograma'],
                'fecha_inicio' => $row['fecha_inicio'],
                'fecha_fin' => $row['fecha_fin'],
                'costo_proyecto' => $row['costo_proyecto'],
                'status' => $row['status'],
                
                'cliente' => [],
                'gastos' => [],
                'equipo' => [],
                'cotizaciones' => [],
                
            ];
             $proyectos[$id]['cliente'] = [
                'cliente_id' => $row['cliente_id'],
                'nombre' => $row['nombre_cliente'],
                'direccion' => $row['direccion'],
                'telefono' => $row['telefono'],
                'email' => $row['email'],
                'tipo_cliente' => $row['tipo_cliente']
            ];
        }

    

        // gastos
        if ($row['id_gasto']) {

            $proyectos[$id]['gastos'][] = [
                'id_gasto' => $row['id_gasto'],
                'fecha' => $row['gasto_fecha'],
                'concepto' => $row['concepto'],
                'monto' => (float)$row['monto'],
                'tipo' => $row['tipo']
            ];
        }

        // equipo
        if ($row['id_equipo']) {

            $proyectos[$id]['equipo'][] = [
                'id_equipo' => $row['id_equipo'],
                'nombre_miembro' => $row['nombre_miembro'],
                'rol' => $row['rol'],
                'horas_asignadas' => (float)$row['horas_asignadas']
            ];
        }

        // cotizaciones
        if ($row['id_cotizacion']) {

            $proyectos[$id]['cotizaciones'][] = [
                'id_cotizacion' => $row['id_cotizacion'],
                'fecha' => $row['cotizacion_fecha'],
                'descripcion' => $row['descripcion'],
                'monto' => (float)$row['cotizacion_monto'],
                'estado' => $row['estado']
            ];
        }
    }

    $data = array_values($proyectos);

    echo json_encode([
        'success' => true,
        'data' => $data
    ]);

    pg_close($conn);

} else {

    header('HTTP/1.1 405 Method Not Allowed');

    echo json_encode([
        'success' => false,
        'message' => 'Metodo no permitido'
    ]);
}