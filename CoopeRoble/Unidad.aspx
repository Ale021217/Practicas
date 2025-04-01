<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Unidad.aspx.vb" Inherits="CoopeRoble.Unidad" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <!-- Etiqueta viewport para responsive -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Crear Unidad - CoopeRoble</title>
    <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
    <!-- CSS propio -->
    <link rel="stylesheet" href="assets/css/style.css" />

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

        /* ===== Navbar (header) ===== */
        .navbar-cooperoble {
            background-color: #281966;
            /* Aumentamos padding si deseas mayor altura */
            padding: 1rem 2rem; 
        }
        .navbar-cooperoble .navbar-brand,
        .navbar-cooperoble .nav-link,
        .navbar-cooperoble .dropdown-toggle {
            color: #fff !important;
        }
        .navbar-cooperoble .nav-link:hover {
            color: #ddd !important;
        }

        /* Botón hamburguesa personalizado */
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
            background: #c47a52; /* Naranja */
            border-radius: 2px;
            transition: background 0.3s;
        }
        .hamburger-btn:hover .burger-icon span {
            background: #a66243;
        }

        /* Offcanvas (sidebar) */
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

        /* ===== Tarjetas y formularios ===== */
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
            max-width: 600px;
            margin: 30px auto;
        }

        /* Botones del formulario principal */
        .btn-same-size {
            display: inline-block;
            min-width: 130px;
            padding: 10px 15px;
            text-align: center;
            border: none;
            color: #fff;
            cursor: pointer;
            border-radius: 4px;
        }
        .btn-crear {
            background-color: #c47a52;
            color: #fff !important;
        }
        .btn-crear:hover {
            background-color: #c47a52;
            color: #fff !important;
        }
        .btn-cancel {
            background-color: #c47a52; 
            color: #fff !important;
        }
        .btn-cancel:hover {
            background-color: #c47a52;
            color: #fff !important;
        }
        .btn-action {
            min-width: 130px;
        }
        .btn-c47a52 {
            background-color: #c47a52 !important;
            border-color: #c47a52 !important;
            color: #fff !important;
        }
        .btn-c47a52:hover {
            background-color: #a66243 !important;
            border-color: #a66243 !important;
            color: #fff !important;
        }

        /* ===== Responsividad ===== */
        @media (max-width: 576px) {
            .form-container {
                margin: 20px 10px; 
            }
            .card-header {
                min-height: auto;  
            }
            .card-header h4 {
                font-size: 1.2rem; 
            }
        }
    </style>
