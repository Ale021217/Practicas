Imports System.Data
Imports System.Data.SqlClient
Imports Newtonsoft.Json

Partial Class SeguimientoReporte
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verifica rol de administrador
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            pnlError.Visible = False
            lblError.Text = ""

            CargarUnidades()
            CargarTiposAveria()

            ddlReporte.Items.Clear()
            ddlReporte.Items.Add(New ListItem("-- Seleccione un reporte --", "0"))
        End If
    End Sub


    Private Sub CargarUnidades()
        Try
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim dt As New DataTable()
            Dim sql As String = "
                SELECT 
                    id_unidad,
                    (marca + ' ' + modelo + ' (' + placa + ')') AS nombreUnidad
                FROM dbo.Unidad
                ORDER BY marca, modelo
            "
            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    Using sda As New SqlDataAdapter(cmd)
                        sda.Fill(dt)
                    End Using
                End Using
            End Using

            ddlUnidad.Items.Clear()
            If dt.Rows.Count > 0 Then
                ddlUnidad.DataSource = dt
                ddlUnidad.DataTextField = "nombreUnidad"
                ddlUnidad.DataValueField = "id_unidad"
                ddlUnidad.DataBind()
            End If
            ddlUnidad.Items.Insert(0, New ListItem("-- Todas las unidades --", "0"))
        Catch ex As Exception
            MostrarError("Error al cargar unidades: " & ex.Message)
        End Try
    End Sub


    Private Sub CargarTiposAveria()
        Try
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim dt As New DataTable()
            Dim sql As String = "
                SELECT id_averias, tipo_averia
                FROM dbo.Averias
                ORDER BY tipo_averia
            "

            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    Using sda As New SqlDataAdapter(cmd)
                        sda.Fill(dt)
                    End Using
                End Using
            End Using

            ddlTipoAveria.Items.Clear()
            ddlTipoAveria.Items.Add(New ListItem("-- Todas --", "0"))
            For Each row As DataRow In dt.Rows
                Dim idAveria As String = row("id_averias").ToString()
                Dim nombreAveria As String = row("tipo_averia").ToString()
                ddlTipoAveria.Items.Add(New ListItem(nombreAveria, idAveria))
            Next
        Catch ex As Exception
            MostrarError("Error al cargar tipos de avería: " & ex.Message)
        End Try
    End Sub


    Private Sub CargarReportesFiltrados()
        Try
            Dim idUnidad As Integer
            Integer.TryParse(ddlUnidad.SelectedValue, idUnidad)

            Dim idAveria As Integer
            Integer.TryParse(ddlTipoAveria.SelectedValue, idAveria)

            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim dt As New DataTable()
            Dim sql As New StringBuilder()

            sql.AppendLine("SELECT")
            sql.AppendLine("  R.id_reporte,")
            sql.AppendLine("  A.tipo_averia,")
            sql.AppendLine("  'Reporte: ' + CAST(R.id_reporte AS VARCHAR(10)) + ' | Fecha: ' + CONVERT(VARCHAR(10), R.fecha_reporte, 120) AS desc_reporte,")
            sql.AppendLine("  R.fecha_reporte,")
            sql.AppendLine("  R.unidad")
            sql.AppendLine("FROM dbo.Reporte R")
            sql.AppendLine("JOIN dbo.Averias A ON R.tipo_averia = A.id_averias")
            sql.AppendLine("WHERE 1=1")

            If idUnidad > 0 Then
                sql.AppendLine("  AND R.unidad = @id_unidad")
            End If
            If idAveria > 0 Then
                sql.AppendLine("  AND R.tipo_averia = @id_averia")
            End If

            Dim fechaFiltro As DateTime
            If DateTime.TryParse(txtFechaHora.Text.Trim(), fechaFiltro) Then
                sql.AppendLine("  AND CONVERT(date, R.fecha_reporte) = CONVERT(date, @fechaFiltro)")
            End If

            sql.AppendLine("ORDER BY R.id_reporte DESC")

            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql.ToString(), con)
                    If idUnidad > 0 Then
                        cmd.Parameters.AddWithValue("@id_unidad", idUnidad)
                    End If
                    If idAveria > 0 Then
                        cmd.Parameters.AddWithValue("@id_averia", idAveria)
                    End If
                    If DateTime.TryParse(txtFechaHora.Text.Trim(), fechaFiltro) Then
                        cmd.Parameters.Add("@fechaFiltro", SqlDbType.Date).Value = fechaFiltro.Date
                    End If

                    Using sda As New SqlDataAdapter(cmd)
                        sda.Fill(dt)
                    End Using
                End Using
            End Using

            ddlReporte.Items.Clear()
            If dt.Rows.Count > 0 Then
                ddlReporte.DataSource = dt
                ddlReporte.DataTextField = "desc_reporte"
                ddlReporte.DataValueField = "id_reporte"
                ddlReporte.DataBind()
            End If
            ddlReporte.Items.Insert(0, New ListItem("-- Seleccione un reporte --", "0"))
        Catch ex As Exception
            MostrarError("Error al cargar reportes filtrados: " & ex.Message)
        End Try
    End Sub


    Private Sub CargarInfoReporte(idReporte As Integer)
        Try
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim dt As New DataTable()

            Dim sql As String = "
                SELECT 
                    R.id_reporte,
                    U.nombre AS chofer,
                    R.estado AS estadoReporte,
                    A.tipo_averia,
                    CONVERT(varchar(10), R.fecha_reporte, 120) AS fecha_reporte,
                    R.descripcion,
                    R.unidad
                FROM dbo.Reporte R
                JOIN dbo.Averias A ON R.tipo_averia = A.id_averias
                JOIN dbo.Usuarios U ON R.id_usuario = U.id_usuario
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
                Dim row = dt.Rows(0)
                lblIdReporte.Text = row("id_reporte").ToString()
                lblChofer.Text = row("chofer").ToString()
                lblEstadoReporte.Text = row("estadoReporte").ToString()
                lblTipoAveria.Text = row("tipo_averia").ToString()
                lblFechaReporte.Text = row("fecha_reporte").ToString()
                lblDescripcion.Text = row("descripcion").ToString()
                pnlInfoReporte.Visible = True
            Else
                LimpiarPantalla()
            End If
        Catch ex As Exception
            MostrarError("Error al cargar información del reporte: " & ex.Message)
        End Try
    End Sub


    Private Sub CargarSeguimientos(idReporte As Integer)
        Try
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim dt As New DataTable()

            Dim sql As String = "
                SELECT 
                    U.cedula,
                    U.nombre,
                    CONVERT(varchar(16), Rep.fecha_entrada, 120) AS fecha_seguimiento,
                    Rep.descripcion_reparacion AS comentario,
                    Rep.imagen_reparacion AS foto,
                    R.estado AS estado_reporte
                FROM dbo.Reparaciones Rep
                JOIN dbo.Usuarios U ON Rep.id_usuario = U.id_usuario
                JOIN dbo.Reporte R ON Rep.id_reporte = R.id_reporte
                WHERE Rep.id_reporte = @id_reporte
                ORDER BY Rep.fecha_entrada DESC
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
                rptSeguimientos.DataSource = dt
                rptSeguimientos.DataBind()
                pnlTablaSeguimientos.Visible = True
                pnlSinSeguimientos.Visible = False
            Else
                rptSeguimientos.DataSource = Nothing
                rptSeguimientos.DataBind()
                pnlTablaSeguimientos.Visible = False
                pnlSinSeguimientos.Visible = True
            End If
        Catch ex As Exception
            MostrarError("Error al cargar seguimientos: " & ex.Message)
        End Try
    End Sub


    Private Sub LimpiarPantalla()
        lblIdReporte.Text = ""
        lblChofer.Text = ""
        lblEstadoReporte.Text = ""
        lblTipoAveria.Text = ""
        lblFechaReporte.Text = ""
        lblDescripcion.Text = ""
        pnlInfoReporte.Visible = False

        rptSeguimientos.DataSource = Nothing
        rptSeguimientos.DataBind()
        pnlTablaSeguimientos.Visible = False
        pnlSinSeguimientos.Visible = False
    End Sub

    Protected Sub ddlUnidad_SelectedIndexChanged(sender As Object, e As EventArgs)
        CargarReportesFiltrados()
        LimpiarPantalla()
    End Sub

    Protected Sub ddlReporte_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim idReporte As Integer
        If Integer.TryParse(ddlReporte.SelectedValue, idReporte) AndAlso idReporte > 0 Then
            CargarInfoReporte(idReporte)
            CargarSeguimientos(idReporte)
        Else
            LimpiarPantalla()
        End If
    End Sub

    Protected Sub ddlTipoAveria_SelectedIndexChanged(sender As Object, e As EventArgs)
        CargarReportesFiltrados()
        LimpiarPantalla()
    End Sub

    Protected Sub btnBuscarReporte_Click(sender As Object, e As EventArgs)
        Dim idReporte As Integer
        If Integer.TryParse(txtFiltroReporte.Text.Trim(), idReporte) AndAlso idReporte > 0 Then
            ddlReporte.SelectedValue = "0"
            CargarInfoReporte(idReporte)
            CargarSeguimientos(idReporte)
        Else
            LimpiarPantalla()
        End If
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        CargarReportesFiltrados()
        LimpiarPantalla()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
        ddlUnidad.SelectedIndex = 0
        ddlReporte.SelectedIndex = 0
        ddlTipoAveria.SelectedIndex = 0
        txtFiltroReporte.Text = ""
        txtFechaHora.Text = ""

        CargarReportesFiltrados()
        LimpiarPantalla()
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    Protected Function RenderFotoLinks(ByVal fotoObj As Object) As String
        If fotoObj Is Nothing Then
            Return "Sin foto"
        End If
        Dim fotoJson As String = fotoObj.ToString().Trim()
        If String.IsNullOrEmpty(fotoJson) Then
            Return "Sin foto"
        End If
        Try
            Dim rutas As List(Of String) = JsonConvert.DeserializeObject(Of List(Of String))(fotoJson)
            Dim sb As New StringBuilder()
            For Each r In rutas
                Dim trimmedRuta = r.Trim()
                If Not String.IsNullOrEmpty(trimmedRuta) Then
                    trimmedRuta = trimmedRuta.Replace("~", "")
                    Dim finalRuta As String = ResolveUrl(trimmedRuta)
                    sb.Append($"<a href='{finalRuta}' class='btn btn-sm btn-primary' target='_blank' style='margin-bottom:4px;'>Ver Foto</a><br/>")
                End If
            Next
            If sb.Length = 0 Then
                Return "Sin foto"
            End If
            Return sb.ToString()
        Catch ex As Exception
            Return "Sin foto"
        End Try
    End Function


    Private Sub MostrarError(mensaje As String)
        pnlError.Visible = True
        lblError.Text = mensaje
    End Sub

End Class
