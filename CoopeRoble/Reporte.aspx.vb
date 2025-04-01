Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Script.Serialization
Imports System.Drawing
Imports System.Drawing.Imaging

Partial Public Class Reporte
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté logueado y que su rol sea "chofer"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "chofer" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarUnidades()
            CargarTiposAveria()
        End If
    End Sub

    Private Sub CargarUnidades()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            Dim sql As String = "SELECT id_unidad, (modelo + ' - ' + placa) AS UnidadNombre FROM Unidad WHERE estado = 'activo'"
            Dim cmd As New SqlCommand(sql, con)
            Try
                con.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader()
                ddlUnidad.DataSource = dr
                ddlUnidad.DataTextField = "UnidadNombre"
                ddlUnidad.DataValueField = "id_unidad"
                ddlUnidad.DataBind()
                ddlUnidad.Items.Insert(0, New ListItem("Seleccione...", ""))
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error en CargarUnidades: " & ex.Message)
            End Try
        End Using
    End Sub

    Private Sub CargarTiposAveria()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            Dim sql As String = "SELECT id_averias, tipo_averia FROM Averias"
            Dim cmd As New SqlCommand(sql, con)
            Try
                con.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader()
                ddlTipoAveria.DataSource = dr
                ddlTipoAveria.DataTextField = "tipo_averia"
                ddlTipoAveria.DataValueField = "id_averias"
                ddlTipoAveria.DataBind()
                ddlTipoAveria.Items.Insert(0, New ListItem("Seleccione...", ""))
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error en CargarTiposAveria: " & ex.Message)
            End Try
        End Using
    End Sub

    Protected Sub btnEnviar_Click(sender As Object, e As EventArgs)
        Dim id_usuario As Integer = Convert.ToInt32(Session("id_usuario"))
        Dim fecha_reporte As Date = Date.Now

        Dim unidad As Integer = 0
        Integer.TryParse(ddlUnidad.SelectedValue, unidad)

        Dim tipoAveria As Integer = 0
        Integer.TryParse(ddlTipoAveria.SelectedValue, tipoAveria)

        Dim descripcion As String = txtDescripcion.Text.Trim()
        If descripcion.Length < 100 Then
            Exit Sub
        End If

        Dim estado As String = "pendiente"

        ' Obtener las fotos en base64 desde el HiddenField (ya comprimidas en cliente)
        Dim jsonFotos As String = hfImagenesAveria.Value
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

        Dim folderPath As String = Server.MapPath("~/imgReporte/")
        If Not Directory.Exists(folderPath) Then
            Try
                Directory.CreateDirectory(folderPath)
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error al crear carpeta: " & ex.Message)
            End Try
        End If

        Dim imagenUrls As New List(Of String)
        For Each foto As String In fotosList
            If String.IsNullOrEmpty(foto) Then Continue For

            ' Detectar prefijos para JPEG o PNG
            Dim prefixJpeg As String = "data:image/jpeg;base64,"
            Dim prefixPng As String = "data:image/png;base64,"
            If foto.StartsWith(prefixJpeg) Then
                foto = foto.Substring(prefixJpeg.Length)
            ElseIf foto.StartsWith(prefixPng) Then
                foto = foto.Substring(prefixPng.Length)
            End If

            Dim imageBytes() As Byte
            Try
                imageBytes = Convert.FromBase64String(foto)
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error al convertir base64: " & ex.Message)
                Continue For
            End Try

            ' Si la imagen decodificada pesa más de 1MB, intentar comprimir y redimensionar en el servidor
            If imageBytes.Length > (1 * 1024 * 1024) Then
                Dim calidad As Long = 90
                Dim comprimido() As Byte = Nothing
                Try
                    comprimido = ComprimirYRedimensionarImagen(imageBytes, calidad, 800)
                Catch ex As Exception
                    System.Diagnostics.Debug.WriteLine("Error al comprimir imagen: " & ex.Message)
                    comprimido = imageBytes
                End Try

                While comprimido.Length > (1 * 1024 * 1024) AndAlso calidad > 10
                    calidad -= 10
                    Try
                        comprimido = ComprimirYRedimensionarImagen(imageBytes, calidad, 800)
                    Catch ex As Exception
                        System.Diagnostics.Debug.WriteLine("Error al comprimir imagen con calidad " & calidad & ": " & ex.Message)
                        Exit While
                    End Try
                End While

                If comprimido.Length > (1 * 1024 * 1024) Then
                    System.Diagnostics.Debug.WriteLine("Imagen descartada por exceder 1MB tras compresión.")
                    Continue For
                End If

                imageBytes = comprimido
            End If

            Dim fileName As String = "averia_" & Guid.NewGuid().ToString() & ".jpg"
            Dim filePath As String = Path.Combine(folderPath, fileName)
            Try
                File.WriteAllBytes(filePath, imageBytes)
                imagenUrls.Add("~/imgReporte/" & fileName)
            Catch ex As Exception
                System.Diagnostics.Debug.WriteLine("Error al guardar imagen: " & ex.Message)
                Continue For
            End Try
        Next

        Dim imagenUrl As String = serializer.Serialize(imagenUrls)

        Dim conStr2 As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr2)
            Dim sql As String = "INSERT INTO Reporte (id_usuario, fecha_reporte, unidad, imagen_averia, descripcion, tipo_averia, estado) " &
                                "VALUES (@id_usuario, @fecha_reporte, @unidad, @imagen_averia, @descripcion, @tipoAveria, @estado)"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_usuario", id_usuario)
                cmd.Parameters.AddWithValue("@fecha_reporte", fecha_reporte)
                cmd.Parameters.AddWithValue("@unidad", unidad)
                cmd.Parameters.AddWithValue("@imagen_averia", imagenUrl)
                cmd.Parameters.AddWithValue("@descripcion", descripcion)
                cmd.Parameters.AddWithValue("@tipoAveria", tipoAveria)
                cmd.Parameters.AddWithValue("@estado", estado)
                Try
                    con.Open()
                    cmd.ExecuteNonQuery()
                    con.Close()
                Catch ex As Exception
                    System.Diagnostics.Debug.WriteLine("Error al insertar reporte: " & ex.Message)
                End Try
            End Using
        End Using

        Response.Redirect("DashboardChofer.aspx")
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Session.Abandon()
        If Request.Cookies("ASP.NET_SessionId") IsNot Nothing Then
            Response.Cookies("ASP.NET_SessionId").Expires = DateTime.Now.AddDays(-1)
        End If
        Response.Redirect("Login.aspx")
    End Sub

    ' Función para redimensionar y comprimir la imagen usando System.Drawing.
    ' maxDimension: valor máximo para ancho o alto (manteniendo la relación de aspecto).
    Private Function ComprimirYRedimensionarImagen(bytesOriginal() As Byte, calidad As Long, maxDimension As Integer) As Byte()
        Using msOriginal As New MemoryStream(bytesOriginal)
            Using imgOriginal As Image = Image.FromStream(msOriginal)
                Dim factor As Double = Math.Min(1, Math.Min(maxDimension / imgOriginal.Width, maxDimension / imgOriginal.Height))
                Dim newWidth As Integer = Convert.ToInt32(imgOriginal.Width * factor)
                Dim newHeight As Integer = Convert.ToInt32(imgOriginal.Height * factor)

                Using bmpRedimensionada As New Bitmap(newWidth, newHeight)
                    Using gr As Graphics = Graphics.FromImage(bmpRedimensionada)
                        gr.InterpolationMode = Drawing2D.InterpolationMode.HighQualityBicubic
                        gr.DrawImage(imgOriginal, 0, 0, newWidth, newHeight)
                    End Using

                    Dim codecParams As New EncoderParameters(1)
                    codecParams.Param(0) = New EncoderParameter(Encoder.Quality, calidad)
                    Dim jpegCodec As ImageCodecInfo = GetEncoderInfo("image/jpeg")
                    If jpegCodec Is Nothing Then Return bytesOriginal
                    Using msComprimido As New MemoryStream()
                        Try
                            bmpRedimensionada.Save(msComprimido, jpegCodec, codecParams)
                        Catch ex As Exception
                            Return bytesOriginal
                        End Try
                        Return msComprimido.ToArray()
                    End Using
                End Using
            End Using
        End Using
    End Function

    Private Function GetEncoderInfo(mimeType As String) As ImageCodecInfo
        For Each ici As ImageCodecInfo In ImageCodecInfo.GetImageEncoders()
            If ici.MimeType = mimeType Then
                Return ici
            End If
        Next
        Return Nothing
    End Function
End Class
