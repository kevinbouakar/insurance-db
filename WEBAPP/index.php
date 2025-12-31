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
        $stmt = mysqli_prepare(
            $conn,
            "SELECT staff_email, staff_password, staff_name, staff_role
                    FROM staff
                    WHERE staff_email = ?"
        );

        mysqli_stmt_bind_param($stmt, "s", $email);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_store_result($stmt);

        if (mysqli_stmt_num_rows($stmt) === 1) {
            mysqli_stmt_bind_result($stmt, $dbEmail,$dbPasswordHash, $dbName, $dbRole);
            mysqli_stmt_fetch($stmt);

            if (password_verify($password, $dbPasswordHash)) {
                $_SESSION['staff_email'] = $dbEmail;
                $_SESSION['staff_name']  = $dbName;
                $_SESSION['staff_role']  = $dbRole;

                header("Location: customers.php");
                exit;
            } else {
                $message = "Invalid staff credentials!";
            }
        } else {
            $message = "No staff credentials found!.";
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
        <?php if ($message): ?>
            <p><?php echo htmlspecialchars($message); ?></p>
        <?php endif; ?>
    </form>
</div>

<?php 
    include("./includes/footer.php"); 
?>
