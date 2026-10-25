package controlador;

import modelo.conexion;
import modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

public class UsuarioDAO {

    public boolean existeEmail(String correo) {
        boolean existe = false;
        String sql = "SELECT COUNT(*) FROM usuarios WHERE correo = ?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                existe = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return existe;
    }

    public void registrar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (numero_documento, nombre_completo, correo, telefono, tipo_usuario, password, patologias, ejercicios_recomendados, ejercicios_contraindicados) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getDocumento());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getTelefono() != null ? usuario.getTelefono() : "3000000000");
            ps.setString(5, usuario.getRol() != null ? usuario.getRol() : "Administrador");
            ps.setString(6, usuario.getPassword());
            ps.setString(7, usuario.getPatologias());
            ps.setString(8, usuario.getEjerciciosRecomendados());
            ps.setString(9, usuario.getEjerciciosContraindicados());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean actualizar(Usuario usuario) {
        boolean actualizado = false;
        String sql = "UPDATE usuarios SET numero_documento = ?, nombre_completo = ?, telefono = ?, tipo_usuario = ?, patologias = ?, ejercicios_recomendados = ?, ejercicios_contraindicados = ? WHERE correo = ?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getDocumento());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getTelefono());
            ps.setString(4, usuario.getRol());
            ps.setString(5, usuario.getPatologias());
            ps.setString(6, usuario.getEjerciciosRecomendados());
            ps.setString(7, usuario.getEjerciciosContraindicados());
            ps.setString(8, usuario.getEmail());
            
            int filas = ps.executeUpdate();
            actualizado = filas > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return actualizado;
    }

    public boolean actualizarPorId(Usuario usuario) {
        boolean actualizado = false;
        String sql = "UPDATE usuarios SET numero_documento = ?, nombre_completo = ?, correo = ?, telefono = ? WHERE id_usuario = ?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getDocumento());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getEmail());
            ps.setString(4, usuario.getTelefono());
            ps.setInt(5, usuario.getIdUsuario());
            
            int filas = ps.executeUpdate();
            actualizado = filas > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return actualizado;
    }

    public Usuario validarLogin(String correo, String password) {
        Usuario usuario = null;
        String sql = "SELECT id_usuario, numero_documento, nombre_completo, correo, telefono, tipo_usuario, password, patologias, ejercicios_recomendados, ejercicios_contraindicados FROM usuarios WHERE correo = ? AND password = ?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo != null ? correo.trim() : "");
            ps.setString(2, password != null ? password.trim() : "");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setDocumento(rs.getString("numero_documento"));
                usuario.setNombre(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("correo"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setPassword(rs.getString("password"));
                usuario.setRol(rs.getString("tipo_usuario"));
                usuario.setPatologias(rs.getString("patologias"));
                usuario.setEjerciciosRecomendados(rs.getString("ejercicios_recomendados"));
                usuario.setEjerciciosContraindicados(rs.getString("ejercicios_contraindicados"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }

    public List<Usuario> listarUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT id_usuario, numero_documento, nombre_completo, correo, telefono, tipo_usuario, password, patologias, ejercicios_recomendados, ejercicios_contraindicados FROM usuarios";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setDocumento(rs.getString("numero_documento"));
                u.setNombre(rs.getString("nombre_completo"));
                u.setEmail(rs.getString("correo"));
                u.setTelefono(rs.getString("telefono"));
                u.setPassword(rs.getString("password"));
                u.setRol(rs.getString("tipo_usuario"));
                u.setPatologias(rs.getString("patologias"));
                u.setEjerciciosRecomendados(rs.getString("ejercicios_recomendados"));
                u.setEjerciciosContraindicados(rs.getString("ejercicios_contraindicados"));
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Usuario buscarPorDocumento(String documento) {
        Usuario usuario = null;
        String sql = "SELECT id_usuario, numero_documento, nombre_completo, correo, telefono, tipo_usuario, patologias, ejercicios_recomendados, ejercicios_contraindicados FROM usuarios WHERE numero_documento = ?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setDocumento(rs.getString("numero_documento"));
                usuario.setNombre(rs.getString("nombre_completo"));
                usuario.setEmail(rs.getString("correo"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setRol(rs.getString("tipo_usuario"));
                usuario.setPatologias(rs.getString("patologias"));
                usuario.setEjerciciosRecomendados(rs.getString("ejercicios_recomendados"));
                usuario.setEjerciciosContraindicados(rs.getString("ejercicios_contraindicados"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }
}