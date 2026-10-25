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

@WebServlet(name = "ComunicadosServlet", urlPatterns = {"/ComunicadosServlet"})
public class ComunicadosServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Capturamos la acción enviada desde la vista de comunicados
        String accion = request.getParameter("accion");
        
        if ("enviar".equals(accion)) {
            String titulo = request.getParameter("titulo");
            String mensaje = request.getParameter("mensaje");
            
            try {
                // Verificamos la conexión a la base de datos de DEXONEFIT
                Connection con = conexion.conectar();
                
                // Aquí puedes agregar la lógica para insertar el comunicado en la BD
                
                request.setAttribute("estadoEnvio", "¡Comunicado enviado con éxito!");
                request.getRequestDispatcher("comunicados.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Error al procesar el comunicado: " + e.getMessage());
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
        return "Controlador de Comunicados para DEXONEFIT";
    }
}