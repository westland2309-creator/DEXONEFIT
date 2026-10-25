package modelo;

public class Usuario {

    private int idUsuario;
    private String documento;
    private String nombre;
    private String email;
    private String telefono;
    private String password;
    private String rol;
    private String patologias;
    private String ejerciciosRecomendados;
    private String ejerciciosContraindicados;

    public Usuario() {
    }

    public Usuario(String nombre, String email, String telefono,
                   String password, String rol) {
        this.nombre = nombre;
        this.email = email;
        this.telefono = telefono;
        this.password = password;
        this.rol = rol;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getPatologias() {
        return patologias;
    }

    public void setPatologias(String patologias) {
        this.patologias = patologias;
    }

    public String getEjerciciosRecomendados() {
        return ejerciciosRecomendados;
    }

    public void setEjerciciosRecomendados(String ejerciciosRecomendados) {
        this.ejerciciosRecomendados = ejerciciosRecomendados;
    }

    public String getEjerciciosContraindicados() {
        return ejerciciosContraindicados;
    }

    public void setEjerciciosContraindicados(String ejerciciosContraindicados) {
        this.ejerciciosContraindicados = ejerciciosContraindicados;
    }
}