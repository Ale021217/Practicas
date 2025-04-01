<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="MantenimientoPreventivo.aspx.vb" Inherits="CoopeRoble.MantenimientoPreventivo" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Mantenimiento Preventivo - Cambio de Aceite - CoopeRoble</title>
    <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/responsive.css" />
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8faff;
        }
        .page-wrapper {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .content-wrapper {
            flex: 1 0 auto;
            padding: 20px;
        }
        .footer-cooperoble {
            flex-shrink: 0;
            background-color: #281966;
            color: #fff;
            text-align: center;
            padding: 10px 0;
        }
        /* Navbar */
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
        /* Sidebar Offcanvas */
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
        /* Tarjetas */
        .card {
            border: 1px solid #ddd;
            margin-bottom: 20px;
            border-radius: 4px;
            background: #fff;
        }
        .card-header {
            background-color: #281966;
            color: #fff;
            padding: 15px;
            font-size: 1.2em;
            font-weight: bold;
        }
        /* Botones */
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
      
    </style>
</head>
<body>
    <form id="formMantenimiento" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="page-wrapper">
            <!-- Navbar Superior -->
            <nav class="navbar navbar-cooperoble navbar-dark d-flex align-items-center">
                <div class="d-flex align-items-center">
                    <button type="button" class="hamburger-btn me-3" data-bs-toggle="offcanvas" data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
                        <div class="burger-icon">
                            <span></span>
                            <span></span>
                            <span></span>
                        </div>
                    </button>
                </div>
                <div class="d-flex align-items-center ms-auto">
                    <span class="text-white me-3">Bienvenido, <%: Session("nombre") %></span>
                </div>
            </nav>

            <!-- Sidebar Offcanvas -->
            <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasMenu" aria-labelledby="offcanvasMenuLabel">
                <div class="offcanvas-header">
                    <h5 class="offcanvas-title" id="offcanvasMenuLabel">Menú</h5>
                    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
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
                        <asp:LinkButton ID="lnkLogoutSidebar" runat="server" CssClass="nav-link text-start" OnClick="lnkLogout_Click">
                            Cerrar Sesión
                        </asp:LinkButton>
                    </nav>
                </div>
            </div>

            <!-- Contenido Principal -->
            <div class="content-wrapper container">
                <h3 class="mb-3" style="color:#281966;">Mantenimiento Preventivo - Cambio de Aceite</h3>
                <asp:Label ID="lblMensaje" runat="server" ForeColor="Green"></asp:Label>
                <hr />

                <!-- Card para seleccionar unidad -->
                <div class="card">
                    <div class="card-header">Seleccionar Unidad</div>
                    <div class="card-body">
                        <asp:DropDownList ID="ddlUnidades" runat="server" CssClass="form-control" AutoPostBack="True"
                            OnSelectedIndexChanged="ddlUnidades_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Card para registrar nuevo mantenimiento -->
                <div class="card">
                    <div class="card-header">Registrar Nuevo Mantenimiento</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <asp:Label ID="lblFechaCambio" runat="server" Text="Fecha de Cambio:" AssociatedControlID="txtFechaCambio"></asp:Label>
                                    <asp:TextBox ID="txtFechaCambio" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFechaCambio" runat="server" ControlToValidate="txtFechaCambio"
                                        ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                </div>
                                <div class="mb-3">
                                    <asp:Label ID="lblKilometraje" runat="server" Text="Kilometraje:" AssociatedControlID="txtKilometraje"></asp:Label>
                                    <asp:TextBox ID="txtKilometraje" runat="server" CssClass="form-control" oninput="validarNumero(this)"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvKilometraje" runat="server" ControlToValidate="txtKilometraje"
                                        ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                    <asp:CompareValidator ID="cvKilometraje" runat="server" ControlToValidate="txtKilometraje"
                                        Operator="DataTypeCheck" Type="Integer" ErrorMessage="Debe ser número entero" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                </div>
                                <div class="mb-3">
                                    <asp:Label ID="lblProximoCambio" runat="server" Text="Próximo Cambio (km):" AssociatedControlID="txtProximoCambio"></asp:Label>
                                    <asp:TextBox ID="txtProximoCambio" runat="server" CssClass="form-control" oninput="validarNumero(this)"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvProximoCambio" runat="server" ControlToValidate="txtProximoCambio"
                                        ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                    <asp:CompareValidator ID="cvProximoCambio" runat="server" ControlToValidate="txtProximoCambio"
                                        Operator="DataTypeCheck" Type="Integer" ErrorMessage="Debe ser número entero" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <asp:Label ID="lblMarcaAceite" runat="server" Text="Marca de Aceite:" AssociatedControlID="txtMarcaAceite"></asp:Label>
                                    <asp:TextBox ID="txtMarcaAceite" runat="server" CssClass="form-control"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvMarcaAceite" runat="server" ControlToValidate="txtMarcaAceite"
                                        ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                </div>
                                <div class="mb-3">
                                    <asp:Label ID="lblCostoAceite" runat="server" Text="Costo del Aceite:" AssociatedControlID="txtCostoAceite"></asp:Label>
                                    <asp:TextBox ID="txtCostoAceite" runat="server" CssClass="form-control" oninput="validarDecimal(this)"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCostoAceite" runat="server" ControlToValidate="txtCostoAceite"
                                        ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                    <asp:CompareValidator ID="cvCostoAceite" runat="server" ControlToValidate="txtCostoAceite"
                                        Operator="DataTypeCheck" Type="Double" ErrorMessage="Debe ser número decimal" Display="Dynamic" ForeColor="Red" ValidationGroup="vgMantenimiento" />
                                </div>
                                <div class="mb-3">
                                    <asp:Label ID="lblObservaciones" runat="server" Text="Observaciones:" AssociatedControlID="txtObservaciones"></asp:Label>
                                    <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar Mantenimiento" CssClass="btn btn-c47a52"
                            OnClick="btnRegistrar_Click" ValidationGroup="vgMantenimiento" Enabled="false" />
                    </div>
                </div>

                <!-- Card para historial de mantenimientos -->
                <div class="card">
                    <div class="card-header">Historial de Mantenimientos</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvMantenimientos" runat="server" CssClass="table table-striped table-bordered" 
                                AutoGenerateColumns="False" AllowPaging="True" PageSize="5" 
                                OnPageIndexChanging="gvMantenimientos_PageIndexChanging"
                                OnRowCommand="gvMantenimientos_RowCommand"
                                OnRowDataBound="gvMantenimientos_RowDataBound"
                                DataKeyNames="id_mantenimiento,fecha_cambio,kilometraje,proximo_cambio_km,marca_aceite,costo_aceite,observaciones">
                                <Columns>
                                    <asp:BoundField DataField="id_mantenimiento" HeaderText="ID" />
                                    <asp:BoundField DataField="unidad" HeaderText="Unidad" />
                                    <asp:BoundField DataField="fecha_cambio" HeaderText="Fecha Cambio" DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="kilometraje" HeaderText="Kilometraje" />
                                    <asp:TemplateField HeaderText="Próximo Cambio (km)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProximoCambio" runat="server" Text='<%# Eval("proximo_cambio_km") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="marca_aceite" HeaderText="Marca Aceite" />
                                    <asp:BoundField DataField="costo_aceite" HeaderText="Costo" DataFormatString="{0:C}" />
                                    <asp:BoundField DataField="observaciones" HeaderText="Observaciones" />
                                    <asp:TemplateField HeaderText="Acciones">
                                        <ItemTemplate>
                                            <div class="d-flex gap-2">
                                                <asp:LinkButton ID="lnkEditar" runat="server" CssClass="btn btn-c47a52 btn-sm"
                                                    CommandName="Editar" CommandArgument='<%# Eval("id_mantenimiento") %>'>
                                                    Editar
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lnkEliminar" runat="server" CssClass="btn btn-c47a52 btn-sm"
                                                    CommandName="Eliminar" CommandArgument='<%# Eval("id_mantenimiento") %>'
                                                    OnClientClick="return confirm('¿Está seguro que desea eliminar este mantenimiento?');">
                                                    Eliminar
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="alert alert-info">No hay registros de mantenimiento para la unidad seleccionada.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="footer-cooperoble">
                <div class="container">
                    <p>&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>

        <!-- Modal de Edición -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Editar Mantenimiento</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="divModalError" runat="server" class="alert alert-danger" style="display:none;"></div>
                        <asp:HiddenField ID="hfIdMantenimiento" runat="server" />
                        <div class="mb-3">
                            <asp:Label ID="lblModalFechaCambio" runat="server" Text="Fecha de Cambio:" AssociatedControlID="txtModalFechaCambio"></asp:Label>
                            <asp:TextBox ID="txtModalFechaCambio" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalFechaCambio" runat="server" ControlToValidate="txtModalFechaCambio"
                                ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalKilometraje" runat="server" Text="Kilometraje:" AssociatedControlID="txtModalKilometraje"></asp:Label>
                            <asp:TextBox ID="txtModalKilometraje" runat="server" CssClass="form-control" oninput="validarNumero(this)"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalKilometraje" runat="server" ControlToValidate="txtModalKilometraje"
                                ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                            <asp:CompareValidator ID="cvModalKilometraje" runat="server" ControlToValidate="txtModalKilometraje"
                                Operator="DataTypeCheck" Type="Integer" ErrorMessage="Debe ser número entero" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalProximoCambio" runat="server" Text="Próximo Cambio (km):" AssociatedControlID="txtModalProximoCambio"></asp:Label>
                            <asp:TextBox ID="txtModalProximoCambio" runat="server" CssClass="form-control" oninput="validarNumero(this)"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalProximoCambio" runat="server" ControlToValidate="txtModalProximoCambio"
                                ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                            <asp:CompareValidator ID="cvModalProximoCambio" runat="server" ControlToValidate="txtModalProximoCambio"
                                Operator="DataTypeCheck" Type="Integer" ErrorMessage="Debe ser número entero" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalMarcaAceite" runat="server" Text="Marca de Aceite:" AssociatedControlID="txtModalMarcaAceite"></asp:Label>
                            <asp:TextBox ID="txtModalMarcaAceite" runat="server" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalMarcaAceite" runat="server" ControlToValidate="txtModalMarcaAceite"
                                ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalCostoAceite" runat="server" Text="Costo del Aceite:" AssociatedControlID="txtModalCostoAceite"></asp:Label>
                            <asp:TextBox ID="txtModalCostoAceite" runat="server" CssClass="form-control" oninput="validarDecimal(this)"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalCostoAceite" runat="server" ControlToValidate="txtModalCostoAceite"
                                ErrorMessage="Requerido" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                            <asp:CompareValidator ID="cvModalCostoAceite" runat="server" ControlToValidate="txtModalCostoAceite"
                                Operator="DataTypeCheck" Type="Double" ErrorMessage="Debe ser número decimal" Display="Dynamic" ForeColor="Red" ValidationGroup="vgModal" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalObservaciones" runat="server" Text="Observaciones:" AssociatedControlID="txtModalObservaciones"></asp:Label>
                            <asp:TextBox ID="txtModalObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnModalGuardar" runat="server" Text="Guardar Cambios" CssClass="btn btn-c47a52"
                            OnClick="btnModalGuardar_Click" ValidationGroup="vgModal" />
                        <button type="button" class="btn btn-c47a52" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script>
            // Validación para solo números en campos numéricos
            function validarNumero(input) {
                input.value = input.value.replace(/[^0-9]/g, '');
            }

            // Validación para números con decimales (para costo)
            function validarDecimal(input) {
                // Permite números y un solo punto decimal
                input.value = input.value.replace(/[^0-9.]/g, '');

                // Elimina puntos adicionales
                if ((input.value.match(/\./g) || []).length > 1) {
                    input.value = input.value.substring(0, input.value.lastIndexOf('.'));
                }
            }

            function showEditModal() {
                var modal = new bootstrap.Modal(document.getElementById('editModal'));
                modal.show();
            }

            function hideEditModal() {
                var modal = bootstrap.Modal.getInstance(document.getElementById('editModal'));
                if (modal) {
                    modal.hide();
                }
            }
        </script>
    </form>
</body>
</html>