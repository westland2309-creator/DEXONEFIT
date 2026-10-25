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

@WebServlet(name = "EvaluacionesMicrobiotaServlet", urlPatterns = {"/EvaluacionesMicrobiotaServlet"})
public class EvaluacionesMicrobiotaServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de microbiota
        String accion = request.getParameter("accion");
        
        if ("guardarMicrobiota".equals(accion)) {
            String idUsuario = request.getParameter("idUsuario");
            String estadoSaludIntestinal = request.getParameter("estadoSaludIntestinal");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar los datos de microbiota en la BD
                
                request.setAttribute("mensajeExito", "¡Evaluación de microbiota registrada correctamente!");
                request.getRequestDispatcher("evaluaciones_microbiota.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar la evaluación de microbiota: " + e.getMessage());
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
        return "Controlador de Evaluaciones de Microbiota para DEXONEFIT";
    }
}