Imports System.Data.SqlClient
Imports Newtonsoft.Json

Partial Public Class Mecanico
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("id_usuario") Is Nothing OrElse Session("rol") Is Nothing OrElse
           Session("rol").ToString().Trim().ToLower() <> "mecanico" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarMisReportes()
        End If
    End Sub

    Private Sub CargarMisReportes()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Dim idMecanico As Integer = Convert.ToInt32(Session("id_usuario"))

        Dim sql As String = "
            SELECT 
                R.id_reporte,
                R.fecha_reporte,
                (SELECT modelo + ' - ' + placa FROM dbo.Unidad WHERE id_unidad = R.unidad) AS Unidad,
                R.descripcion,
                R.estado,
                R.imagen_averia,
                A.estado AS Gravedad,
                A.tipo_averia
            FROM dbo.Reporte R
            INNER JOIN Averias A ON R.tipo_averia = A.id_averias
            WHERE LOWER(LTRIM(RTRIM(R.estado))) = 'en proceso'
              AND R.usuarioAsignado = @id_mecanico_str
            ORDER BY 
                CASE 
                    WHEN LOWER(A.estado) = 'grave' THEN 1
                    WHEN LOWER(A.estado) = 'medio' THEN 2
                    WHEN LOWER(A.estado) = 'leve'  THEN 3
                    ELSE 4
                END,
                R.fecha_reporte DESC
        "

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_mecanico_str", idMecanico.ToString())
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using

        rptReportes.DataSource = dt
        rptReportes.DataBind()
    End Sub

    Protected Sub rptReportes_ItemCommand(sender As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "VerDetalle" Then
            Dim idReporte As Integer = Convert.ToInt32(e.CommandArgument)
            CargarDetalleReporte(idReporte)
            CargarHistorial(idReporte)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "OpenModal", "abrirModalDetalle();", True)
        End If
    End Sub

    Private Sub CargarDetalleReporte(idReporte As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Dim sql As String = "
            SELECT 
                R.id_reporte,
                CONVERT(varchar(16), R.fecha_reporte, 120) AS fecha_formateada,
                (SELECT modelo + ' - ' + placa FROM dbo.Unidad WHERE id_unidad = R.unidad) AS Unidad,
                R.descripcion,
                R.estado,
                R.imagen_averia,
                A.tipo_averia
            FROM dbo.Reporte R
            INNER JOIN Averias A ON R.tipo_averia = A.id_averias
            WHERE R.id_reporte = @id_reporte
        "

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_reporte", idReporte)
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using

        If dt.Rows.Count > 0 Then
            Dim row As DataRow = dt.Rows(0)
            lblModalIdReporte.Text = row("id_reporte").ToString()
            lblModalFecha.Text = row("fecha_formateada").ToString()
            lblModalUnidad.Text = row("Unidad").ToString()
            lblModalDescripcion.Text = row("descripcion").ToString()
            lblModalEstado.Text = row("estado").ToString()


            Dim imagenAveria As String = If(row("imagen_averia") IsNot DBNull.Value, row("imagen_averia").ToString().Trim(), "")
            If Not String.IsNullOrEmpty(imagenAveria) Then
                CargarImagenAveria(imagenAveria)
            Else
                modalImagenes.InnerHtml = "<em>Sin imagen de avería.</em>"
            End If
        Else
            LimpiarModal()
        End If
    End Sub

    Private Sub CargarImagenAveria(imagenAveria As String)
        Try
            Dim rutas As List(Of String) = JsonConvert.DeserializeObject(Of List(Of String))(imagenAveria)
            If rutas IsNot Nothing AndAlso rutas.Count > 0 Then
                Dim sb As New StringBuilder()
                For Each ruta In rutas
                    If Not String.IsNullOrEmpty(ruta) Then
                        Dim finalRuta = ruta.Replace("~", "")
                        sb.AppendLine($"<img src='{finalRuta}' class='img-fluid mb-2' alt='Imagen Avería' /><br/>")
                    End If
                Next
                modalImagenes.InnerHtml = sb.ToString()
            Else
                Dim finalRuta = imagenAveria.Replace("~", "")
                modalImagenes.InnerHtml = $"<img src='{finalRuta}' class='img-fluid mb-2' alt='Imagen Avería' /><br/>"
            End If
        Catch ex As Exception
            Dim finalRuta = imagenAveria.Replace("~", "")
            modalImagenes.InnerHtml = $"<img src='{finalRuta}' class='img-fluid mb-2' alt='Imagen Avería' /><br/>"
        End Try
    End Sub

    Private Sub CargarHistorial(idReporte As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Dim sql As String = "
            SELECT 
                CONVERT(varchar(16), fecha_entrada, 120) AS fecha_seguimiento,
                descripcion_reparacion AS comentario
            FROM Reparaciones
            WHERE id_reporte = @id_reporte
            ORDER BY fecha_entrada DESC
        "

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_reporte", idReporte)
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using

        If dt.Rows.Count > 0 Then
            rptHistorial.DataSource = dt
            rptHistorial.DataBind()
            lblEmptyHistorial.Visible = False
        Else
            rptHistorial.DataSource = Nothing
            rptHistorial.DataBind()
            lblEmptyHistorial.Visible = True
        End If
    End Sub

    Private Sub LimpiarModal()
        lblModalIdReporte.Text = ""
        lblModalFecha.Text = ""
        lblModalUnidad.Text = ""
        lblModalDescripcion.Text = ""
        lblModalEstado.Text = ""
        modalImagenes.InnerHtml = ""
        rptHistorial.DataSource = Nothing
        rptHistorial.DataBind()
        lblEmptyHistorial.Visible = True
    End Sub

    Protected Sub lnkReportesDisponibles_Click(sender As Object, e As EventArgs)
        Response.Redirect("ListaReportes.aspx")
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    ' Retorna el estilo en línea según la gravedad
    Public Function GetSeverityStyle(objGravedad As Object) As String
        If objGravedad Is Nothing Then
            Return ""
        End If
        Dim gravedad As String = objGravedad.ToString().ToLower()
        Select Case gravedad
            Case "grave"
                Return "background-color: red;"
            Case "medio"
                Return "background-color: yellow;"
            Case "leve"
                Return "background-color: green;"
            Case Else
                Return "background-color: gray;"
        End Select
    End Function
End Class
