package appPregunta3

import dominio.Usuario
import repos.RepoUsuario
import java.time.LocalDate
import dominio.Simple
import java.time.LocalDateTime
import repos.RepoPregunta
import dominio.DeRiesgo
import dominio.Solidaria
import dominio.Respuesta
import org.springframework.stereotype.Service
import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import dominio.Pregunta

@Service
class Bootstrap implements InitializingBean {

	@Autowired
	RepoUsuario repoUsuario

	@Autowired
	RepoPregunta repoPregunta

	Usuario pepe
	Usuario manolo
	Usuario nancy
	Usuario casandra
	Usuario lucrecia
	Usuario pancho
	Usuario elena

//########################### USUARIOS #####################################################//
	def void initUsuarios() {
		pepe = new Usuario => [
			nombre = "Pepe"
			apellido = "Palala"
			userName = "pepito"
			password = "123"
			puntaje = 1098
			fechaDeNacimiento = LocalDate.of(1990, 7, 28)

			agregarRespuesta(new Respuesta => [
				pregunta = "¿Cuantos años tiene Mirtha Legrand?"
				puntos = 500
				fechaRespuesta = LocalDate.of(2020, 4, 16)
			])

			agregarRespuesta(new Respuesta => [
				pregunta = "¿Cuantas provincias tiene Argentina?"
				puntos = 100
				fechaRespuesta = LocalDate.of(2021, 3, 24)
			])

			agregarRespuesta(new Respuesta => [
				pregunta = "¿Cuantas provincias tiene Argentina?"
				puntos = 100
				fechaRespuesta = LocalDate.of(2021, 3, 24)
			])
		]

		this.crearUsuario(pepe)

		manolo = new Usuario => [
			nombre = "Manolo"
			apellido = "Palala"
			userName = "manolito"
			password = "456"
			puntaje = 304
			fechaDeNacimiento = LocalDate.of(1995, 10, 4)
		]

		manolo.agregarAmigo(pepe)

		this.crearUsuario(manolo)

		nancy = new Usuario => [
			nombre = "Nancy"
			apellido = "Vargas"
			userName = "nan"
			password = "123"
			puntaje = 4089
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]

		nancy.agregarAmigo(manolo)
		nancy.agregarAmigo(pepe)

		this.crearUsuario(nancy)

		casandra = new Usuario => [
			nombre = "Casandra"
			apellido = "Malandra"
			userName = "casalandra"
			password = "774"
			puntaje = 100
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]

		casandra.agregarAmigo(nancy)
		casandra.agregarAmigo(manolo)
		casandra.agregarAmigo(pepe)

		this.crearUsuario(casandra)

		lucrecia = new Usuario => [
			nombre = "Lucrecia"
			apellido = "Magnesia"
			userName = "lugenesia"
			password = "122"
			puntaje = 0
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]

		lucrecia.agregarAmigo(casandra)
		lucrecia.agregarAmigo(nancy)
		lucrecia.agregarAmigo(manolo)
		lucrecia.agregarAmigo(pepe)

		this.crearUsuario(lucrecia)

		pancho = new Usuario => [
			nombre = "Pancho"
			apellido = "Rancho"
			userName = "zafarancho"
			password = "999"
			puntaje = 904
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]

		pancho.agregarAmigo(lucrecia)
		pancho.agregarAmigo(casandra)
		pancho.agregarAmigo(nancy)
		pancho.agregarAmigo(manolo)

		this.crearUsuario(pancho)

		elena = new Usuario => [
			nombre = "Elena"
			apellido = "Melena"
			userName = "melinena"
			password = "364"
			puntaje = 3457
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]

		elena.agregarAmigo(pancho)
		elena.agregarAmigo(lucrecia)
		elena.agregarAmigo(casandra)
		elena.agregarAmigo(manolo)

		this.crearUsuario(elena)

	}

	def void crearUsuario(Usuario usuario) {
		val usuarioEnRepo = repoUsuario.findByUserName(usuario.userName)
		if (usuarioEnRepo !== null) {
			usuario.id = usuarioEnRepo.id
		}
		repoUsuario.save(usuario)
		println("Usuario " + usuario.userName + " creado")
	}

//########################### PREGUNTAS #####################################################//	
	def void initPreguntas() {
		
		this.crearPregunta(new Simple => [
			descripcion = "¿Por que sibarita es tan rica?"
			autor = pepe
			fechaHoraCreacion = LocalDateTime.now
			// fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Por la muzza")
			agregarOpcion("Por la salsa")
			agregarOpcion("Por la masa")
			agregarOpcion("No hay motivo")
			agregarOpcion("Es existencial")
			respuestaCorrecta = "Es existencial"
		])

		this.crearPregunta(new Simple => [
			descripcion = "¿Cual es la masa del sol?"
			autor = pancho
			// fechaHoraCreacion = LocalDateTime.now
			fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Mucha")
			agregarOpcion("Poca")
			agregarOpcion("Maso")
			agregarOpcion("No se sabe")
			respuestaCorrecta = "Mucha"
		])

		this.crearPregunta(new DeRiesgo => [
			descripcion = "¿Que es mas lento que un piropo de tartamudo?"
			autor = manolo
			fechaHoraCreacion = LocalDateTime.now
			// fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Un caracol")
			agregarOpcion("Higuain")
			agregarOpcion("Una babosa")
			agregarOpcion("Nada")
			respuestaCorrecta = "Higuain"
		])

		this.crearPregunta(new DeRiesgo => [
			descripcion = "Cocodrilo que durmio es..."
			autor = pancho
			// fechaHoraCreacion = LocalDateTime.now
			fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Feroz")
			agregarOpcion("Anfibio")
			agregarOpcion("Cartera")
			agregarOpcion("Yacare")
			agregarOpcion("No existe el dicho")
			respuestaCorrecta = "Cartera"
		])

		this.crearPregunta(new Solidaria() => [
			descripcion = "Hamlet es una obra de..."
			autor = casandra
			fechaHoraCreacion = LocalDateTime.now
			// fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			puntos = 15
			agregarOpcion("Pato donald")
			agregarOpcion("Micky Mouse")
			agregarOpcion("Gallo Claudio")
			agregarOpcion("Coyote")
			agregarOpcion("Shakespare")
			respuestaCorrecta = "Shakespare"
		])

		this.crearPregunta(new Solidaria() => [
			descripcion = "Mas vale pajaro en mano que..."
			autor = pepe
			// fechaHoraCreacion = LocalDateTime.now
			fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			puntos = 30
			agregarOpcion("Pajaro perdido")
			agregarOpcion("Cien volando")
			agregarOpcion("Un avestruz")
			agregarOpcion("Se te escape")
			agregarOpcion("Mano sin pajaro")
			respuestaCorrecta = "Cien volando"
		])
	}
	
	def void crearPregunta(Pregunta pregunta) {
		val preguntaEnRepo = repoPregunta.findByDescripcionIgnoreCase(pregunta.descripcion)
		if (preguntaEnRepo !== null) {
			pregunta.id = preguntaEnRepo.id
		}
		repoPregunta.save(pregunta)
		println("Usuario " + pregunta.descripcion + " creado")
	}
	
		override afterPropertiesSet() throws Exception {
		println("************************************************************************")
		println("Running initialization")
		println("************************************************************************")
		initUsuarios
		initPreguntas
	}

}
