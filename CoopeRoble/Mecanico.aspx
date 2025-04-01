<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Mecanico.aspx.vb" Inherits="CoopeRoble.Mecanico" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <title>Mecánico - CoopeRoble</title>
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
    </style>
</head>
<body>
    <form id="formMecanico" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="page-wrapper">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark">
                <div class="container-fluid">
                    <a class="navbar-brand" href="#">Bienvenido, <%: Session("nombre") %></a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMecanico"
                        aria-controls="navbarMecanico" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarMecanico">
                        <ul class="navbar-nav ms-auto">
                
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
                <h3 class="mb-3" style="color:#281966;">Dashboard Mecánico</h3>
                <p>Aquí se muestran los reportes asignados con estado <strong>"en proceso"</strong>, ordenados por urgencia (grave, medio, leve).</p>
                
                <!-- Botones superiores -->
                <div class="d-flex flex-wrap gap-2 mb-4">
                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="btn btn-sm btn-primary" OnClick="lnkReportesDisponibles_Click">
                        Reportes Disponibles
                    </asp:LinkButton>
                    <asp:LinkButton ID="LinkButton2" runat="server" CssClass="btn btn-sm btn-primary" PostBackUrl="ReparacionTerminada.aspx">
                        Reparaciones Terminadas
                    </asp:LinkButton>
                </div>

                <!-- UpdatePanel -->
                <asp:UpdatePanel ID="upReportes" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- Repeater para tarjetas -->
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
                                                <span class="severity-indicator" style='<%# GetSeverityStyle(Eval("Gravedad")) %>'></span>
                                                <%# Eval("Gravedad") %><br />
                                                <strong>Tipo de Avería:</strong> <%# Eval("tipo_averia") %>
                                            </p>
                                            <div class="mt-auto d-flex flex-wrap gap-2">
                                                <asp:LinkButton ID="lnkVerDetalle" runat="server" CssClass="btn btn-sm btn-naranja"
                                                    CommandName="VerDetalle" CommandArgument='<%# Eval("id_reporte") %>'>
                                                    Ver Detalle
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lnkSeguimiento" runat="server" CssClass="btn btn-sm btn-naranja"
                                                    PostBackUrl='<%# "Seguimiento.aspx?id_reporte=" & Eval("id_reporte") %>'>
                                                    Seguimiento
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lnkResponder" runat="server" CssClass="btn btn-sm btn-naranja"
                                                    PostBackUrl='<%# "Reparacion.aspx?id_reporte=" & Eval("id_reporte") %>'
                                                    Visible='<%# Eval("estado").ToString().Trim().ToLower() = "en proceso" %>'>
                                                    Responder
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

                        <!-- Modal para detalle -->
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
                                <div id="modalImagenes" runat="server"></div>
                                <!-- Historial de Reparaciones -->
                                <div class="mt-3">
                                    <h6>Historial de Reparaciones</h6>
                                    <asp:Repeater ID="rptHistorial" runat="server">
                                        <HeaderTemplate>
                                            <ul class="list-group">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <li class="list-group-item">
                                                <strong><%# Eval("fecha_seguimiento") %>:</strong> <%# Eval("comentario") %>
                                            </li>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </ul>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <asp:Label ID="lblEmptyHistorial" runat="server" Text="No hay historial disponible." CssClass="text-muted"></asp:Label>
                                </div>
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
        function abrirModalDetalle() {
            var modalDetalle = new bootstrap.Modal(document.getElementById('detalleModal'));
            modalDetalle.show();
        }
    </script>
</body>
</html>
