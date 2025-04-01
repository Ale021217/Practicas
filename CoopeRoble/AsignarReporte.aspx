<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="AsignarReporte.aspx.vb" Inherits="CoopeRoble.AsignarReporte" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
  <meta charset="utf-8" />
  <title>Asignar Reporte - CoopeRoble</title>
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- Bootstrap CSS -->
  <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
  <link href="assets/css/style.css" rel="stylesheet" />
  <link href="assets/css/responsive.css" rel="stylesheet" />

  <style>
    /* ===== ESTILO GENERAL ===== */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
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
      padding: 20px 0;
    }
    .footer-area {
      margin-top: auto;
      background-color: #281966;
      color: #fff;
      text-align: center;
      padding: 10px 0;
    }

    /* ===== NAVBAR ===== */
    .navbar-cooperoble {
      background-color: #281966;
      padding: 1rem 2rem;
    }
    .navbar-cooperoble .navbar-brand,
    .navbar-cooperoble .nav-link {
      color: #fff !important;
      font-size: 0.9rem;
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

    /* ===== SIDEBAR OFFCANVAS ===== */
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
    }

    /* ===== CARDS ===== */
    .card-custom {
      box-shadow: 0 0 15px rgba(0,0,0,0.05);
      border: none;
      border-radius: 8px;
      margin-bottom: 20px;
      background-color: #fff;
    }
    .card-custom .card-header {
      background-color: #281966;
      border-radius: 8px 8px 0 0;
      padding: 15px;
    }
    .card-custom .card-header h5 {
      color: #fff !important;
      margin: 0;
      font-size: 1.25rem;
    }
    .card-custom .card-body {
      padding: 20px;
    }
    .btn-custom {
      background-color: #c47a52;
      border-color: #c47a52;
      color: #fff;
      padding: 10px 20px;
      border-radius: 4px;
      transition: background-color 0.3s;
    }
    .btn-custom:hover {
      background-color: #a66243;
      border-color: #a66243;
    }

    /* ===== ALERTAS ===== */
    .alert {
      margin-top: 15px;
    }
    .btn-azul {
  background-color: #281966 !important; 
  border-color: #281966 !important;
  color: #fff !important;
}
.btn-azul:hover {
  background-color: #1f1452 !important; /* un tono más oscuro, opcional */
  border-color: #1f1452 !important;
  color: #fff !important;
}


    /* ===== RESPONSIVE ===== */
    @media (max-width: 576px) {
      .content-wrapper {
        padding: 10px 0;
      }
      .card-custom .card-body {
        padding: 15px;
      }
      .navbar-cooperoble {
        padding: 0.75rem 1rem;
      }
      .navbar-cooperoble .navbar-brand {
        font-size: 0.9rem;
      }
      .form-container {
        margin: 0 10px;
      }
      .card-custom .card-header h5 {
        font-size: 1rem;
      }
    }
  </style>
