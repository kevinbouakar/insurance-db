<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="../assets/images/logo.png">
    <title>Circo Insurance</title>
    <style>
        body {
            background-color: #EBF4DD; /* Background */
            color: #3B4953; /* Primary text */
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        header {
            text-align: center;
            padding: 15px 0;
            border-bottom: 0px solid rgba(90, 120, 99, 0.15); 
        }
        header ul {
            list-style: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            padding: 0;
            margin: 0;
        }
        header li {
            display: flex;
            align-items: center;
        }
        header a {
            text-decoration: none;
            color: #3B4953; /* Primary text */
            padding: 5px 10px;
            transition: color 0.3s, background-color 0.3s;
            border-radius: 5px;
        }
        header a:hover {
            color: #EBF4DD;
            background-color: #90AB8B; /* Buttons / highlights */
        }
        header img {
            display: block;
        }
        header .separator {
            color: #5A7863; /* Secondary text */
            font-weight: bold;
        }
    </style>
</head>
<body>
<header>
    <ul>
        <li><img src="../assets/images/logo.png" width="60" height="60" alt="Logo"></li>
        <li><a href="../dashboard.php">Dashboard</a></li>
        <li><a href="../customers.php">Customers</a></li>
        <li><a href="../policies.php">Policies</a></li>
        <li><a href="../register.php">Register</a></li>
        <li><a href="../tools.php">Tools</a></li>
        <li class="separator">|</li>
        <li><a href="../logout.php">Logout</a></li>
    </ul>
</header>
