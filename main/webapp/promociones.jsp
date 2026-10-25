<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Promociones y Novedades - DEXONEFIT</title>
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
        input[type="text"], input[type="date"], textarea {
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
        /* Estilos para el muro de novedades / promociones activas */
        .novedades-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }
        .novedad-card {
            background: linear-gradient(135deg, #00a86b 0%, #007e4e 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,168,107,0.2);
        }
        .novedad-card h3 {
            margin-top: 0;
            font-size: 18px;
            border-bottom: 1px solid rgba(255,255,255,0.3);
            padding-bottom: 8px;
        }
        .novedad-card p {
            font-size: 14px;
            line-height: 1.4;
        }
        .novedad-badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
            margin-top: 10px;
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

        <!-- Sección visual de Novedades y Promociones Activas -->
        <div class="card">
            <h2>🚀 Novedades y Promociones Vigentes en DEXONEFIT</h2>
            <div class="novedades-grid">
                <%
                    Connection connNovedades = null;
                    Statement stmtNovedades = null;
                    ResultSet rsNovedades = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connNovedades = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");
                        stmtNovedades = connNovedades.createStatement();
                        rsNovedades = stmtNovedades.executeQuery("SELECT * FROM promociones ORDER BY fecha_vigencia DESC");

                        boolean hayPromos = false;
                        while (rsNovedades.next()) {
                            hayPromos = true;
                %>
                            <div class="novedad-card">
                                <h3><%= rsNovedades.getString("nombre") %></h3>
                                <p><%= rsNovedades.getString("descripcion") %></p>
                                <div class="novedad-badge">Vigencia: <%= rsNovedades.getString("fecha_vigencia") %></div>
                            </div>
                <%
                        }
                        if (!hayPromos) {
                %>
                            <p style="color: #666; grid-column: 1/-1;">No hay promociones o novedades registradas en este momento.</p>
                <%
                        }
                    } catch (Exception e) {
                %>
                        <p style="color: red; grid-column: 1/-1;">Error cargando novedades: <%= e.getMessage() %></p>
                <%
                    } finally {
                        if (rsNovedades != null) try { rsNovedades.close(); } catch(Exception ignore){}
                        if (stmtNovedades != null) try { stmtNovedades.close(); } catch(Exception ignore){}
                        if (connNovedades != null) try { connNovedades.close(); } catch(Exception ignore){}
                    }
                %>
            </div>
        </div>

        <!-- Formulario de Registro -->
        <div class="card">
            <h2>📢 Registrar Nueva Promoción o Noticia / Novedad</h2>
            
            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    try {
                        String nombre = request.getParameter("nombre");
                        String fechaVigencia = request.getParameter("fecha_vigencia");
                        String descripcion = request.getParameter("descripcion");

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC", "root", "");

                        String sql = "INSERT INTO promociones (nombre, fecha_vigencia, descripcion) VALUES (?, ?, ?)";
                        
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, nombre);
                        pstmt.setString(2, fechaVigencia);
                        pstmt.setString(3, descripcion);

                        pstmt.executeUpdate();
                        pstmt.close();
                        conn.close();
            %>
                        <div class="alerta exito">¡Promoción o novedad publicada con éxito! Recarga la página para verla en las tarjetas superiores.</div>
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
                        <label>Nombre de la Promoción o Novedad:</label>
                        <input type="text" name="nombre" required placeholder="Ej. Bono Especial Trimestral / Lanzamiento Asesoría Nutricional">
                    </div>
                    <div class="form-group">
                        <label>Fecha Límite / Vigencia:</label>
                        <input type="date" name="fecha_vigencia" required>
                    </div>
                    <div class="form-group full">
                        <label>Descripción / Detalles:</label>
                        <textarea name="descripcion" rows="3" required placeholder="Ej. Obtén un 20% de descuento en tu membresía + un plan de alimentación enfocado en microbiota y salud intestinal..."></textarea>
                    </div>
                </div>
                <button type="submit">Publicar Promoción / Novedad</button>
            </form>
        </div>

        <!-- Tabla de Control de Base de Datos -->
        <div class="card">
            <h2>📋 Tabla de Registro y Control</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID Promoción</th>
                            <th>Nombre</th>
                            <th>Fecha de Vigencia</th>
                            <th>Descripción</th>
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
                                rsList = stmtList.executeQuery("SELECT * FROM promociones");

                                while (rsList.next()) {
                        %>
                                    <tr>
                                        <td><%= rsList.getInt("id_promocion") %></td>
                                        <td><strong><%= rsList.getString("nombre") %></strong></td>
                                        <td><%= rsList.getString("fecha_vigencia") %></td>
                                        <td><%= rsList.getString("descripcion") %></td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                        %>
                                <tr><td colspan="4" style="color: red;">Error cargando registros: <%= e.getMessage() %></td></tr>
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