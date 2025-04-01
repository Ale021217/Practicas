Imports System.Data.SqlClient
Imports Newtonsoft.Json

Partial Public Class ListaReportes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté autenticado y tenga el rol de "administrador"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "mecanico" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarReportes()
        End If
    End Sub

    Private Sub CargarReportes()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()

        Dim sql As String = "
            SELECT 
                R.id_reporte,
                U.nombre AS Usuario,
                R.fecha_reporte,
                (Un.modelo + ' - ' + Un.placa) AS Unidad,
                R.imagen_averia,
                R.descripcion,
                A.tipo_averia AS TipoAveria,
                R.estado,
                A.estado AS Gravedad
            FROM Reporte R
            INNER JOIN Usuarios U ON R.id_usuario = U.id_usuario
            INNER JOIN Unidad Un ON R.unidad = Un.id_unidad
            INNER JOIN Averias A ON R.tipo_averia = A.id_averias
            WHERE R.estado = 'pendiente'
            ORDER BY R.fecha_reporte DESC
        "

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
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

            ' Muestra el modal usando JS
            Dim script As String = "abrirModalDetalle();"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "OpenModal", script, True)
        End If
    End Sub

    Private Sub CargarDetalleReporte(idReporte As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()

        Dim sql As String = "
            SELECT 
                R.id_reporte,
                CONVERT(varchar(16), R.fecha_reporte, 120) AS fecha_formateada,
                (Un.modelo + ' - ' + Un.placa) AS Unidad,
                R.descripcion,
                R.estado,
                R.imagen_averia
            FROM Reporte R
            INNER JOIN Unidad Un ON R.unidad = Un.id_unidad
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

            ' Asignar a los labels del modal
            lblModalIdReporte.Text = row("id_reporte").ToString()
            lblModalFecha.Text = row("fecha_formateada").ToString()
            lblModalUnidad.Text = row("Unidad").ToString()
            lblModalDescripcion.Text = row("descripcion").ToString()
            lblModalEstado.Text = row("estado").ToString()

            ' Imágenes
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
                Dim sb As New Text.StringBuilder()
                For Each ruta In rutas
                    If Not String.IsNullOrEmpty(ruta) Then
                        Dim finalRuta = ruta.Replace("~", "")
                        sb.AppendLine($"<img src='{finalRuta}' class='img-fluid mb-2 modal-img' alt='Imagen Avería' /><br/>")
                    End If
                Next
                modalImagenes.InnerHtml = sb.ToString()
            Else
                ' Si no es lista, asumimos una sola ruta
                Dim finalRuta = imagenAveria.Replace("~", "")
                modalImagenes.InnerHtml = $"<img src='{finalRuta}' class='img-fluid mb-2 modal-img' alt='Imagen Avería' /><br/>"
            End If
        Catch ex As Exception
            ' Si falla el parseo, es una sola ruta
            Dim finalRuta = imagenAveria.Replace("~", "")
            modalImagenes.InnerHtml = $"<img src='{finalRuta}' class='img-fluid mb-2 modal-img' alt='Imagen Avería' /><br/>"
        End Try
    End Sub

    Private Sub LimpiarModal()
        lblModalIdReporte.Text = ""
        lblModalFecha.Text = ""
        lblModalUnidad.Text = ""
        lblModalDescripcion.Text = ""
        lblModalEstado.Text = ""
        modalImagenes.InnerHtml = "<em>Sin datos.</em>"
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

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
