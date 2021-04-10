package appPregunta3.facade.service

import appPregunta3.dao.RepoPregunta	
import appPregunta3.dao.RepoUsuario
import appPregunta3.dominio.Respuesta
import appPregunta3.dominio.Usuario
import appPregunta3.exceptions.BadRequestException
import appPregunta3.exceptions.NotFoundException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension appPregunta3.validaciones.Validacion.*

@Service
class UsuarioService {
	@Autowired
	RepoUsuario repoUsuario
	
	@Autowired
	RepoPregunta repoPregunta
	
	def loguearUsuario(Usuario user) {
		user.validarLogin
		val usuario = repoUsuario.findByUserNameAndPassword(user.userName, user.password).get
		usuario.validarRecursoNulo
		usuario
	}
	
	def responder(Long idUser, Long idPregunta, Respuesta respuesta) {
		idUser.validarId
		idPregunta.validarId
		respuesta.validarRecursoNulo
		respuesta.validarCamposVacios
		val pregunta = repoPregunta.findById(idPregunta).get
		pregunta.validarRecursoNulo
		val usuario = repoUsuario.findById(idUser).get
		usuario.validarRecursoNulo
		usuario.responder(pregunta, respuesta)
		repoUsuario.save(usuario)		
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
	
//	def validarId(Long id) {
//		if(id === null) {
//			throw new BadRequestException("Parámetros nulos en el path")
//		}
//	}
	
}
