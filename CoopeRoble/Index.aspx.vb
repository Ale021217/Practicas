Imports System.Data.SqlClient

Public Class Index
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Verificar que el usuario esté logueado y que su rol sea "administrador"
        If Session("id_usuario") Is Nothing OrElse Session("rol").ToString().Trim().ToLower() <> "administrador" Then

            Response.Redirect("Login.aspx?mensaje=Acceso+denegado")
        End If


        If Not IsPostBack Then

            CargarResumen()
            CargarUltimosReportes()
            CargarAveriasHabituales()
            CargarUnidadesProblemas()
        End If
    End Sub


    Private Sub CargarResumen()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Using con As New SqlConnection(conStr)
            con.Open()
            ' Total Averías
            Dim totalQuery As String = "SELECT COUNT(*) FROM Reporte"
            Using cmd As New SqlCommand(totalQuery, con)
                lblTotalAverias.Text = cmd.ExecuteScalar().ToString()
            End Using

            ' Averías Pendientes
            Dim pendientesQuery As String = "SELECT COUNT(*) FROM Reporte WHERE estado = 'pendiente'"
            Using cmd As New SqlCommand(pendientesQuery, con)
                lblPendientes.Text = cmd.ExecuteScalar().ToString()
            End Using

            ' Averías en Proceso
            Dim enProcesoQuery As String = "SELECT COUNT(*) FROM Reporte WHERE estado = 'en proceso'"
            Using cmd As New SqlCommand(enProcesoQuery, con)
                lblEnProceso.Text = cmd.ExecuteScalar().ToString()
            End Using

            ' Reportes Terminados
            Dim terminadosQuery As String = "SELECT COUNT(*) FROM Reporte WHERE estado = 'terminado'"
            Using cmd As New SqlCommand(terminadosQuery, con)
                lblReportesTerminados.Text = cmd.ExecuteScalar().ToString()
            End Using
        End Using
    End Sub

    ' Cargar Últimos Reportes de Averías
    Private Sub CargarUltimosReportes()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Dim sql As String = "SELECT TOP 5 id_reporte, descripcion, fecha_reporte, estado " &
                            "FROM Reporte " &
                            "ORDER BY fecha_reporte DESC"
        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using
        rptUltimosReportes.DataSource = dt
        rptUltimosReportes.DataBind()
    End Sub

    ' Cargar Averías Más Habituales
    Private Sub CargarAveriasHabituales()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Dim sql As String = "
            SELECT TOP 5 A.tipo_averia, COUNT(*) AS Cantidad
            FROM Reporte R
            INNER JOIN Averias A ON R.tipo_averia = A.id_averias
            GROUP BY A.tipo_averia
            ORDER BY Cantidad DESC
        "
        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using
        rptAveriasHabituales.DataSource = dt
        rptAveriasHabituales.DataBind()
    End Sub

    ' Cargar Unidades con Más Problemas (incluyendo el estado)
    Private Sub CargarUnidadesProblemas()
        Dim conStr As String = ConfigurationManager.ConnectionStrings("cadena").ConnectionString
        Dim dt As New DataTable()
        Dim sql As String = "
            SELECT TOP 5 
                (Un.modelo + ' - ' + Un.placa) AS Unidad, 
                Un.estado,
                COUNT(*) AS Cantidad
            FROM Reporte R
            INNER JOIN Unidad Un ON R.unidad = Un.id_unidad
            GROUP BY Un.modelo, Un.placa, Un.estado
            ORDER BY Cantidad DESC
        "
        Using con As New SqlConnection(conStr)
            Using cmd As New SqlCommand(sql, con)
                Using sda As New SqlDataAdapter(cmd)
                    sda.Fill(dt)
                End Using
            End Using
        End Using
        rptUnidadesProblemas.DataSource = dt
        rptUnidadesProblemas.DataBind()
    End Sub

    ' Evento de Logout
    Protected Sub lnkLogout_Click(sender As Object, e As EventArgs)
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
End Class
