<%@ Page Language="vb" AutoEventWireup="true" 
    CodeFile="SeguimientoReporte.aspx.vb" 
    Inherits="SeguimientoReporte" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Seguimiento de Reporte</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
    <!-- Bootstrap Icons (CDN) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <!-- Estilos globales -->
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/responsive.css" />

    <style>
        /* ===== ESTRUCTURA BÁSICA ===== */
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
        .input-group .form-control {
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
        }
        .input-group .btn-action {
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
        }

        /* ===== NAVBAR Y SIDEBAR ===== */
        .navbar-cooperoble {
            background-color: #281966; /* Fondo morado */
            padding: 0.75rem 1rem;
        }
        /* Color de los textos en la navbar */
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
            background: #c47a52; /* Color naranja de las líneas */
            border-radius: 2px;
            transition: background 0.3s;
        }
        .hamburger-btn:hover .burger-icon span {
            background: #a66243; /* Al pasar el mouse */
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
            padding: 10px 15px;
        }
        .offcanvas .offcanvas-title {
            color: #fff;
            font-size: 1rem;
        }
        .offcanvas .btn-close {
            filter: invert(1);
            font-size: 0.75rem;
        }
        .offcanvas .nav-link {
            color: #fff;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            transition: background 0.3s;
            font-size: 0.85rem;
        }
        .offcanvas .nav-link:hover {
            background-color: #1f144f;
            color: #fff;
        }

        /* ===== BOTONES PERSONALIZADOS ===== */
        .btn-naranja {
            background-color: #a66243 !important;
            border-color: #a66243 !important;
            color: #fff !important;
        }
        .btn-naranja:hover {
            background-color: #8a5038 !important;
            border-color: #8a5038 !important;
        }
        /* Botón azul (mismo color que el navbar) */
        .btn-azul {
            background-color: #281966 !important;
            border-color: #281966 !important;
            color: #fff !important;
        }
        .btn-azul:hover {
            background-color: #1f1452 !important;
            border-color: #1f1452 !important;
        }

        /* ===== TITULOS Y TABLAS ===== */
        h2 {
            color: #281966;
            margin-bottom: 15px;
            font-size: 1.5rem;
        }
        .table thead th {
            background-color: #281966;
            color: #fff;
            font-size: 0.8rem;
            white-space: nowrap;
        }
        .table td {
            font-size: 0.85rem;
            vertical-align: middle;
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f2f2f2;
        }
        .card-header {
            background-color: #281966;
            color: #fff;
            padding: 10px 15px;
            font-size: 0.95rem;
        }

        /* ===== CONTENEDOR CENTRAL ===== */
        .form-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 15px;
        }

        /* Panel de información del reporte */
        .card-body p {
            margin-bottom: 8px;
            font-size: 0.9rem;
        }

        /* Tabla responsive */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        /* Inputs y selects */
        .form-control, .form-select {
            font-size: 0.85rem;
            padding: 0.375rem 0.75rem;
        }

        /* Botones de acción */
        .btn-action {
            padding: 0.25rem 0.5rem;
            font-size: 0.8rem;
        }

        /* ===== AJUSTES ESPECÍFICOS PARA MÓVIL ===== */
        @media (max-width: 767.98px) {
            .content-wrapper {
                padding-top: 10px;
                padding-bottom: 10px;
            }
            h2 {
                font-size: 1.25rem;
                margin-bottom: 10px;
            }
            .filter-row .col {
                margin-bottom: 10px;
            }
            .btn-mobile {
                width: 100%;
                margin-bottom: 5px;
            }
            .card-body p {
                font-size: 0.8rem;
                margin-bottom: 5px;
            }
            .table td, .table th {
                padding: 0.5rem;
            }
            .footer-cooperoble p {
                font-size: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <form id="formSeguimiento" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="page-wrapper">
            <!-- NAVBAR SUPERIOR -->
            <nav class="navbar navbar-cooperoble navbar-dark">
                <div class="container-fluid">
                    <!-- IZQUIERDA: Botón hamburguesa + "Inicio" -->
                    <div class="d-flex align-items-center">
                        <button type="button" class="hamburger-btn me-2" data-bs-toggle="offcanvas"
                                data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
                            <div class="burger-icon">
                                <span></span>
                                <span></span>
                                <span></span>
                            </div>
                        </button>
                   
                    </div>

                    <!-- DERECHA: "Bienvenido, ..." -->
                    <div class="d-flex align-items-center ms-auto">
                        <span class="text-white me-2">
                            Bienvenido, <%: Session("nombre") %>
                        </span>
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

            <!-- Panel de error -->
            <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger container mt-3" Visible="False">
                <asp:Label ID="lblError" runat="server" Text="Error"></asp:Label>
            </asp:Panel>

            <!-- CONTENIDO PRINCIPAL -->
            <div class="content-wrapper container mt-2 mb-3">
                <div class="form-container">
                    <h2 class="text-center text-md-start">Seguimiento de Reporte</h2>
                    <hr />

                    <!-- Filtros -->
                    <div class="card mb-3">
                        <div class="card-body p-3">
                            <div class="row row-cols-1 g-3 filter-row">
                                <!-- Dropdown Unidad -->
                                <div class="col">
                                    <label class="form-label small" for="ddlUnidad">Unidad:</label>
                                    <asp:DropDownList ID="ddlUnidad" runat="server" CssClass="form-select form-select-sm"
                                                      AutoPostBack="True"
                                                      OnSelectedIndexChanged="ddlUnidad_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- Filtro por ID -->
                                <div class="col">
                                    <label class="form-label small" for="txtFiltroReporte">Buscar por ID:</label>
                                    <div class="input-group input-group-sm" style="height: 40px;">
                                        <asp:TextBox ID="txtFiltroReporte" runat="server"
                                                     CssClass="form-control"
                                                     placeholder="Ej. 1"
                                                     style="height: 40px; line-height: 40px;">
                                        </asp:TextBox>
                                        <asp:LinkButton ID="btnBuscarReporte" runat="server"
                                                        CssClass="btn btn-naranja btn-action"
                                                        OnClick="btnBuscarReporte_Click"
                                                        CausesValidation="False">
                                            <i class="bi bi-search"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <!-- Dropdown Tipo de Avería -->
                                <div class="col">
                                    <label class="form-label small" for="ddlTipoAveria">Tipo de Avería:</label>
                                    <asp:DropDownList ID="ddlTipoAveria" runat="server" CssClass="form-select form-select-sm"
                                                      AutoPostBack="True"
                                                      OnSelectedIndexChanged="ddlTipoAveria_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- Filtro Fecha -->
                                <div class="col">
                                    <label class="form-label small" for="txtFechaHora">Fecha:</label>
                                    <asp:TextBox ID="txtFechaHora" runat="server" CssClass="form-control form-control-sm"
                                                 TextMode="Date"
                                                 placeholder="Ej. 2025-02-03"></asp:TextBox>
                                </div>
                                <!-- Dropdown Reporte -->
                                <div class="col">
                                    <label class="form-label small" for="ddlReporte">Reporte:</label>
                                    <asp:DropDownList ID="ddlReporte" runat="server" CssClass="form-select form-select-sm"
                                                      AutoPostBack="True"
                                                      OnSelectedIndexChanged="ddlReporte_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- Botones Buscar / Limpiar -->
                                <div class="col">
                                    <div class="d-grid gap-2 d-md-flex">
                                        <!-- Botón Buscar (naranja) -->
                                        <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-naranja btn-sm flex-grow-1"
                                                        OnClick="btnBuscar_Click" CausesValidation="False">
                                            <i class="bi bi-search"></i> Buscar
                                        </asp:LinkButton>
                                        <!-- Botón Limpiar (naranja) -->
                                        <asp:LinkButton ID="btnLimpiar" runat="server" CssClass="btn btn-naranja btn-sm flex-grow-1"
                                                        OnClick="btnLimpiar_Click" CausesValidation="False">
                                            <i class="bi bi-x-circle"></i> Limpiar
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Panel con la información principal del reporte -->
                    <asp:Panel ID="pnlInfoReporte" runat="server" Visible="False" CssClass="card mb-3">
                        <div class="card-header">
                            <strong>Detalle del Reporte</strong>
                        </div>
                        <div class="card-body p-3">
                            <p><strong>ID Reporte:</strong> <asp:Label ID="lblIdReporte" runat="server"></asp:Label></p>
                            <p><strong>Chofer:</strong> <asp:Label ID="lblChofer" runat="server"></asp:Label></p>
                            <p><strong>Estado del Reporte:</strong> <asp:Label ID="lblEstadoReporte" runat="server"></asp:Label></p>
                            <p><strong>Tipo de Avería:</strong> <asp:Label ID="lblTipoAveria" runat="server"></asp:Label></p>
                            <p><strong>Fecha del Reporte:</strong> <asp:Label ID="lblFechaReporte" runat="server"></asp:Label></p>
                            <p><strong>Descripción:</strong> <asp:Label ID="lblDescripcion" runat="server"></asp:Label></p>
                        </div>
                    </asp:Panel>

                    <!-- Panel de resultados (tabla de reparaciones) -->
                    <asp:Panel ID="pnlTablaSeguimientos" runat="server" Visible="False">
                        <div class="card">
                            <div class="card-header">
                                <strong>Reparaciones asociadas</strong>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <asp:Repeater ID="rptSeguimientos" runat="server">
                                        <HeaderTemplate>
                                            <table class="table table-striped table-bordered align-middle mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Cédula</th>
                                                        <th>Nombre</th>
                                                        <th>Fecha Seguimiento</th>
                                                        <th>Comentario</th>
                                                        <th>Estado</th>
                                                        <th>Foto</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("cedula") %></td>
                                                <td><%# Eval("nombre") %></td>
                                                <td><%# Eval("fecha_seguimiento") %></td>
                                                <td><%# Eval("comentario") %></td>
                                                <td><%# Eval("estado_reporte") %></td>
                                                <td>
                                                    <asp:Literal ID="litFotos" runat="server"
                                                                 Text='<%# RenderFotoLinks(Eval("foto")) %>'>
                                                    </asp:Literal>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                                </tbody>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- Panel si no hay reparaciones -->
                    <asp:Panel ID="pnlSinSeguimientos" runat="server" CssClass="alert alert-info mt-3 mb-3 p-2" Visible="False">
                        No hay reparaciones registradas para este reporte.
                    </asp:Panel>
                </div>
            </div>

            <!-- FOOTER -->
            <div class="footer-cooperoble">
                <div class="container">
                    <p class="mb-0">&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
                </div>
            </div>
        </div>

        <!-- Scripts Bootstrap -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
