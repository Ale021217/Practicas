<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="DashboardChofer.aspx.vb" Inherits="CoopeRoble.CoopeRoble.DashboardChofer" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard Chofer - CoopeRoble</title>
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <!-- CSS adicional de la plantilla -->
  <link rel="stylesheet" href="assets/css/style.css" />

  <style>
    /* Estructura para sticky footer */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
    }
    .page-wrapper {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
    .content-wrapper {
      flex: 1 0 auto;
      padding-bottom: 20px;
    }
    .footer-cooperoble {
      flex-shrink: 0;
      background-color: #281966;
      color: #fff;
      text-align: center;
      padding: 10px 0;
    }

    /* Navbar Responsive */
    .navbar-cooperoble {
      background-color: #281966;
    }
    .navbar-cooperoble .navbar-brand,
    .navbar-cooperoble .nav-link {
      color: #fff !important;
    }
    .navbar-cooperoble .nav-link:hover {
      color: #ddd !important;
    }
 
    .icon-setting {
      width: 20px;
      margin-right: 5px;
    }

    /* Cards de Reportes */
    .card-report {
      margin-bottom: 20px;
      border: 1px solid #ddd;
      border-radius: 6px;
      box-shadow: 0 0 5px rgba(0,0,0,0.1);
    }
    .card-report .card-body {
      padding: 15px;
    }
    .card-report-title {
      font-size: 1rem;
      font-weight: bold;
      color: #281966;
      margin-bottom: 8px;
    }
    .card-report-subtitle {
      color: #666;
      margin-bottom: 10px;
    }
    .card-report-text {
      font-size: 0.9rem;
      margin-bottom: 6px;
    }
    /* Muestra el estado en el card */
    .card-report-state {
      font-size: 0.9rem;
      margin-bottom: 6px;
      color: #333;
    }
    .btn-detalle {
      background-color: #a66243;
      color: #ffffff;
      margin-top: 10px;
    }
  </style>
</head>
<body>
  <form id="formDashboardChofer" runat="server">
    <div class="page-wrapper">
      <!-- Navbar Superior -->
      <nav class="navbar navbar-expand-lg navbar-cooperoble navbar-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">
            Bienvenido, <%: Session("nombre") %>
          </a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarChofer"
                  aria-controls="navbarChofer" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarChofer">
            <ul class="navbar-nav ms-auto">
              <li class="nav-item me-3">
                <asp:LinkButton ID="lnkNuevoReporte" runat="server" CssClass="nav-link" OnClick="lnkNuevoReporte_Click">
                  Crear Nuevo Reporte
                </asp:LinkButton>
              </li>
              <!-- Único enlace para Cerrar Sesión -->
              <li class="nav-item">
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="nav-link" OnClick="lnkLogout_Click">
                  Cerrar Sesión
                </asp:LinkButton>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <!-- Contenido principal -->
      <div class="content-wrapper container mt-4">
        <h4 class="mb-3">Mis Reportes</h4>
        <asp:Repeater ID="rptReportes" runat="server">
          <HeaderTemplate>
            <div class="row">
          </HeaderTemplate>
          <ItemTemplate>
            <div class="col-12 col-md-6 col-lg-4">
              <div class="card-report">
                <div class="card-body">
            
                  <div class="card-report-title">
                    Reporte #<%# Eval("id_reporte") %>
                  </div>
                  <div class="card-report-subtitle">
                    Fecha: <%# Eval("fecha_reporte", "{0:dd/MM/yyyy HH:mm}") %>
                  </div>
                  <div class="card-report-text">
                    <strong>Unidad:</strong> <%# Eval("Unidad") %>
                  </div>
                  <!-- Estado en el card -->
                  <div class="card-report-state">
                    <strong>Estado:</strong> <%# Eval("estado") %>
                  </div>

                  <!-- Datos adicionales ocultos: descripción, estado e imagen (JSON) -->
                  <div class="d-none datos-reporte" 
                       data-descripcion='<%# Eval("descripcion") %>' 
                       data-estado='<%# Eval("estado") %>'
                       data-imagen='<%# Eval("imagen_averia") %>'>
                  </div>
                  
                  <!-- Botón "Ver Detalle" -->
                  <asp:LinkButton 
                    ID="lnkVerDetalle" 
                    runat="server" 
                    CssClass="btn btn-info btn-sm btn-detalle"
                    OnClientClick='<%# "mostrarDetalleModal(this, &apos;" & Eval("id_reporte") &
                          "&apos;, &apos;" & Eval("fecha_reporte", "{0:dd/MM/yyyy HH:mm}") & "&apos;, &apos;" & Eval("Unidad") &
                          "&apos;, &apos;" & Eval("estado") & "&apos;); return false;" %>'>
                    Ver Detalle
                  </asp:LinkButton>
                </div>
              </div>
            </div>
          </ItemTemplate>
          <FooterTemplate>
            </div>
          </FooterTemplate>
        </asp:Repeater>
      </div>

      <!-- Footer -->
      <div class="footer-cooperoble">
        <p>&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
      </div>
    </div>
  </form>

  <!-- Modal para ver detalle -->
  <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="detalleModalLabel">Detalle del Reporte</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <p><strong>ID Reporte:</strong> <span id="modalId"></span></p>
          <p><strong>Fecha:</strong> <span id="modalFecha"></span></p>
          <p><strong>Unidad:</strong> <span id="modalUnidad"></span></p>
          <!-- Descripción con saltos de línea preservados -->
          <p>
            <strong>Descripción:</strong>
            <span id="modalDescripcion" style="white-space: pre-wrap; word-wrap: break-word;"></span>
          </p>
          <p><strong>Estado:</strong> <span id="modalEstado"></span></p>
          <!-- Contenedor para mostrar las imágenes -->
          <div id="modalImagenes" style="margin-top:15px;"></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Scripts JS -->
  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
  <script>
      // Función para mostrar la modal con el detalle del reporte, incluyendo imágenes y estado
      function mostrarDetalleModal(btn, idReporte, fecha, unidad, estado) {
          var cardBody = btn.closest('.card-body');
          var datos = cardBody.querySelector('.datos-reporte');

          // Tomar la descripción del data-descripcion
          var descripcion = datos.getAttribute("data-descripcion");

          // Asignar valores al modal
          document.getElementById("modalId").textContent = idReporte;
          document.getElementById("modalFecha").textContent = fecha;
          document.getElementById("modalUnidad").textContent = unidad;
          document.getElementById("modalDescripcion").textContent = descripcion;
          document.getElementById("modalEstado").textContent = estado;

          // Mostrar imágenes
          var modalImagenes = document.getElementById("modalImagenes");
          modalImagenes.innerHTML = "";
          var imagenJson = datos.getAttribute("data-imagen");
          if (imagenJson) {
              try {
                  var imagenes = JSON.parse(imagenJson);
                  if (Array.isArray(imagenes)) {
                      imagenes.forEach(function (url) {
                          url = url.replace("~", "");
                          var img = document.createElement("img");
                          img.src = url;
                          img.style.width = "100%";
                          img.style.maxWidth = "300px";
                          img.style.marginBottom = "10px";
                          modalImagenes.appendChild(img);
                      });
                  }
              } catch (ex) {
                  console.error("Error al parsear el JSON de imágenes:", ex);
              }
          }

          var modal = new bootstrap.Modal(document.getElementById("detalleModal"));
          modal.show();
      }
  </script>
</body>
</html>
