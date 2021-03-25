package dominio

import java.util.HashSet
import java.util.Set
import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import java.time.LocalDateTime
import repos.RepoUsuario

@Accessors
class Usuario extends Entity {
	
	String nombre
	String apellido
	@JsonIgnore LocalDate fechaDeNacimiento
	String userName
	String password
	@JsonIgnore Set<Usuario> amigos = new HashSet<Usuario>
	int puntaje
	List<Respuesta> respuestas = new ArrayList<Respuesta>
	List<String> preguntasRespondidas = new ArrayList<String>
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	@JsonProperty("fechaDeNacimiento")
	def getFechaAsString() {
		formatter.format(this.fechaDeNacimiento)
	}
	
	@JsonProperty("fechaDeNacimiento")
	def setFecha(String fecha) {
		this.fechaDeNacimiento = LocalDate.parse(fecha, formatter)
	}
	
	@JsonProperty("amigos")
	def getAmigos() {
		amigos.map[amigo|amigo.nombre +" "+ amigo.apellido].toSet
	}
	
	@JsonProperty("amigos")
	def setAmigos(List<String> ami) {
		ami.forEach[amigo | this.amigos.add(RepoUsuario.instance.searchAmigo(amigo))]
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
	
	def sumarPuntaje(int puntos) {
		puntaje += puntos
	}
	
	def restarPuntaje(int puntos) {
		puntaje -= puntos
	}
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		nombre.toLowerCase.contains(valorBusqueda.toLowerCase) || apellido.toLowerCase.equals(valorBusqueda.toLowerCase)
	}
	
	def agregarRespuesta(Respuesta respuesta) {
		respuestas.add(respuesta)
	}
	
	def agregarPreguntaRespondida(String pregunta) {
		preguntasRespondidas.add(pregunta)
	}
	
	def agregarAmigo(Usuario usuario){
		amigos.add(usuario)
	}
	
	def esAmigo(Usuario usuario) {
		amigos.contains(usuario)
	}
	
	def responder(Pregunta pregunta, Respuesta respuesta) {
		respuesta.fechaRespuesta = LocalDate.now
		if (pregunta.esCorrecta(respuesta.opcionElegida) && pregunta.estaActiva) {
			pregunta.gestionarRespuestaDe(this, respuesta)
		} else {
			respuesta.puntos = 0
		}
			agregarRespuesta(respuesta)
			agregarPreguntaRespondida(pregunta.descripcion)
	}
	
	def respondioAntesDeUnMinuto(Pregunta pregunta) {
		pregunta.fechaHoraCreacion.plusMinutes(1).isAfter(LocalDateTime.now)
	}
}