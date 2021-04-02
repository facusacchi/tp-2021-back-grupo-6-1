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
import com.fasterxml.jackson.annotation.JsonView
import serializer.View
import exceptions.NullFieldException

@Accessors
class Usuario extends Entity {
	@JsonView(View.Pregunta.Table, View.Usuario.Login, View.Usuario.Perfil, View.Usuario.TablaNoAmigos)
	String nombre
	@JsonView(View.Pregunta.Table, View.Usuario.Login, View.Usuario.Perfil, View.Usuario.TablaNoAmigos)
	String apellido
	@JsonIgnore LocalDate fechaDeNacimiento
	@JsonView(View.Pregunta.Busqueda, View.Usuario.Login)
	String userName
	String password
	@JsonIgnore Set<Usuario> amigos = new HashSet<Usuario>
	@JsonView(View.Usuario.Login, View.Usuario.Perfil)
	int puntaje
	@JsonView(View.Usuario.Perfil)
	List<Respuesta> respuestas = new ArrayList<Respuesta>
	static String DATE_PATTERN = "yyyy-MM-dd"

    @JsonView(View.Usuario.Perfil)
	@JsonProperty("fechaDeNacimiento")
	def getFechaAsString() {
		formatter.format(this.fechaDeNacimiento)
	}

	@JsonProperty("fechaDeNacimiento")
	def setFecha(String fecha) {
		this.fechaDeNacimiento = LocalDate.parse(fecha, formatter)
	}

    @JsonView(View.Usuario.Perfil)
	@JsonProperty("amigos")
	def getAmigos() {
		amigos.map[amigo|amigo.nombre + " " + amigo.apellido].toSet
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

	}

	def respondioAntesDeUnMinuto(Pregunta pregunta) {
		pregunta.fechaHoraCreacion.plusMinutes(1).isAfter(LocalDateTime.now)
	}
	
	def preguntasRespondidas() {
		respuestas.map[respuesta | respuesta.pregunta]
	}
	
	def validar() {
		if(nombre === null || apellido === null || fechaDeNacimiento === null || userName === null) {
			throw new NullFieldException("Campos de usuario nulos")
		}
	}
}

