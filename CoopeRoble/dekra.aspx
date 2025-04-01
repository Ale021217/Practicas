<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="dekra.aspx.vb" Inherits="CoopeRoble.dekra" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <!-- Etiqueta viewport para responsive -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Control Dekra - CoopeRoble</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
    <!-- Estilos globales -->
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/responsive.css" />
    
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
            padding-top: 20px;
            padding-bottom: 20px;
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
            background-color: #281966; /* Morado */
            padding: 0.75rem 1rem;
        }
        .navbar-cooperoble .navbar-brand,
        .navbar-cooperoble .nav-link {
            color: #fff !important;
            font-size: 0.9rem;
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
            width: 25px;
            height: 16px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .burger-icon span {
            display: block;
            height: 2px;
            background: #c47a52; /* Color naranja */
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

        /* ===== Tarjetas y cabeceras ===== */
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
            font-size: 1rem;
            font-weight: bold;
        }

        /* ===== Contenedor principal ===== */
        .form-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 15px; /* Para pantallas muy pequeñas */
        }

        /* Botones personalizados (azul = #281966) */
        .btn-c47a52 {
            background-color: #281966 !important;
            border-color: #281966 !important;
            color: #fff !important;
        }
        .btn-c47a52:hover {
            background-color: #1f144f !important;
            border-color: #1f144f !important;
            color: #fff !important;
        }
        .btn-danger {
            margin-left: 5px;
        }

        /* ===== Ajustes de tabla y otros ===== */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        .text-white {
  --bs-text-opacity: 1;
  color: rgb(6, 6, 6) !important;
}
                .text-black {
  --bs-text-opacity: 1;
  color: white !important;
}
        
        /* ===== Ajustes específicos para móvil ===== */
        @media (max-width: 767.98px) {
            .navbar-cooperoble {
                padding: 0.5rem;
            }
            .navbar-brand, .nav-link {
                font-size: 0.8rem !important;
            }
            .content-wrapper {
                padding-top: 10px;
                padding-bottom: 10px;
            }
            .card-header {
                font-size: 0.95rem;
            }
            .footer-cooperoble p {
                font-size: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <form id="formDekra" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="page-wrapper">
            <!-- NAVBAR SUPERIOR -->
            <nav class="navbar navbar-cooperoble navbar-dark">
                <div class="container-fluid d-flex align-items-center">
                    <!-- Botón hamburguesa (abre offcanvas) -->
                    <button type="button" class="hamburger-btn me-3" data-bs-toggle="offcanvas"
                            data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
                        <div class="burger-icon">
                            <span></span>
                            <span></span>
                            <span></span>
                        </div>
                    </button>

                    <!-- Texto "Bienvenido, ..." a la derecha -->
                    <div class="ms-auto d-flex align-items-center">
                        <span class=" text-black me-3">Bienvenido, <%: Session("nombre") %></span>
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
                        <a href="MantenimientoPreventivo.aspx" class="nav-link">Mantenimiento Preventivo</a>
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
                <!-- Título principal -->
                <h3 class="mb-3" style="color:#281966;">
                    Control Dekra - Renovación de Derecho a Circulación
                </h3>
                <asp:Label ID="lblMensaje" runat="server" ForeColor="Green"></asp:Label>
                <hr />

                <!-- Card para registrar nuevo control Dekra -->
                <div class="card form-container mb-4">
                    <div class="card-header">
                        Registrar Nuevo Control Dekra
                    </div>
                    <div class="card-body">
                        <p>
                            Ingrese la fecha de la última renovación y la fecha programada para la próxima.  
                        
                        </p>
                        
                        <!-- Unidad -->
                        <div class="mb-3">
                            <asp:Label ID="lblUnidadSelect" runat="server" Text="Unidad:" AssociatedControlID="ddlUnidades"></asp:Label>
                            <asp:DropDownList ID="ddlUnidades" runat="server" CssClass="form-control" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlUnidades_SelectedIndexChanged" ValidationGroup="vgDekra">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvUnidad" runat="server"
                                ControlToValidate="ddlUnidades" InitialValue="0"
                                ErrorMessage="Debe seleccionar una unidad." ValidationGroup="vgDekra"
                                Display="Dynamic" ForeColor="Red" />
                        </div>
                        
                        <!-- Fechas en dos columnas en desktop -->
                        <div class="row g-3">
                            <div class="col-sm-12 col-md-6">
                                <div class="mb-3">
                                    <asp:Label ID="lblFechaUltima" runat="server" Text="Fecha Última Renovación:" AssociatedControlID="txtFechaUltima"></asp:Label>
                                    <asp:TextBox ID="txtFechaUltima" runat="server" CssClass="form-control" TextMode="Date" ValidationGroup="vgDekra"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFechaUltima" runat="server"
                                        ControlToValidate="txtFechaUltima" ErrorMessage="La fecha de la última renovación es obligatoria."
                                        ValidationGroup="vgDekra" Display="Dynamic" ForeColor="Red" />
                                    <asp:CompareValidator ID="cvFechaUltima" runat="server"
                                        ControlToValidate="txtFechaUltima" Operator="DataTypeCheck" Type="Date"
                                        ErrorMessage="Ingrese una fecha válida." ValidationGroup="vgDekra"
                                        Display="Dynamic" ForeColor="Red" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-6">
                                <div class="mb-3">
                                    <asp:Label ID="lblFechaProximo" runat="server" Text="Fecha Próximo Renovación:" AssociatedControlID="txtFechaProximo"></asp:Label>
                                    <asp:TextBox ID="txtFechaProximo" runat="server" CssClass="form-control" TextMode="Date" ValidationGroup="vgDekra"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFechaProximo" runat="server"
                                        ControlToValidate="txtFechaProximo" ErrorMessage="La fecha del próximo renovación es obligatoria."
                                        ValidationGroup="vgDekra" Display="Dynamic" ForeColor="Red" />
                                    <asp:CompareValidator ID="cvFechaProximo" runat="server"
                                        ControlToValidate="txtFechaProximo" Operator="DataTypeCheck" Type="Date"
                                        ErrorMessage="Ingrese una fecha válida." ValidationGroup="vgDekra"
                                        Display="Dynamic" ForeColor="Red" />
                                    <asp:CompareValidator ID="cvFechaProximoMayor" runat="server"
                                        ControlToValidate="txtFechaProximo" ControlToCompare="txtFechaUltima"
                                        Operator="GreaterThan" Type="Date"
                                        ErrorMessage="La fecha próxima debe ser mayor a la última renovación."
                                        ValidationGroup="vgDekra" Display="Dynamic" ForeColor="Red" />
                                </div>
                            </div>
                        </div>
                        
                        <!-- Observaciones -->
                        <div class="mb-3">
                            <asp:Label ID="lblObservaciones" runat="server" Text="Observaciones:" AssociatedControlID="txtObservaciones"></asp:Label>
                            <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                        
                        <!-- Botón registrar -->
                        <asp:Button ID="btnRegistrar" runat="server" Text="Registrar Control Dekra"
                                    CssClass="btn btn-c47a52" OnClick="btnRegistrar_Click"
                                    ValidationGroup="vgDekra" />
                    </div>
                </div>

                <!-- Card para historial de controles -->
                <div class="card form-container">
                    <div class="card-header">
                        Historial de Controles Dekra
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <asp:GridView ID="gvDekra" runat="server" CssClass="table table-striped table-bordered"
                                AutoGenerateColumns="False"
                                AllowPaging="True" PageSize="5"
                                OnPageIndexChanging="gvDekra_PageIndexChanging"
                                OnRowCommand="gvDekra_RowCommand"
                                OnRowDataBound="gvDekra_RowDataBound"
                                DataKeyNames="id_control,fecha_ultima_renovacion,fecha_proximo_renovacion,observaciones,dias_restantes,estado">
                                <Columns>
                                    <asp:BoundField DataField="id_control" HeaderText="ID" />
                                    <asp:BoundField DataField="unidad" HeaderText="Unidad" />
                                    <asp:BoundField DataField="fecha_ultima_renovacion" HeaderText="Última Renovación" 
                                        DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:BoundField DataField="fecha_proximo_renovacion" HeaderText="Próximo Renovación" 
                                        DataFormatString="{0:yyyy-MM-dd}" />
                              
                                    <asp:TemplateField HeaderText="Días Restantes">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDiasRestantes" runat="server" Style="color: black;" Text='<%# Eval("dias_restantes") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Estado">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEstado" runat="server" Style="color: black;" Text='<%# Eval("estado") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                    <asp:BoundField DataField="observaciones" HeaderText="Observaciones" />
                                    <asp:TemplateField HeaderText="Acciones">
                                        <ItemTemplate>
                                            <div class="d-flex">
                                                <asp:LinkButton ID="lnkEdit" runat="server"
                                                    CommandName="EditRecord"
                                                    CommandArgument='<%# Eval("id_control") %>'
                                                    CssClass="btn btn-c47a52 btn-sm">
                                                    Editar
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lnkDelete" runat="server"
                                                    CommandName="DeleteRecord"
                                                    CommandArgument='<%# Eval("id_control") %>'
                                                    CssClass="btn btn-danger btn-sm ms-2"
                                                    OnClientClick="return confirm('¿Está seguro que desea eliminar este registro?');">
                                                    Eliminar
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="alert alert-info">
                                        No hay registros de Dekra para la unidad seleccionada.
                                    </div>
                                </EmptyDataTemplate>
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

        <!-- MODAL DE EDICIÓN -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Editar Control Dekra</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div id="divModalError" runat="server" class="alert alert-danger" style="display:none;"></div>
                        <asp:HiddenField ID="hfIdControl" runat="server" />
                        <div class="mb-3">
                            <asp:Label ID="lblModalFechaUltima" runat="server"
                                       Text="Fecha Última Renovación:" 
                                       AssociatedControlID="txtModalFechaUltima"></asp:Label>
                            <asp:TextBox ID="txtModalFechaUltima" runat="server"
                                         CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalFechaUltima" runat="server"
                                ControlToValidate="txtModalFechaUltima" ErrorMessage="Requerido"
                                ValidationGroup="vgModal" Display="Dynamic" ForeColor="Red" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalFechaProximo" runat="server"
                                       Text="Fecha Próximo Renovación:"
                                       AssociatedControlID="txtModalFechaProximo"></asp:Label>
                            <asp:TextBox ID="txtModalFechaProximo" runat="server"
                                         CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvModalFechaProximo" runat="server"
                                ControlToValidate="txtModalFechaProximo" ErrorMessage="Requerido"
                                ValidationGroup="vgModal" Display="Dynamic" ForeColor="Red" />
                            <asp:CompareValidator ID="cvModalFechaProximo" runat="server"
                                ControlToValidate="txtModalFechaProximo" ControlToCompare="txtModalFechaUltima"
                                Operator="GreaterThan" Type="Date"
                                ErrorMessage="Debe ser mayor a la última renovación"
                                ValidationGroup="vgModal" Display="Dynamic" ForeColor="Red" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="lblModalObservaciones" runat="server"
                                       Text="Observaciones:"
                                       AssociatedControlID="txtModalObservaciones"></asp:Label>
                            <asp:TextBox ID="txtModalObservaciones" runat="server"
                                         CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnModalGuardar" runat="server" Text="Guardar Cambios"
                                    CssClass="btn btn-c47a52"
                                    OnClick="btnModalGuardar_Click"
                                    ValidationGroup="vgModal" />
                        <button type="button" class="btn btn-c47a52" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts Bootstrap -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script>
            // Funciones JS para mostrar/ocultar modal desde code-behind
            function showEditModal() {
                var modal = new bootstrap.Modal(document.getElementById('editModal'));
                modal.show();
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
