<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="ListaReportes.aspx.vb" Inherits="CoopeRoble.ListaReportes" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lista de Reportes Pendientes - CoopeRoble</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />

    <style>
        html, body {
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
            flex: 1;
            padding: 20px;
        }
        .footer-cooperoble {
            background-color: #281966;
            color: #fff;
            text-align: center;
            padding: 10px 0;
        }
        .navbar {
            background-color: #281966;
        }
        .navbar-brand, .nav-link {
            color: #fff !important;
        }

        /* Botones primarios y naranjas */
        .btn-primary {
            background-color: #281966 !important;
            border-color: #281966 !important;
        }
        .btn-primary:hover {
            background-color: #1f1452 !important;
            border-color: #1f1452 !important;
        }
        .btn-naranja {
            background-color: #a66243 !important;
            border-color: #a66243 !important;
            color: #fff !important;
        }
        .btn-naranja:hover {
            background-color: #8a5038 !important;
            border-color: #8a5038 !important;
            color: #fff !important;
        }

        /* Tarjetas minimalistas */
        .card-mechanic {
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            background-color: #fff;
            transition: transform 0.2s ease-in-out;
        }
        .card-mechanic:hover {
            transform: translateY(-3px);
        }
        .card-mechanic .card-body {
            padding: 16px;
        }
        .card-mechanic .card-title {
            font-size: 1.1rem;
            margin-bottom: 10px;
            color: #281966;
            font-weight: bold;
        }
        .card-mechanic .card-text {
            margin-bottom: 0.6rem;
            line-height: 1.4;
        }

        /* Indicador de gravedad */
        .severity-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 5px;
            vertical-align: middle;
        }

        /* Imágenes en el modal */
        .modal-img {
            max-width: 100%;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <form id="formListaReportes" runat="server">
        <!-- ScriptManager para usar Ajax (UpdatePanel) y RegisterStartupScript -->
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="page-wrapper">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark">
                <div class="container-fluid">
                    <a class="navbar-brand" href="#">Bienvenido, <%: Session("nombre") %></a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarListaReportes"
                        aria-controls="navbarListaReportes" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarListaReportes">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item me-3">
                                <a class="nav-link" href="Mecanico.aspx">Mis Reportes</a>
                            </li>
                            <li class="nav-item">
                                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="nav-link" OnClick="lnkLogout_Click">
                                    Cerrar Sesión
                                </asp:LinkButton>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Contenido Principal -->
            <div class="content-wrapper container mt-4 mb-4">
                <h3 class="mb-3" style="color:#281966;">Lista de Reportes Pendientes</h3>
                <p>Aquí se muestran todos los reportes con estado <strong>"pendiente"</strong>.</p>

                <!-- UpdatePanel que incluye el Repeater Y el modal -->
                <asp:UpdatePanel ID="upReportes" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- Repeater con tarjetas -->
                        <asp:Repeater ID="rptReportes" runat="server" OnItemCommand="rptReportes_ItemCommand">
                            <HeaderTemplate>
                                <div class="row g-4">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="col-12 col-md-6 col-lg-4">
                                    <div class="card-mechanic">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title">Reporte #<%# Eval("id_reporte") %></h5>
                                            <p class="card-text">
                                                <strong>Fecha:</strong> <%# Eval("fecha_reporte", "{0:dd/MM/yyyy HH:mm}") %><br />
                                                <strong>Unidad:</strong> <%# Eval("Unidad") %><br />
                                                <strong>Estado:</strong> <%# Eval("estado") %><br />
                                                <strong>Gravedad:</strong>
                                                <span class="severity-indicator"
                                                      style='<%# GetSeverityStyle(Eval("gravedad")) %>'></span>
                                                <%# Eval("gravedad") %><br />
                                                <strong>Tipo de Avería:</strong> <%# Eval("TipoAveria") %>
                                            </p>

                                            <!-- Contenedor oculto para imagen (JSON) y descripción (si lo requieres) -->
                                            <div class="d-none datos-reporte" 
                                                 data-imagen='<%# Eval("imagen_averia") %>' 
                                                 data-descripcion='<%# Eval("descripcion") %>'>
                                            </div>

                                            <!-- Botón para Ver Detalle (abrirá el modal) -->
                                            <div class="mt-auto">
                                                <asp:LinkButton 
                                                    ID="lnkVerDetalle" 
                                                    runat="server"
                                                    CssClass="btn btn-sm btn-naranja"
                                                    CommandName="VerDetalle"
                                                    CommandArgument='<%# Eval("id_reporte") %>'>
                                                    Ver Detalle
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                </div>
                            </FooterTemplate>
                        </asp:Repeater>

                        <!-- Modal para ver detalle (incluido en el UpdatePanel para que se actualicen los labels) -->
                        <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel" aria-hidden="true">
                          <div class="modal-dialog modal-dialog-scrollable">
                            <div class="modal-content">
                              <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="detalleModalLabel">Detalle del Reporte</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                              </div>
                              <div class="modal-body">
                                <p><strong>ID Reporte:</strong> <asp:Label ID="lblModalIdReporte" runat="server"></asp:Label></p>
                                <p><strong>Fecha:</strong> <asp:Label ID="lblModalFecha" runat="server"></asp:Label></p>
                                <p><strong>Unidad:</strong> <asp:Label ID="lblModalUnidad" runat="server"></asp:Label></p>
                                <p><strong>Descripción:</strong> <asp:Label ID="lblModalDescripcion" runat="server"></asp:Label></p>
                                <p><strong>Estado:</strong> <asp:Label ID="lblModalEstado" runat="server"></asp:Label></p>
                                <!-- Contenedor para las imágenes -->
                                <div id="modalImagenes" runat="server"></div>
                              </div>
                              <div class="modal-footer">
                                 <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                              </div>
                            </div>
                          </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                      
                        <asp:AsyncPostBackTrigger ControlID="rptReportes" EventName="ItemCommand" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>

            <!-- Footer -->
            <div class="footer-cooperoble">
                <div class="container">
                    <p>&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>
    </form>

    <!-- Scripts -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función que muestra el modal de Bootstrap
        function abrirModalDetalle() {
            var modalDetalle = new bootstrap.Modal(document.getElementById('detalleModal'));
            modalDetalle.show();
        }
    </script>
</body>
</html>
