<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Entrenamientos - DEXONEFIT</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f2f4f7;
            padding: 30px 20px;
        }
        .contenedor {
            max-width: 1200px;
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
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group.full {
            grid-column: 1 / -1;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
            font-size: 13px;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
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
            grid-column: 1 / -1;
        }
        button:hover {
            background: #008f5a;
        }
        .table-container {
            width: 100%;
            overflow-x: auto;
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
            <h2>🏋️ Registro y Gestión de Entrenamientos - DEXONEFIT</h2>
            
            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    try {
                        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
                        String nombreRutina = request.getParameter("nombre_rutina");
                        String objetivo = request.getParameter("objetivo");
                        int diasPorSemana = Integer.parseInt(request.getParameter("dias_por_semana"));
                        String ejercicios = request.getParameter("ejercicios");

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");

                        String sql = "INSERT INTO entrenamientos (id_usuario, nombre_rutina, objetivo, dias_por_semana, ejercicios) VALUES (?, ?, ?, ?, ?)";
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, idUsuario);
                        pstmt.setString(2, nombreRutina);
                        pstmt.setString(3, objetivo);
                        pstmt.setInt(4, diasPorSemana);
                        pstmt.setString(5, ejercicios);

                        pstmt.executeUpdate();
                        pstmt.close();
                        conn.close();
            %>
                        <div class="alerta exito">¡Rutina de entrenamiento guardada con éxito en la base de datos!</div>
            <%
                    } catch (Exception e) {
            %>
                        <div class="alerta error">Error al procesar: <%= e.getMessage() %></div>
            <%
                    }
                }
            %>

            <form method="POST">
                <div class="form-grid">
                    <div class="form-group">
                        <label>ID del Usuario:</label>
                        <input type="text" name="id_usuario" required placeholder="Ej. 1">
                    </div>
                    <div class="form-group">
                        <label>Días por Semana:</label>
                        <input type="text" name="dias_por_semana" required placeholder="Ej. 4">
                    </div>
                    <div class="form-group full">
                        <label>Nombre de la Rutina:</label>
                        <input type="text" name="nombre_rutina" required placeholder="Ej. Hipertrofia y Biomecánica - Tren Inferior">
                    </div>
                    <div class="form-group full">
                        <label>Objetivo:</label>
                        <input type="text" name="objetivo" required placeholder="Ej. Optimización de momentos de fuerza y sobrecarga progresiva">
                    </div>
                    <div class="form-group full">
                        <label>Ejercicios (Separados por comas):</label>
                        <textarea name="ejercicios" rows="3" required placeholder="Ej. Sentadilla libre, Prensa 45°, Curl femoral, Extensiones"></textarea>
                    </div>
                </div>
                <button type="submit">Guardar Rutina de Entrenamiento</button>
            </form>
        </div>

        <div class="card">
            <h2>📋 Listado de Entrenamientos Registrados</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID Entrenamiento</th>
                            <th>ID Usuario</th>
                            <th>Nombre de Rutina</th>
                            <th>Objetivo</th>
                            <th>Días/Semana</th>
                            <th>Ejercicios</th>
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
                                rsList = stmtList.executeQuery("SELECT * FROM entrenamientos");

                                while (rsList.next()) {
                        %>
                                    <tr>
                                        <td><%= rsList.getInt("id_entrenamiento") %></td>
                                        <td><%= rsList.getInt("id_usuario") %></td>
                                        <td><strong><%= rsList.getString("nombre_rutina") %></strong></td>
                                        <td><%= rsList.getString("objetivo") %></td>
                                        <td><%= rsList.getInt("dias_por_semana") %> días</td>
                                        <td><%= rsList.getString("ejercicios") %></td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr><td colspan="6" style="color: red;">Error cargando entrenamientos: <%= e.getMessage() %></td></tr>
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
    </div>

</body>
</html>