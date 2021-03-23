package repos

import dominio.Pregunta
import java.util.List

class RepoPregunta extends Repositorio<Pregunta>{
	
	static RepoPregunta instance
	
	static def instance() {
		if(instance === null) {
			instance = new RepoPregunta
		}
		instance
	}
	
	static def restartInstance() {
		instance = new RepoPregunta
	}
	
	def List<Pregunta> search(String value, String activa) {
		val preguntas = objects.filter[object | object.cumpleCondicionDeBusqueda(value)].toList
		if(activa == "true") {
			return preguntas.filter[pregunta | pregunta.estaActiva].toList
		} else {			
			return preguntas
		}
	}
}