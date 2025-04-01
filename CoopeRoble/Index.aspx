<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Index.aspx.vb" Inherits="CoopeRoble.Index" %>
<!DOCTYPE html>
<html lang="es">
<head>

    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/responsive.css" />
    <link rel="stylesheet" href="assets/css/header.css" />
    <link rel="stylesheet" href="assets/css/footer.css" />
    <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
    <title>Reporte de Averías - Admin</title>


    <style>

      html, body {
        margin: 0;
        padding: 0;
        height: 100%;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f8faff; 
      }


      .wrapper {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
      }
    
      .page-content {
        flex: 1;
      }

  
      .preloader {
        position: fixed;
        z-index: 9999;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        background: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .preloader img {
        width: 120px;
        height: auto;
      }

      .header-top {
        background-color: #281966;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 20px;
      }
      /* Botón hamburguesa */
      .hamburger-btn {
        background: none;
        border: none;
        outline: none;
        margin-right: 15px;
      }
      .hamburger-btn .burger-icon {
        width: 30px;
        height: 20px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }
      .hamburger-btn .burger-icon span {
        display: block;
        height: 3px;
        background: #c47a52; /* Naranja */
        border-radius: 2px;
        transition: background 0.3s;
      }
      .hamburger-btn:hover .burger-icon span {
        background: #a66243; /* Más oscuro al hover */
      }

      .header-top .profile-area {
        display: flex;
        align-items: center;
      }
      .header-top .profile-area img {
        border-radius: 50%;
        margin-right: 10px;
        width: 40px;
        height: 40px;
      }
      .header-top .profile-area .user-info h6 {
        margin: 0;
        font-size: 1rem;
        color: #fff;
      }
      .header-top .profile-area .user-info span {
        font-size: 0.8rem;
        color: #fff;
      }

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

      /* ========== CONTENIDO PRINCIPAL ========== */
      .main-content {
        padding: 20px;
      }

      /* ========== TARJETAS DE RESUMEN ========== */
      .summary-card {
        background-color: #fff;
        border: none;
        border-left: 5px solid #c47a52;
        border-radius: 6px;
        box-shadow: 0 0 15px rgba(0,0,0,0.05);
        transition: transform 0.2s;
      }
      .summary-card:hover {
        transform: translateY(-2px);
      }
      .summary-card .card-title {
        color: #281966;
        font-weight: 600;
      }
      .summary-card .card-text {
        font-size: 1.5rem;
        font-weight: bold;
      }

      /* ========== TABLAS ========== */
      .table-striped tbody tr:hover {
        background-color: #f2f2f2;
      }
      .table thead th {
        background-color: #281966;
        color: #fff;
      }

      /* ========== FOOTER ========== */
      .footer-area {
        background-color: #281966;
        color: #fff;
        text-align: center;
        padding: 10px 0;
        margin-top: 20px;
      }
    </style>
</head>

<body>
  <form id="formIndex" runat="server">
    <div class="wrapper">
      <div class="page-content">
        <!-- Preloader (Opcional) -->
        <div class="preloader">
          <img src="assets/images/main-logo.svg" alt="main-logo" />
        </div>

        <!-- Header Superior -->
        <div class="header-top mb-4">
          <div class="d-flex align-items-center">
       
            <button type="button" class="hamburger-btn" data-bs-toggle="offcanvas" data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
              <div class="burger-icon">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </button>
            <h5 class="text-white mb-0">Panel </h5>
          </div>
          <!-- Perfil (sin el botón de Cerrar Sesión) -->
          <div class="profile-area">
            <img src="assets/images/avatar.png" alt="avatar" />
            <div class="user-info">
              <h6 class="mb-0"><%: Session("nombre") %></h6>
              <span>Administrador</span>
            </div>
          </div>
        </div>

        <!-- Offcanvas (Menú lateral) -->
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
              <!-- Botón de Cerrar Sesión en el sidebar -->
              <asp:LinkButton ID="lnkLogout" runat="server" CssClass="nav-link text-start"
                              OnClick="lnkLogout_Click">
                Cerrar Sesión
              </asp:LinkButton>
            </nav>
          </div>
        </div>

        <!-- Contenido principal -->
        <div class="main-content">
          <div class="container-fluid">
            <!-- Tarjetas de Resumen -->
            <div class="row g-3 mb-4">
              <!-- Total Averías -->
              <div class="col-md-3">
                <div class="card summary-card">
                  <div class="card-body text-center">
                    <h5 class="card-title">Total Averías</h5>
                    <p class="card-text">
                      <asp:Label ID="lblTotalAverias" runat="server" Text="0"></asp:Label>
                    </p>
                  </div>
                </div>
              </div>
              <!-- Averías Pendientes -->
              <div class="col-md-3">
                <div class="card summary-card">
                  <div class="card-body text-center">
                    <h5 class="card-title">Averías Pendientes</h5>
                    <p class="card-text">
                      <asp:Label ID="lblPendientes" runat="server" Text="0"></asp:Label>
                    </p>
                  </div>
                </div>
              </div>
              <!-- Averías en Proceso -->
              <div class="col-md-3">
                <div class="card summary-card">
                  <div class="card-body text-center">
                    <h5 class="card-title">Averías en Proceso</h5>
                    <p class="card-text">
                      <asp:Label ID="lblEnProceso" runat="server" Text="0"></asp:Label>
                    </p>
                  </div>
                </div>
              </div>
              <!-- Reportes Terminados -->
              <div class="col-md-3">
                <div class="card summary-card">
                  <div class="card-body text-center">
                    <h5 class="card-title">Reportes Terminados</h5>
                    <p class="card-text">
                      <asp:Label ID="lblReportesTerminados" runat="server" Text="0"></asp:Label>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Sección de Últimos Reportes -->
            <div class="row g-3 mb-4">
              <div class="col-12">
                <div class="card">
                  <div class="card-body">
                    <h5 class="card-title mb-3" style="color: #281966;">Últimos Reportes de Averías</h5>
                    <asp:Repeater ID="rptUltimosReportes" runat="server">
                      <HeaderTemplate>
                        <div class="table-responsive">
                          <table class="table table-striped align-middle">
                            <thead>
                              <tr>
                                <th>ID</th>
                                <th>Descripción</th>
                                <th>Fecha</th>
                                <th>Estado</th>
                              </tr>
                            </thead>
                            <tbody>
                      </HeaderTemplate>
                      <ItemTemplate>
                        <tr>
                          <td><%# Eval("id_reporte") %></td>
                          <td><%# Eval("descripcion") %></td>
                          <td><%# Eval("fecha_reporte", "{0:dd/MM/yyyy}") %></td>
                          <td><%# Eval("estado") %></td>
                        </tr>
                      </ItemTemplate>
                      <FooterTemplate>
                            </tbody>
                          </table>
                        </div>
                      </FooterTemplate>
                    </asp:Repeater>
                  </div>
                </div>
              </div>
            </div>

            <!-- Sección de Averías Más Habituales -->
            <div class="row g-3 mb-4">
              <div class="col-12">
                <div class="card">
                  <div class="card-body">
                    <h5 class="card-title mb-3" style="color: #281966;">Averías Más Habituales</h5>
                    <div class="table-responsive">
                      <table class="table table-striped align-middle">
                        <thead>
                          <tr>
                            <th>Tipo Avería</th>
                            <th>Cantidad</th>
                          </tr>
                        </thead>
                        <tbody>
                          <asp:Repeater ID="rptAveriasHabituales" runat="server">
                            <ItemTemplate>
                              <tr>
                                <td><%# Eval("tipo_averia") %></td>
                                <td><%# Eval("Cantidad") %></td>
                              </tr>
                            </ItemTemplate>
                          </asp:Repeater>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Sección de Unidades con Más Problemas -->
            <div class="row g-3 mb-4">
              <div class="col-12">
                <div class="card">
                  <div class="card-body">
                    <h5 class="card-title mb-3" style="color: #281966;">Unidades con Más Problemas</h5>
                    <div class="table-responsive">
                      <table class="table table-striped align-middle">
                        <thead>
                          <tr>
                            <th>Unidad</th>
                            <th>Estado</th>
                            <th>Cantidad</th>
                          </tr>
                        </thead>
                        <tbody>
                          <asp:Repeater ID="rptUnidadesProblemas" runat="server">
                            <ItemTemplate>
                              <tr>
                                <td><%# Eval("Unidad") %></td>
                                <td><%# Eval("estado") %></td>
                                <td><%# Eval("Cantidad") %></td>
                              </tr>
                            </ItemTemplate>
                          </asp:Repeater>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
     
      </div> 

      <!-- Footer -->
      <div class="footer-area">
        <div class="container-fluid">
          <p class="mb-0">© CoopeRoble 2025. Todos los derechos reservados.</p>
        </div>
      </div>
    </div> 
  </form>


  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
  <!-- Tus demás scripts (owl, apexcharts, etc.) -->
  <script src="assets/js/custom.js"></script>

  <script>
      window.addEventListener('load', function () {
          document.querySelector('.preloader').style.display = 'none';
      });
  </script>
</body>
</html>
