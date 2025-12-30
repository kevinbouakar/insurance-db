<?php
session_start();
require_once "./config/database.php";
include("./includes/header.php");

if (!isset($_SESSION['staff_email'])) {
    header("Location: index.php");
    exit;
}

$message = '';

// -----------------------
// Handle Purchase Policy
// -----------------------
if (isset($_POST['purchase_policy'])) {
    $customer_id = intval($_POST['customer_id']);
    $policy_id   = intval($_POST['policy_id']);
    $amount      = floatval($_POST['payment_amount']);
    $method      = $_POST['payment_method'];
    
    $stmt = $conn->prepare("CALL sp_PurchasePolicy(?, ?, ?, ?, @result)");
    $stmt->bind_param("iids", $customer_id, $policy_id, $amount, $method);
    $stmt->execute();
    $stmt->close();

    $res = $conn->query("SELECT @result AS result");
    $message = $res->fetch_assoc()['result'] ?? '';
}

// -----------------------
// Handle File Claim
// -----------------------
if (isset($_POST['file_claim'])) {
    $customerpolicy_id = intval($_POST['customerpolicy_id']);
    $claim_amount      = floatval($_POST['claim_amount']);
    $description       = $_POST['claim_description'];

    $stmt = $conn->prepare("CALL sp_FileClaim(?, ?, ?, @result)");
    $stmt->bind_param("ids", $customerpolicy_id, $claim_amount, $description);
    $stmt->execute();
    $stmt->close();

    $res = $conn->query("SELECT @result AS result");
    $message = $res->fetch_assoc()['result'] ?? '';
}

// -----------------------
// Fetch Payments by Date Range
// -----------------------
$payments = [];
$start_date = $_GET['start_date'] ?? '';
$end_date   = $_GET['end_date'] ?? '';
if ($start_date && $end_date) {
    $stmt = $conn->prepare("CALL sp_GetPaymentsByDateRange(?, ?)");
    $stmt->bind_param("ss", $start_date, $end_date);
    $stmt->execute();
    $res = $stmt->get_result();
    while ($row = $res->fetch_assoc()) {
        $payments[] = $row;
    }
    $stmt->close();
}

// -----------------------
// Fetch Monthly Report
// -----------------------
$monthly_report = [];
$month = intval($_GET['month'] ?? date('m'));
$year  = intval($_GET['year'] ?? date('Y'));

$stmt = $conn->prepare("CALL sp_GenerateMonthlyReport(?, ?)");
$stmt->bind_param("ii", $month, $year);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $monthly_report[] = $row;
}
$stmt->close();

// -----------------------
// Fetch customers and policies for forms
// -----------------------
$customers = $conn->query("SELECT customer_id, customer_name FROM Customer");
$policies  = $conn->query("SELECT policy_id, policy_type, policy_cost FROM Policy");

?>
<style>
.container { max-width: 1200px; margin: 40px auto; padding: 20px; background: #EBF4DD; color: #3B4953; font-family: Arial; }
h2 { margin-top: 40px; color: #3B4953; }
form { margin: 20px 0; padding: 15px; background: #fff; border-radius: 10px; }
input, select { padding: 8px; margin: 5px; border-radius:5px; border:1px solid #90AB8B; }
button { padding:8px 12px; border:none; border-radius:5px; background:#5A7863; color:#fff; cursor:pointer; }
button:hover { background:#3B4953; }
table { width:100%; border-collapse:collapse; margin-top:20px; background:#EBF4DD; }
th, td { border:1px solid #5A7863; padding:10px; text-align:center; }
th { background:#90AB8B; color:#fff; }
.message { margin: 10px 0; font-weight:600; color:#B00020; }
</style>

<div class="container">
<h1>Staff Tools</h1>
<p>Welcome, <?php echo $_SESSION['staff_name']; ?></p>

<?php if($message): ?>
    <p class="message"><?= htmlspecialchars($message) ?></p>
<?php endif; ?>

<!-- Purchase Policy Form -->
<h2>Purchase Policy</h2>
<p>Use this form to create a new policy for a customer and record the payment. Requires selecting a customer, policy, and payment details.</p>
<form method="POST">
    <select name="customer_id" required>
        <option value="">Select Customer</option>
        <?php while($c=$customers->fetch_assoc()): ?>
            <option value="<?= $c['customer_id'] ?>"><?= htmlspecialchars($c['customer_name']) ?></option>
        <?php endwhile; ?>
    </select>
    <select name="policy_id" required>
        <option value="">Select Policy</option>
        <?php while($p=$policies->fetch_assoc()): ?>
            <option value="<?= $p['policy_id'] ?>"><?= htmlspecialchars($p['policy_type']) ?> ($<?= $p['policy_cost'] ?>)</option>
        <?php endwhile; ?>
    </select>
    <input type="number" step="0.01" name="payment_amount" placeholder="Payment Amount" required>
    <input type="text" name="payment_method" placeholder="Payment Method" required>
    <button type="submit" name="purchase_policy">Purchase</button>
</form>

<!-- File Claim Form -->
<h2>File Claim</h2>
<p>File a new claim for a customer’s active policy. Enter the Customer Policy ID, claim amount, and description.</p>
<form method="POST">
    <input type="number" name="customerpolicy_id" placeholder="Customer Policy ID" required>
    <input type="number" step="0.01" name="claim_amount" placeholder="Claim Amount" required>
    <input type="text" name="claim_description" placeholder="Description" required>
    <button type="submit" name="file_claim">File Claim</button>
</form>

<!-- Payments Table -->
<h2>Payments by Date Range</h2>
<p>View all payments made within a specific date range. Useful for auditing or tracking customer payments.</p>
<form method="GET">
    <input type="date" name="start_date" value="<?= htmlspecialchars($start_date) ?>" required>
    <input type="date" name="end_date" value="<?= htmlspecialchars($end_date) ?>" required>
    <button type="submit">Filter</button>
</form>

<!-- Monthly Report -->
<h2>Monthly Report (<?= "$month/$year" ?>)</h2>
<p>Summary of revenue, claims, and profit per policy type for the selected month. Helps track performance and profitability.</p>
<table>
<tr><th>Policy Type</th><th>Revenue</th><th>Claims</th><th>Profit</th></tr>
<?php foreach($monthly_report as $row): ?>
<tr>
    <td><?= htmlspecialchars($row['policy_type']) ?></td>
    <td>$<?= number_format($row['revenue'],2) ?></td>
    <td>$<?= number_format($row['claims'],2) ?></td>
    <td>$<?= number_format($row['profit'],2) ?></td>
</tr>
<?php endforeach; ?>
</table>

</div>

<?php include("./includes/footer.php"); ?>