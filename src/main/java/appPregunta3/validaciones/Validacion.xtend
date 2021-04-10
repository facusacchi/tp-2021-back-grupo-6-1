package appPregunta3.validaciones

import appPregunta3.dominio.Usuario
import appPregunta3.exceptions.NullFieldException
import appPregunta3.dominio.Pregunta
import appPregunta3.exceptions.NullCollectionException
import appPregunta3.exceptions.NotFoundException
import appPregunta3.exceptions.BadRequestException
import appPregunta3.dominio.Respuesta

class Validacion {
	
	static def validarId(Long id) {
		if(id === null) {
			throw new BadRequestException("Parámetros nulos en el path")
		}
	}
	
	static def validarLogin(Usuario usuario) {
		if (usuario.userName === null || usuario.password ===  null) {
			throw new BadRequestException("Error, userName y password no pueden ser nulos")
		}
	}
	
	static def validarCamposVacios(Usuario usuario) {
		if(usuario.nombre === null || usuario.apellido === null || usuario.fechaDeNacimiento === null || usuario.userName === null) {
			throw new NullFieldException("Campos de usuario nulos. Requeridos: nombre, apellido, fechaDeNacimiento, userName")
		}		
	}
	
	static def validarRecursoNulo(Usuario usuario) {
		if (usuario === null) {
			throw new NotFoundException("Usuario no encontrado")
		}
	}
	
	static def validarRecursoNulo(Respuesta respuesta) {
		if (respuesta === null) {
			throw new NotFoundException("Respuesta no encontrada")
		}
	}
	
	static def validarCamposVacios(Respuesta respuesta) {
		if(respuesta.opcionElegida === null) {
			throw new NullFieldException("Campos de respuesta nulos. Requeridos: opcionElegida")
		}		
	}
	
	static def validarRecursoNulo(Pregunta pregunta) {
		if (pregunta === null) {
			throw new NotFoundException("Pregunta no encontrada")
		}
	}
	
	static def validarCamposVacios(Pregunta pregunta) {		
		if(pregunta.descripcion === null || pregunta.respuestaCorrecta === null) {
			throw new NullFieldException("Campos de pregunta nulos. Requeridos: descripcion, respuestaCorrecta")
		}
		if(pregunta.opciones.isEmpty) {
			throw new NullCollectionException("Faltan las opciones en la pregunta")
		}
	}
}