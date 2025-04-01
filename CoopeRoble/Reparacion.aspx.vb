Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Script.Serialization

Partial Public Class Reparacion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "mecanico" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            hfFechaEntrada.Value = DateTime.Now.ToString("yyyy-MM-ddTHH:mm")
            If Not String.IsNullOrEmpty(Request.QueryString("id_reporte")) Then
                hfIdReporte.Value = Request.QueryString("id_reporte")
            Else
                Response.Redirect("Mecanico.aspx?mensaje=Reporte+no+encontrado")
            End If
        End If
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        ' Validar idReporte
        Dim idReporte As Integer
        If Not Integer.TryParse(hfIdReporte.Value, idReporte) Then
            Exit Sub
        End If

        ' Validar que el usuario esté en sesión
        Dim idMecanico As Integer
        If Not Integer.TryParse(Session("id_usuario").ToString(), idMecanico) Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        ' Fechas
        Dim fechaEntrada As DateTime
        Dim fechaSalida As DateTime
        If Not DateTime.TryParse(hfFechaEntrada.Value, fechaEntrada) Then
            fechaEntrada = DateTime.Now
        End If
        If Not DateTime.TryParse(hfFechaSalida.Value, fechaSalida) Then
            fechaSalida = DateTime.Now
        End If

        ' Descripción (mínimo 100 caracteres)
        Dim descripcion As String = txtDescripcionReparacion.Text.Trim()
        If descripcion.Length < 100 Then
            Exit Sub
        End If

        ' Procesar imágenes desde el HiddenField (ya comprimidas en cliente)
        Dim jsonFotos As String = hfImagenesReparacion.Value
        Dim serializer As New JavaScriptSerializer()
        Dim fotosList As List(Of String) = New List(Of String)
        If Not String.IsNullOrEmpty(jsonFotos) Then
            fotosList = serializer.Deserialize(Of List(Of String))(jsonFotos)
        End If

        Dim savedFotos As New List(Of String)
        Dim folderPath As String = Server.MapPath("~/uploads/")
        If Not Directory.Exists(folderPath) Then
            Directory.CreateDirectory(folderPath)
        End If

        For Each base64String As String In fotosList
            If Not String.IsNullOrEmpty(base64String) Then
                Dim prefix As String = "data:image/jpeg;base64,"
                If base64String.StartsWith(prefix) Then
                    base64String = base64String.Substring(prefix.Length)
                End If
                Try
                    Dim imageBytes() As Byte = Convert.FromBase64String(base64String)
                    Dim fileName As String = Guid.NewGuid().ToString() & ".jpg"
                    Dim savePath As String = Path.Combine(folderPath, fileName)
                    File.WriteAllBytes(savePath, imageBytes)
                    savedFotos.Add("uploads/" & fileName)
                Catch ex As Exception
                    ' Manejo de error al guardar la imagen
                End Try
            End If
        Next

        Dim savedFotosJson As String = serializer.Serialize(savedFotos)

        ' Falla adicional (opcional)
        Dim fallaAdicional As String = ""
        If rblFallaAdicional.SelectedValue = "Si" Then
            fallaAdicional = txtFallaAdicional.Text.Trim()
        End If

        ' Obtener el estado actual del reporte
        Dim estadoActualReporte As String = ObtenerEstadoReporte(idReporte)

        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sqlInsert As String = "
                INSERT INTO Reparaciones (
                    id_reporte, id_usuario, fecha_entrada, fecha_salida, 
                    descripcion_reparacion, imagen_reparacion, falla_adicional, estado_reporte_momento
                )
                VALUES (
                    @id_reporte, @id_usuario, @fecha_entrada, @fecha_salida,
                    @descripcion, @imagenes, @falla, @estado_reporte_momento
                )
            "
            Using cmd As New SqlCommand(sqlInsert, con)
                cmd.Parameters.AddWithValue("@id_reporte", idReporte)
                cmd.Parameters.AddWithValue("@id_usuario", idMecanico)
                cmd.Parameters.AddWithValue("@fecha_entrada", fechaEntrada)
                cmd.Parameters.AddWithValue("@fecha_salida", fechaSalida)
                cmd.Parameters.AddWithValue("@descripcion", descripcion)
                cmd.Parameters.AddWithValue("@imagenes", savedFotosJson)
                cmd.Parameters.AddWithValue("@falla", fallaAdicional)
                cmd.Parameters.AddWithValue("@estado_reporte_momento", estadoActualReporte)
                Dim rowsInserted As Integer = cmd.ExecuteNonQuery()
                ' Comentado para evitar salida antes de la redirección
                ' Response.Write("<div style='color:blue;'>DEBUG: Insert Reparaciones => " & rowsInserted & " fila(s). estado_reporte_momento=" & estadoActualReporte & "</div>")
            End Using

            Dim sqlUpdate As String = "
                UPDATE Reporte 
                SET estado = 'terminado'
                WHERE id_reporte = @id_reporte
            "
            Using cmd As New SqlCommand(sqlUpdate, con)
                cmd.Parameters.AddWithValue("@id_reporte", idReporte)
                Dim rowsUpdated As Integer = cmd.ExecuteNonQuery()
                ' Comentado para evitar salida antes de la redirección
                ' Response.Write("<div style='color:blue;'>DEBUG: Update Reporte => " & rowsUpdated & " fila(s) a 'terminado'.</div>")
            End Using
        End Using

        Response.Redirect("Mecanico.aspx?mensaje=ReparacionExitosa")
    End Sub

    Private Function ObtenerEstadoReporte(idReporte As Integer) As String
        Dim estado As String = "desconocido"
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT estado FROM Reporte WHERE id_reporte = @id_reporte"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_reporte", idReporte)
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then
                    estado = result.ToString()
                End If
            End Using
        End Using
        Return estado
    End Function

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Response.Redirect("Mecanico.aspx")
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs) Handles lnkLogout.Click
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
