Imports System.Data.SqlClient
Imports System.Security.Cryptography

Partial Public Class Signup
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblMensaje.Text = ""
        End If
    End Sub

    Protected Sub btnRegister_Click(sender As Object, e As EventArgs)
        ' 1) Tomar los valores de los campos
        Dim nombre As String = txtNombre.Text.Trim()
        Dim cedula As String = txtCedula.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
        Dim confirmPassword As String = txtConfirmPassword.Text.Trim()
        Dim rol As String = ddlRol.SelectedValue

        ' 2) Validar que los campos no estén vacíos
        If String.IsNullOrEmpty(nombre) OrElse String.IsNullOrEmpty(cedula) OrElse
           String.IsNullOrEmpty(password) OrElse String.IsNullOrEmpty(confirmPassword) Then
            lblMensaje.Text = "Por favor, complete todos los campos."
            Return
        End If

        ' 3) Validar que las contraseñas coincidan
        If Not password.Equals(confirmPassword) Then
            lblMensaje.Text = "Las contraseñas no coinciden."
            Return
        End If

        ' 4) Generar el hash de la contraseña
        Dim passwordHash As String = HashPasswordSHA256(password)

        ' 5) Conexión a la BD y verificación de cédula única
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            ' Verificar que no exista ya un usuario con la misma cédula
            Dim sqlCheck As String = "SELECT COUNT(*) FROM Usuarios WHERE cedula = @cedula"
            Dim cmdCheck As New SqlCommand(sqlCheck, con)
            cmdCheck.Parameters.AddWithValue("@cedula", cedula)

            ' Insertar usuario si no existe
            Dim sqlInsert As String = "INSERT INTO Usuarios (nombre, cedula, [contraseña], rol) " &
                                      "VALUES (@nombre, @cedula, @pass, @rol)"
            Dim cmdInsert As New SqlCommand(sqlInsert, con)
            cmdInsert.Parameters.AddWithValue("@nombre", nombre)
            cmdInsert.Parameters.AddWithValue("@cedula", cedula)
            cmdInsert.Parameters.AddWithValue("@pass", passwordHash)
            cmdInsert.Parameters.AddWithValue("@rol", rol)

            Try
                con.Open()
                Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())
                If count > 0 Then
                    lblMensaje.Text = "Ya existe un usuario registrado con esta cédula."
                    ' Mostrar toast de error
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showToastError", "showToast('error');", True)
                    Return
                End If

                Dim rowsAffected As Integer = cmdInsert.ExecuteNonQuery()
                If rowsAffected > 0 Then
                    ' Usuario creado correctamente
                    lblMensaje.ForeColor = Drawing.Color.Green
                    lblMensaje.Text = "Usuario creado exitosamente. Redirigiendo a la página de inicio..."

                    ' Mostrar toast de éxito
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showToastSuccess", "showToast('success');", True)

                    ' Redirigir después de 2 segundos
                    Response.AddHeader("REFRESH", "1;URL=Index.aspx")
                Else
                    lblMensaje.Text = "No se pudo crear el usuario. Intente de nuevo."
                    ' Mostrar toast de error
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showToastError", "showToast('error');", True)
                End If

            Catch ex As Exception
                lblMensaje.Text = "Error en la base de datos: " & ex.Message
                ' Mostrar toast de error
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showToastError", "showToast('error');", True)
            End Try
        End Using
    End Sub

    ' Función para encriptar la contraseña con SHA-256
    Private Function HashPasswordSHA256(ByVal password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password)
            Dim hash As Byte() = sha256.ComputeHash(bytes)
            Dim sb As New StringBuilder()
            For Each b As Byte In hash
                sb.Append(b.ToString("x2"))
            Next
            Return sb.ToString()
        End Using
    End Function
End Class
