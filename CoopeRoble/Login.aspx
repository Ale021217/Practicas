<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Login.aspx.vb" Inherits="CoopeRoble.Login" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    

    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />

    <style>
        body {
            background: linear-gradient(5deg, #FFA500 5%, #FFFFFF 95%) !important;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-attachment: fixed;
            background-repeat: no-repeat;
        }
        .account-area {
            padding: 40px 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: none !important;
            background-color: transparent !important;
        }
        .account-content {
            background: #fff;
            border: 2px solid #e0e0e0;
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
            padding: 30px;
            border-radius: 8px;
            max-width: 400px;
            width: 100%;
        }
        .account-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .account-header a img {
            height: 60px;
        }
        .account-header h3 {
            margin-top: 10px;
            color: #281966;
        }
        .form-control {
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .default-btn {
            background-color: #281966;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            width: 100%;
            transition: background-color 0.3s;
        }
        .default-btn:hover {
            background-color: #1f1458;
        }
        .account {
            color: #281966;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
    
    <title>CoopeRoble - Iniciar Sesión</title>
</head>
<body>
    <form id="formLogin" runat="server">
        <div class="account-area">
            <div class="account-content">
                <div class="account-header text-center">
                    <a href="index.html">
                        <img src="assets/images/Coope.jpeg" alt="Logo CoopeRoble">
                    </a>
                    <h3>Iniciar Sesión</h3>
                </div>
       
                <asp:Label ID="lblError" runat="server" CssClass="error-message" EnableViewState="False"></asp:Label>
                <!-- Formulario de Login -->
                <div class="account-wrap">
                    <div class="form-group mb-3">
                        <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" placeholder="Cédula"></asp:TextBox>
                    </div>
                    <div class="form-group mb-3">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Contraseña" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="form-group mb-3 text-center">
                        <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="default-btn" OnClick="btnLogin_Click" />
                    </div>
                </div>
            </div>
        </div>
        <!-- Scripts JS -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
