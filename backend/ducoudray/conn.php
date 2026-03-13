<?php
header("Content-Type: application/json; charset=UTF-8");
require_once __DIR__ . "/env.php"; // archivo que carga variables

$conn = pg_connect("host={$ENV['DB_HOST']} port={$ENV['DB_PORT']} dbname={$ENV['DB_NAME']} user={$ENV['DB_USER']} password={$ENV['DB_PASS']}");

if (!$conn) {
    http_response_code(500);
    echo json_encode(["success" => false, "error" => "No se pudo conectar con la base de datos"]);
    exit;
}

// Ajustes recomendados
pg_query($conn, "SET client_encoding = 'UTF8'");

pg_query($conn, "SET TIME ZONE 'America/Santo_Domingo'");
