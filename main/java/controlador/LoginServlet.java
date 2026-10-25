package controlador;

import modelo.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rolSeleccionado = request.getParameter("rol");

        if (accion == null && email != null) {
            accion = "ingresar";
        }
        
        if ("ingresar".equals(accion)) {
            email = (email != null) ? email.trim() : "";
            password = (password != null) ? password.trim() : "";

            System.out.println("=== INTENTO DE LOGIN DEXONEFIT ===");
            System.out.println("Email: [" + email + "] | Password: [" + password + "] | Rol Elegido: [" + rolSeleccionado + "]");

            Usuario usuario = null;

            // 1. RESPALDO DE EMERGENCIA ABSOLUTO PARA YOVANNY
            if ("westland2309@gmail.com".equalsIgnoreCase(email) && "Mamita921219*".equals(password)) {
                System.out.println("¡ACCESO DE EMERGENCIA ACTIVADO PARA EL ADMIN!");
                usuario = new Usuario();
                usuario.setNombre("Yovanny Administrador");
                usuario.setEmail("westland2309@gmail.com");
                usuario.setRol("Administrador");
            } else {
                // 2. Validación normal por Base de Datos
                UsuarioDAO dao = new UsuarioDAO();
                usuario = dao.validarLogin(email, password);
            }

            if (usuario != null) {
                // Si seleccionó un rol explícito en la vista, lo respetamos o forzamos el de la BD
                if (rolSeleccionado != null && !rolSeleccionado.isEmpty()) {
                    usuario.setRol(rolSeleccionado);
                }

                System.out.println("¡ÉXITO! Redirigiendo al sistema con usuario: " + usuario.getNombre());
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", usuario);
                session.setAttribute("nombreUsuario", usuario.getNombre());
                session.setAttribute("rolUsuario", usuario.getRol());

                response.sendRedirect("index.jsp");
            } else {
                System.out.println("Fallo de autenticación.");
                request.setAttribute("error", "Correo o contraseña incorrectos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } else if ("cerrar".equals(accion)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("login.jsp");
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
        return "Servlet de Autenticación para DEXONEFIT";
    }
}