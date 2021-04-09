package appPregunta3.controller

import appPregunta3.facade.service.PreguntaService	
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.dominio.Pregunta
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import appPregunta3.serializer.View

@RestController
@CrossOrigin(origins = "http://localhost:3000")
class PreguntaController {
	
	@Autowired
	PreguntaService preguntaService
	
	@GetMapping(value="/preguntas/{valorBusqueda}/{activas}/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def getPreguntasPorString(@PathVariable String valorBusqueda, @PathVariable String activas, @PathVariable Long idUser) {
		val preguntas = this.preguntaService.getPreguntasPorString(valorBusqueda, activas, idUser)
		ResponseEntity.ok(preguntas)
	}
	
	@GetMapping("/pregunta/{id}")
	@JsonView(value=View.Pregunta.Table)
	def preguntaPorId(@PathVariable Long id) {
		val pregunta = preguntaService.preguntaPorId(id) 
		ResponseEntity.ok(pregunta)
	}
	
	@GetMapping("/preguntasAll/{activas}/{idUser}")
	@JsonView(value=View.Pregunta.Busqueda)
	def todasLasPreguntas(@PathVariable Boolean activas, @PathVariable Long idUser) {
		val preguntas = preguntaService.todasLasPreguntas(activas, idUser)
		ResponseEntity.ok(preguntas)
	}
	
	@PutMapping(value="/pregunta/{id}")
	def actualizarPregunta(@RequestBody Pregunta preguntaModificada, @PathVariable Long id) {
		preguntaService.actualizarPregunta(preguntaModificada, id)
		ResponseEntity.ok("Pregunta actualizada correctamente")
	}
	
	@PostMapping(value="/{idAutor}/pregunta")
	def crearPregunta(@RequestBody Pregunta bodyPregunta, @PathVariable Long idAutor) {
		preguntaService.crearPregunta(bodyPregunta, idAutor)
		ResponseEntity.ok("Pregunta creada correctamente")
	}
	
}
