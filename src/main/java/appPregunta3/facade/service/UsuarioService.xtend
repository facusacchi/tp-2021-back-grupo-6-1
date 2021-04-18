package appPregunta3.facade.service

import appPregunta3.dao.RepoUsuario
import appPregunta3.dominio.Respuesta
import appPregunta3.dominio.Usuario
import appPregunta3.facade.service.TemplateService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import static extension appPregunta3.validaciones.ValidacionUsuario.*
import static extension appPregunta3.validaciones.ValidacionId.*
import static extension appPregunta3.validaciones.ValidacionRespuesta.*
import appPregunta3.exceptions.NotFoundException

@Service
class UsuarioService extends TemplateService {
	
	@Autowired
	RepoUsuario repoUsuario
	
//##########  METHODS OF ENDPOINTS ###############################################################

	def loguearUsuario(Usuario user) {
		user.validarLogin
		val usuario = repoUsuario.findByUserNameAndPassword(user.userName, user.password).orElseThrow([
			throw new NotFoundException("Usuario o contraseña incorrectos")
		])
		usuario
	}
	
	def responder(Long idUser, Long idPregunta, Respuesta respuesta) {
		validarAntesDeResponder(idUser, idPregunta, respuesta)
		val pregunta = buscarPregunta(idPregunta)
		val usuario = buscarUsuario(idUser)
		usuario.responder(pregunta, respuesta)
		repoUsuario.save(usuario)
		usuario	
	}
	
	def buscarUsuarioPorId(Long idUser) {
		idUser.validarId
		val usuario = buscarUsuario(idUser)
		usuario
	}	
	
	def actualizarUsuario(Long idUser, Usuario user) {
		validarAntesDeActualizar(idUser,user)
		val usuario = buscarUsuario(idUser) 
		actualizarCampos(usuario, user) 
		repoUsuario.save(usuario)
		usuario
	}
	
	def buscarUsuariosNoAmigos(Long idUser) {
		idUser.validarId
		val usuarioLogueado = buscarUsuario(idUser)
		val usuariosNoAmigos = buscarUsuariosNoAmigosDe(usuarioLogueado)
		usuariosNoAmigos
	}
	
	def agregarAmigo(Long idUser, Long nuevoAmigoId) {
		validarAntesDeAgregarAmigo(idUser, nuevoAmigoId)
		val nuevoAmigo = buscarUsuario(nuevoAmigoId)
		val usuarioLogueado = buscarUsuario(idUser)
		validarCamposDeUsuarios(nuevoAmigo, usuarioLogueado)
		usuarioLogueado.agregarAmigo(nuevoAmigo)
		repoUsuario.save(usuarioLogueado)
		usuarioLogueado
	}

//################################################################################################
	
	def validarAntesDeResponder(Long idUser, Long idPregunta, Respuesta respuesta) {
		idUser.validarId
		idPregunta.validarId
		respuesta.validarRecursoNulo
		respuesta.validarCamposVacios
	}
	
	// REVISAR SI ESTOS DOS METODOS DE BUSQUEDA NO CONVIENE IMPLEMENTARLOS EN UNA CLASE 
	// ABSTRACTA DE LA QUE EXTIENDAN LOS SERVICE CONCRETOS PARA NO REPETIRLOS EN CADA
	// SERVICE
	////////////////////////////////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////////////////////
	
	def actualizarCampos(Usuario userOld, Usuario userNew) {
		userOld.nombre = userNew.nombre
		userOld.apellido = userNew.apellido
		userOld.fechaDeNacimiento = userNew.fechaDeNacimiento
	}
	
	def validarAntesDeActualizar(Long idUser, Usuario user) {
		idUser.validarId
		user.validarCamposVacios		
	}
	
	def buscarUsuariosNoAmigosDe(Usuario usuarioLogueado) {
		val usuariosNoAmigos = repoUsuario.findAll.filter[usuario |
			!usuarioLogueado.esAmigo(usuario) && usuarioLogueado.id != usuario.id
		].toSet
		usuariosNoAmigos
	}
	
	def validarAntesDeAgregarAmigo(Long idUser, Long nuevoAmigoId) {
		idUser.validarId
		nuevoAmigoId.validarId		
	}
	
	def validarCamposDeUsuarios(Usuario nuevoAmigo, Usuario usuarioLogueado) {
		nuevoAmigo.validarCamposVacios
		usuarioLogueado.validarCamposVacios
	}
	
}
