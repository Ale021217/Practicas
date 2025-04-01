<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Seguimiento.aspx.vb" Inherits="CoopeRoble.Seguimiento" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Seguimiento de Reparación - CoopeRoble</title>
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <!-- CSS propio -->
  <link rel="stylesheet" href="assets/css/style.css" />

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
      padding: 20px 0;
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
    /* Contenedor principal del formulario */
    .seguimiento-container {
      max-width: 500px;
      margin: 2rem auto;
      background: #fff;
      border-radius: 6px;
      box-shadow: 0 0 5px rgba(0,0,0,0.1);
      padding: 1.5rem;
    }
    .seguimiento-container h3 {
      margin-bottom: 1.5rem;
      font-weight: bold;
      color: #281966;
      text-align: center;
    }
    /* Botones */
    .btn-azul {
      background-color: #281966;
      border-color: #007bff !important;
      color: #fff !important;
      padding: 10px 15px;
      border-radius: 4px;
      text-decoration: none;
      margin-right: 5px;
      display: inline-block;
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
    /* Vista previa de fotos */
    #fotosPreview {
      margin-top: 10px;
      display: flex;
      flex-wrap: wrap;
      gap: 5px;
    }
    #fotosPreview div {
      position: relative;
      display: inline-block;
      margin-right: 5px;
      margin-bottom: 5px;
    }
    #fotosPreview img {
      width: 80px;
      height: auto;
      display: block;
    }
    #fotosPreview span {
      position: absolute;
      top: 0;
      right: 0;
      background: rgba(0, 0, 0, 0.5);
      color: #fff;
      cursor: pointer;
      padding: 2px 5px;
      font-weight: bold;
    }
    /* Spinner overlay */
    #spinnerOverlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(255,255,255,0.7);
      z-index: 1050;
      display: none;
      align-items: center;
      justify-content: center;
    }
    /* Ajustes extra para pantallas pequeñas */
    @media (max-width: 576px) {
      .seguimiento-container {
        margin: 1rem auto;
        padding: 1rem;
      }
      #fotosPreview img {
        width: 60px;
      }
    }
  </style>

  <!-- Librería de compresión en cliente -->
  <script src="https://unpkg.com/browser-image-compression/dist/browser-image-compression.js"></script>
  
  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
  <script>
      // Validar descripción del seguimiento (mínimo 100 caracteres)
      function ValidateDescripcionSeguimiento(sender, args) {
          args.IsValid = args.Value.trim().length >= 100;
      }

      // Array global para almacenar las fotos (ya comprimidas)
      let fotos = [];
      const maxFotos = 4;

      // Función asíncrona para procesar y comprimir archivos en el cliente
      async function procesarArchivos(files) {
          // Calcular cuántas imágenes aún se pueden agregar
          let disponibles = maxFotos - fotos.length;
          if (files.length > disponibles) {
              alert("Solo se permiten " + maxFotos + " fotos en total. Se omitirán las adicionales.");
          }
          for (let i = 0; i < files.length && i < disponibles; i++) {
              let file = files[i];

              // Validar que sea imagen
              if (!file.type.startsWith("image/")) {
                  alert("Solo se permiten imágenes.");
                  continue;
              }
              // Configuración de compresión: Ajusta estos valores para obtener el peso deseado
              const options = {
                  maxSizeMB: 0.1,         // Objetivo: ~100 KB (ajusta según necesites)
                  maxWidthOrHeight: 400,  // Redimensionar a 400 píxeles
                  useWebWorker: true
              };
              try {
                  file = await imageCompression(file, options);
              } catch (err) {
                  console.error("Error al comprimir:", err);
                  continue;
              }
              const reader = new FileReader();
              reader.onload = function (e) {
                  fotos.push(e.target.result);
                  renderFotosPreview();
              };
              reader.readAsDataURL(file);
          }
      }

      // Función para renderizar la vista previa de las imágenes
      function renderFotosPreview() {
          const previewDiv = document.getElementById("fotosPreview");
          previewDiv.innerHTML = "";
          fotos.forEach((dataURL, index) => {
              const container = document.createElement("div");
              const img = document.createElement("img");
              img.src = dataURL;
              const closeBtn = document.createElement("span");
              closeBtn.innerHTML = "&times;";
              closeBtn.onclick = function () {
                  fotos.splice(index, 1);
                  renderFotosPreview();
              };
              container.appendChild(img);
              container.appendChild(closeBtn);
              previewDiv.appendChild(container);
          });
      }

      // Asignar evento al input file de galería
      document.addEventListener("DOMContentLoaded", function () {
          const fileGallery = document.getElementById("fileGallerySeguimiento");
          if (fileGallery) {
              fileGallery.addEventListener("change", function () {
                  // Validar que solo se suban imágenes
                  for (let i = 0; i < this.files.length; i++) {
                      if (!this.files[i].type.startsWith("image/")) {
                          alert("Solo se permiten imágenes.");
                          this.value = "";
                          return;
                      }
                  }
                  procesarArchivos(this.files);
              });
          }
      });

      // Antes de enviar el formulario, asigna el array 'fotos' al HiddenField y muestra el spinner
      function prepararEnvio() {
          document.getElementById("<%= hfImagenesSeguimiento.ClientID %>").value = JSON.stringify(fotos);
          document.getElementById("spinnerOverlay").style.display = "flex";
      }
  </script>
