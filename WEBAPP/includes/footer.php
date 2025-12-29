<style>
    footer {
        display: flex;
        flex-wrap: wrap;
        gap: 40px;
        padding: 50px;
        background-color: #EBF4DD; /* optional */
        color: #3B4953;
        justify-content: center;
        align-items: flex-start;
    }

    footer img {
        max-width: 250px;
        height: auto;
    }

    .socialLinks ul {
        list-style: none;
        padding: 0;
        margin: 0;
        display: list-item;
        gap: 15px;
    }

    .socialLinks a, .socialLinks li {
        text-decoration: none;
        color: #3B4953;
        font-weight: bold;
        margin: 5px;
    }

    .socialLinks a:hover, .socialLinks li:hover {
        color: #90AB8B;
        cursor: pointer;
    }

    address {
        font-style: normal;
        color: #5A7863;
        line-height: 1.5;
    }

    .footer-bottom {
        width: 100%;
        text-align: center;
        margin-top: 20px;
        color: #3B4953;
        font-size: 0.9rem;
    }

    @media (max-width: 800px) {
        footer {
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .socialLinks ul {
            justify-content: center;
        }
    }
</style>
<footer>
    <img src="/assets/images/logo-transparent.png" alt="Circo Insurance Logo">
    
    <div class="socialLinks">
        <ul>
            <li><a href="https://instagram.com/circo">Instagram</a></li>
            <li><a href="https://facebook.com/circo">Facebook</a></li>
            <li><a href="https://linkedin.com/circo">Linked In</a></li>
            <li><a href="mailto:contact@example.com">Email</a></li>
        </ul>
    </div>

    <address>
        Mr. Kevin Bou Akar<br>
        Human Resources Department<br>
        Circo Insurance Inc.<br>
        456 Tech Avenue, Suite 100<br>
        Metropolis, NY 10001
    </address>
</footer>
<p class="footer-bottom">All Rights Reserved - Circo Insurance 2025</p>
</body>
</html>
