package appPregunta3.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.http.ResponseEntity
import repos.RepoPregunta
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import dominio.Pregunta
import org.springframework.web.bind.annotation.PostMapping
import repos.RepoUsuario
import com.fasterxml.jackson.annotation.JsonView
import serializer.View
import dominio.Solidaria
import org.springframework.beans.factory.annotation.Autowired

@RestController
@CrossOrigin(origins = "http://localhost:3000")
class PreguntaController {
	
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	RepoUsuario repoUsuario
	
	@GetMapping(value="/preguntas/{valorBusqueda}/{activas}/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def getPreguntasPorString(@PathVariable String valorBusqueda, @PathVariable String activas, @PathVariable Long idUser) {
		if(valorBusqueda === null || activas === null || idUser === null) {
			return ResponseEntity.badRequest.body('''Parametros de busqueda incorrectos''')
		}
		val user = this.repoUsuario.findById(idUser)
		//val user = RepoUsuario.instance.getById(idUser)
		if(user === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontro usuario con ese id''')
		}
		var activa = false
		if (activas=='true') {
			activa = true
		}
		val preguntas = this.repoPregunta.findByDescripcionAndActivaAndAutor(valorBusqueda, activa, user).toList
		//val preguntas = RepoPregunta.instance.search(valorBusqueda, activas, user) 
		if(preguntas === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontraron preguntas que coincidan con los valores de busqueda''')
		}
		ResponseEntity.ok(preguntas)
	}
	
	@GetMapping("/pregunta/{id}")
	@JsonView(value=View.Pregunta.Table)
	def preguntaPorId(@PathVariable Integer id) {
		if (id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val pregunta = RepoPregunta.instance.getById(id.toString)
		if (pregunta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontró la pregunta con id <«id»>''')
		}
		pregunta.activa = pregunta.estaActiva
		ResponseEntity.ok(pregunta)
	}
	
	@GetMapping("/preguntasAll/{activas}/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def todasLasPreguntas(@PathVariable String activas, @PathVariable String idUser) {
		if(activas === null || idUser === null) {
			return ResponseEntity.badRequest.body('''Parametro de busqueda incorrecto''')
		}
		val user = RepoUsuario.instance.getById(idUser)
		if (user === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontro usuario''')
		}
		val preguntas = RepoPregunta.instance.allInstances(activas, user)
		if (preguntas === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontraron preguntas''')
		}
		ResponseEntity.ok(preguntas)
	}
	
	@PutMapping(value="/pregunta/{id}")
	def actualizar(@RequestBody Pregunta preguntaModificada, @PathVariable Integer id) {
		if (id === null || id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val pregunta = RepoPregunta.instance.getById(id.toString)
		if(pregunta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''Error, no se encontro la pregunta''')
		}
		preguntaModificada.validar
		RepoPregunta.instance.getById(id.toString) => [
			it.descripcion = preguntaModificada.descripcion
			it.opciones = preguntaModificada.opciones
			it.respuestaCorrecta = preguntaModificada.respuestaCorrecta
			it.puntos = preguntaModificada.puntos
		]
		ResponseEntity.ok(pregunta)
	}
	
	@PostMapping(value="/{idAutor}/pregunta")
	def crearPregunta(@RequestBody Pregunta bodyPregunta, @PathVariable Integer idAutor) {
		if (idAutor === null || idAutor === 0) {
			return ResponseEntity.badRequest.body('''Id en url invalido''')
		}
		if(bodyPregunta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''Error en el body''')
		}
		val usuario = RepoUsuario.instance.getById(idAutor.toString)
		if(usuario === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontró el usuario con id < «idAutor» >''')
		}
		bodyPregunta.validar
		if(bodyPregunta instanceof Solidaria) {
			bodyPregunta.validar(usuario)
		}
		bodyPregunta.autor = usuario
		RepoPregunta.instance.create(bodyPregunta)
		ResponseEntity.ok(bodyPregunta)
	}
	
	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
}
