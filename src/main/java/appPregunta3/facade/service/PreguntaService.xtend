package appPregunta3.facade.service

import appPregunta3.dao.RepoPregunta
import appPregunta3.dominio.Pregunta
import appPregunta3.dominio.Solidaria
import appPregunta3.dominio.Usuario
import appPregunta3.exceptions.BadRequestException
import java.util.List
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension appPregunta3.validaciones.ValidacionPregunta.*
import static extension appPregunta3.validaciones.ValidacionId.*

@Service
class PreguntaService extends TemplateService {
	@Autowired
	RepoPregunta repoPregunta
	
	def getPreguntasPorString(String valorBusqueda, Boolean activas, Long idUser) {
		idUser.validarId
		if (activas === null){
			throw new BadRequestException("Parámetros nulos en el path")
		}
		val user = buscarUsuario(idUser)
		val preguntas = this.repoPregunta.findByDescripcionContainsIgnoreCase(valorBusqueda).toList
		val preguntasNoRespondidas = preguntas.filter[ pregunta | !user.preguntasRespondidas
			.contains(pregunta.descripcion.toLowerCase)
		].toList
		if (activas){
			val preguntasActivas = preguntasActivas(preguntasNoRespondidas)
			return preguntasActivas
		}	
		preguntas
	}
	
	def preguntaPorId(Long id) {
		id.validarId
		val pregunta = buscarPregunta(id)
		pregunta
	}
	
	def todasLasPreguntas(Boolean activas, Long idUser) {
		idUser.validarId
		val user = buscarUsuario(idUser)
		val preguntas = filtrarPorActivasYNoRespondidas(activas, user)
		preguntas
	}
	
	def actualizarPregunta(Pregunta preguntaModificada, Long id) {
		id.validarId
		preguntaModificada.validarCamposVacios
		val pregunta = buscarPregunta(id)
		pregunta => [
			descripcion = preguntaModificada.descripcion
			opciones = preguntaModificada.opciones
			respuestaCorrecta = preguntaModificada.respuestaCorrecta
			puntos = preguntaModificada.puntos
		]
		repoPregunta.save(pregunta)
	}
	
	def crearPregunta(Pregunta bodyPregunta, Long idAutor) {
		idAutor.validarId
		val autor = buscarUsuario(idAutor)
		bodyPregunta.validarCamposVacios
		if(bodyPregunta instanceof Solidaria) {
			validarPuntajeAsignado(bodyPregunta, autor)
		}
		bodyPregunta.autor = autor
		repoPregunta.save(bodyPregunta)
	}
	
	def filtrarPorActivasYNoRespondidas(Boolean activas, Usuario user) {
		if(activas) {
			preguntasActivas(preguntasNoRespondidasPor(user)).toSet
		} else {
			preguntasNoRespondidasPor(user).toSet
		}
	}
	
	def preguntasNoRespondidasPor(Usuario user) {
		val filtradas = repoPregunta.findAll.filter[ pregunta | !user.preguntasRespondidas
			.contains(pregunta.descripcion.toLowerCase)
		].toList
		filtradas
	}
	
	def preguntasActivas(List<Pregunta> preguntas) {
		return preguntas.filter[pregunta | pregunta.estaActiva].toList
	}
	
}
