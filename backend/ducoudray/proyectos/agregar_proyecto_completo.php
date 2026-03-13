<?php

require_once('../conn.php'); // tu conexión PostgreSQL
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Leer JSON entrante
    $input = json_decode(file_get_contents('php://input'), true);

    // Datos principales del proyecto
    $cliente_id   = $input['cliente_id']            ?? null;
    $proyecto     = $input['proyecto']              ?? [];
    $equipo       = $input['equipo']                ?? [];
    $cotizaciones = $input['cotizaciones']          ?? [];
    $gastos       = $input['gastos']                ?? [];
    $horas        = $input['horas_invertidas']      ?? [];
    $facturacion  = $input['facturacion']           ?? [];
    $servicios    = $input['servicios_contratados'] ?? [];
    $propuestas   = $input['propuestas']            ?? [];
    $oportunidades= $input['oportunidades']         ?? [];

    // Validar campos requeridos
    $empty_fields = [];
    if (empty($cliente_id)) {
        $empty_fields[] = 'cliente_id';
    }
    if (empty($proyecto['nombre'])) {
        $empty_fields[] = 'proyecto.nombre';
    }

    if (!empty($empty_fields)) {
        echo json_encode([
            'success'      => false,
            'message'      => 'Campos obligatorios faltantes',
            'empty_fields' => $empty_fields
        ]);
        exit;
    }

    // Iniciar transacción
    pg_query($conn, 'BEGIN');

    try {
        // Insertar proyecto
        $sql = 'INSERT INTO proyectos (cliente_id, nombre, alcance, entregables, cronograma, fecha_inicio, fecha_fin)
                VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING id_proyecto';
        $params = [
            $cliente_id,
            $proyecto['nombre'],
            $proyecto['alcance']      ?? null,
            $proyecto['entregables']  ?? null,
            $proyecto['cronograma']   ?? null,
            $proyecto['fecha_inicio'] ?? null,
            $proyecto['fecha_fin']    ?? null
        ];
        $result      = pg_query_params($conn, $sql, $params);
        $id_proyecto = pg_fetch_result($result, 0, 'id_proyecto');

        // Insertar equipo
        foreach ($equipo as $miembro) {
            pg_query_params(
                $conn,
                'INSERT INTO equipo_proyecto (id_proyecto, nombre_miembro, rol, horas_asignadas)
                 VALUES ($1,$2,$3,$4)',
                [$id_proyecto, $miembro['nombre_miembro'], $miembro['rol'], $miembro['horas_asignadas']]
            );
        }

        // Insertar cotizaciones
        foreach ($cotizaciones as $co) {
            pg_query_params(
                $conn,
                'INSERT INTO cotizaciones (id_proyecto, descripcion, monto, estado, fecha)
                 VALUES ($1,$2,$3,$4,$5)',
                [$id_proyecto, $co['descripcion'], $co['monto'], $co['estado'], $co['fecha']]
            );
        }

        // Insertar gastos
        foreach ($gastos as $g) {
            pg_query_params(
                $conn,
                'INSERT INTO gastos (id_proyecto, concepto, monto, tipo, fecha)
                 VALUES ($1,$2,$3,$4,$5)',
                [$id_proyecto, $g['concepto'], $g['monto'], $g['tipo'], $g['fecha']]
            );
        }

        // Insertar horas invertidas
        foreach ($horas as $h) {
            pg_query_params(
                $conn,
                'INSERT INTO horas_invertidas (id_proyecto, fecha, horas, costo_hora)
                 VALUES ($1,$2,$3,$4)',
                [$id_proyecto, $h['fecha'], $h['horas'], $h['costo_hora']]
            );
        }

        // Insertar facturación
        foreach ($facturacion as $f) {
            pg_query_params(
                $conn,
                'INSERT INTO facturacion (cliente_id, id_proyecto, fecha, monto, estado)
                 VALUES ($1,$2,$3,$4,$5)',
                [$cliente_id, $id_proyecto, $f['fecha'], $f['monto'], $f['estado']]
            );
        }

        // Insertar servicios contratados
        foreach ($servicios as $s) {
            pg_query_params(
                $conn,
                'INSERT INTO servicios_contratados (cliente_id, nombre_servicio, fecha_inicio, fecha_fin, estado)
                 VALUES ($1,$2,$3,$4,$5)',
                [$cliente_id, $s['nombre_servicio'], $s['fecha_inicio'], $s['fecha_fin'], $s['estado']]
            );
        }

        // Insertar propuestas
        foreach ($propuestas as $p) {
            pg_query_params(
                $conn,
                'INSERT INTO propuestas (cliente_id, descripcion, estado, path_file)
                 VALUES ($1,$2,$3,$4)',
                [$cliente_id, $p['descripcion'], $p['estado'], $p['path_file']]
            );
        }

        // Insertar oportunidades
        foreach ($oportunidades as $o) {
            pg_query_params(
                $conn,
                'INSERT INTO oportunidades (cliente_id, descripcion, fecha, probabilidad, valor_estimado)
                 VALUES ($1,$2,$3,$4,$5)',
                [$cliente_id, $o['descripcion'], $o['fecha'], $o['probabilidad'], $o['valor_estimado']]
            );
        }

        // Confirmar transacción
        pg_query($conn, 'COMMIT');

        echo json_encode([
            'success'     => true,
            'message'     => 'Proyecto y datos relacionados registrados correctamente',
            'proyecto_id' => $id_proyecto
        ]);

    } catch (Exception $e) {
        pg_query($conn, 'ROLLBACK');
        echo json_encode([
            'success' => false,
            'message' => 'Error al insertar: ' . $e->getMessage()
        ]);
    }

    pg_close($conn);

} else {
    header('HTTP/1.1 405 Method Not Allowed');
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
