Imports System.Data.SqlClient

Public Class Averias
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté autenticado y tenga el rol de "administrador"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then
            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If

        If Not IsPostBack Then
            CargarAverias()
        End If
    End Sub


    Protected Sub btnCrearAveria_Click(sender As Object, e As EventArgs)
        Dim tipoAveria As String = txtTipoAveria.Text.Trim()

        If String.IsNullOrEmpty(tipoAveria) Then
            alertError.Visible = True
            alertError.InnerText = "El campo Tipo de Avería es obligatorio."
            alertSuccess.Visible = False
            Return
        End If

        If String.IsNullOrEmpty(ddlEstado.SelectedValue) Then
            alertError.Visible = True
            alertError.InnerText = "Debe seleccionar un estado para la avería."
            alertSuccess.Visible = False
            Return
        End If

        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()

            ' Validar si el tipo de avería ya existe en la base de datos
            Dim sqlCheck As String = "SELECT COUNT(*) FROM Averias WHERE UPPER(LTRIM(RTRIM(tipo_averia))) = UPPER(@tipoAveria)"
            Using cmdCheck As New SqlCommand(sqlCheck, con)
                cmdCheck.Parameters.AddWithValue("@tipoAveria", tipoAveria)
                Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())
                If count > 0 Then
                    alertError.Visible = True
                    alertError.InnerText = "El tipo de avería ya se encuentra registrada."
                    alertSuccess.Visible = False
                    Return
                End If
            End Using

            Dim estadoAveria As String = ddlEstado.SelectedValue
            Dim sql As String = "INSERT INTO Averias (tipo_averia, estado) VALUES (@tipo_averia, @estado)"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@tipo_averia", tipoAveria)
                cmd.Parameters.AddWithValue("@estado", estadoAveria)
                Try
                    cmd.ExecuteNonQuery()
                    alertSuccess.Visible = True
                    alertError.Visible = False
                    txtTipoAveria.Text = ""
                    ddlEstado.ClearSelection()
                    ddlEstado.Items.FindByValue("").Selected = True
                    CargarAverias()
                Catch ex As Exception
                    alertError.Visible = True
                    alertError.InnerText = "Ocurrió un error al agregar la avería."
                    alertSuccess.Visible = False
                End Try
            End Using
        End Using
    End Sub



    Private Sub CargarAverias()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()

        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT id_averias, tipo_averia, estado FROM Averias"
            Using cmd As New SqlCommand(sql, con)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        gvAverias.DataSource = dt
        gvAverias.DataBind()
    End Sub

    Protected Sub gvAverias_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAverias.RowCommand
        If e.CommandName = "EditarAveria" Then
            Dim idAveria As Integer = Convert.ToInt32(e.CommandArgument)
            CargarAveria(idAveria)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalAveria", "mostrarModalAveria();", True)
        ElseIf e.CommandName = "EliminarAveria" Then
            Dim idAveria As Integer = Convert.ToInt32(e.CommandArgument)
            EliminarAveria(idAveria)
        End If
    End Sub


    Private Sub CargarAveria(idAveria As Integer)
        hfIdAveria.Value = idAveria.ToString()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString

        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT tipo_averia, estado FROM Averias WHERE id_averias = @id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id", idAveria)
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.Read() Then
                        txtEditarAveria.Text = dr("tipo_averia").ToString()
                        ' Guardamos el valor original en un HiddenField
                        Dim estadoValue As String = dr("estado").ToString().ToLower().Trim()
                        hfEstadoOriginal.Value = estadoValue
                        ' Asignamos al dropdown de edición si existe el valor
                        If ddlEditarEstado.Items.FindByValue(estadoValue) IsNot Nothing Then
                            ddlEditarEstado.SelectedValue = estadoValue
                        Else
                            ddlEditarEstado.SelectedIndex = 0
                        End If
                    End If
                End Using
            End Using
        End Using
    End Sub


    Protected Sub btnActualizarAveria_Click(sender As Object, e As EventArgs)
        Dim idAveria As Integer = Convert.ToInt32(hfIdAveria.Value)
        Dim nuevoTipo As String = txtEditarAveria.Text.Trim()

        If String.IsNullOrEmpty(nuevoTipo) Then
            alertError.Visible = True
            alertError.InnerText = "El campo Tipo de Avería no puede estar vacío."
            Return
        End If

        ' Si el usuario no cambia la selección, usamos el valor original almacenado
        Dim nuevoEstado As String = ddlEditarEstado.SelectedValue
        If String.IsNullOrEmpty(nuevoEstado) Then
            nuevoEstado = hfEstadoOriginal.Value
        End If

        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString

        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "UPDATE Averias SET tipo_averia = @nuevoTipo, estado = @nuevoEstado WHERE id_averias = @id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@nuevoTipo", nuevoTipo)
                cmd.Parameters.AddWithValue("@nuevoEstado", nuevoEstado)
                cmd.Parameters.AddWithValue("@id", idAveria)
                Try
                    cmd.ExecuteNonQuery()
                    CargarAverias()
                Catch ex As Exception
                    ' Opcional: manejo de error
                End Try
            End Using
        End Using
    End Sub

    ' ========================
    ' ELIMINAR AVERÍA
    ' ========================
    Private Sub EliminarAveria(idAveria As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString

        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "DELETE FROM Averias WHERE id_averias = @id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id", idAveria)
                Try
                    cmd.ExecuteNonQuery()
                Catch ex As Exception
                    ' Opcional: manejo de error
                End Try
            End Using
        End Using

        CargarAverias()
    End Sub


    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
