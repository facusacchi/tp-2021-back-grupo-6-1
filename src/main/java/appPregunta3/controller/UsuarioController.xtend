package appPregunta3.controller

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RestController
import repos.RepoUsuario
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PostMapping
import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.PathVariable
import dominio.Usuario

@RestController
@CrossOrigin(origins = #["http://localhost:3000"])
class UsuarioController {

	@PostMapping(value="/login")
	def buscarUsuario(@RequestBody String body) {
		val dataSession = mapper.readValue(body, DataSession)
		if(dataSession === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''Error al construir los datos de sesion''')
		}
		val usuario = RepoUsuario.instance.getByLogin(dataSession.userName, dataSession.password)
		if(usuario === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(mapper.writeValueAsString('''Usuario o contraseña invalidos'''))
		}
		ResponseEntity.ok(mapper.writeValueAsString(usuario))
	}
	
	@PutMapping(value="/perfilDeUsuario/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		if (id === null || id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val actualizado = mapper.readValue(body, Usuario)

		if (id != actualizado.id) {
			return ResponseEntity.badRequest.body("Id en URL distinto del id que viene en el body")
		}
		RepoUsuario.instance.update(actualizado)
		ResponseEntity.ok(mapper.writeValueAsString(actualizado))
	}
	
	@GetMapping("/perfilDeUsuario/{id}")
	def usuarioPorId(@PathVariable Integer id) {
		if (id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val usuario = RepoUsuario.instance.getById(id.toString)
		if (usuario === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontró el usuario con id <«id»>''')
		}
		ResponseEntity.ok(usuario)
	}

	@GetMapping(value="/usuarios")
	def getUsuarios() {
		val usuarios = RepoUsuario.instance.allInstances
		if (usuarios === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontron usuarios''')
		}
			ResponseEntity.ok(usuarios)
	}
	
	@GetMapping(value="/usuarios/{valorBusqueda}")
	def getUsuariosPorString(@PathVariable String valorBusqueda) {
		if(valorBusqueda === null) {
			return ResponseEntity.badRequest.body('''Parametro de busqueda incorrecto''')
		}
		val usuarios = RepoUsuario.instance.search(valorBusqueda)
		ResponseEntity.ok(usuarios)
	}
	
	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
	
}

@Accessors
class DataSession {
	String userName
	String password
}
