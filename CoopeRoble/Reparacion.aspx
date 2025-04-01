<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Reparacion.aspx.vb" Inherits="CoopeRoble.Reparacion" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Reparación - CoopeRoble</title>
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <!-- CSS propio -->
  <link rel="stylesheet" href="assets/css/style.css" />

  <style>
    /* Ajustes básicos y sticky footer */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      background-color: #f8faff;
      font-family: sans-serif;
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
    /* Tarjeta de formulario */
    .card {
      border: 1px solid #ccc;
      margin-bottom: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      background-color: #fff;
    }
    .card-header {
      background-color: #281966;
      min-height: 60px;
      display: flex;
      align-items: center;
      padding: 0 20px;
      border-radius: 0;
    }
    .card-header h4 {
      margin: 0;
      color: #fff;
      font-weight: 400;
      font-size: 24px;
      font-family: sans-serif;
    }
    .form-container {
      max-width: 600px;
      margin: 30px auto;
      padding: 0 15px;
    }
    /* Botones en color naranja */
    .default-btn {
      padding: 10px 15px;
      background-color: #c47a52;
      border: none;
      color: #fff;
      cursor: pointer;
      border-radius: 4px;
      text-decoration: none;
      margin-right: 5px;
    }
    .default-btn:hover {
      background-color: #a66243;
    }
    /* Vista previa de fotos */
    #fotosPreview {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 10px;
    }
    #fotosPreview div {
      position: relative;
      display: inline-block;
    }
    #fotosPreview img {
      width: 100px;
      height: auto;
      border: 1px solid #ccc;
      display: block;
    }
    #fotosPreview span {
      position: absolute;
      top: 0;
      right: 0;
      background: rgba(0,0,0,0.5);
      color: #fff;
      cursor: pointer;
      padding: 2px 5px;
      font-weight: bold;
    }
    /* Ajuste para el texto en las tarjetas */
    .card-body p {
      white-space: pre-wrap;
      word-wrap: break-word;
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
    /* Ajustes responsive */
    @media (max-width: 576px) {
      .form-container {
        margin: 20px 10px;
      }
      .card-header h4 {
        font-size: 1.2rem;
      }
    }
  </style>

  <!-- Incluir la librería de compresión en cliente -->
  <script src="https://unpkg.com/browser-image-compression/dist/browser-image-compression.js"></script>
  
  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
  <script>
      // Validación de descripción: mínimo 100 caracteres
      function ValidateDescripcion(sender, args) {
          args.IsValid = (args.Value.trim().length >= 100);
      }

      // Array global para almacenar las fotos ya comprimidas
      let fotos = [];
      const maxFotos = 4;

      // Función asíncrona para procesar archivos desde la galería, incluyendo compresión
      async function procesarArchivos(files) {
          let disponibles = maxFotos - fotos.length;
          if (files.length > disponibles) {
              alert("Solo se permiten " + maxFotos + " fotos en total. Se omitirán las adicionales.");
          }
          // Iterar solo sobre los archivos que se pueden agregar
          for (let i = 0; i < files.length && i < disponibles; i++) {
              let file = files[i];

              // Validar que sea imagen
              if (!file.type.startsWith("image/")) {
                  alert("Solo se permiten imágenes, no videos u otros archivos.");
                  continue;
              }
              // Opcional: usar compresión en el cliente (ajusta estos parámetros según sea necesario)
              const options = {
                  maxSizeMB: 0.1,         // Objetivo ~100 KB (ajusta para reducir más o menos)
                  maxWidthOrHeight: 400,  // Redimensionar a 400 píxeles
                  useWebWorker: true
              };
              try {
                  file = await imageCompression(file, options);
              } catch (err) {
                  console.error("Error al comprimir:", err);
                  continue;
              }
              // Convertir el archivo comprimido a base64
              const reader = new FileReader();
              reader.onload = function (e) {
                  fotos.push(e.target.result);
                  renderFotosPreview();
              };
              reader.readAsDataURL(file);
          }
      }

      // Función para renderizar la vista previa de imágenes con opción de eliminar
      function renderFotosPreview() {
          const previewDiv = document.getElementById("fotosPreview");
          previewDiv.innerHTML = "";
          fotos.forEach(function (dataURL, index) {
              const container = document.createElement("div");
              const img = document.createElement("img");
              img.src = dataURL;
              const closeBtn = document.createElement("span");
              closeBtn.innerHTML = "&times;";
              closeBtn.onclick = function () {
                  removePhoto(index);
              };
              container.appendChild(img);
              container.appendChild(closeBtn);
              previewDiv.appendChild(container);
          });
      }

      // Función para eliminar una imagen del array
      function removePhoto(index) {
          fotos.splice(index, 1);
          renderFotosPreview();
      }

      // Asignar evento al input file al cargar el DOM
      document.addEventListener("DOMContentLoaded", function () {
          var fileGallery = document.getElementById("fileGalleryReparacion");
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

          // Control de despliegue para Falla Adicional
          var divFallaAdicional = document.getElementById('<%= divFallaAdicional.ClientID %>');
          var rblFallaAdicional = document.getElementById('<%= rblFallaAdicional.ClientID %>');
          var radios = rblFallaAdicional.querySelectorAll('input[type="radio"]');
          radios.forEach(function(radio) {
              radio.addEventListener('change', function() {
                  if (this.value === "Si" && this.checked) {
                      divFallaAdicional.style.display = "block";
                  } else {
                      divFallaAdicional.style.display = "none";
                  }
              });
          });
          // Mostrar el div si ya estaba seleccionado al cargar la página
          var selected = rblFallaAdicional.querySelector('input[type="radio"]:checked');
          if (selected && selected.value === "Si") {
              divFallaAdicional.style.display = "block";
          } else {
              divFallaAdicional.style.display = "none";
          }
      });

      // Antes de enviar, asignar el array 'fotos' al HiddenField y mostrar el spinner
      function prepararEnvio() {
          document.getElementById("<%= hfImagenesReparacion.ClientID %>").value = JSON.stringify(fotos);
          document.getElementById("spinnerOverlay").style.display = "flex";
      }
  </script>
</head>
<body>
  <form id="formReparacion" runat="server" onsubmit="prepararEnvio()">
    <asp:HiddenField ID="hfImagenesReparacion" runat="server" />
    <asp:HiddenField ID="hfFechaEntrada" runat="server" />
    <asp:HiddenField ID="hfFechaSalida" runat="server" />
    <asp:HiddenField ID="hfIdReporte" runat="server" />

    <div class="page-wrapper">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-cooperoble navbar-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">Bienvenido, <%: Session("nombre") %></a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarReparacion" aria-controls="navbarReparacion" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarReparacion">
            <ul class="navbar-nav ms-auto">
              <li class="nav-item me-3">
                <a class="nav-link" href="Mecanico.aspx">Mis Reportes</a>
              </li>
              <li class="nav-item">
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="nav-link" OnClick="lnkLogout_Click" CausesValidation="False">
                  Cerrar Sesión
                </asp:LinkButton>
              </li>
            </ul>
          </div>
        </div>
      </nav>
      
      <!-- Contenido Principal -->
      <div class="content-wrapper container mt-4">
        <div class="form-container">
          <div class="card shadow-sm">
            <div class="card-header">
              <h4 class="mb-0">Reparación</h4>
            </div>
            <div class="card-body">
              <p>Completa la información de la reparación del reporte.</p>

              <!-- ValidationSummary -->
              <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="text-danger" DisplayMode="BulletList" />

              <!-- Descripción de la reparación -->
              <div class="mb-3">
                <label for="txtDescripcionReparacion" class="form-label">Descripción de la Reparación</label>
                <asp:TextBox ID="txtDescripcionReparacion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server"
                    ControlToValidate="txtDescripcionReparacion"
                    ErrorMessage="La descripción de la reparación es obligatoria."
                    Display="Dynamic" CssClass="text-danger">
                </asp:RequiredFieldValidator>
                <asp:CustomValidator ID="cvDescripcion" runat="server"
                    ControlToValidate="txtDescripcionReparacion"
                    ErrorMessage="La descripción debe tener mínimo 100 caracteres."
                    ClientValidationFunction="ValidateDescripcion"
                    Display="Dynamic" CssClass="text-danger">
                </asp:CustomValidator>
              </div>

              <!-- Sección para Fotos (solo galería) -->
              <div class="mb-3">
                <label class="form-label">Capturar Fotos (Opcional)</label>
                <div class="d-flex flex-wrap gap-2 mb-2">
                  <button type="button" class="default-btn" onclick="document.getElementById('fileGalleryReparacion').click();">
                    Adjuntar Foto
                  </button>
                </div>
                <input type="file" id="fileGalleryReparacion" accept="image/*" style="display:none;" multiple />
                <div id="fotosPreview" class="mt-2"></div>
              </div>

              <!-- Falla Adicional -->
              <div class="mb-3">
                <label class="form-label">¿Hubo falla adicional?</label>
                <asp:RadioButtonList ID="rblFallaAdicional" runat="server" RepeatDirection="Horizontal" CssClass="form-check">
                  <asp:ListItem Value="No" Selected="True">No</asp:ListItem>
                  <asp:ListItem Value="Si">Sí</asp:ListItem>
                </asp:RadioButtonList>
              </div>
              <div class="mb-3" id="divFallaAdicional" runat="server" style="display:none;">
                <label for="txtFallaAdicional" class="form-label">Descripción de la Falla Adicional</label>
                <asp:TextBox ID="txtFallaAdicional" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
              </div>

              <!-- Botones Guardar / Cancelar -->
              <div class="d-flex flex-wrap">
                <asp:Button ID="btnGuardar" runat="server" CssClass="default-btn me-2" Text="Guardar Reparación" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnCancelar" runat="server" CssClass="default-btn" Text="Cancelar" OnClick="btnCancelar_Click" CausesValidation="False" />
              </div>
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
  
  <!-- Scripts principales -->
  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
