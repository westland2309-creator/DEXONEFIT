<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volumen de Entrenamiento - DEXONEFIT</title>
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
        input[type="text"], input[type="date"], select {
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
            <h2>📈 Registro y Cálculo de Volumen de Entrenamiento - DEXONEFIT</h2>
            
            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    try {
                        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
                        int idEjercicio = Integer.parseInt(request.getParameter("id_ejercicio"));
                        int series = Integer.parseInt(request.getParameter("series"));
                        int repeticiones = Integer.parseInt(request.getParameter("repeticiones"));
                        double carga = Double.parseDouble(request.getParameter("carga"));
                        String fecha = request.getParameter("fecha");

                        // Cálculo automático del volumen de entrenamiento (Series x Repeticiones x Carga)
                        double volumenTotal = series * repeticiones * carga;

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");

                        String sql = "INSERT INTO volumen_entrenamiento (id_usuario, id_ejercicio, series, repeticiones, carga, volumen, fecha) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, idUsuario);
                        pstmt.setInt(2, idEjercicio);
                        pstmt.setInt(3, series);
                        pstmt.setInt(4, repeticiones);
                        pstmt.setDouble(5, carga);
                        pstmt.setDouble(6, volumenTotal);
                        pstmt.setString(7, fecha);

                        pstmt.executeUpdate();
                        pstmt.close();
                        conn.close();
            %>
                        <div class="alerta exito">¡Volumen registrado con éxito! Volumen calculado: <%= volumenTotal %> kg</div>
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
                        <label>ID del Ejercicio:</label>
                        <input type="text" name="id_ejercicio" required placeholder="Ej. 1 (Sentadilla, Press, etc.)">
                    </div>
                    <div class="form-group">
                        <label>Series:</label>
                        <input type="text" name="series" required placeholder="Ej. 4">
                    </div>
                    <div class="form-group">
                        <label>Repeticiones:</label>
                        <input type="text" name="repeticiones" required placeholder="Ej. 10">
                    </div>
                    <div class="form-group">
                        <label>Carga (kg):</label>
                        <input type="text" name="carga" required placeholder="Ej. 80.5">
                    </div>
                    <div class="form-group">
                        <label>Fecha:</label>
                        <input type="date" name="fecha" required>
                    </div>
                </div>
                <button type="submit">Calcular y Guardar Volumen</button>
            </form>
        </div>

        <div class="card">
            <h2>📋 Historial de Volumen de Entrenamiento</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID Volumen</th>
                            <th>ID Usuario</th>
                            <th>ID Ejercicio</th>
                            <th>Series</th>
                            <th>Repeticiones</th>
                            <th>Carga (kg)</th>
                            <th>Volumen Total</th>
                            <th>Fecha</th>
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
                                rsList = stmtList.executeQuery("SELECT * FROM volumen_entrenamiento");

                                while (rsList.next()) {
                        %>
                                    <tr>
                                        <td><%= rsList.getInt("id_volumen") %></td>
                                        <td><%= rsList.getInt("id_usuario") %></td>
                                        <td><%= rsList.getInt("id_ejercicio") %></td>
                                        <td><%= rsList.getInt("series") %></td>
                                        <td><%= rsList.getInt("repeticiones") %></td>
                                        <td><%= rsList.getDouble("carga") %> kg</td>
                                        <td><strong><%= rsList.getDouble("volumen") %> kg</strong></td>
                                        <td><%= rsList.getString("fecha") %></td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr><td colspan="8" style="color: red;">Error cargando registros: <%= e.getMessage() %></td></tr>
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