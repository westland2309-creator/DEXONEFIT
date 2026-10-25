package com.mycompany.calculos_composicion.resources;

import controlador.UsuarioDAO;
import modelo.Usuario;
import java.util.List;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("usuarios")
public class UsuarioResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Usuario> obtenerUsuarios() {
        UsuarioDAO dao = new UsuarioDAO();
        return dao.listarUsuarios();
    }
}