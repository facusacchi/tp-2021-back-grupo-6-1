package appPregunta3.validaciones

import appPregunta3.dominio.Usuario	
import appPregunta3.exceptions.NotFoundException
import appPregunta3.exceptions.BadRequestException
import java.util.Set

class ValidacionUsuario {	
	
	static def validarLogin(Usuario usuario) {
		if (usuario.userName === null || usuario.password ===  null) {
			throw new BadRequestException("Error, userName y password no pueden ser nulos")
		}
	}
	
	static def validarCamposVacios(Usuario usuario) {
		if(usuario.nombre === null || usuario.apellido === null || usuario.fechaDeNacimiento === null) {
			throw new BadRequestException("Campos de usuario nulos. Requeridos: nombre, apellido, fechaDeNacimiento")
		}		
	}
	
	static def validarRecursoNulo(Usuario usuario) {
		if (usuario === null) {
			throw new NotFoundException("Usuario no encontrado")
		}
	}
	
	static def validarRecursoNulo(Set<Usuario> usuarios) {
		if(usuarios.isEmpty) {
			throw new NotFoundException("Amigos no encontrados")
		}
	}
	
}