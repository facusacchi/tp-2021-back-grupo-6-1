package facade.service

import org.springframework.beans.factory.annotation.Autowired
import dao.RepoUsuario
import dominio.Usuario
import exceptions.BadRequestException
import dominio.Respuesta
import dao.RepoPregunta
import exceptions.NotFoundException
import dominio.Pregunta
import dominio.Entidad
import java.util.List

class UsuarioService {
	@Autowired
	RepoUsuario repoUsuario
	
	@Autowired
	RepoPregunta repoPregunta
	
	def loguearUsuario(Usuario user) {
		val usuario = repoUsuario.findByUserNameAndPassword(user.userName, user.password).get
		validarRecurso(usuario, usuario.id)
		usuario
	}
	
	def responder(Long idUser, Long idPregunta, Respuesta respuesta) {
		validarId(idUser)
		validarId(idPregunta)
		val pregunta = repoPregunta.findById(idPregunta).get
		validarRecurso(pregunta, idPregunta)
		val usuario = repoUsuario.findById(idUser).get
		validarRecurso(usuario, idUser)
		usuario.responder(pregunta, respuesta)
		repoUsuario.save(usuario)
	}
	
	def buscarUsuarioPorId(Long idUser) {
		validarId(idUser)
		val usuario = repoUsuario.findById(idUser).get
		validarRecurso(usuario, idUser)
		usuario
	}	
	
	def actualizarUsuario(Long idUser, Usuario user) {
		validarId(idUser)
		user.validar
		val usuario = repoUsuario.findById(idUser).get
		validarRecurso(usuario, idUser)			
		usuario => [
			it.nombre = user.nombre
			it.apellido = user.apellido
			it.fechaDeNacimiento = user.fechaDeNacimiento
		]
		repoUsuario.save(usuario)
	}
	
	def buscarUsuariosNoAmigos(Long idUser) {
		validarId(idUser)
		val usuarioLogueado = repoUsuario.findById(idUser).get
		validarRecurso(usuarioLogueado, idUser)
		val usuariosNoAmigos = repoUsuario.findAll().filter(usuario |  !usuarioLogueado.esAmigo(usuario) && usuarioLogueado != usuario).toList
		validarListaDeUsuarios(usuariosNoAmigos)
		usuariosNoAmigos
	}
// ##############  METODOS DE VALIDACION  ################################################

	def validarId(Long id) {
		if(id === null) {
			throw new BadRequestException("Parámetros nulos en el path")
		}
	}
	
	def validarRecurso(Entidad object, Long idObject) {
		if(object instanceof Usuario && object === null) {
			throw new NotFoundException("Usuario con id: " + idObject + " no encontrado")
		}
		if(object instanceof Pregunta && object === null) {
			throw new NotFoundException("Pregunta con id: " + idObject + " no encontrada")
		}
	}
	
	def validarListaDeUsuarios(List<Usuario> usuarios) {
		if(usuarios.isEmpty) {
			throw new NotFoundException("Lista de recursos no encontrada")
		}
	}
	
}