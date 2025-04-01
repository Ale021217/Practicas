<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="ReparacionTerminada.aspx.vb" Inherits="CoopeRoble.ReparacionTerminada" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Reparaciones Terminadas - CoopeRoble</title>
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <!-- CSS propio -->
  <link rel="stylesheet" href="assets/css/style.css" />
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  <style>
    /* Estructura para sticky footer */
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
    
    /* Navbar */
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
    
    /* Botones y estilos de tarjetas */
    .default-btn {
      padding: 10px 15px;
      background-color: #c47a52;
      border: none;
      color: #fff;
      cursor: pointer;
      border-radius: 4px;
      text-decoration: none;
    }
    .default-btn:hover {
      background-color: #a66243;
    }
    .card-report {
      margin-bottom: 20px;
      border: 1px solid #ddd;
      border-radius: 6px;
      box-shadow: 0 0 5px rgba(0,0,0,0.1);
    }
    .card-report .card-body {
      padding: 20px;
    }
    .card-report-title {
      font-size: 1rem;
      font-weight: bold;
      color: #281966;
      margin-bottom: 10px;
    }
    .card-report-text {
      margin-bottom: 0.5rem;
      line-height: 1.4;
    }
    .btn-detalle {
      padding: 10px 15px;
      background-color: #281966;
      color: #fff;
      border: none;
      border-radius: 4px;
      text-decoration: none;
      cursor: pointer;
    }
    .btn-detalle:hover {
      background-color: #1f1452;
    }
    .modal-img {
      width: 100%;
      max-width: 300px;
      margin-bottom: 10px;
    }

    /* Ajustar texto largo en el modal */
    #modalDescripcionReparacion, 
    #modalFallaAdicional {
      white-space: pre-wrap; 
      word-wrap: break-word; 
      overflow-wrap: break-word;
    }
  </style>
</head>
<body class="body-bg-f8faff">
  <form id="formReparacionTerminada" runat="server">
    <div class="page-wrapper">
      
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-cooperoble navbar-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">Bienvenido, <%: Session("nombre") %></a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarReparacionTerminada" aria-controls="navbarReparacionTerminada" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>

          <!-- Se elimina el dropdown y se añaden dos enlaces directos -->
          <div class="collapse navbar-collapse" id="navbarReparacionTerminada">
            <ul class="navbar-nav ms-auto">
              <!-- Botón Mis Reportes -> Mecanico.aspx -->
              <li class="nav-item me-3">
                <a class="nav-link" href="Mecanico.aspx">Mis Reportes</a>
              </li>
              <!-- Botón Cerrar Sesión -->
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
      <div class="content-wrapper container-md px-4 mt-4 mb-4">
        <h3 class="mb-3">Reparaciones Terminadas</h3>
        <p class="mb-4">
          Se muestran los registros de la tabla <strong>Reparaciones</strong> asociados a reportes con <em>estado = "terminado"</em> de los últimos 5 días.
        </p>
        
       
        
        <asp:Repeater ID="rptReportesTerminados" runat="server">
          <HeaderTemplate>
            <div class="row g-4">
          </HeaderTemplate>
          <ItemTemplate>
            <div class="col-12 col-md-6 col-lg-4">
              <div class="card-report">
                <div class="card-body">
                  <div class="card-report-title">
                    Reparación #<%# Eval("id_reparaciones") %>
                  </div>
                  <p class="card-report-text">
                    <strong>ID Reporte:</strong> <%# Eval("id_reporte") %>
                  </p>
                  <p class="card-report-text">
                    <strong>Inicio de reparación:</strong> <%# Eval("fecha_entrada", "{0:dd/MM/yyyy HH:mm}") %>
                  </p>
                  <p class="card-report-text">
                    <strong>Fecha Salida:</strong> <%# Eval("fecha_salida", "{0:dd/MM/yyyy HH:mm}") %>
                  </p>
                  <p class="card-report-text">
                    <strong>Estado del Reporte:</strong> <%# Eval("estado") %>
                  </p>
                  <div class="d-none datos-reporte"
                       data-imagen='<%# If(Eval("imagen_reparacion") Is DBNull.Value, "[]", Eval("imagen_reparacion")) %>'
                       data-estado='<%# Eval("estado") %>'>
                  </div>
                  
                  <div class="mt-3">
                    <asp:LinkButton 
                      ID="lnkVerDetalle" 
                      runat="server" 
                      CssClass="btn-detalle"
                      OnClientClick='<%# String.Format("mostrarDetalleModal(this, ""{0}"", ""{1}"", ""{2}"", ""{3}"", ""{4}"", ""{5}""); return false;",
                                                       Eval("id_reparaciones"),
                                                       Eval("fecha_entrada", "{0:dd/MM/yyyy HH:mm}"),
                                                       Eval("fecha_salida", "{0:dd/MM/yyyy HH:mm}"),
                                                       Eval("descripcion_reparacion"),
                                                       Eval("falla_adicional"),
                                                       Eval("estado")) %>'>
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
      </div>
      
      <!-- Footer -->
      <div class="footer-cooperoble">
        <div class="container">
          <p>&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
        </div>
      </div>
    </div>
  </form>
  
  <!-- Modal para Ver Detalle -->
  <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title" id="detalleModalLabel">Detalle de la Reparación</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body">
          <p><strong>ID Reparación:</strong> <span id="modalIdReparaciones"></span></p>
          <p><strong>Fecha Entrada:</strong> <span id="modalFechaEntrada"></span></p>
          <p><strong>Fecha Salida:</strong> <span id="modalFechaSalida"></span></p>
          <p><strong>Estado del Reporte:</strong> <span id="modalEstado"></span></p>
          
          <!-- Descripción y falla adicional -->
          <p><strong>Descripción Reparación:</strong> 
            <span id="modalDescripcionReparacion"></span>
          </p>
          <p><strong>Falla Adicional:</strong> 
            <span id="modalFallaAdicional"></span>
          </p>

          <!-- Contenedor para imágenes -->
          <div id="modalImagenes" class="mt-3"></div>
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
      function mostrarDetalleModal(link, idReparaciones, fechaEntrada, fechaSalida, descReparacion, fallaAdicional, estado) {
          // Llenar campos del modal
          document.getElementById("modalIdReparaciones").textContent = idReparaciones;
          document.getElementById("modalFechaEntrada").textContent = fechaEntrada;
          document.getElementById("modalFechaSalida").textContent = fechaSalida;
          document.getElementById("modalEstado").textContent = estado;

          // Descripción y falla adicional
          document.getElementById("modalDescripcionReparacion").textContent = descReparacion;
          document.getElementById("modalFallaAdicional").textContent = fallaAdicional;

          // Obtener data-imagen
          var cardBody = link.closest('.card-body');
          var datos = cardBody.querySelector('.datos-reporte');
          var imagenJson = datos.getAttribute('data-imagen');

          var contenedor = document.getElementById("modalImagenes");
          contenedor.innerHTML = "";

          if (imagenJson) {
              try {
                  var imagenes = JSON.parse(imagenJson);
                  if (Array.isArray(imagenes)) {
                      imagenes.forEach(function (url) {
                          url = url.replace("~", "");
                          var img = document.createElement("img");
                          img.src = url;
                          img.classList.add("modal-img");
                          contenedor.appendChild(img);
                      });
                  }
              } catch (ex) {
                  console.error("Error al parsear imagen_reparacion:", ex);
              }
          }

          // Mostrar el modal
          var modal = new bootstrap.Modal(document.getElementById("detalleModal"));
          modal.show();
          return false;
      }
  </script>
</body>
</html>
