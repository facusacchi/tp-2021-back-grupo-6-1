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

@RestController
@CrossOrigin(origins = "http://localhost:3000")
class PreguntaController {
	
	@GetMapping(value="/preguntas/{valorBusqueda}")
	def getPreguntasPorString(@PathVariable String valorBusqueda) {
		if(valorBusqueda === null) {
			return ResponseEntity.badRequest.body('''Parametro de busqueda incorrecto''')
		}
		val preguntas = RepoPregunta.instance.search(valorBusqueda)
		ResponseEntity.ok(preguntas)
	}
	
	@GetMapping("/pregunta/{id}")
	def usuarioPorId(@PathVariable Integer id) {
		if (id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val pregunta = RepoPregunta.instance.getById(id.toString)
		if (pregunta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontró el usuario con id <«id»>''')
		}
		ResponseEntity.ok(pregunta)
	}
	
	@PutMapping(value="/pregunta/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		if (id === null || id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val actualizado = mapper.readValue(body, Pregunta)

		if (id != actualizado.id) {
			return ResponseEntity.badRequest.body("Id en URL distinto del id que viene en el body")
		}
		RepoPregunta.instance.update(actualizado)
		ResponseEntity.ok(mapper.writeValueAsString(actualizado))
	}
	
	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
}
