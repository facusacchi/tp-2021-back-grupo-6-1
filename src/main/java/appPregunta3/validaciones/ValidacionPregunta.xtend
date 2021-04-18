package appPregunta3.validaciones

import appPregunta3.dominio.Pregunta		
import appPregunta3.exceptions.BadRequestException
import appPregunta3.dominio.Usuario
import appPregunta3.exceptions.BusinessException

class ValidacionPregunta {
	
	static def validarCamposVacios(Pregunta pregunta) {		
		if(pregunta.descripcion === null || pregunta.respuestaCorrecta === null) {
			throw new BadRequestException("Campos de pregunta nulos. Requeridos: descripcion, respuestaCorrecta")
		}
		if(pregunta.opciones.isEmpty) {
			throw new BadRequestException("Faltan las opciones en la pregunta")
		}
	}
	
	static def validarPuntajeAsignado(Pregunta pregunta, Usuario autor) {
		if(pregunta.puntos > autor.puntaje) {
			throw new BusinessException("El puntaje asignado a la pregunta debe ser menor al puntaje actual del autor")
		}
	}
}