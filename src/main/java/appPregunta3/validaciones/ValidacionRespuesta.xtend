package appPregunta3.validaciones

import appPregunta3.dominio.Respuesta	
import appPregunta3.exceptions.NotFoundException
import appPregunta3.exceptions.BadRequestException

class ValidacionRespuesta {
	
	static def validarRecursoNulo(Respuesta respuesta) {
		if (respuesta === null) {
			throw new NotFoundException("Respuesta no encontrada")
		}
	}
	
	static def validarCamposVacios(Respuesta respuesta) {
		if(respuesta.opcionElegida === null) {
			throw new BadRequestException("Campos de respuesta nulos. Requeridos: opcionElegida")
		}		
	}
	
}