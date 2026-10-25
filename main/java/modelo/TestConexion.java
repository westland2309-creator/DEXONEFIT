
package modelo;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConexion {

    public static void main(String[] args) {

        try (Connection con = conexion.conectar()) {

            if (con != null && !con.isClosed()) {
                System.out.println(
                    "Conexión exitosa a la base de datos DEXONEFIT."
                );
            } else {
                System.out.println(
                    "No se pudo establecer la conexión con MySQL."
                );
            }

        } catch (SQLException e) {
            System.out.println(
                "Error al comprobar la conexión: " + e.getMessage()
            );
            e.printStackTrace();
        }
    }
}
