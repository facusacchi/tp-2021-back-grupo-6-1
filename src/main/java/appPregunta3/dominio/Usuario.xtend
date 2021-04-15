package appPregunta3.dominio

import com.fasterxml.jackson.annotation.JsonIgnore	
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonView
import appPregunta3.dominio.Respuesta
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToMany
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors
import appPregunta3.serializer.View

@Entity
@Accessors
class Usuario {
	
	@Id @GeneratedValue
	@JsonView(View.Usuario.Login, View.Usuario.Perfil, View.Usuario.TablaNoAmigos)
	Long id
	
	@JsonView(View.Pregunta.Table, View.Usuario.Login, View.Usuario.Perfil, View.Usuario.TablaNoAmigos)
	@Column(length=50)
	String nombre
	
	@JsonView(View.Pregunta.Table, View.Usuario.Login, View.Usuario.Perfil, View.Usuario.TablaNoAmigos)
	@Column(length=50)
	String apellido
	
	@JsonIgnore
	LocalDate fechaDeNacimiento
	
	@JsonView(View.Pregunta.Busqueda, View.Usuario.Login)
	@Column(length=50)
	String userName
	
	@Column(length=50)
	String password
	
	@JsonIgnore
	@ManyToMany(fetch=FetchType.LAZY)
	Set<Usuario> amigos = new HashSet<Usuario>
	
	@JsonView(View.Usuario.Login, View.Usuario.Perfil)
	@Column(length=50)
	int puntaje
	
	@JsonView(View.Usuario.Perfil)
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
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

	def cumpleCondicionDeBusqueda(String valorBusqueda) {
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
		agregarRespuesta(respuesta)
	}

	def respondioAntesDeUnMinuto(Pregunta pregunta) {
		pregunta.fechaHoraCreacion.plusMinutes(1).isAfter(LocalDateTime.now)
	}
	
	def preguntasRespondidas() {
		respuestas.map[respuesta | respuesta.pregunta.toLowerCase].toList
	}
	
}

