<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    header('Content-Type: application/json; charset=utf-8');

    require_once('../conn.php');
    require_once('../utils.php');

    $query = "
       SELECT 
    m.usuario_id, 
    m.usuario, 
    m.nombre_completo, 
    m.status, 
    m.created_at, 
    m.occupacion,
    licencia_chofer.licencia_chofer_id, 
    licencia_chofer.nombre_chofer, 
    licencia_chofer.categoria, 
    licencia_chofer.restrinciones, 
    licencia_chofer.fecha_emision, 
    licencia_chofer.first_emision, 
    licencia_chofer.estatura, 
    licencia_chofer.peso, 
    licencia_chofer.sexo, 
    licencia_chofer.tipo_sangre, 
    licencia_chofer.nacimiento,
    licencia_chofer.vence, 
    licencia_chofer.id_cedula,
    CASE 
        WHEN licencia_chofer.vence < CURRENT_DATE 
            THEN 'Vencida'
        WHEN licencia_chofer.vence <= CURRENT_DATE + INTERVAL '2 months' 
            THEN 'Próximo a vencer'
        ELSE 'Vigente'
    END AS estado_vencimiento
FROM public.usuarios AS m
INNER JOIN public.licencia_chofer 
    ON licencia_chofer.usuario_id = m.usuario_id
WHERE m.occupacion = 'DRIVER'
ORDER BY m.nombre_completo ASC;
    ";

    $result = pg_query($conn, $query);

    if ($result && pg_num_rows($result) > 0) {

        $data = [];
        while ($row = pg_fetch_assoc($result)) {

            // Separar info de licencia
            $info_licencia = [
                'usuario_id'      => $row['usuario_id'],
                'occupacion'         => $row['occupacion'],
                'licencia_chofer_id' => $row['licencia_chofer_id'],
                'nombre_chofer'      => $row['nombre_chofer'],
                'categoria'          => $row['categoria'],
                'restrinciones'      => $row['restrinciones'],
                'fecha_emision'      => $row['fecha_emision'],
                'first_emision'      => $row['first_emision'],
                'estatura'           => $row['estatura'],
                'peso'               => $row['peso'],
                'sexo'               => $row['sexo'],
                'tipo_sangre'        => $row['tipo_sangre'],
                'nacimiento'         => $row['nacimiento'],
                'vence'              => $row['vence'],
                'id_cedula'          => $row['id_cedula'],
                'estado_vencimiento' => $row['estado_vencimiento'],
             ];

            // Datos del usuario sin duplicar las columnas de licencia
            $data[] = [
                'usuario_id'      => $row['usuario_id'],
                'usuario'         => $row['usuario'],
                'nombre_completo' => $row['nombre_completo'],
                'status'          => $row['status'],
                'created_at'      => $row['created_at'],

                // Aquí va el array separado
                'licencia_chofer'   => $info_licencia
            ];

        }

        echo json_encode([
            'success' => true,
            'message' => 'Datos encontrados.',
            'data'    => $data
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'No se encontraron registros.'
        ]);
    }

    pg_close($conn);
    exit;
}

header('HTTP/1.1 405 Method Not Allowed');
echo json_encode([
    'success' => false,
    'message' => 'Método no permitido'
]);
