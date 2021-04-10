package appPregunta3.validaciones

import appPregunta3.exceptions.BadRequestException

class ValidacionId {
	
	static def validarId(Long id) {
		if(id === null) {
			throw new BadRequestException("Parámetros nulos en el path")
		}
	}
	
}