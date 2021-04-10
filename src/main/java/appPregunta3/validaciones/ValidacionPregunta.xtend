package appPregunta3.validaciones

import appPregunta3.dominio.Pregunta
import appPregunta3.exceptions.NotFoundException
import appPregunta3.exceptions.NullFieldException
import appPregunta3.exceptions.NullCollectionException

class ValidacionPregunta {
	
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