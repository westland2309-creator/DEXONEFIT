package com.dexonefit.ia;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GuardarEvaluacionClinica", urlPatterns = {"/GuardarEvaluacionClinica"})
public class GuardarEvaluacionClinica extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Capturar los datos del formulario JSP unificado
        String idUsuarioStr = request.getParameter("id_usuario");
        String tipoRegistro = request.getParameter("tipo_registro");
        String nombreCondicion = request.getParameter("nombre_condicion");
        String zonaAfectada = request.getParameter("zona_afectada");
        String tipoLesion = request.getParameter("tipo_lesion");
        String nivelODolor = request.getParameter("nivel_o_dolor");
        String estado = request.getParameter("estado");
        String fecha = request.getParameter("fecha");
        String recomendacionesMeta = request.getParameter("recomendaciones_meta");

        if (idUsuarioStr == null || idUsuarioStr.isEmpty() || nombreCondicion == null || nombreCondicion.isEmpty()) {
            response.sendRedirect("evaluacion_clinica.jsp?error=campos_vacios");
            return;
        }

        try {
            int idUsuario = Integer.parseInt(idUsuarioStr);

            // 2. Conexión directa a MySQL (ajusta el usuario "" y contraseña si tienes una)
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");

            // 3. Sentencia SQL para insertar en la tabla unificada evaluacion_clinica
            String sql = "INSERT INTO evaluacion_clinica (id_usuario, tipo_registro, nombre_condicion, zona_afectada, tipo_lesion, nivel_o_dolor, estado, fecha, recomendaciones_meta) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setString(2, tipoRegistro);
            ps.setString(3, nombreCondicion);
            ps.setString(4, zonaAfectada);
            ps.setString(5, tipoLesion);
            ps.setString(6, nivelODolor);
            ps.setString(7, estado);
            
            if (fecha != null && !fecha.isEmpty()) {
                ps.setString(8, fecha);
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }
            
            ps.setString(9, recomendacionesMeta);
            
            ps.executeUpdate();
            ps.close();
            con.close();

            // 4. Redireccionar con éxito
            response.sendRedirect("evaluacion_clinica.jsp?exito=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("evaluacion_clinica.jsp?error=excepcion");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}