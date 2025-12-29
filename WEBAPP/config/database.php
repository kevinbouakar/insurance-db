<?php 
    $db_host = "localhost";
    $db_user = "root";
    $db_pass = "admin4321";
    $db_name = "insurancedb"; 

    $conn = mysqli_connect($db_host, $db_user, $db_pass, $db_name);
    if (!$conn) {
        echo die("Connection failed: " . mysqli_connect_error());
    }
    echo "Connected successfully!";

?>