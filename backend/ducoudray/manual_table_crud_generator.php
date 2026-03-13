<?php

require_once('conn.php');

/* validar tabla */

$tabla = $_GET['tabla'] ?? null;

if(!$tabla) {
    die('Debes enviar ?tabla=nombre_tabla');
}

/* verificar si existe la tabla */

$query = "
SELECT table_name
FROM information_schema.tables
WHERE table_schema='public'
AND table_name=$1
";

$result = pg_query_params($conn, $query, [$tabla]);

if(pg_num_rows($result) == 0) {
    die('La tabla no existe');
}

/* obtener columnas */

$query = '
SELECT column_name
FROM information_schema.columns
WHERE table_name=$1
ORDER BY ordinal_position
';

$result = pg_query_params($conn, $query, [$tabla]);

$columnas=[];

while($row = pg_fetch_assoc($result)) {
    $columnas[] = $row['column_name'];
}

/* detectar primary key */

$primaryKey = $columnas[0];

$colsInsert = array_slice($columnas, 1);

/* crear carpeta api */

$apiFolder = './api';

if(!file_exists($apiFolder)) {
    mkdir($apiFolder, 0777, true);
}

/* crear carpeta tabla */

$folder = "$apiFolder/$tabla";

if(!file_exists($folder)) {
    mkdir($folder, 0777, true);
}

/* placeholders */

$paramsInsert=[];
$i           =1;

foreach($colsInsert as $col) {
    $paramsInsert[]='$'.$i;
    $i++;
}

$insertCols   = implode(',', $colsInsert);
$insertParams = implode(',', $paramsInsert);

/* CREATE */

/* CREATE */

$create = "<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if (\$_SERVER['REQUEST_METHOD'] === 'POST') {

\$input = json_decode(file_get_contents('php://input'), true);

\$fields = [
";

foreach($colsInsert as $col) {
    $create .= "'$col' => trim(\$input['$col'] ?? ''),\n";
}

$create .= "];

\$empty_fields=[];

foreach(\$fields as \$key=>\$value){
    if(\$value===''){
        \$empty_fields[]=\$key;
    }
}

if(!empty(\$empty_fields)){
    echo json_encode([
        'success'=>false,
        'message'=>'Campos obligatorios faltantes',
        'data'=>\$empty_fields
    ]);
    exit;
}

\$query='INSERT INTO $tabla ($insertCols)
VALUES ($insertParams)
RETURNING $primaryKey';

\$params=[
";

foreach($colsInsert as $col) {
    $create .= "\$fields['$col'],\n";
}

$create .= "];

\$result=pg_query_params(\$conn,\$query,\$params);

if(\$result){

    \$id=pg_fetch_result(\$result,0,0);

    echo json_encode([
        'success'=>true,
        'message'=>'Registro creado correctamente',
        'data'=>['$primaryKey'=>\$id]
    ]);

}else{

    echo json_encode([
        'success'=>false,
        'message'=>pg_last_error(\$conn),
        'data'=>[]
    ]);

}

pg_close(\$conn);

}else{

echo json_encode([
'success'=>false,
'message'=>'Metodo no permitido',
'data'=>[]
]);

}
?>";

file_put_contents("$folder/create.php", $create);

/* GET */

$get = "<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if(\$_SERVER['REQUEST_METHOD']==='POST'){

\$query='SELECT * FROM $tabla ORDER BY $primaryKey DESC';

\$result=pg_query(\$conn,\$query);

\$data=[];

if(\$result){

while(\$row=pg_fetch_assoc(\$result)){
\$data[]=\$row;
}

if(count(\$data)>0){

echo json_encode([
'success'=>true,
'message'=>'Registros encontrados',
'data'=>\$data
]);

}else{

echo json_encode([
'success'=>false,
'message'=>'No hay registros',
'data'=>[]
]);

}

}else{

echo json_encode([
'success'=>false,
'message'=>'Error en consulta',
'data'=>[]
]);

}

pg_close(\$conn);

}else{

echo json_encode([
'success'=>false,
'message'=>'Metodo no permitido',
'data'=>[]
]);

}
?>";

// file_put_contents("$folder/list.php", $list);

file_put_contents("$folder/get.php", $get);

/* UPDATE */

$updateSet=[];
$i        =1;

foreach($colsInsert as $col) {
    $updateSet[]="$col = $".$i;
    $i++;
}

$updateSetStr = implode(',', $updateSet);

$update = "<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if(\$_SERVER['REQUEST_METHOD']==='POST'){

\$input=json_decode(file_get_contents('php://input'),true);

if(!isset(\$input['$primaryKey'])){

echo json_encode([
'success'=>false,
'message'=>'ID requerido',
'data'=>[]
]);

exit;

}

\$query='UPDATE $tabla SET
$updateSetStr
WHERE $primaryKey=$$i';

\$params=[
";

foreach($colsInsert as $col) {
    $update .= "\$input['$col'] ?? null,\n";
}

$update .= "\$input['$primaryKey']
];

\$result=pg_query_params(\$conn,\$query,\$params);

if(\$result){

echo json_encode([
'success'=>true,
'message'=>'Registro actualizado',
'data'=>[]
]);

}else{

echo json_encode([
'success'=>false,
'message'=>pg_last_error(\$conn),
'data'=>[]
]);

}

pg_close(\$conn);

}else{

echo json_encode([
'success'=>false,
'message'=>'Metodo no permitido',
'data'=>[]
]);

}
?>";

file_put_contents("$folder/update.php", $update);

$delete = "<?php

require_once('../../conn.php');

header('Content-Type: application/json');

if(\$_SERVER['REQUEST_METHOD']==='POST'){

\$input=json_decode(file_get_contents('php://input'),true);

if(!isset(\$input['$primaryKey'])){

echo json_encode([
'success'=>false,
'message'=>'ID requerido',
'data'=>[]
]);

exit;

}

\$query='DELETE FROM $tabla WHERE $primaryKey=$1';

\$result=pg_query_params(\$conn,\$query,[\$input['$primaryKey']]);

if(\$result){

echo json_encode([
'success'=>true,
'message'=>'Registro eliminado',
'data'=>[]
]);

}else{

echo json_encode([
'success'=>false,
'message'=>pg_last_error(\$conn),
'data'=>[]
]);

}

pg_close(\$conn);

}else{

echo json_encode([
'success'=>false,
'message'=>'Metodo no permitido',
'data'=>[]
]);

}
?>";

file_put_contents("$folder/delete.php", $delete);

echo "CRUD generado para tabla: $tabla";
