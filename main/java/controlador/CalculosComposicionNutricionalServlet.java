package controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.conexion;

@WebServlet(name = "CalculosComposicionNutricionalServlet", urlPatterns = {"/CalculosComposicionNutricionalServlet"})
public class CalculosComposicionNutricionalServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // 1. Recibir parámetros del formulario
        String idUsuarioStr = request.getParameter("id_usuario");
        String sexo = request.getParameter("sexo");
        String edadStr = request.getParameter("edad");
        String pesoStr = request.getParameter("peso");
        String estaturaStr = request.getParameter("estatura");
        String cinturaStr = request.getParameter("cintura");
        String cuelloStr = request.getParameter("cuello");
        String caderaStr = request.getParameter("cadera");
        String objetivoNutricional = request.getParameter("objetivo_nutricional");
        String factorActividadStr = request.getParameter("factor_actividad");
        
        try {
            int idUsuario = Integer.parseInt(idUsuarioStr);
            int edad = Integer.parseInt(edadStr);
            double peso = Double.parseDouble(pesoStr);
            double estatura = Double.parseDouble(estaturaStr);
            double factorActividad = Double.parseDouble(factorActividadStr);
            
            double cintura = (cinturaStr != null && !cinturaStr.trim().isEmpty()) ? Double.parseDouble(cinturaStr) : 0.0;
            double cuello = (cuelloStr != null && !cuelloStr.trim().isEmpty()) ? Double.parseDouble(cuelloStr) : 0.0;
            double cadera = (caderaStr != null && !caderaStr.trim().isEmpty()) ? Double.parseDouble(caderaStr) : 0.0;

            // 2. CÁLCULOS ANTROPOMÉTRICOS Y METABÓLICOS
            double estMetros = estatura / 100.0;
            double imc = peso / (estMetros * estMetros);
            
            // Categorización según IMC
            String categorizacionImc = "Normal";
            if (imc < 18.5) {
                categorizacionImc = "Bajo peso";
            } else if (imc >= 25.0 && imc < 30.0) {
                categorizacionImc = "Sobrepeso";
            } else if (imc >= 30.0) {
                categorizacionImc = "Obesidad";
            }

            // Composición corporal
            double porcentajeGrasa = (sexo != null && sexo.equalsIgnoreCase("Masculino")) 
                ? (1.20 * imc) + (0.23 * edad) - 16.2 
                : (1.20 * imc) + (0.23 * edad) - 5.4;
            if (porcentajeGrasa < 5) porcentajeGrasa = 5.0;

            double masaGrasa = peso * (porcentajeGrasa / 100.0);
            double masaLibre = peso - masaGrasa;
            double relCinturaEstatura = (cintura > 0 && estatura > 0) ? (cintura / estatura) : 0.0;

            // Zonas de entrenamiento cardiovascular
            double fcMax = 220 - edad;
            double z1Min = fcMax * 0.55;
            double z1Max = fcMax * 0.65;
            double z2Min = fcMax * 0.65;
            double z2Max = fcMax * 0.75;
            double z3Min = fcMax * 0.75;
            double z3Max = fcMax * 0.85;

            // Requerimiento Calórico
            double tmb = (10 * peso) + (6.25 * estatura) - (5 * edad);
            if (sexo != null && sexo.equalsIgnoreCase("Masculino")) { tmb += 5; } else { tmb -= 161; }
            double get = tmb * factorActividad;
            double caloriasFinales = get;
            double gProtPerKg = 2.0;
            double gGrasaPerKg = 0.9;

            if (objetivoNutricional != null) {
                if (objetivoNutricional.equals("deficit")) {
                    caloriasFinales = get * 0.80; gProtPerKg = 2.2; gGrasaPerKg = 0.8;
                } else if (objetivoNutricional.equals("superavit")) {
                    caloriasFinales = get * 1.15; gProtPerKg = 2.0; gGrasaPerKg = 1.0;
                }
            }

            int caloriasObjetivo = (int) Math.round(caloriasFinales);
            double proteinasG = Math.round(peso * gProtPerKg);
            double grasasG = Math.round(peso * gGrasaPerKg);
            double calCarbs = caloriasFinales - ((proteinasG * 4) + (grasasG * 9));
            double carbohidratosG = Math.max(Math.round(calCarbs / 4), 0);

            // 3. SENTENCIA SQL ALINEADA A MYSQL (28 campos, categorizacion_imc y 27 interrogantes + NOW())
            String sql = "INSERT INTO calculos_composicion_nutricional " +
                         "(id_usuario, fecha, sexo, edad, peso, estatura, cintura, cuello, cadera, " +
                         "objetivo_nutricional, factor_actividad, calorias_objetivo, proteinas_g, carbohidratos_g, grasas_g, " +
                         "imc, categorizacion_imc, porcentaje_grasa, masa_grasa, masa_libre, relacion_cintura_estatura, " +
                         "fc_max, z1_min, z1_max, z2_min, z2_max, z3_min, z3_max) " +
                         "VALUES (?, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (Connection con = conexion.conectar();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                
                ps.setInt(1, idUsuario);
                ps.setString(2, sexo);
                ps.setInt(3, edad);
                ps.setDouble(4, peso);
                ps.setDouble(5, estatura);
                ps.setDouble(6, cintura);
                ps.setDouble(7, cuello);
                ps.setDouble(8, cadera);
                ps.setString(9, objetivoNutricional);
                ps.setDouble(10, factorActividad);
                ps.setInt(11, caloriasObjetivo);
                ps.setDouble(12, proteinasG);
                ps.setDouble(13, carbohidratosG);
                ps.setDouble(14, grasasG);
                ps.setDouble(15, imc);
                ps.setString(16, categorizacionImc); // Mapeado correctamente a categorizacion_imc
                ps.setDouble(17, porcentajeGrasa);
                ps.setDouble(18, masaGrasa);
                ps.setDouble(19, masaLibre);
                ps.setDouble(20, relCinturaEstatura);
                ps.setDouble(21, fcMax);
                ps.setDouble(22, z1Min);
                ps.setDouble(23, z1Max);
                ps.setDouble(24, z2Min);
                ps.setDouble(25, z2Max);
                ps.setDouble(26, z3Min);
                ps.setDouble(27, z3Max);

                ps.executeUpdate();
                
                response.sendRedirect("calculos_composicion_nutricional.jsp?exito=ok");
                
            } catch (SQLException e) {
                System.out.println("Error SQL: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("calculos_composicion_nutricional.jsp?error=db");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("Error en formato numérico: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("calculos_composicion_nutricional.jsp?error=formato");
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
}