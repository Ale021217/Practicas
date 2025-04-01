Imports System.Data.SqlClient

Partial Public Class MantenimientoPreventivo
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté autenticado y tenga el rol de "administrador"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarUnidades()
            gvMantenimientos.DataSource = Nothing
            gvMantenimientos.DataBind()
        End If
    End Sub

    Private Sub CargarUnidades()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim sql As String = "SELECT id_unidad, (modelo + ' - ' + placa) AS descripcion FROM Unidad ORDER BY descripcion"
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
            btnRegistrar.Enabled = False
            gvMantenimientos.DataSource = Nothing
            gvMantenimientos.DataBind()
        Else
            btnRegistrar.Enabled = True
            CargarMantenimientos(1)
        End If
    End Sub

    Private Sub CargarMantenimientos(pageIndex As Integer)
        If ddlUnidades.SelectedValue = "0" Then Return

        Dim idUnidad As Integer = Convert.ToInt32(ddlUnidades.SelectedValue)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim sql As String = "
            SELECT 
                m.id_mantenimiento,
                (SELECT modelo + ' - ' + placa FROM Unidad WHERE id_unidad = m.id_unidad) AS unidad,
                m.fecha_cambio,
                m.kilometraje,
                m.proximo_cambio_km,
                m.marca_aceite,
                m.costo_aceite,
                m.observaciones
            FROM dbo.MantenimientoAceite m
            WHERE m.id_unidad = @id_unidad
            ORDER BY m.fecha_cambio DESC, m.id_mantenimiento DESC
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

        gvMantenimientos.DataSource = dt
        gvMantenimientos.PageIndex = pageIndex - 1
        gvMantenimientos.DataBind()
    End Sub

    Protected Sub gvMantenimientos_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        gvMantenimientos.PageIndex = e.NewPageIndex
        CargarMantenimientos(gvMantenimientos.PageIndex + 1)
    End Sub

    Protected Sub gvMantenimientos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Editar" Then
            Dim idMantenimiento As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = CType(CType(e.CommandSource, LinkButton).NamingContainer, GridViewRow)

            hfIdMantenimiento.Value = idMantenimiento.ToString()
            txtModalFechaCambio.Text = Convert.ToDateTime(gvMantenimientos.DataKeys(row.RowIndex)("fecha_cambio")).ToString("yyyy-MM-dd")
            txtModalKilometraje.Text = gvMantenimientos.DataKeys(row.RowIndex)("kilometraje").ToString()
            txtModalProximoCambio.Text = gvMantenimientos.DataKeys(row.RowIndex)("proximo_cambio_km").ToString()
            txtModalMarcaAceite.Text = gvMantenimientos.DataKeys(row.RowIndex)("marca_aceite").ToString()
            txtModalCostoAceite.Text = Convert.ToDecimal(gvMantenimientos.DataKeys(row.RowIndex)("costo_aceite")).ToString("0.00")
            txtModalObservaciones.Text = gvMantenimientos.DataKeys(row.RowIndex)("observaciones").ToString()

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
        ElseIf e.CommandName = "Eliminar" Then
            Dim idMantenimiento As Integer = Convert.ToInt32(e.CommandArgument)
            EliminarMantenimiento(idMantenimiento)
            CargarMantenimientos(1)
            lblMensaje.Text = "Mantenimiento eliminado correctamente."
            lblMensaje.ForeColor = Drawing.Color.Green
        End If
    End Sub

    Private Sub EliminarMantenimiento(idMantenimiento As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim sql As String = "DELETE FROM dbo.MantenimientoAceite WHERE id_mantenimiento = @id_mantenimiento"

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id_mantenimiento", idMantenimiento)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Sub gvMantenimientos_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim kilometrajeActual As Integer = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "kilometraje"))
            Dim proximoCambio As Integer = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "proximo_cambio_km"))
            Dim lblProximoCambio As Label = CType(e.Row.FindControl("lblProximoCambio"), Label)

            ' Marcar en rojo si ya pasó el kilometraje para cambio
            If kilometrajeActual >= proximoCambio Then
                lblProximoCambio.CssClass = "urgente-cambio"
            ElseIf (proximoCambio - kilometrajeActual) <= 1000 Then ' Avisar si faltan 1000 km o menos
                lblProximoCambio.CssClass = "proximo-cambio"
            End If
        End If
    End Sub

    Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return
        If ddlUnidades.SelectedValue = "0" Then
            lblMensaje.Text = "Seleccione una unidad antes de registrar."
            lblMensaje.ForeColor = Drawing.Color.Red
            Return
        End If

        ' Validación adicional de números
        If Not EsNumeroEntero(txtKilometraje.Text) Then
            lblMensaje.Text = "El kilometraje debe ser un número entero."
            lblMensaje.ForeColor = Drawing.Color.Red
            Return
        End If

        If Not EsNumeroEntero(txtProximoCambio.Text) Then
            lblMensaje.Text = "El próximo cambio debe ser un número entero."
            lblMensaje.ForeColor = Drawing.Color.Red
            Return
        End If

        If Not EsNumeroDecimal(txtCostoAceite.Text) Then
            lblMensaje.Text = "El costo debe ser un número válido."
            lblMensaje.ForeColor = Drawing.Color.Red
            Return
        End If

        Try
            Dim idUnidad As Integer = Convert.ToInt32(ddlUnidades.SelectedValue)
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim sql As String = "
                INSERT INTO dbo.MantenimientoAceite
                    (id_unidad, fecha_cambio, kilometraje, proximo_cambio_km, marca_aceite, costo_aceite, observaciones)
                VALUES
                    (@id_unidad, @fecha_cambio, @kilometraje, @proximo_cambio_km, @marca_aceite, @costo_aceite, @observaciones)
            "

            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@id_unidad", idUnidad)
                    cmd.Parameters.AddWithValue("@fecha_cambio", Convert.ToDateTime(txtFechaCambio.Text))
                    cmd.Parameters.AddWithValue("@kilometraje", Convert.ToInt32(txtKilometraje.Text))
                    cmd.Parameters.AddWithValue("@proximo_cambio_km", Convert.ToInt32(txtProximoCambio.Text))
                    cmd.Parameters.AddWithValue("@marca_aceite", txtMarcaAceite.Text.Trim())

                    Dim costo As Decimal = 0
                    Decimal.TryParse(txtCostoAceite.Text, costo)
                    cmd.Parameters.AddWithValue("@costo_aceite", costo)

                    cmd.Parameters.AddWithValue("@observaciones", If(String.IsNullOrEmpty(txtObservaciones.Text), DBNull.Value, txtObservaciones.Text.Trim()))

                    con.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMensaje.Text = "Mantenimiento registrado correctamente."
            lblMensaje.ForeColor = Drawing.Color.Green
            LimpiarCampos()
            CargarMantenimientos(1)
        Catch ex As Exception
            lblMensaje.Text = "Error al registrar mantenimiento: " & ex.Message
            lblMensaje.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Protected Sub btnModalGuardar_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return

        ' Validación adicional de números
        If Not EsNumeroEntero(txtModalKilometraje.Text) Then
            divModalError.InnerText = "El kilometraje debe ser un número entero."
            divModalError.Style("display") = "block"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
            Return
        End If

        If Not EsNumeroEntero(txtModalProximoCambio.Text) Then
            divModalError.InnerText = "El próximo cambio debe ser un número entero."
            divModalError.Style("display") = "block"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
            Return
        End If

        If Not EsNumeroDecimal(txtModalCostoAceite.Text) Then
            divModalError.InnerText = "El costo debe ser un número válido."
            divModalError.Style("display") = "block"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
            Return
        End If

        Try
            Dim idMantenimiento As Integer = Convert.ToInt32(hfIdMantenimiento.Value)
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim sql As String = "
                UPDATE dbo.MantenimientoAceite
                SET fecha_cambio = @fecha_cambio,
                    kilometraje = @kilometraje,
                    proximo_cambio_km = @proximo_cambio_km,
                    marca_aceite = @marca_aceite,
                    costo_aceite = @costo_aceite,
                    observaciones = @observaciones
                WHERE id_mantenimiento = @id_mantenimiento
            "

            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@id_mantenimiento", idMantenimiento)
                    cmd.Parameters.AddWithValue("@fecha_cambio", Convert.ToDateTime(txtModalFechaCambio.Text))
                    cmd.Parameters.AddWithValue("@kilometraje", Convert.ToInt32(txtModalKilometraje.Text))
                    cmd.Parameters.AddWithValue("@proximo_cambio_km", Convert.ToInt32(txtModalProximoCambio.Text))
                    cmd.Parameters.AddWithValue("@marca_aceite", txtModalMarcaAceite.Text.Trim())

                    Dim costo As Decimal = 0
                    Decimal.TryParse(txtModalCostoAceite.Text, costo)
                    cmd.Parameters.AddWithValue("@costo_aceite", costo)

                    cmd.Parameters.AddWithValue("@observaciones", If(String.IsNullOrEmpty(txtModalObservaciones.Text), DBNull.Value, txtModalObservaciones.Text.Trim()))

                    con.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMensaje.Text = "Mantenimiento actualizado correctamente."
            lblMensaje.ForeColor = Drawing.Color.Green
            CargarMantenimientos(gvMantenimientos.PageIndex + 1)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HideEditModal", "hideEditModal();", True)
        Catch ex As Exception
            divModalError.InnerText = "Error al actualizar: " & ex.Message
            divModalError.Style("display") = "block"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowEditModal", "showEditModal();", True)
        End Try
    End Sub

    Private Sub LimpiarCampos()
        txtFechaCambio.Text = ""
        txtKilometraje.Text = ""
        txtProximoCambio.Text = ""
        txtMarcaAceite.Text = ""
        txtCostoAceite.Text = ""
        txtObservaciones.Text = ""
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub

    ' Funciones auxiliares para validación
    Private Function EsNumeroEntero(valor As String) As Boolean
        Dim resultado As Integer
        Return Integer.TryParse(valor, resultado)
    End Function

    Private Function EsNumeroDecimal(valor As String) As Boolean
        Dim resultado As Decimal
        Return Decimal.TryParse(valor, resultado)
    End Function
End Class