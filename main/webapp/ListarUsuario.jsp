<%@page import="java.util.List"%>
<%@page import="controlador.UsuarioDAO"%>
<%@page import="modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista de Usuarios - DEXONEFIT</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
            .container { max-width: 900px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
            h2 { color: #333; text-align: center; }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
            th { background-color: #007bff; color: white; }
            tr:nth-child(even) { background-color: #f2f2f2; }
            .btn-back { display: inline-block; margin-bottom: 15px; padding: 8px 15px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; }
            .btn-back:hover { background-color: #5a6268; }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="index.jsp" class="btn-back">← Volver al Inicio</a>
            <h2>Gestión de Usuarios - DEXONEFIT</h2>
            
            <table>
                <thead>
                    <tr>
                        <th>Cédula</th>
                        <th>Nombre</th>
                        <th>Correo</th>
                        <th>Rol</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        UsuarioDAO dao = new UsuarioDAO();
                        List<Usuario> lista = dao.listarUsuarios();
                        if (lista != null && !lista.isEmpty()) {
                            for (Usuario u : lista) {
                    %>
                    <tr>
                        <td><%= u.getCedula() %></td>
                        <td><%= u.getNombre() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getRol() %></td>
                    </tr>
                    <% 
                            }
                        } else { 
                    %>
                    <tr>
                        <td colspan="4" style="text-align: center;">No hay usuarios registrados.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </body>
</html>