</head>
<body>
  <form id="formAsignarReporte" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="upAsignarReporte" runat="server" UpdateMode="Conditional">
      <ContentTemplate>
        <div class="page-wrapper">
          <!-- NAVBAR SUPERIOR -->
          <nav class="navbar navbar-cooperoble navbar-dark d-flex align-items-center">
            <!-- IZQUIERDA: Botón hamburguesa -->
            <div class="d-flex align-items-center">
              <button type="button" class="hamburger-btn me-3" data-bs-toggle="offcanvas" data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
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

          <!-- SIDEBAR OFFCANVAS -->
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
                <a href="MantenimientoPreventivo.aspx" class="nav-link">Mantenimiento Preventivo</a>
                <a href="dekra.aspx" class="nav-link">Mantenimiento Dekra</a>
                <asp:LinkButton ID="lnkLogoutSidebar" runat="server" CssClass="nav-link text-start" OnClick="lnkLogout_Click">
                  Cerrar Sesión
                </asp:LinkButton>
              </nav>
            </div>
          </div>

          <!-- CONTENIDO PRINCIPAL -->
          <div class="content-wrapper container">
            <!-- Panel de alertas (solo éxito en verde, igual que en Dekra) -->
            <asp:Panel ID="alertSuccess" runat="server" CssClass="alert alert-success text-center" Visible="False" role="alert">
              <asp:Label ID="lblMensajeExito" runat="server" />
            </asp:Panel>
            <asp:Panel ID="alertError" runat="server" CssClass="alert alert-danger text-center" Visible="False" role="alert">
              <asp:Label ID="lblMensajeError" runat="server" />
            </asp:Panel>

            <hr />

            <!-- Card para Asignar Reporte -->
            <div class="card card-custom form-container">
              <div class="card-header">
                <h5>Asignar un reporte a un mecánico</h5>
              </div>
              <div class="card-body">
                <div class="row row-cols-1 row-cols-md-2 g-3 mb-3">
                  <div class="col">
                    <label for="ddlMecanicos" class="form-label">Mecánico</label>
                    <asp:DropDownList ID="ddlMecanicos" runat="server" CssClass="form-select">
                      <asp:ListItem Value="" Text="Seleccione un mecánico" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                  </div>
                  <div class="col">
                    <label for="ddlReportes" class="form-label">Reporte Pendiente</label>
                    <asp:DropDownList ID="ddlReportes" runat="server" CssClass="form-select">
                      <asp:ListItem Value="" Text="Seleccione un reporte" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                  </div>
                </div>
                <asp:Button ID="btnAsignar" runat="server" Text="Asignar Reporte" CssClass="btn btn-custom" OnClick="btnAsignar_Click" />
              </div>
            </div>

            <!-- Card con GridView de Asignaciones -->
            <div class="card card-custom form-container">
              <div class="card-header">
                <h5>Reportes en Proceso</h5>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <asp:GridView ID="gvAsignaciones" runat="server" CssClass="table table-bordered table-striped mb-0"
                                AutoGenerateColumns="False" OnRowCommand="gvAsignaciones_RowCommand">
                    <Columns>
                      <asp:BoundField DataField="id_reporte" HeaderText="ID Reporte" />
                      <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                      <asp:BoundField DataField="mecanico" HeaderText="Mecánico Asignado" />
                      <asp:BoundField DataField="estado" HeaderText="Estado" />
                      <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                          <div class="d-flex">
                            <asp:LinkButton ID="lnkEditarAsignacion" runat="server"
                            CommandName="EditarAsignacion"
                            CommandArgument='<%# Eval("id_reporte") %>'
                            CssClass="btn btn-azul btn-sm">
                            <i class="bi bi-pencil-square"></i> Editar
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
          <div class="footer-area">
            <div class="container">
              <p class="mb-0">© CoopeRoble 2025. Todos los derechos reservados.</p>
            </div>
          </div>
        </div>
      </ContentTemplate>
      <Triggers>
        <asp:PostBackTrigger ControlID="btnGuardarAsignacion" />
      </Triggers>
    </asp:UpdatePanel>

    <!-- Modal para Editar Asignación (Reasignar Mecánico) -->
    <div class="modal fade" id="modalEditarAsignacion" tabindex="-1" aria-labelledby="modalEditarAsignacionLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalEditarAsignacionLabel">Editar Asignación</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label for="ddlNuevoMecanico" class="form-label">Nuevo Mecánico</label>
              <asp:DropDownList ID="ddlNuevoMecanico" runat="server" CssClass="form-select">
                <asp:ListItem Value="" Text="Seleccione un mecánico" Selected="True"></asp:ListItem>
              </asp:DropDownList>
            </div>
            <div class="mb-3">
              <label for="txtMotivo" class="form-label">Motivo del cambio (opcional)</label>
              <asp:TextBox ID="txtMotivo" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
          </div>
          <div class="modal-footer">
            <asp:Button ID="btnGuardarAsignacion" runat="server" CssClass="btn btn-azul" Text="Guardar Cambios" OnClick="btnGuardarAsignacion_Click" />
            <button type="button" class="btn btn-azul" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Scripts JS -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para abrir el modal de editar asignación
        function abrirModalEditarAsignacion() {
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarAsignacion'));
            myModal.show();
        }
    </script>
  </form>
</body>
</html>
