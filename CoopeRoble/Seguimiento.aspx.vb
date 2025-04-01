Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Script.Serialization

Partial Public Class Seguimiento
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté logueado y que su rol sea "mecanico"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "mecanico" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("id_reporte")) Then
                hfIdReporte.Value = Request.QueryString("id_reporte")
            Else
                Response.Redirect("Mecanico.aspx?mensaje=Reporte+no+encontrado")
            End If
        End If
    End Sub

    Protected Sub btnGuardarSeguimiento_Click(sender As Object, e As EventArgs) Handles btnGuardarSeguimiento.Click
        Dim idReporte As Integer
        If Not Integer.TryParse(hfIdReporte.Value, idReporte) Then
            Response.Write("<div style='color:red;'>DEBUG: id_reporte no válido.</div>")
            Exit Sub
        End If

        Dim descripcion As String = txtDescripcionSeguimiento.Text.Trim()
        If String.IsNullOrEmpty(descripcion) OrElse descripcion.Length < 100 Then
            Response.Write("<div style='color:red;'>DEBUG: La descripción debe tener al menos 100 caracteres.</div>")
            Exit Sub
        End If

        Dim jsonFotos As String = hfImagenesSeguimiento.Value
        Dim serializer As New JavaScriptSerializer()
        Dim fotosList As New List(Of String)
        If Not String.IsNullOrEmpty(jsonFotos) Then
            Try
                fotosList = serializer.Deserialize(Of List(Of String))(jsonFotos)
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error al deserializar fotos: " & ex.Message)
                fotosList = New List(Of String)()
            End Try
        End If

        ' Limitar a 4 fotos (por seguridad)
        If fotosList.Count > 4 Then
            fotosList = fotosList.Take(4).ToList()
        End If

        Dim folderPath As String = Server.MapPath("~/uploads/")
        If Not Directory.Exists(folderPath) Then
            Try
                Directory.CreateDirectory(folderPath)
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error al crear carpeta: " & ex.Message)
            End Try
        End If

        Dim savedFotos As New List(Of String)
        For Each base64String As String In fotosList
            If String.IsNullOrEmpty(base64String) Then Continue For

            ' Detectar prefijos para JPEG o PNG
            Dim prefix As String = "data:image/jpeg;base64,"
            If base64String.StartsWith(prefix) Then
                base64String = base64String.Substring(prefix.Length)
            Else
                Dim prefixPng As String = "data:image/png;base64,"
                If base64String.StartsWith(prefixPng) Then
                    base64String = base64String.Substring(prefixPng.Length)
                End If
            End If

            Try
                Dim imageBytes() As Byte = Convert.FromBase64String(base64String)
                Dim fileName As String = Guid.NewGuid().ToString() & ".jpg"
                Dim savePath As String = Path.Combine(folderPath, fileName)
                File.WriteAllBytes(savePath, imageBytes)
                savedFotos.Add("uploads/" & fileName)
            Catch ex As Exception
                Response.Write("<div style='color:red;'>DEBUG: Error guardando imagen: " & ex.Message & "</div>")
            End Try
        Next

        Dim savedFotosJson As String = serializer.Serialize(savedFotos)

        Dim fechaEntrada As DateTime = DateTime.Now
        Dim estadoReporteMomento As String = "en proceso"  ' Valor fijo

        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            Try
                con.Open()

                Dim sqlInsert As String = "
                    INSERT INTO Reparaciones (
                        id_reporte, 
                        id_usuario, 
                        fecha_entrada, 
                        fecha_salida, 
                        descripcion_reparacion, 
                        imagen_reparacion, 
                        falla_adicional, 
                        estado_reporte_momento
                    )
                    VALUES (
                        @id_reporte, 
                        @id_usuario, 
                        @fecha_entrada, 
                        @fecha_salida, 
                        @descripcion, 
                        @imagenes, 
                        @falla_adicional, 
                        @estado_reporte_momento
                    )
                "

                Using cmd As New SqlCommand(sqlInsert, con)
                    cmd.Parameters.Add("@id_reporte", SqlDbType.Int).Value = idReporte
                    cmd.Parameters.Add("@id_usuario", SqlDbType.Int).Value = Convert.ToInt32(Session("id_usuario"))
                    cmd.Parameters.Add("@fecha_entrada", SqlDbType.DateTime).Value = fechaEntrada
                    cmd.Parameters.Add("@fecha_salida", SqlDbType.DateTime).Value = fechaEntrada
                    cmd.Parameters.Add("@descripcion", SqlDbType.NVarChar, -1).Value = descripcion
                    cmd.Parameters.Add("@imagenes", SqlDbType.NVarChar, -1).Value = savedFotosJson
                    cmd.Parameters.Add("@falla_adicional", SqlDbType.NVarChar, -1).Value = ""
                    cmd.Parameters.Add("@estado_reporte_momento", SqlDbType.VarChar, 50).Value = estadoReporteMomento

                    Dim rowsInserted As Integer = cmd.ExecuteNonQuery()
                    System.Diagnostics.Debug.WriteLine("DEBUG: Se insertaron " & rowsInserted & " fila(s).")
                End Using

            Catch ex As SqlException
                Response.Write("<div style='color:red;'>DEBUG SQL ERROR: " & ex.Message & "</div>")
            Catch ex As Exception
                Response.Write("<div style='color:red;'>DEBUG ERROR: " & ex.Message & "</div>")
            End Try
        End Using

        Response.Redirect("Mecanico.aspx")
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs) Handles lnkLogout.Click
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
