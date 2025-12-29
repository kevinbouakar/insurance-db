<?php
session_start();
require_once "./config/database.php";
include("./includes/header.php");

$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['indexEmail'] ?? '');
    $password = $_POST['indexPassword'] ?? '';

    if ($email === '' || $password === '') {
        $message = "All fields are required.";
    } else {
        $passwordHash = password_hash($password,PASSWORD_DEFAULT);
        // fetch hashed password and customer id from Customer table
        $stmt = mysqli_prepare($conn, "SELECT customer_email, customer_password FROM customer WHERE customer_email = ?");
        mysqli_stmt_bind_param($stmt, "s", $email);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_store_result($stmt);

        // bind results to variables
        mysqli_stmt_bind_result($stmt, $dbEmail, $dbPasswordHash);
        mysqli_stmt_fetch($stmt);

        if (password_verify($password, $dbPasswordHash)) {
            $_SESSION['user_email'] = $dbEmail;
            header("Location: customers.php");
            exit;   
        } else {
            $message = "Invalid email or password.";
        } 
        mysqli_stmt_close($stmt);
    }
}
?>
<link rel="stylesheet" href="./assets/css/index.css">

<div class="loginForm">
    <form method="POST" action="index.php">
        <label>Email: </label><br>
        <input type="email" required name="indexEmail"><br>
        <label>Password</label><br>
        <input type="password" required name="indexPassword">
        <button type="submit">Login</button>
        <p>Don't have an account? <a href="register.php">Register</a></p>

        <?php if ($message): ?>
            <p><?php echo htmlspecialchars($message); ?></p>
        <?php endif; ?>
    </form>
</div>

<?php 
    include("./includes/footer.php"); 
?>