</head>
<body>
  <form id="formSeguimiento" runat="server" onsubmit="prepararEnvio();">
    <!-- HiddenField para almacenar las imágenes comprimidas -->
    <asp:HiddenField ID="hfImagenesSeguimiento" runat="server" />
    <div class="page-wrapper">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-cooperoble navbar-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">Bienvenido, <%: Session("nombre") %></a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSeguimiento" aria-controls="navbarSeguimiento" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarSeguimiento">
            <ul class="navbar-nav ms-auto">
              <li class="nav-item me-3">
                <a class="btn btn-azul" href="Mecanico.aspx">Mis Reportes</a>
              </li>
              <li class="nav-item">
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="btn btn-azul" CausesValidation="False" OnClick="lnkLogout_Click">
                  Cerrar Sesión
                </asp:LinkButton>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <!-- Contenido Principal -->
      <div class="content-wrapper">
        <div class="seguimiento-container">
          <h3>Seguimiento de Reparación</h3>
          
          <!-- Hidden para id_reporte y para imágenes -->
          <asp:HiddenField ID="hfIdReporte" runat="server" />
          <asp:HiddenField ID="HiddenField1" runat="server" />
          
          <!-- Descripción del Seguimiento -->
          <div class="mb-3">
            <label for="txtDescripcionSeguimiento" class="form-label">
              Descripción del Seguimiento <span class="text-danger">*</span>
            </label>
            <asp:TextBox 
              ID="txtDescripcionSeguimiento" 
              runat="server" 
              CssClass="form-control" 
              TextMode="MultiLine" 
              Rows="4">
            </asp:TextBox>
            <asp:RequiredFieldValidator 
              ID="rfvDescripcionSeguimiento" 
              runat="server"
              ControlToValidate="txtDescripcionSeguimiento"
              ErrorMessage="La descripción es obligatoria."
              Display="Dynamic"
              CssClass="text-danger" />
            <asp:CustomValidator 
              ID="cvDescripcionSeguimiento" 
              runat="server"
              ControlToValidate="txtDescripcionSeguimiento"
              ErrorMessage="La descripción debe tener mínimo 100 caracteres."
              ClientValidationFunction="ValidateDescripcionSeguimiento"
              Display="Dynamic"
              CssClass="text-danger" />
          </div>
          
          <!-- Sección para Fotos -->
          <div class="mb-3">
            <label class="form-label">Fotos (Opcional)</label>
            <div class="d-flex flex-wrap gap-2 mb-2">
              <button type="button" class="btn btn-naranja btn-sm" onclick="document.getElementById('fileGallerySeguimiento').click();">
                Adjuntar Foto
              </button>
            </div>
            <input type="file" id="fileGallerySeguimiento" accept="image/*" style="display:none;" multiple />
            <div id="fotosPreview" class="mt-2 d-flex flex-wrap"></div>
          </div>
          
          <!-- Botones Guardar / Cancelar -->
          <div class="row g-2">
            <div class="col-12 col-md-6 d-grid">
              <asp:Button 
                ID="btnGuardarSeguimiento" 
                runat="server" 
                CssClass="btn btn-naranja btn-sm" 
                Text="Guardar Seguimiento" 
                OnClick="btnGuardarSeguimiento_Click" />
            </div>
            <div class="col-12 col-md-6 d-grid">
              <asp:Button 
                ID="btnCancelar" 
                runat="server" 
                CssClass="btn btn-naranja btn-sm" 
                Text="Cancelar" 
                PostBackUrl="Mecanico.aspx" 
                CausesValidation="False" />
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
    
    <!-- Spinner Overlay -->
    <div id="spinnerOverlay">
      <div class="spinner-border text-dark" role="status">
        <span class="sr-only"></span>
      </div>
    </div>
  </form>
</body>
</html>
