<?php
session_start();
require_once "./config/database.php";
include("./includes/header.php");

if (!isset($_SESSION['staff_email'])) {
    header("Location: index.php");
    exit;
}
$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name     = trim($_POST['customer_name'] ?? '');
    $email    = trim($_POST['customer_email'] ?? '');
    $password = trim($_POST['customer_password'] ?? '');
    $phone    = trim($_POST['customer_phone'] ?? '');
    $address  = trim($_POST['customer_address'] ?? '');
    $agentId  = intval($_POST['agent_id'] ?? 0);

    if ($name === '' || $email === '' || $agentId === 0 || $password === '') {
        $message = "Name, email, password, and agent are required.";
    } else {
        $passwordHash = password_hash($password, PASSWORD_DEFAULT); // hash password

        $stmt = mysqli_prepare(
            $conn,
            "INSERT INTO Customer
            (customer_name, customer_email, customer_password, customer_phone, customer_address, Agent_agent_id)
            VALUES (?, ?, ?, ?, ?, ?)"
        );

        mysqli_stmt_bind_param(
            $stmt,
            "sssssi",
            $name,
            $email,
            $passwordHash,
            $phone,
            $address,
            $agentId
        );

        if (mysqli_stmt_execute($stmt)) {
            header("Location: customers.php");
            exit;
        } else {
            $message = "Customer could not be created.";
        }

        mysqli_stmt_close($stmt);
    }
}

$agents = mysqli_query(
    $conn,
    "SELECT agent_id, agent_name FROM Agent"
);
?>


<style>
body {
    min-height: 100vh;
    margin: 0;
    background-color: #EBF4DD;   /* light background */
    justify-content: center;
    align-items: center;
    font-family: Arial, sans-serif;
    color: #3B4953;
}

/* Form container */
.registerForm {
    margin: 0 auto;
    width: 420px;
    background-color: #FFFFFF;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 10px 25px rgba(59, 73, 83, 0.15);
}

/* Title */
.registerForm h2 {
    text-align: center;
    margin-bottom: 20px;
    color: #3B4953;
}

/* Labels */
.registerForm label {
    display: block;
    margin-top: 12px;
    font-weight: 600;
    color: #5A7863;
}

/* Inputs & select */
.registerForm input,
.registerForm select {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border: 1px solid #90AB8B;
    border-radius: 5px;
    outline: none;
}

/* Focus state */
.registerForm input:focus,
.registerForm select:focus {
    border-color: #5A7863;
}

/* Button */
.registerForm button {
    width: 100%;
    margin-top: 20px;
    padding: 12px;
    background-color: #90AB8B;
    color: #FFFFFF;
    border: none;
    border-radius: 6px;
    font-size: 16px;
    cursor: pointer;
}

.registerForm button:hover {
    background-color: #5A7863;
}

/* Error message */
.error {
    margin-top: 15px;
    text-align: center;
    color: #B00020;
    font-weight: 600;
}

</style>
<div class="registerForm">
    <h2>Register Customer</h2>

    <form method="POST" >
        <label>Name *</label>
        <input type="text" name="customer_name" required>

        <label>Email *</label>
        <input type="email" name="customer_email" required>

        <label>Password *</label>
        <input type="password" name="customer_password" required>

        <label>Phone</label>
        <input type="text" name="customer_phone">

        <label>Address</label>
        <input type="text" name="customer_address">

        <label>Agent *</label>
        <select name="agent_id" required>
            <option value="">-- Select Agent --</option>
            <?php while ($agent = mysqli_fetch_assoc($agents)): ?>
                <option value="<?= $agent['agent_id'] ?>">
                    <?= htmlspecialchars($agent['agent_name']) ?>
                </option>
            <?php endwhile; ?>
        </select>
        <button type="submit">Save Customer</button>

        <?php if ($message): ?>
            <p class="error"><?= htmlspecialchars($message) ?></p>
        <?php endif; ?>
    </form>
</div>

<?php include("./includes/footer.php"); ?>
