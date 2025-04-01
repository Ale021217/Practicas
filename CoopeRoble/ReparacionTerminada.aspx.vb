Imports System.Data.SqlClient

Partial Public Class ReparacionTerminada
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' Verificar que el usuario esté logueado y que su rol sea "mecanico"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "mecanico" Then

            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If


        If Not IsPostBack Then
            CargarReportesTerminados()
        End If
    End Sub


    Private Sub CargarReportesTerminados()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()


        Dim idMecanico As Integer = Convert.ToInt32(Session("id_usuario"))

        Dim sql As String = "
            SELECT 
                MAX(R.id_reparaciones) AS id_reparaciones,
                R.id_reporte,
                MAX(R.fecha_entrada) AS fecha_entrada,
                MAX(R.fecha_salida) AS fecha_salida,
                MAX(R.descripcion_reparacion) AS descripcion_reparacion,
                MAX(R.imagen_reparacion) AS imagen_reparacion,
                MAX(R.falla_adicional) AS falla_adicional,
                Rep.estado
            FROM Reparaciones R
            INNER JOIN Reporte Rep ON R.id_reporte = Rep.id_reporte
            WHERE LOWER(Rep.estado) = 'terminado'
              AND R.fecha_salida >= DATEADD(day, -5, GETDATE())
              AND R.id_usuario = @idMecanico
            GROUP BY R.id_reporte, Rep.estado
            ORDER BY MAX(R.fecha_salida) DESC
        "

        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@idMecanico", idMecanico)
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using

        rptReportesTerminados.DataSource = dt
        rptReportesTerminados.DataBind()
    End Sub

    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class