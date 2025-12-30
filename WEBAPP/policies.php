<?php
session_start();
require_once "./config/database.php";
include("./includes/header.php");

if (!isset($_SESSION['staff_email'])) {
    header("Location: index.php");
    exit;
}

// Handle search/filter
$search_type = $_GET['type'] ?? '';

// Fetch policies using stored procedure
$policy_summary = [];
$stmt = $conn->prepare("CALL sp_GetPoliciesByType(?)");
$stmt->bind_param("s", $search_type);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $policy_summary[] = $row;
}
$stmt->close();

// Fetch customers for a specific policy if requested
$customers_for_policy = [];
$policy_id_for_customers = $_GET['policy_id'] ?? null;

if ($policy_id_for_customers) {
    $stmt = $conn->prepare("CALL sp_GetCustomerPolicyDetails(?)");
    $stmt->bind_param("i", $policy_id_for_customers);
    $stmt->execute();
    $res = $stmt->get_result();
    while ($row = $res->fetch_assoc()) {
        $customers_for_policy[] = $row;
    }
    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Policies</title>
<style>
body { font-family: Arial; background: #EBF4DD; color: #3B4953; margin: 0; padding: 0; }
header { background: #5A7863; color: #EBF4DD; padding: 20px; text-align: center; }
.container { padding: 20px; max-width: 1200px; margin: auto; }
input[type="text"] { padding: 8px; width: 300px; margin-right: 10px; border-radius: 6px; border: 1px solid #5A7863; }
button { padding: 8px 15px; border: none; border-radius: 6px; background: #90AB8B; color: #EBF4DD; cursor: pointer; }
button:hover { background: #5A7863; }
table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #EBF4DD; }
th, td { border: 1px solid #5A7863; padding: 10px; text-align: center; }
th { background: #5A7863; color: #EBF4DD; }
</style>
</head>
<body>
<header>
    <h1>Policies</h1>
    <p>Welcome, <?php echo $_SESSION['staff_name']; ?></p>
</header>

<div class="container">
    <form method="get">
        <input type="text" name="type" placeholder="Search by policy type" value="<?php echo htmlspecialchars($search_type); ?>">
        <button type="submit">Search</button>
    </form>

    <table>
        <tr>
            <th>Policy ID</th>
            <th>Policy Type</th>
            <th>Cost</th>
            <th>Duration (Months)</th>
            <th>Total Customers</th>
            <th>Action</th>
        </tr>
        <?php if (count($policy_summary) > 0): ?>
            <?php foreach($policy_summary as $p): ?>
            <tr>
                <td><?php echo $p['policy_id']; ?></td>
                <td><?php echo $p['policy_type']; ?></td>
                <td>$<?php echo number_format($p['policy_cost'], 2); ?></td>
                <td><?php echo $p['policy_durationMonths']; ?></td>
                <td><?php echo $p['total_customers']; ?></td>
                <td>
                    <a href="?type=<?php echo urlencode($search_type); ?>&policy_id=<?php echo $p['policy_id']; ?>" style="color:#EBF4DD; background:#5A7863; padding:5px 10px; border-radius:5px; text-decoration:none;">View Customers</a>
                </td>
            </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="6">No policies found.</td></tr>
        <?php endif; ?>
    </table>

    <?php if ($policy_id_for_customers && count($customers_for_policy) > 0): ?>
        <h2>Customers for Policy ID <?php echo $policy_id_for_customers; ?></h2>
        <table>
            <tr>
                <th>Customer Name</th>
                <th>Status</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Total Paid</th>
                <th>Total Claimed</th>
            </tr>
            <?php foreach($customers_for_policy as $c): ?>
            <tr>
                <td><?php echo $c['customer_name']; ?></td>
                <td><?php echo $c['customerpolicy_status']; ?></td>
                <td><?php echo $c['customerpolicy_startDate']; ?></td>
                <td><?php echo $c['customerpolicy_endDate']; ?></td>
                <td>$<?php echo number_format($c['total_paid'], 2); ?></td>
                <td>$<?php echo number_format($c['total_claimed'], 2); ?></td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php elseif ($policy_id_for_customers): ?>
        <p>No customers found for this policy.</p>
    <?php endif; ?>
</div>
</body>
</html>
