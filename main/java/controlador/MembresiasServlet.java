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

@WebServlet(name = "MembresiasServlet", urlPatterns = {"/MembresiasServlet"})
public class MembresiasServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de membresías
        String accion = request.getParameter("accion");
        
        if ("guardarMembresia".equals(accion)) {
            String tipoMembresia = request.getParameter("tipoMembresia");
            String duracion = request.getParameter("duracion");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar la membresía en la BD
                
                request.setAttribute("mensajeExito", "¡Membresía registrada correctamente!");
                request.getRequestDispatcher("membresias.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar la membresía: " + e.getMessage());
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
        return "Controlador de Membresias para DEXONEFIT";
    }
}