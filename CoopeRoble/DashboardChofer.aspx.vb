Imports System.Data.SqlClient

Namespace CoopeRoble
    Partial Public Class DashboardChofer
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "chofer" Then
                Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
            End If


            If Not IsPostBack Then

                CargarMisReportes()
            End If
        End Sub


        Private Sub CargarMisReportes()
            Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
            Dim dt As New DataTable()
            Dim sql As String = "
        SELECT 
            id_reporte,
            fecha_reporte,
            (SELECT modelo + ' - ' + placa FROM Unidad WHERE id_unidad = R.unidad) AS Unidad,
            descripcion,
            estado,
            imagen_averia
        FROM Reporte R
        WHERE id_usuario = @id_usuario
          AND estado IN ('pendiente', 'en proceso')
        ORDER BY fecha_reporte DESC
    "
            Using con As New SqlConnection(conStr)
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@id_usuario", Session("id_usuario"))
                    Using sda As New SqlDataAdapter(cmd)
                        sda.Fill(dt)
                    End Using
                End Using
            End Using

            rptReportes.DataSource = dt
            rptReportes.DataBind()
        End Sub


        ' Evento para el link "Crear Nuevo Reporte"
        Protected Sub lnkNuevoReporte_Click(sender As Object, e As EventArgs)
            Response.Redirect("Reporte.aspx")
        End Sub


        Protected Sub lnkMisReportes_Click(sender As Object, e As EventArgs)
            CargarMisReportes()
        End Sub

        ' Evento para ver detalle (redirección si se desea)
        Protected Sub lnkVerDetalle_Command(sender As Object, e As CommandEventArgs)
            Dim idReporte As String = e.CommandArgument.ToString()
            Response.Redirect("DetalleReporte.aspx?id=" & idReporte)
        End Sub

        ' Ver perfil del chofer
        Protected Sub lnkPerfil_Click(sender As Object, e As EventArgs)
            Response.Redirect("PerfilChofer.aspx")
        End Sub

        ' Cerrar sesión
        Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
            Session.Clear()
            Response.Redirect("Login.aspx")
        End Sub
    End Class
End Namespace
