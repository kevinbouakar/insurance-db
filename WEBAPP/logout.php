<?php 
    session_start();
    // logged in -> destroy session and redirect to index
    $_SESSION = [];
    session_destroy();
    
    header("Location: index.php");   
    exit; 
?>