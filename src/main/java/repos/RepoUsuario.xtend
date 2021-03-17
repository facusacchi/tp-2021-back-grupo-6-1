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
}
