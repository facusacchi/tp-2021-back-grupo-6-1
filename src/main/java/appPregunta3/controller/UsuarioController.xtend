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
import repos.RepoPregunta
import dominio.Usuario
import dominio.Respuesta
import com.fasterxml.jackson.annotation.JsonView
import serializer.View
import exceptions.NullFieldException

@RestController
@CrossOrigin(origins="http://localhost:3000")
class UsuarioController {

	@PostMapping(value="/login")
	@JsonView(value=View.Usuario.Login)
	def buscarUsuario(@RequestBody String body) {
		val dataSession = mapper.readValue(body, DataSession)
		if (dataSession === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''Error al construir los datos de sesion''')
		}
		if(dataSession.userName === null || dataSession.password === null) {
			throw new NullFieldException("Campos de login invalidos")
		}
		val usuario = RepoUsuario.instance.getByLogin(dataSession.userName, dataSession.password)
		if (usuario === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
				mapper.writeValueAsString('''Usuario o contraseña invalidos'''))
		}
		ResponseEntity.ok(usuario)
	}

	@PutMapping(value="/perfilDeUsuario/{idUser}/{idPregunta}")
	def responder(@PathVariable Integer idUser, @PathVariable Integer idPregunta, @RequestBody String opcionElegida) {
		if (idUser === null || idUser === 0) {
			return ResponseEntity.badRequest.body('''Error de parámetro de usuario''')
		}
		if (idPregunta === null || idPregunta === 0) {
			return ResponseEntity.badRequest.body('''Error de parámetro de pregunta''')
		}
		val usuario = RepoUsuario.instance.getById(idUser.toString)
		if (usuario === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
				mapper.writeValueAsString('''Usuario no encontrado'''))
		}
		val pregunta = RepoPregunta.instance.getById(idPregunta.toString)
		if (pregunta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
				mapper.writeValueAsString('''Pregunta no encontrada'''))
		}
		val opcion = mapper.readValue(opcionElegida, Respuesta)
		if(opcion === null) {
			return ResponseEntity.badRequest.body('''Error en la respuesta enviada en el body''')
		}
		usuario.responder(pregunta, opcion)
		ResponseEntity.ok(mapper.writeValueAsString(usuario))
	}
	
    @JsonView(View.Usuario.Perfil)
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

	@JsonView(View.Usuario.Perfil)
	@PutMapping(value="/perfilDeUsuario/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		if (id === null || id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val actualizado = mapper.readValue(body, Usuario)
		if (actualizado === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
				mapper.writeValueAsString('''Usuario no encontrado'''))
		}
		if(id != actualizado.id) {
			return ResponseEntity.badRequest.body("Id en URL distinto del id que viene en el body")
		}
//		actualizado.validar
		RepoUsuario.instance.modificar(actualizado)
		ResponseEntity.ok(mapper.writeValueAsString(actualizado))
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}

	@JsonView(View.Usuario.TablaNoAmigos)
	@GetMapping(value="/usuarios/noAmigos/{id}")
	def getUsuariosNoAmigos(@PathVariable String id) {
		val usuarios = RepoUsuario.instance.getUsuariosNoAmigos(id)
		if (usuarios.empty) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No tenes amigos para agregar''')
		}
		ResponseEntity.ok(usuarios)
	}

	@JsonView(View.Usuario.Perfil)
	@PutMapping(value="/usuarios/{id}/agregarAmigo/{nuevoAmigoId}")
	def agregarAmigo(@PathVariable String id, @PathVariable String nuevoAmigoId) {
		if (id === null || Integer.valueOf(id) === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val Usuario nuevoAmigo = RepoUsuario.instance.getById(nuevoAmigoId)
		val Usuario usuarioLogueado = RepoUsuario.instance.getById(id)
		nuevoAmigo.validar
		usuarioLogueado.validar
		usuarioLogueado.agregarAmigo(nuevoAmigo)
		RepoUsuario.instance.update(usuarioLogueado)
		ResponseEntity.ok(usuarioLogueado)
	}

}

@Accessors
class DataSession {
	String userName
	String password
}
