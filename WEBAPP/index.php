<?php 
    session_start(); 
    include("./config/database.php");
    include("./includes/header.php");
?>
<link rel="stylesheet" href="./assets/css/index.css">
<div class="loginForm">
    <form method="POST" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']);?>">
        
    </form>
</div>
<?php echo "<b>$message<b>";?>

<?php include("./includes/footer.php"); ?>