<?php
session_start();
require_once "./config/database.php";
include("./includes/header.php");

if (!isset($_SESSION['staff_email'])) {
    header("Location: index.php");
    exit;
}

// -----------------------
// Fetch total counts
// -----------------------
$total_customers = $conn->query("SELECT COUNT(*) as count FROM Customer")->fetch_assoc()['count'] ?? 0;
$total_policies  = $conn->query("SELECT COUNT(*) as count FROM Policy")->fetch_assoc()['count'] ?? 0;
$total_claims    = $conn->query("SELECT COUNT(*) as count FROM Claim")->fetch_assoc()['count'] ?? 0;
$total_revenue   = $conn->query("SELECT SUM(payment_amount) as total FROM Payment")->fetch_assoc()['total'] ?? 0;

// -----------------------
// Fetch policies by type for summary table
// -----------------------
$policy_summary = [];
if ($stmt = $conn->prepare("CALL sp_GetPoliciesByType('')")) { // empty string for all types
    $stmt->execute();
    $res = $stmt->get_result();
    while ($row = $res->fetch_assoc()) {
        $policy_summary[] = $row;
    }
    $stmt->close();
}

// -----------------------
// Fetch claims by status (example: Pending)
// -----------------------
$claims_pending = [];
if ($stmt = $conn->prepare("CALL sp_GetClaimsByStatus('Pending')")) {
    $stmt->execute();
    $res = $stmt->get_result();
    while ($row = $res->fetch_assoc()) {
        $claims_pending[] = $row;
    }
    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Staff Dashboard</title>
<style>
body { font-family: Arial, sans-serif; background: #EBF4DD; color: #3B4953; margin: 0; padding: 0; }
header { background: #5A7863; color: #EBF4DD; padding: 20px; text-align: center; }
.dashboard-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; padding: 30px; }
.card { background: #90AB8B; color: #EBF4DD; padding: 20px; border-radius: 12px; text-align: center; font-size: 1.2rem; box-shadow: 0 4px 10px rgba(0,0,0,0.1); transition: transform 0.2s; }
.card:hover { transform: translateY(-5px); box-shadow: 0 8px 20px rgba(0,0,0,0.15); }
table { width: 90%; margin: 20px auto; border-collapse: collapse; background: #EBF4DD; }
th, td { border: 1px solid #5A7863; padding: 10px; text-align: center; }
th { background: #5A7863; color: #EBF4DD; }
</style>
</head>
<body>
<header>
    <h1>Staff Dashboard</h1>
    <p>Welcome, <?php echo $_SESSION['staff_name']; ?></p>
</header>

<div class="dashboard-cards">
    <div class="card">Total Customers: <?php echo $total_customers; ?></div>
    <div class="card">Total Policies: <?php echo $total_policies; ?></div>
    <div class="card">Total Claims: <?php echo $total_claims; ?></div>
    <div class="card">Total Revenue: $<?php echo number_format($total_revenue, 2); ?></div>
</div>

<h2 style="text-align:center;">Policies Summary</h2>
<table>
    <tr>
        <th>Policy ID</th>
        <th>Policy Type</th>
        <th>Cost</th>
        <th>Duration (Months)</th>
        <th>Total Customers</th>
    </tr>
    <?php foreach($policy_summary as $p): ?>
    <tr>
        <td><?php echo $p['policy_id']; ?></td>
        <td><?php echo $p['policy_type']; ?></td>
        <td>$<?php echo number_format($p['policy_cost'], 2); ?></td>
        <td><?php echo $p['policy_durationMonths']; ?></td>
        <td><?php echo $p['total_customers']; ?></td>
    </tr>
    <?php endforeach; ?>
</table>

<h2 style="text-align:center;">Pending Claims</h2>
<table>
    <tr>
        <th>Claim ID</th>
        <th>Customer Name</th>
        <th>Phone</th>
        <th>Policy Type</th>
        <th>Date</th>
        <th>Amount</th>
        <th>Status</th>
    </tr>
    <?php foreach($claims_pending as $c): ?>
    <tr>
        <td><?php echo $c['claim_id']; ?></td>
        <td><?php echo $c['customer_name']; ?></td>
        <td><?php echo $c['customer_phone']; ?></td>
        <td><?php echo $c['policy_type']; ?></td>
        <td><?php echo $c['claim_date']; ?></td>
        <td>$<?php echo number_format($c['claim_amount'], 2); ?></td>
        <td><?php echo $c['claim_status']; ?></td>
    </tr>
    <?php endforeach; ?>
</table>
</body>
</html>
