<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Reporte.aspx.vb" Inherits="CoopeRoble.Reporte" %>
<!DOCTYPE html>
<html lang="es">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Nuevo Reporte - CoopeRoble</title>
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <!-- CSS propio -->
  <link rel="stylesheet" href="assets/css/style.css" />

  <style>
    /* Reset y layout básico */
    html, body {
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
    .navbar-cooperoble {
      background-color: #281966;
    }
    .navbar-cooperoble .navbar-brand,
    .navbar-cooperoble .nav-link {
      color: #fff !important;
    }
    /* Tarjeta del Formulario */
    .card {
      border: 1px solid #ccc;
      margin-bottom: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      background-color: #fff;
    }
    .card-header {
      background-color: #281966;
      color: #fff;
      padding: 10px;
    }
    .card-header h4 {
      color: #fff !important;
      margin: 0;
    }
    .form-container {
      max-width: 600px;
      margin: 30px auto;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-label {
      display: block;
      margin-bottom: 5px;
      color: #281966;
    }
    input[type="text"], textarea, select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ccc;
    }
    button, .default-btn {
      padding: 10px 15px;
      background-color: #c47a52;
      border: none;
      color: #fff;
      cursor: pointer;
      border-radius: 4px;
      text-decoration: none;
      margin-right: 5px;
    }
    button:hover, .default-btn:hover {
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
      .card-header {
        padding: 15px;
        font-family: Arial;
        font-weight: normal;
      }
      .card-header h4 {
        font-size: 1.2rem;
        color: #fff !important;
        font-weight: Arial;
      }
    }
  </style>

  <!-- Librería de compresión en cliente -->
  <script src="https://unpkg.com/browser-image-compression/dist/browser-image-compression.js"></script>
  
  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
  <script>
      // Validar descripción: mínimo 100 caracteres
      function ValidateDescripcionReporte(sender, args) {
          args.IsValid = args.Value.trim().length >= 100;
      }

      // Array global para almacenar las fotos ya comprimidas
      let fotos = [];
      const maxFotos = 4;

      // Función asíncrona para procesar archivos con compresión en el cliente
      async function procesarArchivos(files) {
          // Calcular cuántas imágenes se pueden agregar
          let disponibles = maxFotos - fotos.length;

          // Si el usuario selecciona más archivos de los que caben, mostrar alerta
          if (files.length > disponibles) {
              alert("Solo se permiten " + maxFotos + " fotos en total.");
          }

          for (let i = 0; i < files.length && i < disponibles; i++) {
              let file = files[i];

              // Validar que el archivo sea de tipo imagen
              if (!file.type.startsWith("image/")) {
                  alert("Solo se permiten imágenes, no videos u otros archivos.");
                  continue;
              }

              // Configuración de compresión
              const options = {
                  maxSizeMB: 0.1,         // Apunta a ~100 KB
                  maxWidthOrHeight: 400,  // Redimensiona a un máximo de 400 píxeles
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

      // Renderiza la vista previa de las fotos con opción para eliminar
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

      document.addEventListener("DOMContentLoaded", function () {
          const fileGallery = document.getElementById("fileGallery");
          if (fileGallery) {
              fileGallery.addEventListener("change", function () {
                  // Validar que solo se suban imágenes
                  for (let i = 0; i < this.files.length; i++) {
                      if (!this.files[i].type.startsWith("image/")) {
                          alert("Solo se permiten imágenes.");
                          this.value = ""; // Limpiar input
                          return;
                      }
                  }
                  procesarArchivos(this.files);
              });
          }
      });

      // Antes de enviar, asigna el array 'fotos' al HiddenField y muestra el spinner
      function prepararEnvio() {
          document.getElementById("<%= hfImagenesAveria.ClientID %>").value = JSON.stringify(fotos);
          document.getElementById("spinnerOverlay").style.display = "flex";
      }
  </script>
</head>
<body>
  <form id="formReporte" runat="server" onsubmit="prepararEnvio();">
    <asp:HiddenField ID="hfImagenesAveria" runat="server" />
    <div class="page-wrapper">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-cooperoble navbar-dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="DashboardChofer.aspx">Bienvenido, <%: Session("nombre") %></a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarChofer" aria-controls="navbarChofer" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarChofer">
            <ul class="navbar-nav ms-auto">
              <li class="nav-item me-3">
                <a class="nav-link" href="DashboardChofer.aspx">Mis Reportes</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <!-- Contenido Principal -->
      <div class="content-wrapper container">
        <div class="form-container">
          <div class="card">
            <div class="card-header">
              <h4 class="mb-0">Nuevo Reporte de Avería</h4>
            </div>
            <div class="card-body">
              <asp:ValidationSummary ID="ValidationSummary1" runat="server" Style="color:red;" />

              <!-- Unidad -->
              <div class="form-group">
                <label for="ddlUnidad" class="form-label">Unidad</label>
                <asp:DropDownList ID="ddlUnidad" runat="server" CssClass="form-control"></asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvUnidad" runat="server" 
                    ControlToValidate="ddlUnidad" InitialValue="" 
                    ErrorMessage="Seleccione una unidad" Style="color:red;" Display="Dynamic">
                </asp:RequiredFieldValidator>
              </div>

              <!-- Tipo de Avería -->
              <div class="form-group">
                <label for="ddlTipoAveria" class="form-label">Tipo de Avería</label>
                <asp:DropDownList ID="ddlTipoAveria" runat="server" CssClass="form-control"></asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTipoAveria" runat="server" 
                    ControlToValidate="ddlTipoAveria" InitialValue="" 
                    ErrorMessage="Seleccione un tipo de avería" Style="color:red;" Display="Dynamic">
                </asp:RequiredFieldValidator>
              </div>
              
              <!-- Sección de Fotos -->
              <div class="form-group">
                <label class="form-label">Fotos (máximo 4, máximo 1MB cada una)</label>
                <div class="d-flex flex-wrap gap-2 mb-2">
                  <button type="button" class="default-btn" onclick="document.getElementById('fileGallery').click();">
                    Adjuntar Foto
                  </button>
                </div>
                <!-- Input para seleccionar imágenes -->
                <input type="file" id="fileGallery" accept="image/*" style="display:none;" multiple />
                <!-- Vista previa -->
                <div id="fotosPreview"></div>
              </div>
              
              <!-- Descripción -->
              <div class="form-group">
                <label for="txtDescripcion" class="form-label">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" 
                             TextMode="MultiLine" Rows="5" 
                             placeholder="Ingrese la descripción de la avería"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" 
                    ControlToValidate="txtDescripcion" 
                    ErrorMessage="La descripción es obligatoria" 
                    Style="color:red;" Display="Dynamic">
                </asp:RequiredFieldValidator>
                <asp:CustomValidator ID="cvDescripcion" runat="server" 
                    ControlToValidate="txtDescripcion"
                    ErrorMessage="La descripción debe tener mínimo 100 caracteres."
                    ClientValidationFunction="ValidateDescripcionReporte"
                    Display="Dynamic" CssClass="text-danger">
                </asp:CustomValidator>
              </div>
              
              <!-- Botones: Enviar y Cancelar -->
              <div class="text-center d-flex justify-content-center mt-3">
                <asp:Button ID="btnEnviar" runat="server" Text="Enviar Reporte" 
                            OnClick="btnEnviar_Click" CssClass="default-btn me-2" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" 
                            PostBackUrl="DashboardChofer.aspx" CssClass="default-btn" 
                            CausesValidation="False" />
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

  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
