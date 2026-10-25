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

@WebServlet(name = "EjerciciosServlet", urlPatterns = {"/EjerciciosServlet"})
public class EjerciciosServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de ejercicios
        String accion = request.getParameter("accion");
        
        if ("registrarEjercicio".equals(accion)) {
            String nombreEjercicio = request.getParameter("nombreEjercicio");
            String grupoMuscular = request.getParameter("grupoMuscular");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar el ejercicio en la BD
                
                request.setAttribute("mensajeExito", "¡Ejercicio registrado correctamente!");
                request.getRequestDispatcher("ejercicios.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar el ejercicio: " + e.getMessage());
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
        return "Controlador de Ejercicios para DEXONEFIT";
    }
}