</head>
<body>
    <form id="formUnidad" runat="server">

        <div class="page-wrapper">
            <!-- NAVBAR SUPERIOR -->
            <nav class="navbar navbar-cooperoble navbar-dark">
                <div class="container-fluid d-flex align-items-center">
                    <!-- Botón hamburguesa -->
                    <button type="button" class="hamburger-btn me-3" data-bs-toggle="offcanvas"
                            data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
                        <div class="burger-icon">
                            <span></span>
                            <span></span>
                            <span></span>
                        </div>
                    </button>
                    

                    <!-- "Bienvenido, ..." a la derecha -->
                    <div class="ms-auto d-flex align-items-center">
                        <span class="text-white me-3">Bienvenido, <%: Session("nombre") %></span>
                    </div>
                </div>
            </nav>

            <!-- SIDEBAR OFFCANVAS -->
            <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasMenu" aria-labelledby="offcanvasMenuLabel">
                <div class="offcanvas-header">
                    <h5 class="offcanvas-title" id="offcanvasMenuLabel">Menú</h5>
                    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas"
                            aria-label="Close"></button>
                </div>
                <div class="offcanvas-body">
                    <nav class="nav flex-column">
                        <a href="Index.aspx" class="nav-link">Inicio</a>
                        <a href="Unidad.aspx" class="nav-link">Crear Unidad</a>
                        <a href="Averias.aspx" class="nav-link">Crear Avería</a>
                        <a href="Usuarios.aspx" class="nav-link">Usuarios</a>
                        <a href="SeguimientoReporte.aspx" class="nav-link">Seguimiento Reporte</a>
                        <a href="AsignarReporte.aspx" class="nav-link">Asignar Reporte</a>
                        <a href="MantenimientoPreventivo.aspx" class="nav-link">Mantenimiento preventivo</a>
                        <a href="dekra.aspx" class="nav-link">Mantenimiento Dekra</a>
                        <asp:LinkButton ID="lnkLogoutSidebar" runat="server" CssClass="nav-link text-start"
                                        OnClick="lnkLogout_Click">
                            Cerrar Sesión
                        </asp:LinkButton>
                    </nav>
                </div>
            </div>

            <!-- CONTENIDO PRINCIPAL -->
            <div class="content-wrapper container">
                <!-- Tarjeta para crear Unidad -->
                <div class="card form-container">
                    <div class="card-header">
                        <h4>Crear Unidad</h4>
                    </div>
                    <div class="card-body">
                        <div class="form-group mb-2">
                            <label for="txtMarca" class="form-label">Marca</label>
                            <asp:TextBox ID="txtMarca" runat="server" CssClass="form-control" placeholder="Ingrese la marca"></asp:TextBox>
                        </div>
                        <div class="form-group mb-2">
                            <label for="txtModelo" class="form-label">Modelo</label>
                            <asp:TextBox ID="txtModelo" runat="server" CssClass="form-control" placeholder="Ingrese el modelo"></asp:TextBox>
                        </div>
                        <div class="form-group mb-2">
                            <label for="txtAnio" class="form-label">Año</label>
                            <asp:TextBox 
                                ID="txtAnio" 
                                runat="server" 
                                CssClass="form-control" 
                                placeholder="Ingrese el año"
                                MaxLength="4" 
                                onkeypress="return onlyNumbers(event)" 
                                TextMode="Number">
                            </asp:TextBox>

                        </div>
                        <div class="form-group mb-2">
                            <label for="txtPlaca" class="form-label">Placa</label>
                            <asp:TextBox ID="txtPlaca" runat="server" CssClass="form-control" placeholder="Ingrese la placa"></asp:TextBox>
                        </div>
                        <div class="form-group mb-3">
                            <label for="ddlEstado" class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Activo" Value="Activo" />
                                <asp:ListItem Text="Inactivo" Value="Inactivo" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group mt-3">
                            <asp:Button ID="btnCrearUnidad" runat="server"
                                        CssClass="btn-same-size btn-crear me-2"
                                        Text="Crear Unidad"
                                        OnClick="btnCrearUnidad_Click" />
                            <asp:Button ID="btnCancelar" runat="server"
                                        CssClass="btn-same-size btn-cancel"
                                        Text="Cancelar"
                                        PostBackUrl="Index.aspx" />
                        </div>
                        <div class="alert alert-success mt-3" runat="server" ID="alertSuccess" Visible="False">
                            Unidad creada exitosamente.
                        </div>
                        <div class="alert alert-danger mt-3" runat="server" ID="alertError" Visible="False">
                            Ocurrió un error al crear la unidad.
                        </div>
                    </div>
                </div>

                <!-- Tarjeta para listar Unidades -->
                <div class="card form-container">
                    <div class="card-header">
                        <h4>Unidades Existentes</h4>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvUnidades" runat="server" AutoGenerateColumns="False"
                                          CssClass="table table-striped table-hover table-bordered table-sm w-100"
                                          OnRowCommand="gvUnidades_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="id_unidad" HeaderText="ID" />
                                    <asp:BoundField DataField="marca" HeaderText="Marca" />
                                    <asp:BoundField DataField="modelo" HeaderText="Modelo" />
                                    <asp:BoundField DataField="ano" HeaderText="Año" />
                                    <asp:BoundField DataField="placa" HeaderText="Placa" />
                                    <asp:BoundField DataField="estado" HeaderText="Estado" />
                                    <asp:TemplateField HeaderText="Acciones">
                                        <ItemTemplate>
                                            <div class="d-flex gap-2">
                                                <asp:LinkButton ID="lnkEditar" runat="server"
                                                                CssClass="btn btn-c47a52 btn-sm"
                                                                CommandName="EditarUnidad"
                                                                CommandArgument='<%# Eval("id_unidad") %>'>
                                                    Editar
                                                </asp:LinkButton>
                                            </div>
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
                    <p>&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>

        <!-- MODAL para Editar Unidad -->
        <div class="modal fade" id="modalUnidadEdit" tabindex="-1" aria-labelledby="modalUnidadEditLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalUnidadEditLabel">Editar Unidad</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Div para error de validación -->
                        <div id="divModalErrorEdit" style="display:none;" class="alert alert-danger"></div>
                        <!-- Campos del formulario para edición -->
                        <asp:HiddenField ID="hfIdUnidadEdit" runat="server" />
                        <div class="form-group mb-2">
                            <label for="txtMarcaEdit" class="form-label">Marca</label>
                            <asp:TextBox ID="txtMarcaEdit" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group mb-2">
                            <label for="txtModeloEdit" class="form-label">Modelo</label>
                            <asp:TextBox ID="txtModeloEdit" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group mb-2">
                            <label for="txtAnioEdit" class="form-label">Año</label>
                            <asp:TextBox ID="txtAnioEdit" runat="server" CssClass="form-control"
                                         MaxLength="4" onkeypress="return onlyNumbers(event)" />
                        </div>
                        <div class="form-group mb-2">
                            <label for="txtPlacaEdit" class="form-label">Placa</label>
                            <asp:TextBox ID="txtPlacaEdit" runat="server" CssClass="form-control" ReadOnly="True" />
                        </div>
                        <div class="form-group mb-3">
                            <label for="ddlEstadoEdit" class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstadoEdit" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Activo" Value="Activo" />
                                <asp:ListItem Text="Inactivo" Value="Inactivo" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnGuardarUnidad" runat="server"
                                    CssClass="btn btn-crear"
                                    Text="Guardar"
                                    OnClick="btnGuardarUnidad_Click"
                                    OnClientClick="return ValidateUnidadEdit();" />
                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts JS -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript">
            // Permitir solo números en el campo Año
            function onlyNumbers(e) {
                var charCode = (typeof e.which == "number") ? e.which : e.keyCode;
                // Teclas especiales: backspace, tab, enter, flechas, delete
                if (
                    charCode !== 8 && charCode !== 9 && charCode !== 13 &&
                    charCode !== 37 && charCode !== 39 && charCode !== 46
                ) {
                    if (charCode < 48 || charCode > 57) {
                        e.preventDefault();
                        return false;
                    }
                }
                return true;
            }

            // Validación del modal de edición
            function ValidateUnidadEdit() {
                var marca = document.getElementById('<%= txtMarcaEdit.ClientID %>').value;
                var modelo = document.getElementById('<%= txtModeloEdit.ClientID %>').value;
                var anio = document.getElementById('<%= txtAnioEdit.ClientID %>').value;
                var errorDiv = document.getElementById('divModalErrorEdit');

                errorDiv.style.display = "none";
                errorDiv.innerHTML = "";

                if (marca.trim() === "" || modelo.trim() === "" || anio.trim() === "") {
                    errorDiv.innerHTML = "Los campos Marca, Modelo y Año son obligatorios.";
                    errorDiv.style.display = "block";
                    return false;
                }
                if (isNaN(anio)) {
                    errorDiv.innerHTML = "El año debe ser un número válido.";
                    errorDiv.style.display = "block";
                    return false;
                }
                return true;
            }
        </script>
    </form>
</body>
</html>
