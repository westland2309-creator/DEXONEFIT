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

@WebServlet(name = "EntrenamientosServlet", urlPatterns = {"/EntrenamientosServlet"})
public class EntrenamientosServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de entrenamientos
        String accion = request.getParameter("accion");
        
        if ("guardarEntrenamiento".equals(accion)) {
            String tipoEntrenamiento = request.getParameter("tipoEntrenamiento");
            String observaciones = request.getParameter("observaciones");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar el entrenamiento en la BD
                
                request.setAttribute("mensajeExito", "¡Entrenamiento registrado correctamente!");
                request.getRequestDispatcher("entrenamientos.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar el entrenamiento: " + e.getMessage());
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
        return "Controlador de Entrenamientos para DEXONEFIT";
    }
}