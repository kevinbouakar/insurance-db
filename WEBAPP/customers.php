<?php
session_start();
require_once "./config/database.php";
include("./includes/header.php");

if (!isset($_SESSION['staff_email'])) {
    header("Location: index.php");
    exit;
}

$search = trim($_GET['search'] ?? '');

// Call stored procedure for search
if ($search !== '') {
    $stmt = mysqli_prepare($conn, "CALL sp_SearchCustomers(?)");
    mysqli_stmt_bind_param($stmt, "s", $search);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
} else {
    $query = "
        SELECT 
            c.customer_id,
            c.customer_name,
            c.customer_email,
            c.customer_password,
            c.customer_phone,
            c.customer_address,
            a.agent_name
        FROM Customer c
        JOIN Agent a ON c.Agent_agent_id = a.agent_id
        ORDER BY c.customer_name
    ";
    $result = mysqli_query($conn, $query);
}
?>
<style>
.container {
    max-width: 1000px;
    margin: 40px auto;
    padding: 20px;
}
h2 { color: #3B4953; margin-bottom: 20px; }
.search-bar { margin-bottom: 20px; display: flex; gap: 10px; }
.search-bar input { flex: 1; padding: 8px; border: 1px solid #90AB8B; border-radius: 5px; }
.search-bar button { padding: 8px 16px; background: #90AB8B; color: #fff; border: none; border-radius: 5px; cursor: pointer; }
.search-bar button:hover { background: #5A7863; }
.data-table { width: 100%; border-collapse: collapse; background: #EBF4DD; }
.data-table th { background: #90AB8B; color: #fff; padding: 10px; text-align: left; }
.data-table td { padding: 10px; border-bottom: 1px solid #5A7863; }
.data-table tr:hover { background: #DCE8CF; }
.delete-btn { padding: 5px 10px; background: #C0392B; color: #fff; border: none; border-radius: 5px; cursor: pointer; }
.delete-btn:hover { background: #A93226; }
.add-btn { padding: 8px 16px; background: #5A7863; color: #fff; border-radius: 5px; text-decoration: none; margin-bottom: 10px; display: inline-block; }
.add-btn:hover { background: #3B4953; }
</style>

<div class="container">
    <h2>Customers</h2>
    <a href="register.php" class="add-btn">+ Add Customer</a>

    <form method="GET" class="search-bar">
        <input type="text" name="search" placeholder="Search by name, email, or phone..." value="<?= htmlspecialchars($search) ?>">
        <button type="submit">Search</button>
    </form>

    <table class="data-table">
        <thead>
            <tr>
                <th>Name</th><th>Email</th><th>Phone</th><th>Address</th><th>Agent</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
            <?php if ($result && mysqli_num_rows($result) > 0): ?>
                <?php while ($row = mysqli_fetch_assoc($result)): ?>
                    <tr>
                        <td><?= htmlspecialchars($row['customer_name']) ?></td>
                        <td><?= htmlspecialchars($row['customer_email']) ?></td>
                        <td><?= htmlspecialchars($row['customer_phone']) ?></td>
                        <td><?= htmlspecialchars($row['customer_address']) ?></td>
                        <td><?= htmlspecialchars($row['agent_name']) ?></td>
                        <td>
                            <form method="POST" action="delete_customer.php" onsubmit="return confirm('Delete this customer?');">
                                <input type="hidden" name="customer_id" value="<?= $row['customer_id'] ?>">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="6" class="empty">No customers found.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>

<?php include("./includes/footer.php"); ?>
