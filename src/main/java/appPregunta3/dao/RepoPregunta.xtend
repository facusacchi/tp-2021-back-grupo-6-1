package appPregunta3.dao

import appPregunta3.dominio.Pregunta
import java.util.List
import java.util.Set
import org.springframework.data.repository.CrudRepository
import java.util.Optional
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.EntityGraph

@Repository
interface RepoPregunta extends CrudRepository<Pregunta, Long> {
	
	@EntityGraph(attributePaths=#["autor"])
	def List<Pregunta> findByDescripcionContainsIgnoreCase(String descripcion)
	
	def Optional<Pregunta> findByDescripcionContains(String descripcion)
	
	//def Set<Pregunta> findByActiva(Boolean activas) 
	
	@EntityGraph(attributePaths=#["opciones","autor"])
	override Set<Pregunta> findAll()
	
	@EntityGraph(attributePaths = #["opciones","autor"])
	override findById(Long id)
	
//	
//	def Set<Pregunta> allInstances(String activas, Usuario user) {
//		if(activas == "true") {			
//			preguntasActivas(preguntasNoRespondidasPor(user)).toSet
//		} else {
//			return preguntasNoRespondidasPor(user).toSet
//		}
//	}
//	
//	def preguntasNoRespondidasPor(Usuario user) {
//		val filtradas = objects.filter[ object | !user.preguntasRespondidas
//			.contains(object.descripcion.toLowerCase)
//		].toList
//		filtradas
//	}
//	
//	def preguntasActivas(List<Pregunta> preguntas) {
//		return preguntas.filter[pregunta | pregunta.estaActiva].toList
//	}
}