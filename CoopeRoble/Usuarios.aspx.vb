Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class Usuarios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté logueado y que su rol sea "administrador"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then

            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If


        If Not IsPostBack Then
            CargarUsuarios()
        End If
    End Sub


    Private Sub CargarUsuarios()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT id_usuario, nombre, cedula, rol, estado, fecha FROM Usuarios"
            Using cmd As New SqlCommand(sql, con)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        gvUsuarios.DataSource = dt
        gvUsuarios.DataBind()
    End Sub

    Protected Sub gvUsuarios_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvUsuarios.RowCommand
        If e.CommandName = "Editar" Then
            Dim idUsuario As Integer = Convert.ToInt32(e.CommandArgument)
            CargarDatosUsuario(idUsuario)
        End If
    End Sub

    Private Sub CargarDatosUsuario(idUsuario As Integer)
        Try
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Using con As New SqlConnection(conStr)
                con.Open()
                Dim sql As String = "SELECT id_usuario, nombre, cedula, rol, estado FROM Usuarios WHERE id_usuario = @id"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@id", idUsuario)
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            hfIdUsuario.Value = reader("id_usuario").ToString()
                            txtNombre.Text = reader("nombre").ToString()
                            txtCedula.Text = reader("cedula").ToString()
                            ddlRol.SelectedValue = reader("rol").ToString()
                            ddlEstado.SelectedValue = reader("estado").ToString()
                        End If
                    End Using
                End Using
            End Using

            ' Resetear el panel de cambio de contraseña
            pnlChangePassword.Visible = True
            chkChangePassword.Checked = False
            txtPassword.Enabled = False
            txtConfirmPassword.Enabled = False
            txtPassword.Text = ""
            txtConfirmPassword.Text = ""

            ' La cédula no se debe modificar
            txtCedula.ReadOnly = True

            ' Mostrar el modal de edición
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalUsuario",
                "setTimeout(function(){ var myModal = new bootstrap.Modal(document.getElementById('modalUsuario')); myModal.show(); }, 100);", True)
        Catch ex As Exception
            alertError.Visible = True
            lblError.Text = "Error al cargar datos: " & ex.Message
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            alertError.Visible = False
            alertSuccess.Visible = False

            Dim idUsuario As Integer = Convert.ToInt32(hfIdUsuario.Value)

            ' Validar que la cédula no se haya modificado
            Dim cedulaBD As String = ObtenerCedulaDesdeBD(idUsuario)
            If txtCedula.Text.Trim() <> cedulaBD Then
                Throw New Exception("No se permite modificar la cédula del usuario.")
            End If

            ' Detectar si hubo cambios en nombre, rol, estado o contraseña
            Dim oldData = ObtenerDatosUsuarioBD(idUsuario)
            Dim cambioReal As Boolean = False

            If txtNombre.Text.Trim() <> oldData.nombre.Trim() Then
                cambioReal = True
            End If
            If ddlRol.SelectedValue <> oldData.rol Then
                cambioReal = True
            End If
            If Convert.ToBoolean(ddlEstado.SelectedValue) <> oldData.estado Then
                cambioReal = True
            End If

            Dim changePassword As Boolean = chkChangePassword.Checked
            If changePassword Then
                cambioReal = True
            End If

            If Not cambioReal Then
                Throw New Exception("No se realizaron cambios en el usuario.")
            End If

            ' Validar contraseña solo si se va a cambiar
            If changePassword Then
                If String.IsNullOrEmpty(txtPassword.Text.Trim()) OrElse txtPassword.Text.Trim().Length < 8 Then
                    Throw New Exception("La contraseña es obligatoria y debe tener mínimo 8 caracteres.")
                End If
                If txtPassword.Text.Trim() <> txtConfirmPassword.Text.Trim() Then
                    Throw New Exception("Las contraseñas no coinciden.")
                End If
            End If

            ' Actualizar usuario según corresponda
            If changePassword Then
                ActualizarUsuarioConPass(idUsuario)
            Else
                ActualizarUsuarioSinPass(idUsuario)
            End If

            alertSuccess.Visible = True
            lblSuccess.Text = "Datos guardados correctamente."
            CargarUsuarios()

        Catch ex As Exception
            alertError.Visible = True
            lblError.Text = ex.Message
            alertSuccess.Visible = False
            ' Reabrir el modal de edición en caso de error
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalUsuario",
                "setTimeout(function(){ var myModal = new bootstrap.Modal(document.getElementById('modalUsuario')); myModal.show(); }, 100);", True)
        End Try
    End Sub

    Private Sub ActualizarUsuarioConPass(idUsuario As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "UPDATE Usuarios SET nombre=@nombre, rol=@rol, estado=@estado, contraseña=@pass WHERE id_usuario=@id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@nombre", txtNombre.Text.Trim())
                cmd.Parameters.AddWithValue("@rol", ddlRol.SelectedValue)
                cmd.Parameters.AddWithValue("@estado", Convert.ToBoolean(ddlEstado.SelectedValue))
                cmd.Parameters.AddWithValue("@pass", HashPasswordSHA256(txtPassword.Text.Trim()))
                cmd.Parameters.AddWithValue("@id", idUsuario)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub ActualizarUsuarioSinPass(idUsuario As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "UPDATE Usuarios SET nombre=@nombre, rol=@rol, estado=@estado WHERE id_usuario=@id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@nombre", txtNombre.Text.Trim())
                cmd.Parameters.AddWithValue("@rol", ddlRol.SelectedValue)
                cmd.Parameters.AddWithValue("@estado", Convert.ToBoolean(ddlEstado.SelectedValue))
                cmd.Parameters.AddWithValue("@id", idUsuario)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Function ObtenerCedulaDesdeBD(idUsuario As Integer) As String
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT cedula FROM Usuarios WHERE id_usuario=@id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id", idUsuario)
                Dim result As Object = cmd.ExecuteScalar()
                If result IsNot Nothing Then
                    Return result.ToString()
                End If
            End Using
        End Using
        Return ""
    End Function

    Private Function ObtenerDatosUsuarioBD(idUsuario As Integer) As (nombre As String, rol As String, estado As Boolean)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim datos = ("", "", True)
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT nombre, rol, estado FROM Usuarios WHERE id_usuario=@id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id", idUsuario)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        datos = (
                            reader("nombre").ToString(),
                            reader("rol").ToString(),
                            Convert.ToBoolean(reader("estado"))
                        )
                    End If
                End Using
            End Using
        End Using
        Return datos
    End Function

    ' Función de hash para la contraseña
    Private Function HashPasswordSHA256(ByVal password As String) As String
        If String.IsNullOrEmpty(password) Then Return ""
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes() As Byte = Encoding.UTF8.GetBytes(password)
            Dim hash() As Byte = sha256.ComputeHash(bytes)
            Dim sb As New StringBuilder()
            For Each b As Byte In hash
                sb.Append(b.ToString("x2"))
            Next
            Return sb.ToString()
        End Using
    End Function

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    ' Método para crear un nuevo usuario
    Protected Sub btnCrearUsuario_Click(sender As Object, e As EventArgs)
        Try
            alertError.Visible = False
            alertSuccess.Visible = False
            lblCedulaError.Text = ""
            lblCedulaError.Visible = False

            ' Validaciones básicas para el nuevo usuario
            Dim nombre As String = txtNuevoNombre.Text.Trim()
            Dim cedula As String = txtNuevoCedula.Text.Trim()
            Dim rol As String = ddlNuevoRol.SelectedValue
            Dim estado As Boolean = Convert.ToBoolean(ddlNuevoEstado.SelectedValue)
            Dim pass As String = txtNuevoPassword.Text.Trim()
            Dim confirm As String = txtNuevoConfirmPassword.Text.Trim()

            If String.IsNullOrEmpty(nombre) OrElse String.IsNullOrEmpty(cedula) Then
                Throw New Exception("El nombre y la cédula son obligatorios.")
            End If
            If rol = "" Then
                Throw New Exception("Debe seleccionar un rol.")
            End If
            If pass.Length < 8 Then
                Throw New Exception("La contraseña debe tener al menos 8 caracteres.")
            End If
            If pass <> confirm Then
                Throw New Exception("Las contraseñas no coinciden.")
            End If

            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Using con As New SqlConnection(conStr)
                con.Open()

                Dim sqlCheck As String = "SELECT COUNT(*) FROM Usuarios WHERE UPPER(LTRIM(RTRIM(cedula))) = UPPER(@cedula)"
                Using cmdCheck As New SqlCommand(sqlCheck, con)
                    cmdCheck.Parameters.AddWithValue("@cedula", cedula)
                    Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())
                    If count > 0 Then
                        lblCedulaError.Text = "La cédula ya se encuentra registrada."
                        lblCedulaError.Visible = True
                        ' Reabrir el modal para que se vea el error
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalNuevoUsuario",
                        "setTimeout(function(){ var myModal = new bootstrap.Modal(document.getElementById('modalNuevoUsuario')); myModal.show(); }, 100);", True)
                        Return
                    End If
                End Using

                ' Insertar el nuevo usuario en la BD
                Dim sql As String = "INSERT INTO Usuarios (nombre, cedula, rol, estado, fecha, contraseña) " &
                                "VALUES(@nombre, @cedula, @rol, @estado, GETDATE(), @pass)"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@nombre", nombre)
                    cmd.Parameters.AddWithValue("@cedula", cedula)
                    cmd.Parameters.AddWithValue("@rol", rol)
                    cmd.Parameters.AddWithValue("@estado", estado)
                    cmd.Parameters.AddWithValue("@pass", HashPasswordSHA256(pass))
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            alertSuccess.Visible = True
            lblSuccess.Text = "Usuario creado correctamente."
            CargarUsuarios()

        Catch ex As Exception
            alertError.Visible = True
            lblError.Text = ex.Message
            alertSuccess.Visible = False
            ' Reabrir el modal de nuevo usuario en caso de error
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalNuevoUsuario",
            "setTimeout(function(){ var myModal = new bootstrap.Modal(document.getElementById('modalNuevoUsuario')); myModal.show(); }, 100);", True)
        End Try
    End Sub


End Class
