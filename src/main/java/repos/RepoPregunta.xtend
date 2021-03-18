package repos

import dominio.Pregunta

class RepoPregunta extends Repositorio<Pregunta>{
	
	static RepoPregunta instance
	
	static def instance() {
		if(instance === null) {
			instance = new RepoPregunta
		}
		instance
	}
	
	static def restartInstance() {
		instance = new RepoPregunta
	}
	
	
}