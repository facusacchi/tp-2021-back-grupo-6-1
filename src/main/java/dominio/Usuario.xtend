package dominio

import java.util.HashSet
import java.util.Set
import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List

@Accessors
class Usuario extends Entity {
	
	String nombre
	String apellido
	LocalDate fechaDeNacimiento
	String userName
	String password
	Set<Usuario> amigos = new HashSet<Usuario>
	int puntaje
	List<Pregunta> preguntasRespondidas = new ArrayList<Pregunta> 
	
	def sumarPuntaje(int puntos) {
		puntaje += puntos
	}
	
	def restarPuntaje(int puntos) {
		puntaje -= puntos
	}
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		nombre.toLowerCase.contains(valorBusqueda.toLowerCase) || apellido.toLowerCase.equals(valorBusqueda.toLowerCase)
	}
	
	def agregarPreguntaRespondida(Pregunta pregunta) {
		preguntasRespondidas.add(pregunta)
	}
}