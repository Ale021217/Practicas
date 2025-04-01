<%@ Page Language="vb" AutoEventWireup="true" CodeBehind="Averias.aspx.vb" Inherits="CoopeRoble.Averias" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Averías - CoopeRoble</title>
  <link rel="icon" type="image/png" href="assets/images/Coope.jpeg" />
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
  <!-- CSS propio -->
  <link rel="stylesheet" href="assets/css/style.css" />

  <style>
    /* Estructura básica y responsive */
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
      padding: 20px 0;
    }
    .footer-cooperoble {
      flex-shrink: 0;
      background-color: #281966;
      color: #fff;
      text-align: center;
      padding: 10px 0;
    }
    
    /* Navbar (similar al de Unidad, con padding para mayor altura) */
    .navbar-cooperoble {
      background-color: #281966;
      padding: 1rem 2rem; /* Aumenta la altura */
    }
    .navbar-cooperoble .navbar-brand,
    .navbar-cooperoble .nav-link,
    .navbar-cooperoble .dropdown-toggle {
      color: #fff !important;
    }
    .navbar-cooperoble .nav-link:hover {
      color: #ddd !important;
    }

    /* Botón hamburguesa (sidebar) */
    .hamburger-btn {
      background: none;
      border: none;
      outline: none;
      cursor: pointer;
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

    /* Offcanvas (sidebar) igual que en Index */
    .offcanvas {
      background-color: #281966; /* Fondo morado */
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
    
    /* Tarjetas */
    .card {
      border: 1px solid #ccc;
      margin-bottom: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      background-color: #fff;
    }
    .card-header {
      background-color: #281966;
      min-height: 120px;
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
    }
    
    .form-group {
      margin-bottom: 15px;
    }
    .form-label {
      display: block;
      margin-bottom: 5px;
      color: #281966;
    }
    input[type="text"], select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ccc;
    }
    
    /* Botones base y responsive */
    .btn-same-size {
      display: inline-block;
      min-width: 130px;
      padding: 10px 15px;
      text-align: center;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    /* Clase para color naranja #c47a52 */
    .btn-naranja {
      background-color: #c47a52 !important;
      border-color: #c47a52 !important;
      color: #fff !important;
    }
    .btn-naranja:hover {
      background-color: #a66243 !important;
      border-color: #a66243 !important;
      color: #fff !important;
    }
    
    /* Tabla responsive */
    .table-responsive {
      margin-top: 15px;
    }
    .table thead th,
    .table tbody td {
      padding: 1rem !important;
      vertical-align: middle !important;
    }

    @media (max-width: 576px) {
      .form-container {
        margin: 20px 10px; 
      }
      .card-header {
        min-height: auto; 
        padding: 15px;
      }
      .card-header h4 {
        font-size: 1.2rem; 
      }
    }
  </style>
</head>
<body>
  <form id="formAverias" runat="server">
    <div class="page-wrapper">
      <!-- NAVBAR SUPERIOR con flex y sin navbar-toggler a la derecha -->
      <nav class="navbar navbar-cooperoble navbar-dark d-flex align-items-center">
        <!-- IZQUIERDA: Botón hamburguesa + "Inicio" -->
        <div class="d-flex align-items-center">
          <button type="button" class="hamburger-btn me-3" data-bs-toggle="offcanvas" data-bs-target="#offcanvasMenu" aria-controls="offcanvasMenu">
            <div class="burger-icon">
              <span></span>
              <span></span>
              <span></span>
            </div>
          </button>
         
        </div>
        <!-- DERECHA: “Bienvenido, …” + “Cerrar Sesión” -->
        <div class="d-flex align-items-center ms-auto">
          <span class="text-white me-3">Bienvenido, <%: Session("nombre") %></span>
        
        </div>
      </nav>

      <!-- SIDEBAR OFFCANVAS (igual que en Index) -->
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
            <asp:LinkButton ID="lnkLogoutSidebar" runat="server" CssClass="nav-link text-start"
                            OnClick="lnkLogout_Click">
              Cerrar Sesión
            </asp:LinkButton>
          </nav>
        </div>
      </div>

      <!-- CONTENIDO PRINCIPAL -->
      <div class="content-wrapper container">
        <!-- Tarjeta del formulario para agregar Avería -->
        <div class="card form-container">
          <div class="card-header">
            <h4>Administrar Averías</h4>
          </div>
          <div class="card-body">
            <!-- Campo Tipo de Avería -->
            <div class="form-group">
              <label for="txtTipoAveria" class="form-label">Tipo de Avería</label>
              <asp:TextBox ID="txtTipoAveria" runat="server" CssClass="form-control" placeholder="Ingrese el tipo de avería" />
              <asp:RequiredFieldValidator ID="rfvTipoAveria" runat="server" 
                  ControlToValidate="txtTipoAveria" 
                  ErrorMessage="El campo Tipo de Avería es obligatorio." 
                  Display="Dynamic" ForeColor="Red" 
                  ValidationGroup="crearAveria" />
            </div>
            <!-- Dropdown para Estado de Avería -->
            <div class="form-group mt-3">
              <label for="ddlEstado" class="form-label">Estado de Avería</label>
              <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-control">
                <asp:ListItem Value="" Text="Seleccionar..." Selected="True"></asp:ListItem>
                <asp:ListItem Value="leve" Text="Leve"></asp:ListItem>
                <asp:ListItem Value="medio" Text="Medio"></asp:ListItem>
                <asp:ListItem Value="grave" Text="Grave"></asp:ListItem>
              </asp:DropDownList>
              <asp:RequiredFieldValidator ID="rfvEstado" runat="server" 
                  ControlToValidate="ddlEstado" 
                  ErrorMessage="Seleccione un estado." 
                  InitialValue="" Display="Dynamic" ForeColor="Red" 
                  ValidationGroup="crearAveria" />
            </div>
            <div class="form-group mt-3">
              <asp:Button ID="btnCrearAveria" runat="server" 
                  CssClass="btn-same-size btn-naranja me-2" 
                  Text="Agregar Avería" 
                  OnClick="btnCrearAveria_Click" 
                  ValidationGroup="crearAveria" />
              <asp:Button ID="btnCancelar" runat="server" 
                  CssClass="btn-same-size btn-naranja" 
                  Text="Cancelar" PostBackUrl="Index.aspx" />
            </div>
            <div class="alert alert-success mt-3" runat="server" ID="alertSuccess" Visible="False">
              Avería agregada exitosamente.
            </div>
            <div class="alert alert-danger mt-3" runat="server" ID="alertError" Visible="False">
              Ocurrió un error al agregar la avería.
            </div>
          </div>
        </div>
        <!-- Fin del formulario -->

        <!-- Tarjeta para listar Averías Existentes -->
        <div class="card form-container">
          <div class="card-header">
            <h4>Averías Existentes</h4>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <asp:GridView ID="gvAverias" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-striped table-hover table-bordered w-100" 
                            OnRowCommand="gvAverias_RowCommand">
                <Columns>
                  <asp:BoundField DataField="id_averias" HeaderText="ID" />
                  <asp:BoundField DataField="tipo_averia" HeaderText="Tipo de Avería" />
                  <asp:BoundField DataField="estado" HeaderText="Estado" />
                  <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                      <div class="d-flex gap-2">
                        <asp:LinkButton ID="lnkEditar" runat="server" 
                                        CssClass="btn-same-size btn-naranja btn-sm" 
                                        CommandName="EditarAveria" 
                                        CommandArgument='<%# Eval("id_averias") %>'>
                          Editar
                        </asp:LinkButton>
                      </div>
                    </ItemTemplate>
                  </asp:TemplateField>
                </Columns>
              </asp:GridView>
            </div>
          </div>
        </div>
        <!-- Fin de la tarjeta de averías -->
      </div>
      <!-- Fin del Contenido Principal -->

      <!-- Footer -->
      <div class="footer-cooperoble">
        <div class="container">
          <p>&copy; 2025 CoopeRoble. Todos los derechos reservados.</p>
        </div>
      </div>
      <!-- Fin del Footer -->
    </div>

    <!-- Modal para editar Avería -->
    <div class="modal fade" id="modalAveria" tabindex="-1" aria-labelledby="modalAveriaLabel" aria-hidden="true" runat="server">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalAveriaLabel">Editar Avería</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <!-- Hidden field para almacenar el id y el estado original -->
            <asp:HiddenField ID="hfIdAveria" runat="server" />
            <asp:HiddenField ID="hfEstadoOriginal" runat="server" />
            <!-- Campo Tipo de Avería para editar -->
            <div class="form-group">
              <label for="txtEditarAveria" class="form-label">Tipo de Avería</label>
              <asp:TextBox ID="txtEditarAveria" runat="server" CssClass="form-control" />
              <asp:RequiredFieldValidator ID="rfvEditarAveria" runat="server" 
                  ControlToValidate="txtEditarAveria" 
                  ErrorMessage="El campo Tipo de Avería es obligatorio." 
                  Display="Dynamic" ForeColor="Red" 
                  ValidationGroup="editarAveria" />
            </div>
            <!-- Dropdown para editar Estado -->
            <div class="form-group mt-3">
              <label for="ddlEditarEstado" class="form-label">Estado de Avería</label>
              <asp:DropDownList ID="ddlEditarEstado" runat="server" CssClass="form-control">
                <asp:ListItem Value="" Text="Seleccionar..."></asp:ListItem>
                <asp:ListItem Value="leve" Text="Leve"></asp:ListItem>
                <asp:ListItem Value="medio" Text="Medio"></asp:ListItem>
                <asp:ListItem Value="grave" Text="Grave"></asp:ListItem>
              </asp:DropDownList>
              <asp:RequiredFieldValidator ID="rfvEditarEstado" runat="server" 
                  ControlToValidate="ddlEditarEstado" 
                  ErrorMessage="Seleccione un estado." 
                  InitialValue="" Display="Dynamic" ForeColor="Red" 
                  ValidationGroup="editarAveria" />
            </div>
          </div>
          <div class="modal-footer">
            <asp:Button ID="btnActualizarAveria" runat="server" CssClass="btn-same-size btn-naranja" Text="Actualizar"
                        OnClick="btnActualizarAveria_Click" ValidationGroup="editarAveria" />
            <button type="button" class="btn-same-size btn-naranja" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Scripts JS -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para mostrar el modal de editar avería
        function mostrarModalAveria() {
            var modal = new bootstrap.Modal(document.getElementById('modalAveria'), {});
            modal.show();
        }
    </script>
  </form>
</body>
</html>
