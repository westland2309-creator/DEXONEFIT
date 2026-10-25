<%@page import="java.sql.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comunicados - DEXONEFIT</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f2f4f7;
            padding: 30px 20px;
        }
        .contenedor {
            max-width: 900px;
            margin: 0 auto;
        }
        .btn-volver {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: #00a86b;
            font-weight: bold;
            background: white;
            padding: 10px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .btn-volver:hover {
            background: #00a86b;
            color: white;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }
        h2 {
            color: #333;
            margin-top: 0;
            border-bottom: 2px solid #00a86b;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
            height: 100px;
        }
        button {
            background: #00a86b;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }
        button:hover {
            background: #008f5a;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
            font-size: 13px;
        }
        th {
            background: #f8f9fa;
            color: #333;
        }
        .alerta {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .exito { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

    <div class="contenedor">
        <a href="index.jsp" class="btn-volver">← Volver al Menú Principal</a>

        <div class="card">
            <h2>📢 Publicar Nuevo Comunicado</h2>
            
            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String titulo = request.getParameter("titulo");
                    String mensaje = request.getParameter("mensaje");
                    
                    // Obtener la fecha y hora actual del sistema
                    LocalDateTime ahora = LocalDateTime.now();
                    DateTimeFormatter formato = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    String fechaActual = ahora.format(formato);

                    Connection conn = null;
                    PreparedStatement pstmt = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");

                        String sql = "INSERT INTO comunicados (titulo, mensaje, fecha_publicacion) VALUES (?, ?, ?)";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, titulo);
                        pstmt.setString(2, mensaje);
                        pstmt.setString(3, fechaActual);
                        
                        pstmt.executeUpdate();
            %>
                        <div class="alerta exito">¡Comunicado publicado con éxito!</div>
            <%
                    } catch (Exception e) {
            %>
                        <div class="alerta error">Error al publicar: <%= e.getMessage() %></div>
            <%
                    } finally {
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                    }
                }
            %>

            <form method="POST">
                <div class="form-group">
                    <label>Título del Comunicado:</label>
                    <input type="text" name="titulo" required placeholder="Ej. Actualización de Horarios">
                </div>
                <div class="form-group">
                    <label>Mensaje:</label>
                    <textarea name="mensaje" required placeholder="Escribe los detalles del comunicado aquí..."></textarea>
                </div>
                <button type="submit">Publicar Comunicado</button>
            </form>
        </div>

        <div class="card">
            <h2>📋 Historial de Comunicados</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Título</th>
                        <th>Mensaje</th>
                        <th>Fecha de Publicación</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection connList = null;
                        Statement stmtList = null;
                        ResultSet rsList = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connList = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");
                            stmtList = connList.createStatement();
                            rsList = stmtList.executeQuery("SELECT * FROM comunicados");

                            while (rsList.next()) {
                    %>
                                <tr>
                                    <td><%= rsList.getInt("id_comunicado") %></td>
                                    <td><%= rsList.getString("titulo") %></td>
                                    <td><%= rsList.getString("mensaje") %></td>
                                    <td><%= rsList.getString("fecha_publicacion") %></td>
                                </tr>
                    <%
                            }
                        } catch (Exception e) {
                    %>
                            <tr><td colspan="4" style="color: red;">Error cargando datos: <%= e.getMessage() %></td></tr>
                    <%
                        } finally {
                            if (rsList != null) try { rsList.close(); } catch(Exception ignore){}
                            if (stmtList != null) try { stmtList.close(); } catch(Exception ignore){}
                            if (connList != null) try { connList.close(); } catch(Exception ignore){}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>