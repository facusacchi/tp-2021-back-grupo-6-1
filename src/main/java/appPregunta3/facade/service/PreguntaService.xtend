package appPregunta3.facade.service

import appPregunta3.dao.RepoPregunta	
import appPregunta3.dao.RepoUsuario
import appPregunta3.dominio.Pregunta
import appPregunta3.dominio.Solidaria
import appPregunta3.dominio.Usuario
import appPregunta3.exceptions.BadRequestException
import java.util.List
import appPregunta3.exceptions.NotFoundException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class PreguntaService {
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	RepoUsuario repoUsuario
	
	def getPreguntasPorString(String valorBusqueda, Boolean activas, Long idUser) {
		validarId(idUser)
		if (activas===null){
			throw new BadRequestException("Parámetros nulos en el path")
		}
		val user = repoUsuario.findById(idUser).orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
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
		validarId(id)
		val pregunta = repoPregunta.findById(id).orElseThrow([
		throw new NotFoundException("Pregunta con id: " + id + " no encontrada")
		])
		pregunta
	}
	
	def todasLasPreguntas(Boolean activas, Long idUser) {
		validarId(idUser)
		val user = repoUsuario.findById(idUser).orElseThrow([
		throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		val preguntas = filtrarPorActivasYNoRespondidas(activas, user)
		preguntas
	}
	
	def actualizarPregunta(Pregunta preguntaModificada, Long id) {
		validarId(id)
		preguntaModificada.validar
		val pregunta = repoPregunta.findById(id).orElseThrow([
		throw new NotFoundException("Pregunta con id: " + id + " no encontrada")
		])
		pregunta => [
			descripcion = preguntaModificada.descripcion
			opciones = preguntaModificada.opciones
			respuestaCorrecta = preguntaModificada.respuestaCorrecta
			puntos = preguntaModificada.puntos
		]
		repoPregunta.save(pregunta)
	}
	
	def crearPregunta(Pregunta bodyPregunta, Long idAutor) {
		validarId(idAutor)
		val usuario = repoUsuario.findById(idAutor).orElseThrow([
		throw new NotFoundException("Usuario con id: " + idAutor + " no encontrado")
		])
		bodyPregunta.validar
		if(bodyPregunta instanceof Solidaria) {
			bodyPregunta.validar(usuario)
		}
		bodyPregunta.autor = usuario
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
	
	def validarId(Long id) {
		if(id === null) {
			throw new BadRequestException("Parámetros nulos en el path")
		}
	}
}
