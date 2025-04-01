Imports System.Data.SqlClient
Imports System.Security.Cryptography

Partial Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblError.Text = ""
        End If
    End Sub

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim cedula As String = txtCedula.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If String.IsNullOrEmpty(cedula) OrElse String.IsNullOrEmpty(password) Then
            lblError.Text = "Por favor, ingrese su cédula y contraseña."
            Return
        End If

        Dim hashedPassword As String = HashPasswordSHA256(password)

        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            Dim sql As String = "SELECT id_usuario, nombre, rol, estado FROM Usuarios WHERE cedula = @cedula AND [contraseña] = @pass"
            Dim cmd As New SqlCommand(sql, con)
            cmd.Parameters.AddWithValue("@cedula", cedula)
            cmd.Parameters.AddWithValue("@pass", hashedPassword)
            Try
                con.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader()
                If dr.HasRows Then
                    If dr.Read() Then
                        Dim idUsuario As Integer = Convert.ToInt32(dr("id_usuario"))
                        Dim nombre As String = dr("nombre").ToString()
                        Dim rol As String = dr("rol").ToString().Trim().ToLower()
                        Dim estado As Boolean = Convert.ToBoolean(dr("estado"))
                        If Not estado Then
                            lblError.Text = "Usuario inactivo. Contacte al administrador."
                            Return
                        End If
                        Session("id_usuario") = idUsuario
                        Session("nombre") = nombre
                        Session("rol") = rol
                        Select Case rol
                            Case "administrador"
                                Response.Redirect("Index.aspx")
                            Case "chofer"
                                Response.Redirect("DashboardChofer.aspx")
                            Case "mecanico"
                                Response.Redirect("Mecanico.aspx")
                            Case Else
                                Response.Redirect("DashboardGeneral.aspx")
                        End Select
                    End If
                Else
                    lblError.Text = "Credenciales inválidas. Por favor, intente de nuevo."
                End If
            Catch ex As Exception
                lblError.Text = "Error al conectar con la base de datos: " & ex.Message
            End Try
        End Using
    End Sub

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
End Class
