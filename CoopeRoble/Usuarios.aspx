<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Usuarios.aspx.vb" Inherits="CoopeRoble.Usuarios" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Mantenimiento de Usuarios - CoopeRoble</title>
    <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <!-- CSS propio -->
    <link href="assets/css/style.css" rel="stylesheet" />

    <style>
        /* ===== Layout principal (sticky footer) ===== */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            background-color: #f8faff;
        }
        .page-wrapper {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .content-wrapper {
            flex: 1 0 auto;
            padding: 20px 0;
        }
        .footer-cooperoble {
            flex-shrink: 0;
            background-color: #281966;
            color: #fff;
            text-align: center;
            padding: 10px 0;
        }

        /* ===== Navbar ===== */
        .navbar-cooperoble {
            background-color: #281966;
            padding: 1rem 2rem;
        }
        .navbar-cooperoble .navbar-brand,
        .navbar-cooperoble .nav-link {
            color: #fff !important;
        }
        .navbar-cooperoble .nav-link:hover {
            color: #ddd !important;
        }

        /* Botón hamburguesa */
        .hamburger-btn {
            background: none;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 5px;
        }
        .burger-icon {
            width: 30px;
            height: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .burger-icon span {
            display: block;
            height: 3px;
            background: #c47a52;
            border-radius: 2px;
            transition: background 0.3s;
        }
        .hamburger-btn:hover .burger-icon span {
            background: #a66243;
        }

        /* ===== Offcanvas (sidebar) ===== */
        .offcanvas {
            background-color: #281966;
            color: #fff;
        }
        .offcanvas.offcanvas-start {
            max-width: 240px;
        }
        .offcanvas .offcanvas-header {
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .offcanvas .offcanvas-title {
            color: #fff;
        }
        .offcanvas .btn-close {
            filter: invert(1);
        }
        .offcanvas .nav-link {
            color: #fff;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            transition: background 0.3s;
        }
        .offcanvas .nav-link:hover {
            background-color: #1f144f;
            color: #fff;
        }

        /* ===== Tarjetas y contenedores ===== */
        .card {
            border: 1px solid #ccc;
            margin-bottom: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            background-color: #fff;
        }
        .card-header {
            background-color: #281966;
            min-height: 120px;
            display: flex;
            align-items: center;
            padding: 0 20px;
            border-radius: 0;
        }
        .card-header h4 {
            margin: 0;
            color: #fff;
            font-weight: 400; 
            font-size: 24px;
            font-family: sans-serif;
        }
        .form-container {
            max-width: 900px;
            margin: 30px auto;
        }
        .table thead th,
        .table tbody td {
            padding: 1rem !important;
            vertical-align: middle !important;
        }
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        /* Botones */
        .btn-orange {
            background-color: #c47a52 !important; 
            border-color: #c47a52 !important;
            color: #fff !important;
        }
        .btn-orange:hover {
            background-color: #c47a52 !important; 
            border-color: #c47a52 !important;
            color: #fff !important;
        }
        .btn-c47a52 {
            background-color: #c47a52 !important;
            border-color: #c47a52 !important;
            color: #fff !important;
        }
        .btn-c47a52:hover {
            background-color: #ad6b48 !important; 
            border-color: #ad6b48 !important;
            color: #fff !important;
        }
        .btn-action {
            min-width: 80px;
        }
        .text-danger {
            color: red !important;
        }

        /* Responsividad para pantallas pequeñas */
        @media (max-width: 576px) {
            .form-container {
                margin: 20px 10px;
            }
            .card-header {
                min-height: auto;
                padding: 15px;
            }
            .card-header h4 {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <form id="formUsuarios" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="upUsuarios" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="page-wrapper">
                    <!-- NAVBAR SUPERIOR -->
                    <nav class="navbar navbar-cooperoble navbar-dark d-flex align-items-center">
                        <!-- IZQUIERDA: Botón hamburguesa (sin "Inicio") -->
                        <div class="d-flex align-items-center">
                            <button type="button" class="hamburger-btn me-3" 
                                    data-bs-toggle="offcanvas" 
                                    data-bs-target="#offcanvasMenu" 
                                    aria-controls="offcanvasMenu">
                                <div class="burger-icon">
                                    <span></span>
                                    <span></span>
                                    <span></span>
                                </div>
                            </button>
                        </div>
                        <!-- DERECHA: “Bienvenido, …” -->
                        <div class="d-flex align-items-center ms-auto">
                            <span class="text-white me-3">Bienvenido, <%: Session("nombre") %></span>
                        </div>
                    </nav>

                    <!-- SIDEBAR OFFCANVAS (agregamos "Inicio" como primer enlace) -->
                    <div class="offcanvas offcanvas-start" tabindex="-1" 
                         id="offcanvasMenu" aria-labelledby="offcanvasMenuLabel">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="offcanvasMenuLabel">Menú</h5>
                            <button type="button" class="btn-close text-reset" 
                                    data-bs-dismiss="offcanvas" 
                                    aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body">
                            <nav class="nav flex-column">
                                <!-- Agregamos "Inicio" como primer elemento -->
                                <a href="Index.aspx" class="nav-link">Inicio</a>
                                <a href="Unidad.aspx" class="nav-link">Crear Unidad</a>
                                <a href="Averias.aspx" class="nav-link">Crear Avería</a>
                                <a href="Usuarios.aspx" class="nav-link">Usuarios</a>
                                <a href="SeguimientoReporte.aspx" class="nav-link">Seguimiento Reporte</a>
                                <a href="AsignarReporte.aspx" class="nav-link">Asignar Reporte</a>
                                <a href="MantenimientoPreventivo.aspx" class="nav-link">Mantenimiento preventivo</a>
                                <a href="dekra.aspx" class="nav-link">Mantenimiento Dekra</a>
                                <asp:LinkButton ID="lnkLogoutSidebar" runat="server" 
                                                CssClass="nav-link text-start"
                                                OnClick="lnkLogout_Click">
                                    Cerrar Sesión
                                </asp:LinkButton>
                            </nav>
                        </div>
                    </div>

                    <!-- CONTENIDO PRINCIPAL -->
                    <div class="content-wrapper container">
                        <!-- Tarjeta de Mantenimiento de Usuarios -->
                        <div class="card form-container">
                            <div class="card-header">
                                <h4>Mantenimiento de Usuarios</h4>
                            </div>
                            <div class="card-body">
                                <!-- Mensajes de éxito y error -->
                                <div class="alert alert-success" runat="server" 
                                     ID="alertSuccess" Visible="False">
                                    <asp:Label ID="lblSuccess" runat="server" Text=""></asp:Label>
                                </div>
                                <div class="alert alert-danger" runat="server" 
                                     ID="alertError" Visible="False">
                                    <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
                                </div>

                                <!-- Botón para abrir modal de Nuevo Usuario -->
                                <div class="mb-3">
                                    <asp:Button ID="btnNuevoUsuario" runat="server" 
                                                CssClass="btn btn-orange"
                                                Text="Nuevo Usuario"
                                                OnClientClick="mostrarModalNuevoUsuario(); return false;" />
                                </div>

                                <!-- GridView de Usuarios -->
                                <div class="table-responsive">
                                    <asp:GridView ID="gvUsuarios" runat="server" 
                                                  AutoGenerateColumns="False"
                                                  CssClass="table table-striped table-hover table-bordered w-100"
                                                  OnRowCommand="gvUsuarios_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="id_usuario" HeaderText="ID" />
                                            <asp:BoundField DataField="nombre" HeaderText="Nombre" />
                                            <asp:BoundField DataField="cedula" HeaderText="Cédula" />
                                            <asp:BoundField DataField="rol" HeaderText="Rol" />
                                            <asp:TemplateField HeaderText="Estado">
                                                <ItemTemplate>
                                                    <%# IIf(Eval("estado").ToString() = "True", "Activo", "Inactivo") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="fecha" HeaderText="Fecha" 
                                                            DataFormatString="{0:dd/MM/yyyy}" />
                                            <asp:TemplateField HeaderText="Acciones">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkEditar" runat="server"
                                                        CommandName="Editar"
                                                        CommandArgument='<%# Eval("id_usuario") %>'
                                                        CssClass="btn btn-c47a52 btn-sm btn-action">
                                                        Editar
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- FOOTER -->
                    <div class="footer-cooperoble">
                        <div class="container">
                            <p class="mb-0">&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
                        </div>
                    </div>
                </div>

                <!-- MODAL para Editar Usuario -->
                <div class="modal fade" id="modalUsuario" tabindex="-1" aria-labelledby="modalUsuarioLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="modalUsuarioLabel">Editar Usuario</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <asp:Panel ID="pnlEditModal" runat="server" DefaultButton="btnGuardar">
                                <div class="modal-body">
                                    <div id="divModalError" style="display:none;" class="alert alert-danger"></div>
                                    <asp:HiddenField ID="hfIdUsuario" runat="server" />

                                    <div class="mb-3">
                                        <label for="txtNombre" class="form-label">Nombre</label>
                                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="mb-3">
                                        <label for="txtCedula" class="form-label">Cédula (no editable)</label>
                                        <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" ReadOnly="True" />
                                    </div>
                                    <div class="mb-3">
                                        <label for="ddlRol" class="form-label">Rol</label>
                                        <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Seleccione..." Value="" />
                                            <asp:ListItem Text="Chofer" Value="chofer" />
                                            <asp:ListItem Text="Mecánico" Value="mecanico" />
                                            <asp:ListItem Text="Administrador" Value="administrador" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="mb-3">
                                        <label for="ddlEstado" class="form-label">Estado</label>
                                        <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Activo" Value="True" />
                                            <asp:ListItem Text="Inactivo" Value="False" />
                                        </asp:DropDownList>
                                    </div>
                                    <asp:Panel ID="pnlChangePassword" runat="server" Visible="true">
                                        <div class="mb-3">
                                            <asp:CheckBox ID="chkChangePassword" runat="server" Text="¿Desea cambiar la contraseña?" AutoPostBack="False" onclick="togglePasswordFields(this);" />
                                        </div>
                                    </asp:Panel>
                                    <hr />
                                    <div class="mb-3">
                                        <label for="txtPassword" class="form-label">Contraseña</label>
                                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                    <div class="mb-3">
                                        <label for="txtConfirmPassword" class="form-label">Confirmar Contraseña</label>
                                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                </div>
                            </asp:Panel>
                            <div class="modal-footer">
                                <asp:Button ID="btnGuardar" runat="server" CssClass="btn btn-orange" Text="Guardar" OnClick="btnGuardar_Click" OnClientClick="return ValidatePasswords();" />
                                <button type="button" class="btn btn-orange" data-bs-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- MODAL para Nuevo Usuario -->
                <div class="modal fade" id="modalNuevoUsuario" tabindex="-1" aria-labelledby="modalNuevoUsuarioLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="modalNuevoUsuarioLabel">Crear Cuenta</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <asp:Panel ID="pnlNuevoModal" runat="server" DefaultButton="btnCrearUsuario">
                                <div class="modal-body">
                                    <div id="divNuevoUsuarioError" style="display:none;" class="alert alert-danger"></div>
                                    <div class="mb-3">
                                        <label class="form-label">Nombre completo</label>
                                        <asp:TextBox ID="txtNuevoNombre" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="mb-3">
                                    <label class="form-label">Cédula</label>
                                    <asp:TextBox ID="txtNuevoCedula" runat="server" CssClass="form-control" />
                                    <asp:Label ID="lblCedulaError" runat="server" CssClass="text-danger" Visible="False"></asp:Label>
                                </div>

                                    <div class="mb-3">
                                        <label class="form-label">Rol</label>
                                        <asp:DropDownList ID="ddlNuevoRol" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Seleccione..." Value="" />
                                            <asp:ListItem Text="Administrador" Value="administrador" />
                                            <asp:ListItem Text="Chofer" Value="chofer" />
                                            <asp:ListItem Text="Mecánico" Value="mecanico" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Estado</label>
                                        <asp:DropDownList ID="ddlNuevoEstado" runat="server" CssClass="form-select">
                                            <asp:ListItem Text="Activo" Value="True" />
                                            <asp:ListItem Text="Inactivo" Value="False" />
                                        </asp:DropDownList>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Contraseña</label>
                                        <asp:TextBox ID="txtNuevoPassword" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Confirmar Contraseña</label>
                                        <asp:TextBox ID="txtNuevoConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
                                    </div>
                                </div>
                            </asp:Panel>
                            <div class="modal-footer">
                                <asp:Button ID="btnCrearUsuario" runat="server" CssClass="btn btn-orange" Text="Crear Cuenta" OnClientClick="return ValidateNewUserPasswords();" OnClick="btnCrearUsuario_Click" />
                                <button type="button" class="btn btn-orange" data-bs-dismiss="modal">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>

            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="gvUsuarios" EventName="RowCommand" />
                <asp:PostBackTrigger ControlID="btnGuardar" />
                <asp:PostBackTrigger ControlID="btnCrearUsuario" />
            </Triggers>
        </asp:UpdatePanel>

        <!-- Scripts JS -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript">
            function mostrarModalNuevoUsuario() {
                document.getElementById('<%= txtNuevoNombre.ClientID %>').value = "";
                document.getElementById('<%= txtNuevoCedula.ClientID %>').value = "";
                document.getElementById('<%= ddlNuevoRol.ClientID %>').selectedIndex = 0;
                document.getElementById('<%= ddlNuevoEstado.ClientID %>').selectedIndex = 0;
                document.getElementById('<%= txtNuevoPassword.ClientID %>').value = "";
                document.getElementById('<%= txtNuevoConfirmPassword.ClientID %>').value = "";

                var errorDiv = document.getElementById('divNuevoUsuarioError');
                errorDiv.style.display = "none";
                errorDiv.innerHTML = "";

                var myModal = new bootstrap.Modal(document.getElementById('modalNuevoUsuario'));
                myModal.show();
            }

            function ValidatePasswords() {
                var chk = document.getElementById('<%= chkChangePassword.ClientID %>');
                if (chk && !chk.checked) {
                    return true;
                }
                var pass = document.getElementById('<%= txtPassword.ClientID %>').value;
                var confirmPass = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
                var errorDiv = document.getElementById('divModalError');
                errorDiv.style.display = "none";
                errorDiv.innerHTML = "";
                if (pass.length < 8) {
                    errorDiv.innerHTML = "La contraseña debe tener mínimo 8 caracteres.";
                    errorDiv.style.display = "block";
                    return false;
                }
                if (pass !== confirmPass) {
                    errorDiv.innerHTML = "Las contraseñas no coinciden.";
                    errorDiv.style.display = "block";
                    return false;
                }
                return true;
            }

            function togglePasswordFields(chk) {
                var txtPass = document.getElementById('<%= txtPassword.ClientID %>');
                var txtConfirm = document.getElementById('<%= txtConfirmPassword.ClientID %>');
                if (chk.checked) {
                    txtPass.disabled = false;
                    txtConfirm.disabled = false;
                } else {
                    txtPass.disabled = true;
                    txtConfirm.disabled = true;
                    txtPass.value = "";
                    txtConfirm.value = "";
                }
            }

            function ValidateNewUserPasswords() {
                var errorDiv = document.getElementById('divNuevoUsuarioError');
                errorDiv.style.display = "none";
                errorDiv.innerHTML = "";
                var nombre = document.getElementById('<%= txtNuevoNombre.ClientID %>').value.trim();
                var cedula = document.getElementById('<%= txtNuevoCedula.ClientID %>').value.trim();
                var rol = document.getElementById('<%= ddlNuevoRol.ClientID %>').value;
                var pass = document.getElementById('<%= txtNuevoPassword.ClientID %>').value;
                var confirmPass = document.getElementById('<%= txtNuevoConfirmPassword.ClientID %>').value;
                if (nombre === "" || cedula === "") {
                    errorDiv.innerHTML = "El nombre y la cédula son obligatorios.";
                    errorDiv.style.display = "block";
                    return false;
                }
                if (rol === "") {
                    errorDiv.innerHTML = "Debe seleccionar un rol.";
                    errorDiv.style.display = "block";
                    return false;
                }
                if (pass.length < 8) {
                    errorDiv.innerHTML = "La contraseña debe tener mínimo 8 caracteres.";
                    errorDiv.style.display = "block";
                    return false;
                }
                if (pass !== confirmPass) {
                    errorDiv.innerHTML = "Las contraseñas no coinciden.";
                    errorDiv.style.display = "block";
                    return false;
                }
                return true;
            }
        </script>
    </form>
</body>
</html>
