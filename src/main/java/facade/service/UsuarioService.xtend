package facade.service

import org.springframework.beans.factory.annotation.Autowired
import dao.RepoUsuario
import dominio.Usuario
import exceptions.BadRequestException
import dominio.Respuesta
import dao.RepoPregunta
import exceptions.NotFoundException

class UsuarioService {
	@Autowired
	RepoUsuario repoUsuario
	
	@Autowired
	RepoPregunta repoPregunta
	
	def loguearUsuario(Usuario user) {
		val usuario = repoUsuario.findByUserNameAndPassword(user.userName, user.password).orElseThrow([
			throw new BadRequestException("Usuario o contraseña invalidos")
		])
		usuario
	}
	
	def responder(Long idUser, Long idPregunta, Respuesta respuesta) {
		validarId(idUser)
		validarId(idPregunta)
		val pregunta = repoPregunta.findById(idPregunta).orElseThrow([
			throw new NotFoundException("Pregunta con id: " + idPregunta + " no encontrada")
		])
		val opcion = respuesta.opcionElegida
		if (opcion === null) {
			throw new NotFoundException("Respuesta en el body nula")
		}
		repoUsuario.findById(idUser).map([ usuario |
			usuario => [
				usuario.responder(pregunta, respuesta)
			]
			repoUsuario.save(usuario)
		]).orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
	}
	
	def buscarUsuarioPorId(Long idUser) {
		validarId(idUser)
		val usuario = repoUsuario.findById(idUser).orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		usuario
	}	
	
	def actualizarUsuario(Long idUser, Usuario user) {
		validarId(idUser)
		user.validar
		repoUsuario.findById(idUser).map([ usuario |
			usuario => [
				it.nombre = user.nombre
				it.apellido = user.apellido
				it.fechaDeNacimiento = user.fechaDeNacimiento
			]
			repoUsuario.save(usuario)
		]).orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
	}
	
	def buscarUsuariosNoAmigos(Long idUser) {
		validarId(idUser)
		val usuarioLogueado = repoUsuario.findById(idUser)
		.orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		val usuariosNoAmigos = repoUsuario.findAll().filter(usuario |  !usuarioLogueado.esAmigo(usuario) && usuarioLogueado != usuario).toList
		if (usuariosNoAmigos.empty) {
			throw new NotFoundException("No se encontro lista de amigos para usuario con id: " + idUser)
		}
		usuariosNoAmigos	
	}
	
	def agregarAmigo(Long idUser, Long nuevoAmigoId) {
		validarId(idUser)
		validarId(nuevoAmigoId)
		val Usuario nuevoAmigo = repoUsuario.findById(nuevoAmigoId).orElseThrow([
			throw new NotFoundException("Usuario con id: " + nuevoAmigoId + " no encontrado")
		])
		val Usuario usuarioLogueado = repoUsuario.findById(idUser).orElseThrow([
			throw new NotFoundException("Usuario con id: " + idUser + " no encontrado")
		])
		nuevoAmigo.validar
		usuarioLogueado.validar
		usuarioLogueado.agregarAmigo(nuevoAmigo)
		repoUsuario.save(usuarioLogueado)
	}
	
	def validarId(Long id) {
		if(id === null) {
			throw new BadRequestException("Parámetros nulos en el path")
		}
	}
	
}