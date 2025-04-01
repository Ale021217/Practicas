Imports System.Data.SqlClient

Partial Public Class dekra
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté autenticado y tenga el rol de "administrador"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarUnidades()
            gvDekra.DataSource = Nothing
            gvDekra.DataBind()
        End If
    End Sub

    Private Sub CargarUnidades()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim sql As String = "
            SELECT id_unidad, (modelo + ' - ' + placa) AS descripcion
            FROM Unidad
            ORDER BY descripcion
        "
        Dim dt As New DataTable()
        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        ddlUnidades.DataSource = dt
        ddlUnidades.DataTextField = "descripcion"
        ddlUnidades.DataValueField = "id_unidad"
        ddlUnidades.DataBind()
        ddlUnidades.Items.Insert(0, New ListItem("Seleccione una unidad", "0"))
    End Sub

    Protected Sub ddlUnidades_SelectedIndexChanged(sender As Object, e As EventArgs)
        If ddlUnidades.SelectedValue = "0" Then
            gvDekra.DataSource = Nothing
            gvDekra.DataBind()
        Else
            CargarDekra(1)
        End If
    End Sub

    Private Sub CargarDekra(pageIndex As Integer)
        Dim idUnidad As Integer = Convert.ToInt32(ddlUnidades.SelectedValue)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString

        ' Calculamos dias_restantes y estado en el SELECT
        Dim sql As String = "
            SELECT 
                d.id_control,
                (SELECT modelo + ' - ' + placa FROM Unidad WHERE id_unidad = d.id_unidad) AS unidad,
                d.fecha_ultima_renovacion,
                d.fecha_proximo_renovacion,
                DATEDIFF(DAY, GETDATE(), d.fecha_proximo_renovacion) AS dias_restantes,
                CASE
                    WHEN DATEDIFF(DAY, GETDATE(), d.fecha_proximo_renovacion) < 0 THEN 'Urgente'
                    WHEN DATEDIFF(DAY, GETDATE(), d.fecha_proximo_renovacion) <= 15 THEN 'Advertencia'
                    ELSE 'Normal'
                END AS estado,
                d.observaciones
            FROM ControlDekra d
            WHERE d.id_unidad = @id_unidad
            ORDER BY d.id_control DESC
        "

        Dim dt As New DataTable()
        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_unidad", idUnidad)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        gvDekra.DataSource = dt
        gvDekra.PageIndex = pageIndex - 1
        gvDekra.DataBind()
    End Sub

    Protected Sub gvDekra_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvDekra.PageIndex = e.NewPageIndex
        CargarDekra(gvDekra.PageIndex + 1)
    End Sub

    Protected Sub gvDekra_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "EditRecord" Then
            Dim idControl As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = CType(CType(e.CommandSource, LinkButton).NamingContainer, GridViewRow)

            hfIdControl.Value = idControl.ToString()
            txtModalFechaUltima.Text = Convert.ToDateTime(gvDekra.DataKeys(row.RowIndex)("fecha_ultima_renovacion")).ToString("yyyy-MM-dd")
            txtModalFechaProximo.Text = Convert.ToDateTime(gvDekra.DataKeys(row.RowIndex)("fecha_proximo_renovacion")).ToString("yyyy-MM-dd")
            txtModalObservaciones.Text = gvDekra.DataKeys(row.RowIndex)("observaciones").ToString()

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)

        ElseIf e.CommandName = "DeleteRecord" Then
            Dim idControl As Integer = Convert.ToInt32(e.CommandArgument)
            EliminarRegistroDekra(idControl)
            CargarDekra(1)
            lblMensaje.Text = "Registro eliminado correctamente."
            lblMensaje.ForeColor = Drawing.Color.Green
        End If
    End Sub

    Private Sub EliminarRegistroDekra(idControl As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim sql As String = "DELETE FROM ControlDekra WHERE id_control = @id_control"

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_control", idControl)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Sub btnModalGuardar_Click(sender As Object, e As EventArgs)
        Page.Validate("vgModal")
        If Not Page.IsValid Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
            Return
        End If

        Try
            Dim idControl As Integer = Convert.ToInt32(hfIdControl.Value)
            Dim fechaUltima As DateTime = Convert.ToDateTime(txtModalFechaUltima.Text)
            Dim fechaProximo As DateTime = Convert.ToDateTime(txtModalFechaProximo.Text)
            Dim observaciones As String = txtModalObservaciones.Text.Trim()

            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim sql As String = "
                UPDATE ControlDekra
                SET fecha_ultima_renovacion = @fecha_ultima,
                    fecha_proximo_renovacion = @fecha_proximo,
                    observaciones = @observaciones
                WHERE id_control = @id_control
            "

            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@fecha_ultima", fechaUltima)
                    cmd.Parameters.AddWithValue("@fecha_proximo", fechaProximo)
                    cmd.Parameters.AddWithValue("@observaciones", If(String.IsNullOrEmpty(observaciones), DBNull.Value, observaciones))
                    cmd.Parameters.AddWithValue("@id_control", idControl)
                    con.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMensaje.Text = "Control Dekra actualizado correctamente."
            lblMensaje.ForeColor = Drawing.Color.Green
            CargarDekra(gvDekra.PageIndex + 1)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideEditModal", "hideEditModal();", True)
        Catch ex As Exception
            divModalError.InnerText = "Error al actualizar: " & ex.Message
            divModalError.Style("display") = "block"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
        End Try
    End Sub

    Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
        Page.Validate("vgDekra")
        If Not Page.IsValid Then
            Return
        End If

        If ddlUnidades.SelectedValue = "0" Then
            lblMensaje.Text = "Seleccione una unidad antes de registrar."
            lblMensaje.ForeColor = Drawing.Color.Red
            Return
        End If

        Try
            Dim idUnidad As Integer = Convert.ToInt32(ddlUnidades.SelectedValue)
            Dim fechaUltima As DateTime = Convert.ToDateTime(txtFechaUltima.Text)
            Dim fechaProximo As DateTime = Convert.ToDateTime(txtFechaProximo.Text)
            Dim observaciones As String = txtObservaciones.Text.Trim()

            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim sql As String = "
                INSERT INTO ControlDekra
                    (id_unidad, fecha_ultima_renovacion, fecha_proximo_renovacion, observaciones)
                VALUES
                    (@id_unidad, @fecha_ultima, @fecha_proximo, @observaciones)
            "

            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@id_unidad", idUnidad)
                    cmd.Parameters.AddWithValue("@fecha_ultima", fechaUltima)
                    cmd.Parameters.AddWithValue("@fecha_proximo", fechaProximo)
                    cmd.Parameters.AddWithValue("@observaciones", If(String.IsNullOrEmpty(observaciones), DBNull.Value, observaciones))
                    con.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMensaje.Text = "Control Dekra registrado correctamente."
            lblMensaje.ForeColor = Drawing.Color.Green
            LimpiarCampos()
            CargarDekra(1)
        Catch ex As Exception
            lblMensaje.Text = "Error al registrar: " & ex.Message
            lblMensaje.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Private Sub LimpiarCampos()
        txtFechaUltima.Text = ""
        txtFechaProximo.Text = ""
        txtObservaciones.Text = ""
    End Sub

    ' Método para el LinkButton de logout
    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    ' Agregado el método gvDekra_RowDataBound para evitar el error de compilación.
    Protected Sub gvDekra_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDekra.RowDataBound
        ' Aquí puedes agregar el código necesario al enlazar cada fila, si es requerido.
    End Sub
End Class
