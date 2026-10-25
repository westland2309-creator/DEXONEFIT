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

@WebServlet(name = "VolumenEntrenamientoServlet", urlPatterns = {"/VolumenEntrenamientoServlet"})
public class VolumenEntrenamientoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de volumen de entrenamiento
        String accion = request.getParameter("accion");
        
        if ("guardarVolumen".equals(accion)) {
            String idEjercicio = request.getParameter("idEjercicio");
            String series = request.getParameter("series");
            String repeticiones = request.getParameter("repeticiones");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar el volumen de entrenamiento en la BD
                
                request.setAttribute("mensajeExito", "¡Volumen de entrenamiento registrado correctamente!");
                request.getRequestDispatcher("volumen_entrenamiento.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar el volumen de entrenamiento: " + e.getMessage());
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
        return "Controlador de Volumen de Entrenamiento para DEXONEFIT";
    }
}