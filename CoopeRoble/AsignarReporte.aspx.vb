Imports System.Data.SqlClient

Public Class AsignarReporte
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        ' Verificar que el usuario tenga rol de administrador
        If Session("id_usuario") Is Nothing OrElse Session("rol") Is Nothing OrElse
           Session("rol").ToString().Trim().ToLower() <> "administrador" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarMecanicos()
            CargarReportesPendientes()
            CargarAsignaciones()
            CargarNuevoMecanicos() ' Para el modal de editar asignación
        End If
    End Sub

    Private Sub CargarMecanicos()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT id_usuario, nombre FROM Usuarios WHERE rol = 'mecanico'"
            Using cmd As New SqlCommand(sql, con)
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.HasRows Then
                        ddlMecanicos.DataSource = dr
                        ddlMecanicos.DataValueField = "id_usuario"
                        ddlMecanicos.DataTextField = "nombre"
                        ddlMecanicos.DataBind()
                    End If
                End Using
            End Using
        End Using
        ddlMecanicos.Items.Insert(0, New ListItem("Seleccione un mecánico", ""))
    End Sub

    Private Sub CargarNuevoMecanicos()
        ' Cargar mecánicos para el modal de edición
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT id_usuario, nombre FROM Usuarios WHERE rol = 'mecanico'"
            Using cmd As New SqlCommand(sql, con)
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.HasRows Then
                        ddlNuevoMecanico.DataSource = dr
                        ddlNuevoMecanico.DataValueField = "id_usuario"
                        ddlNuevoMecanico.DataTextField = "nombre"
                        ddlNuevoMecanico.DataBind()
                    End If
                End Using
            End Using
        End Using
        ddlNuevoMecanico.Items.Insert(0, New ListItem("Seleccione un mecánico", ""))
    End Sub

    Private Sub CargarReportesPendientes()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "
                SELECT
                    R.id_reporte,
                    'Reporte ' + CAST(R.id_reporte AS VARCHAR(10)) + ' - ' + ISNULL(A.tipo_averia, '(sin tipo)') AS display_text
                FROM Reporte R
                INNER JOIN Averias A ON R.tipo_averia = A.id_averias
                WHERE LOWER(LTRIM(RTRIM(R.estado))) = 'pendiente'
                ORDER BY R.id_reporte DESC
            "
            Try
                Using cmd As New SqlCommand(sql, con)
                    Using dr As SqlDataReader = cmd.ExecuteReader()
                        If dr.HasRows Then
                            ddlReportes.DataSource = dr
                            ddlReportes.DataValueField = "id_reporte"
                            ddlReportes.DataTextField = "display_text"
                            ddlReportes.DataBind()
                        End If
                    End Using
                End Using
            Catch ex As Exception
                lblMensajeError.Text = "Error al cargar reportes pendientes: " & ex.Message
            End Try
        End Using
        ddlReportes.Items.Insert(0, New ListItem("Seleccione un reporte", ""))
    End Sub

    Public Sub btnAsignar_Click(sender As Object, e As EventArgs)
        ' Validaciones
        If String.IsNullOrEmpty(ddlMecanicos.SelectedValue) Then
            lblMensajeError.Text = "Por favor, seleccione un mecánico."
            Return
        End If
        If String.IsNullOrEmpty(ddlReportes.SelectedValue) Then
            lblMensajeError.Text = "Por favor, seleccione un reporte."
            Return
        End If

        Dim idMecanico As Integer = Convert.ToInt32(ddlMecanicos.SelectedValue)
        Dim idReporte As Integer = Convert.ToInt32(ddlReportes.SelectedValue)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString

        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "
                UPDATE Reporte
                SET usuarioAsignado = @idMecanico,
                    estado = 'en proceso'
                WHERE id_reporte = @idReporte
            "
            Try
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@idMecanico", idMecanico)
                    cmd.Parameters.AddWithValue("@idReporte", idReporte)
                    cmd.ExecuteNonQuery()
                End Using

                lblMensajeExito.Text = "Reporte asignado correctamente (estado en proceso)."
                CargarReportesPendientes()
                CargarAsignaciones()
            Catch ex As Exception
                lblMensajeError.Text = "Ocurrió un error al asignar el reporte: " & ex.Message
            End Try
        End Using
    End Sub

    Private Sub CargarAsignaciones()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "
                SELECT 
                    R.id_reporte,
                    R.descripcion,
                    ISNULL(U.nombre, 'Sin Asignar') AS mecanico,
                    R.estado
                FROM Reporte R
                LEFT JOIN Usuarios U ON R.usuarioAsignado = U.id_usuario
                WHERE LOWER(LTRIM(RTRIM(R.estado))) = 'en proceso'
                ORDER BY R.id_reporte DESC
            "
            Try
                Using cmd As New SqlCommand(sql, con)
                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            Catch ex As Exception
                lblMensajeError.Text = "Error al cargar asignaciones: " & ex.Message
            End Try
        End Using
        gvAsignaciones.DataSource = dt
        gvAsignaciones.DataBind()
    End Sub

    Protected Sub gvAsignaciones_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "EditarAsignacion" Then
            Dim idReporte As Integer = Convert.ToInt32(e.CommandArgument)
            ViewState("idReporteEditar") = idReporte
            ' Abre el modal de editar asignación
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "AbrirModal", "abrirModalEditarAsignacion();", True)
        End If
    End Sub

    Protected Sub btnGuardarAsignacion_Click(sender As Object, e As EventArgs)
        If ViewState("idReporteEditar") Is Nothing Then
            lblMensajeError.Text = "Error: No se seleccionó un reporte para editar."
            Return
        End If

        If String.IsNullOrEmpty(ddlNuevoMecanico.SelectedValue) Then
            lblMensajeError.Text = "Por favor, seleccione un nuevo mecánico."
            Return
        End If

        Dim idReporte As Integer = Convert.ToInt32(ViewState("idReporteEditar"))
        Dim idNuevoMecanico As Integer = Convert.ToInt32(ddlNuevoMecanico.SelectedValue)
        Dim motivo As String = txtMotivo.Text.Trim()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString

        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sqlUpdate As String = "
                UPDATE Reporte
                SET usuarioAsignado = @idNuevoMecanico
                WHERE id_reporte = @idReporte
            "
            Try
                Using cmdUpdate As New SqlCommand(sqlUpdate, con)
                    cmdUpdate.Parameters.AddWithValue("@idNuevoMecanico", idNuevoMecanico)
                    cmdUpdate.Parameters.AddWithValue("@idReporte", idReporte)
                    cmdUpdate.ExecuteNonQuery()
                End Using

                ' Insertamos registro en la tabla Reparaciones para dejar constancia del cambio
                Dim sqlInsert As String = "
                    INSERT INTO Reparaciones (id_reporte, id_usuario, fecha_entrada, descripcion_reparacion, estado_reporte_momento)
                    VALUES (@idReporte, @idNuevoMecanico, GETDATE(), @descripcion, 'Reasignado')
                "
                Dim descripcion As String = "El reporte fue reasignado a nuevo mecánico (ID " & idNuevoMecanico & ")"
                If Not String.IsNullOrEmpty(motivo) Then
                    descripcion &= " - Motivo: " & motivo
                End If

                Using cmdInsert As New SqlCommand(sqlInsert, con)
                    cmdInsert.Parameters.AddWithValue("@idReporte", idReporte)
                    cmdInsert.Parameters.AddWithValue("@idNuevoMecanico", idNuevoMecanico)
                    cmdInsert.Parameters.AddWithValue("@descripcion", descripcion)
                    cmdInsert.ExecuteNonQuery()
                End Using

                lblMensajeExito.Text = "Asignación actualizada y registrada en historial."
                CargarAsignaciones()

                ' Forzar recarga completa de la página
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "reload", "window.top.location.href = window.top.location.href;", True)
            Catch ex As Exception
                lblMensajeError.Text = "Error al actualizar la asignación: " & ex.Message
            End Try
        End Using

        ' Limpiar el modal
        ddlNuevoMecanico.ClearSelection()
        txtMotivo.Text = ""
    End Sub

    Public Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
