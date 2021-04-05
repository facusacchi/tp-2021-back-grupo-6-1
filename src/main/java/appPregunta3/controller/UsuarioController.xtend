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
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.server.ResponseStatusException

@RestController
@CrossOrigin(origins="http://localhost:3000")
class UsuarioController {

	@Autowired
	RepoUsuario repoUsuario

	@Autowired
	RepoPregunta repoPregunta

	@PostMapping(value="/login")
	@JsonView(value=View.Usuario.Login)
	def buscarUsuario(@RequestBody Usuario usuarioBody) {
		if (usuarioBody === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''Error al construir los datos de sesion''')
		}
		if (usuarioBody.userName === null || usuarioBody.password === null) {
			throw new NullFieldException("Campos de login invalidos")
		}
		val usuario = repoUsuario.findByUserNameAndPassword(usuarioBody.userName, usuarioBody.password).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''Usuario o contraseña invalidos''')
		])
		ResponseEntity.ok(usuario)
	}

	@PutMapping(value="/perfilDeUsuario/{idUser}/{idPregunta}")
	def responder(@PathVariable Long idUser, @PathVariable Long idPregunta, @RequestBody Respuesta respuesta) {
		if (idUser === null || idUser === 0) {
			return ResponseEntity.badRequest.body('''Error de parámetro de usuario''')
		}
		if (idPregunta === null || idPregunta === 0) {
			return ResponseEntity.badRequest.body('''Error de parámetro de pregunta''')
		}
		val pregunta = repoPregunta.findById(idPregunta).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''Pregunta no encontrada''')
		])
		val opcion = respuesta.opcionElegida
		if (opcion === null) {
			return ResponseEntity.badRequest.body('''Error en la respuesta enviada en el body''')
		}
		val usuario = repoUsuario.findById(idUser).map([ usuario |
			usuario => [
				usuario.responder(pregunta, respuesta)
			]
			repoUsuario.save(usuario)
		]).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''No se encontró el usuario con id <«idUser»>''')
		])
		ResponseEntity.ok(usuario)
	}

	@JsonView(View.Usuario.Perfil)
	@GetMapping("/perfilDeUsuario/{id}")
	def usuarioPorId(@PathVariable Long id) {
		if (id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		val usuario = repoUsuario.findById(id).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''No se encontró el usuario con id <«id»>''')
		])
		ResponseEntity.ok(usuario)
	}

//	@JsonView(View.Usuario.Perfil)
	@PutMapping(value="/perfilDeUsuario/{id}")
	def actualizar(@RequestBody Usuario usuarioBody, @PathVariable Long id) {
		if (id === null || id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
		}
		if (usuarioBody === null) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, '''Error en el cuerpo del body''')
		}
		if (id != usuarioBody.id) {
			return ResponseEntity.badRequest.body("Id en URL distinto del id que viene en el body")
		}
		usuarioBody.validar
		repoUsuario.findById(id).map([ usuario |
			usuario => [
				it.nombre = usuarioBody.nombre
				it.apellido = usuarioBody.apellido
				it.fechaDeNacimiento = usuarioBody.fechaDeNacimiento
			]
			repoUsuario.save(usuario)
		]).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "El usuario con identificador " + id + " no existe")
		])

//		ResponseEntity.ok(usuarioBody)
		return ResponseEntity.ok.body("El usuario fue actualizado correctamente")

	}

//	static def mapper() {
//		new ObjectMapper => [
//			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
//			configure(SerializationFeature.INDENT_OUTPUT, true)
//		]
//	}
//
	@JsonView(View.Usuario.TablaNoAmigos)
	@GetMapping(value="/usuarios/noAmigos/{id}")
	def getUsuariosNoAmigos(@PathVariable Long id) {
		val usuarioLogueado = repoUsuario.findById(id)
		.orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "El usuario con identificador " + id + " no existe")
		])
		val usuariosNoAmigos = repoUsuario.findAll().filter(usuario |  !usuarioLogueado.esAmigo(usuario) && usuarioLogueado != usuario).toList
		if (usuariosNoAmigos.empty) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, '''No tenes amigos para agregar''')
		}
		ResponseEntity.ok(usuariosNoAmigos)
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
