<?php 
    $db_host = "localhost";
    $db_user = "root";
    $db_pass = "admin4321";
    $db_name = "insurancedb"; 


    $connection = mysqli_connect($db_host, $db_user, $db_pass, $db_name);

    if ($connection) {
        echo "Connected successfully! <br>";
    } else {
        echo "Not connected...";
    }
?>