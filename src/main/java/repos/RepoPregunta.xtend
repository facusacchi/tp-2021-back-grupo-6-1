package repos

import dominio.Pregunta
import java.util.List
import java.util.Set

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
	
	def Set<Pregunta> allInstances(String activas) {
		if(activas == "true") {			
			return objects.filter[pregunta | pregunta.estaActiva].toSet
		} else {
			return objects
		}
	}
}