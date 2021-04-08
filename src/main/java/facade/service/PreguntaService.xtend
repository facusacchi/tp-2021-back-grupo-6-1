package facade.service

import org.springframework.beans.factory.annotation.Autowired
import dao.RepoPregunta
import org.springframework.stereotype.Service
import exceptions.BadRequestException
import dao.RepoUsuario
import javassist.NotFoundException
import dominio.Usuario
import java.util.List
import dominio.Pregunta
import dominio.Solidaria

@Service
class PreguntaService {
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	RepoUsuario repoUsuario
	
	def getPreguntasPorString(String valorBusqueda, String activas, Long idUser) {
		validarId(idUser)
		val user = repoUsuario.findById(idUser).orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		var activa = false
		if (activas =='true') {
			activa = true
		}
		val preguntas = this.repoPregunta.findByDescripcionAndActivaAndAutor(valorBusqueda, activa, user).toList
		if(preguntas.empty) {
			throw new NotFoundException("Preguntas no encontradas")
		}
		preguntas
	}
	
	def preguntaPorId(Long id) {
		validarId(id)
		val pregunta = repoPregunta.findById(id).orElseThrow([
		throw new NotFoundException("Pregunta con id: " + id + " no encontrada")
		])
		//pregunta.activa = pregunta.estaActiva
		pregunta
	}
	
	def todasLasPreguntas(Boolean activas, Long idUser) {
		validarId(idUser)
		val user = repoUsuario.findById(idUser).orElseThrow([
		throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		val preguntas = filtrarPorActivasYNoRespondidas(activas, user)
		if (preguntas.isEmpty) {
			throw new NotFoundException("Preguntas no encontradas")
		}
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