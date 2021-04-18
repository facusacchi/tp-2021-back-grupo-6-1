package appPregunta3.validaciones

import appPregunta3.dominio.Usuario		
import appPregunta3.exceptions.BadRequestException

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
	
}