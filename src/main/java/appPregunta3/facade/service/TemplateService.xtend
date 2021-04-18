package appPregunta3.facade.service

import appPregunta3.dao.RepoPregunta
import appPregunta3.dao.RepoUsuario
import appPregunta3.exceptions.NotFoundException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
abstract class TemplateService {
	
	@Autowired
	RepoPregunta repoPregunta
	
	@Autowired
	RepoUsuario repoUsuario
	
	def buscarPregunta(Long idPregunta) {
		val pregunta = repoPregunta.findById(idPregunta).orElseThrow([
			throw new NotFoundException("Pregunta no encontrada")
		])
		pregunta
	}
	
	def buscarUsuario(Long idUser) {		
		val usuario = repoUsuario.findById(idUser).orElseThrow([
			throw new NotFoundException("Usuario no encontrado")
		])
		usuario
	}
}