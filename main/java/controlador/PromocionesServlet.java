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

@WebServlet(name = "PromocionesServlet", urlPatterns = {"/PromocionesServlet"})
public class PromocionesServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de promociones
        String accion = request.getParameter("accion");
        
        if ("guardarPromocion".equals(accion)) {
            String nombrePromocion = request.getParameter("nombrePromocion");
            String descuento = request.getParameter("descuento");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para guardar la promoción en la BD
                
                request.setAttribute("mensajeExito", "¡Promoción registrada correctamente!");
                request.getRequestDispatcher("promociones.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al registrar la promoción: " + e.getMessage());
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
        return "Controlador de Promociones para DEXONEFIT";
    }
}