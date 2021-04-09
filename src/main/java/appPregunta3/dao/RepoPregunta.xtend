package appPregunta3.dao

import appPregunta3.dominio.Pregunta
import java.util.List
import java.util.Set
import appPregunta3.dominio.Usuario
import org.springframework.data.repository.CrudRepository
import java.util.Optional
import org.springframework.stereotype.Repository

@Repository
interface RepoPregunta extends CrudRepository<Pregunta, Long> {
	
	def List<Pregunta> findByDescripcionAndActivaAndAutor(String descripcion, Boolean activa, Usuario autor)
	
	def Optional<Pregunta> findByDescripcionIgnoreCase(String descripcion)
	
	def Set<Pregunta> findByActiva(Boolean activas) 
	
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