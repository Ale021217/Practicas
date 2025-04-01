<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Signup.aspx.vb" Inherits="CoopeRoble.Signup" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />

    <title>CoopeRoble - Crear Cuenta</title>

    <style>
        body {
            /* Fondo de un solo color */
            background: linear-gradient(5deg, #FFA500 5%, #FFFFFF 95%) !important;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
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
            border: 3px solid #e0e0e0; /* Borde más grueso */
            box-shadow: 0 0 15px rgba(0,0,0,0.05);
            padding: 40px;
            border-radius: 8px;
            max-width: 500px; /* Aumentado para más espacio */
            width: 100%;
        }

        .account-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .account-header img {
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

        /* Ajustes para los Toast */
        .toast-container {
            z-index: 9999;
        }
    </style>
</head>
<body>
    <form id="formRegister" runat="server">
        <!-- Contenedor principal -->
        <div class="account-area">
            <div class="account-content">
                <div class="account-header text-center">
                    <a href="index.html">
                        <img src="assets/images/Coope.jpeg" alt="Logo CoopeRoble" />
                    </a>
                    <h3>Crear Cuenta</h3>
                </div>

                <!-- Mensaje de error o información adicional -->
                <asp:Label ID="lblMensaje" runat="server" CssClass="error-message" EnableViewState="False"></asp:Label>

                <!-- Campos del formulario -->
                <div class="account-wrap">
                    <div class="form-group mb-3">
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Nombre completo"></asp:TextBox>
                    </div>

                    <div class="form-group mb-3">
                        <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" placeholder="Cédula"></asp:TextBox>
                    </div>

                    <div class="form-group mb-3">
                        <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-control">
                            <asp:ListItem Value="administrador">Administrador</asp:ListItem>
                            <asp:ListItem Value="chofer">Chofer</asp:ListItem>
                            <asp:ListItem Value="mecanico">Mecánico</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group mb-3">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Contraseña" TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="form-group mb-3">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" placeholder="Confirmar contraseña" TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="form-group mb-3 text-center">
                        <asp:Button ID="btnRegister" runat="server" Text="Crear Cuenta" CssClass="default-btn" OnClick="btnRegister_Click" />
                    </div>

                    
                </div>
            </div>
        </div>

        <!-- Contenedor de Toasts (Bootstrap 5) -->
        <div class="toast-container position-fixed top-0 end-0 p-3">
            <!-- Toast de Éxito -->
            <div id="toastSuccess" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        ¡Usuario creado exitosamente!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>

            <!-- Toast de Error -->
            <div id="toastError" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        Ha ocurrido un error al crear el usuario.
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        </div>

        <!-- Scripts de Bootstrap y jQuery -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>

        <!-- Script para mostrar los toasts según el resultado -->
        <script>
            function showToast(type) {
                if (type === 'success') {
                    var toastEl = document.getElementById('toastSuccess');
                    var toast = new bootstrap.Toast(toastEl);
                    toast.show();
                } else if (type === 'error') {
                    var toastEl = document.getElementById('toastError');
                    var toast = new bootstrap.Toast(toastEl);
                    toast.show();
                }
            }
        </script>
    </form>
</body>
</html>
