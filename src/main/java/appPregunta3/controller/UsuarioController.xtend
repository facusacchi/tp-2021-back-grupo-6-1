package appPregunta3.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.PathVariable
import dominio.Usuario
import dominio.Respuesta
import com.fasterxml.jackson.annotation.JsonView
import serializer.View
import org.springframework.beans.factory.annotation.Autowired
import facade.service.UsuarioService

@RestController
@CrossOrigin(origins="http://localhost:3000")
class UsuarioController {

	@Autowired
	UsuarioService usuarioService

	@PostMapping(value="/login")
	@JsonView(value=View.Usuario.Login)
	def loguearUsuario(@RequestBody Usuario usuarioBody) {
		val usuario = usuarioService.loguearUsuario(usuarioBody)		
		ResponseEntity.ok(usuario)
	}

	@PutMapping(value="/perfilDeUsuario/{idUser}/{idPregunta}")
	def responder(@PathVariable Long idUser, @PathVariable Long idPregunta, @RequestBody Respuesta respuesta) {
		usuarioService.responder(idUser, idPregunta, respuesta)
		ResponseEntity.ok("Respuesta actualizada en usuario " + idUser + " correctamente")
	}

	@JsonView(View.Usuario.Perfil)
	@GetMapping("/perfilDeUsuario/{id}")
	def buscarUsuarioPorId(@PathVariable Long idUser) {
		val usuario = usuarioService.buscarUsuarioPorId(idUser)
		ResponseEntity.ok(usuario)
	}

	@PutMapping(value="/perfilDeUsuario/{id}")
	def actualizarUsuario(@RequestBody Usuario usuarioBody, @PathVariable Long idUser) {
		usuarioService.actualizarUsuario(idUser, usuarioBody)
		ResponseEntity.ok.body("El usuario con id " + idUser + " fue actualizado correctamente")
	}

	@JsonView(View.Usuario.TablaNoAmigos)
	@GetMapping(value="/usuarios/noAmigos/{id}")
	def buscarUsuariosNoAmigos(@PathVariable Long idUser) {
		val usuariosNoAmigos = usuarioService.buscarUsuariosNoAmigos(idUser)
		ResponseEntity.ok(usuariosNoAmigos)
	}

	// AQUI FALTA TERMINAR EL POST
//	@JsonView(View.Usuario.Perfil)
//	@PutMapping(value="/usuarios/{id}/agregarAmigo/{nuevoAmigoId}")
//	def agregarAmigo(@PathVariable String id, @PathVariable String nuevoAmigoId) {
//		if (id === null || Integer.valueOf(id) === 0) {
//			return ResponseEntity.badRequest.body('''Debe ingresar el parámetro id''')
//		}
//		val Usuario nuevoAmigo = RepoUsuario.instance.getById(nuevoAmigoId)
//		val Usuario usuarioLogueado = RepoUsuario.instance.getById(id)
//		nuevoAmigo.validar
//		usuarioLogueado.validar
//		usuarioLogueado.agregarAmigo(nuevoAmigo)
//		RepoUsuario.instance.update(usuarioLogueado)
//		ResponseEntity.ok(usuarioLogueado)
//	}
}
