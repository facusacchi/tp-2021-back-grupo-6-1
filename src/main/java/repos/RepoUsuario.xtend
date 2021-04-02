package repos

import dominio.Usuario

class RepoUsuario extends Repositorio<Usuario> {

	static RepoUsuario instance

	private new() {
	}

	def static instance() {
		if (instance === null) {
			instance = new RepoUsuario
		}
		instance
	}

	def static restartInstance() {
		instance = new RepoUsuario
	}

	def getByLogin(String userName, String pssw) {
		objects.findFirst[user|user.userName == userName && user.password == pssw]
	}
	
	def getUsuariosNoAmigos(String id) {
		val usuarioLogueado = getById(id)
		allInstances.filter(usuario |  !usuarioLogueado.esAmigo(usuario) && usuarioLogueado != usuario).toList
	}
	
	def searchAmigo(String ami) {
		objects.findFirst[obj | ami.contains(obj.nombre) && ami.contains(obj.apellido)]
	}
	
	def modificar(Usuario usuario) {
		val usuarioAActualizar = getById(usuario.id.toString)
		usuarioAActualizar =>[
			nombre = usuario.nombre
			apellido = usuario.apellido
			fechaDeNacimiento= usuario.fechaDeNacimiento
		]
	}
	
}
