package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.conexion;
import java.sql.Connection;

@WebServlet(name = "EvaluacionClinicaServlet", urlPatterns = {"/EvaluacionClinicaServlet"})
public class EvaluacionClinicaServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de evaluación clínica
        String accion = request.getParameter("accion");
        
        if ("guardarEvaluacion".equals(accion)) {
            String idUsuario = request.getParameter("idUsuario");
            String observacionesClinicas = request.getParameter("observacionesClinicas");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar la evaluación clínica en la BD
                
                request.setAttribute("mensajeExito", "¡Evaluación clínica registrada correctamente!");
                request.getRequestDispatcher("evaluacion_clinica.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar la evaluación clínica: " + e.getMessage());
            }
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

    @Override
    public String getServletInfo() {
        return "Controlador de Evaluacion Clinica para DEXONEFIT";
    }
}