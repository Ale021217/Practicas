Imports System.Data.SqlClient

Public Class Unidad
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then

            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If


        If Not IsPostBack Then
            CargarUnidades()
            txtAnio.Attributes.Add("inputmode", "numeric")
        End If
    End Sub


    Protected Sub btnCrearUnidad_Click(sender As Object, e As EventArgs)
        Dim marca As String = txtMarca.Text.Trim()
        Dim modelo As String = txtModelo.Text.Trim()
        Dim anio As String = txtAnio.Text.Trim()
        Dim placa As String = txtPlaca.Text.Trim()
        Dim estado As String = ddlEstado.SelectedValue

        ' Validaciones básicas
        If String.IsNullOrEmpty(marca) OrElse String.IsNullOrEmpty(modelo) OrElse
           String.IsNullOrEmpty(anio) OrElse String.IsNullOrEmpty(placa) Then
            alertError.Visible = True
            alertError.InnerText = "Todos los campos son obligatorios."
            alertSuccess.Visible = False
            Return
        End If

        Dim anioNum As Integer
        If Not Integer.TryParse(anio, anioNum) Then
            alertError.Visible = True
            alertError.InnerText = "El año debe ser un número válido."
            alertSuccess.Visible = False
            Return
        End If

        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()

            ' Verificar que la placa no exista
            Dim sqlCheck As String = "SELECT COUNT(*) FROM Unidad WHERE placa = @placa"
            Using cmdCheck As New SqlCommand(sqlCheck, con)
                cmdCheck.Parameters.AddWithValue("@placa", placa)
                Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())
                If count > 0 Then
                    alertError.Visible = True
                    alertError.InnerText = "Error: La placa ya existe."
                    alertSuccess.Visible = False
                    Return
                End If
            End Using

            Dim sqlInsert As String = "INSERT INTO Unidad (modelo, marca, ano, placa, estado) " &
                                      "VALUES (@modelo, @marca, @anio, @placa, @estado)"
            Using cmd As New SqlCommand(sqlInsert, con)
                cmd.Parameters.AddWithValue("@modelo", modelo)
                cmd.Parameters.AddWithValue("@marca", marca)
                cmd.Parameters.AddWithValue("@anio", anioNum)
                cmd.Parameters.AddWithValue("@placa", placa)
                cmd.Parameters.AddWithValue("@estado", estado)

                Try
                    cmd.ExecuteNonQuery()
                    alertSuccess.Visible = True
                    alertError.Visible = False

                    ' Limpiar campos
                    txtMarca.Text = ""
                    txtModelo.Text = ""
                    txtAnio.Text = ""
                    txtPlaca.Text = ""
                    ddlEstado.SelectedIndex = 0

                    CargarUnidades()
                Catch ex As Exception
                    Dim sqlEx As SqlException = TryCast(ex, SqlException)
                    If sqlEx IsNot Nothing AndAlso (sqlEx.Number = 2627 OrElse sqlEx.Number = 2601 OrElse ex.Message.Contains("UQ_Unidad_Placa")) Then
                        alertError.Visible = True
                        alertError.InnerText = "Error: La placa ya existe."
                        alertSuccess.Visible = False
                    Else
                        alertError.Visible = True
                        alertError.InnerText = "Error al crear la unidad: " & ex.Message
                        alertSuccess.Visible = False
                    End If
                End Try
            End Using
        End Using
    End Sub

    Private Sub CargarUnidades()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT id_unidad, marca, modelo, ano, placa, estado FROM Unidad"
            Using cmd As New SqlCommand(sql, con)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        gvUnidades.DataSource = dt
        gvUnidades.DataBind()
    End Sub


    Protected Sub gvUnidades_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvUnidades.RowCommand
        If e.CommandName = "EditarUnidad" Then
            Dim idUnidad As Integer = Convert.ToInt32(e.CommandArgument)
            CargarUnidadParaEdicion(idUnidad)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalUnidadEdit",
                "var myModal = new bootstrap.Modal(document.getElementById('modalUnidadEdit')); myModal.show();", True)
        ElseIf e.CommandName = "EliminarUnidad" Then
            Dim idUnidad As Integer = Convert.ToInt32(e.CommandArgument)
            EliminarUnidad(idUnidad)
        End If
    End Sub

    Private Sub CargarUnidadParaEdicion(idUnidad As Integer)
        hfIdUnidadEdit.Value = idUnidad.ToString()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "SELECT id_unidad, marca, modelo, ano, placa, estado FROM Unidad WHERE id_unidad = @id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id", idUnidad)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtMarcaEdit.Text = reader("marca").ToString()
                        txtModeloEdit.Text = reader("modelo").ToString()
                        txtAnioEdit.Text = reader("ano").ToString()
                        txtPlacaEdit.Text = reader("placa").ToString()
                        ddlEstadoEdit.SelectedValue = reader("estado").ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub


    Protected Sub btnGuardarUnidad_Click(sender As Object, e As EventArgs)
        Try
            Dim idUnidad As Integer = Convert.ToInt32(hfIdUnidadEdit.Value)
            Dim marca As String = txtMarcaEdit.Text.Trim()
            Dim modelo As String = txtModeloEdit.Text.Trim()
            Dim anio As Integer
            If Not Integer.TryParse(txtAnioEdit.Text.Trim(), anio) Then
                Throw New Exception("El año debe ser un número válido.")
            End If
            Dim estado As String = ddlEstadoEdit.SelectedValue

            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Using con As New SqlConnection(conStr)
                con.Open()
                Dim sql As String = "UPDATE Unidad SET marca=@marca, modelo=@modelo, ano=@anio, estado=@estado WHERE id_unidad=@id"
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@marca", marca)
                    cmd.Parameters.AddWithValue("@modelo", modelo)
                    cmd.Parameters.AddWithValue("@anio", anio)
                    cmd.Parameters.AddWithValue("@estado", estado)
                    cmd.Parameters.AddWithValue("@id", idUnidad)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            CargarUnidades()
        Catch ex As Exception

        End Try
    End Sub


    Private Sub EliminarUnidad(idUnidad As Integer)
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            Dim sql As String = "DELETE FROM Unidad WHERE id_unidad = @id"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@id", idUnidad)
                Try
                    cmd.ExecuteNonQuery()
                Catch ex As Exception

                End Try
            End Using
        End Using
        CargarUnidades()
    End Sub


    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
