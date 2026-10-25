
package modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class conexion {

    private static final String URL =
            "jdbc:mysql://localhost:3306/dexonefit?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";

    private static final String USUARIO = "root";
    private static final String CLAVE = "";

    public static Connection conectar() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "No se encontró el controlador JDBC de MySQL. Verifica MySQL Connector/J.",
                    e
            );
        }

        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}
