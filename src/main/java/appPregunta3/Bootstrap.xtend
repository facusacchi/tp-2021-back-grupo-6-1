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

class Bootstrap {

	Usuario pepe
	Usuario manolo
	Usuario nancy
	Usuario casandra
	Usuario lucrecia
	Usuario pancho
	Usuario elena

	def void run() {
		crearUsuarios
		crearPreguntas
	}
	
//########################### USUARIOS #####################################################//

	def crearUsuarios() {
		pepe = new Usuario => [
			nombre = "Pepe"
			apellido = "Palala"
			userName = "pepito"
			password = "123"
			puntaje = 1098
			fechaDeNacimiento = LocalDate.of(1990, 7, 28)
			
//			agregarPreguntaRespondida(new Respuesta => [
//				pregunta = "¿Cuantos años tiene Mirtha Legrand?"
//				puntos = 500
//				fechaRespuesta= LocalDate.of(2020,4,16)
//			])
//			
//			agregarPreguntaRespondida(new Respuesta => [
//				pregunta="¿Cuantas provincias tiene Argentina?"
//				puntos=100
//				fechaRespuesta= LocalDate.of(2021,3,24)
//			])
//			
//			agregarPreguntaRespondida(new Respuesta => [
//				pregunta="¿Cuantas provincias tiene Argentina?"
//				puntos=100
//				fechaRespuesta= LocalDate.of(2021,3,24)
//			])
		]
		
		RepoUsuario.instance.create(pepe)

		manolo = new Usuario => [
			nombre = "Manolo"
			apellido = "Palala"
			userName = "manolito"
			password = "456"
			puntaje = 304
			fechaDeNacimiento = LocalDate.of(1995, 10, 4)
		]

		manolo.agregarAmigo(pepe)

		RepoUsuario.instance.create(manolo)

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

		RepoUsuario.instance.create(nancy)

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

		RepoUsuario.instance.create(casandra)

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

		RepoUsuario.instance.create(lucrecia)

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
		pancho.preguntasRespondidas.add(
			new Respuesta => [
				puntos = 10
			]
		)

		RepoUsuario.instance.create(pancho)

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

		RepoUsuario.instance.create(elena)

	}
	
//########################### PREGUNTAS #####################################################//	

	def crearPreguntas() {
		RepoPregunta.instance.create(new Simple => [
			descripcion = "¿Por que sibarita es tan rica?"
			autor = pepe
			fechaHoraCreacion = LocalDateTime.now
			//fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Por la muzza")
			agregarOpcion("Por la salsa")
			agregarOpcion("Por la masa")
			agregarOpcion("No hay motivo")
			agregarOpcion("Es existencial")
			respuestaCorrecta = "Es existencial"
		])

		RepoPregunta.instance.create(new Simple => [
			descripcion = "¿Cual es la masa del sol?"
			autor = pancho
			fechaHoraCreacion = LocalDateTime.now
			//fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Mucha")
			agregarOpcion("Poca")
			agregarOpcion("Maso")
			agregarOpcion("No se sabe")
			respuestaCorrecta = "Mucha"
		])

		RepoPregunta.instance.create(new DeRiesgo => [
			descripcion = "¿Que es mas lento que un piropo de tartamudo?"
			autor = manolo
			//fechaHoraCreacion = LocalDateTime.now
			fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Un caracol")
			agregarOpcion("Higuain")
			agregarOpcion("Una babosa")
			agregarOpcion("Nada")
			respuestaCorrecta = "Higuain"
		])

		RepoPregunta.instance.create(new DeRiesgo => [
			descripcion = "Cocodrilo que durmio es..."
			autor = pancho
			//fechaHoraCreacion = LocalDateTime.now
			fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			agregarOpcion("Feroz")
			agregarOpcion("Anfibio")
			agregarOpcion("Cartera")
			agregarOpcion("Yacare")
			agregarOpcion("No existe el dicho")
			respuestaCorrecta = "Cartera"
		])

		RepoPregunta.instance.create(new Solidaria(12) => [
			descripcion = "Hamlet es una obra de..."
			autor = casandra
			//fechaHoraCreacion = LocalDateTime.now
			fechaHoraCreacion = LocalDateTime.now.minusMinutes(300)
			puntos = 15
			agregarOpcion("Pato donald")
			agregarOpcion("Micky Mouse")
			agregarOpcion("Gallo Claudio")
			agregarOpcion("Coyote")
			agregarOpcion("Shakespare")
			respuestaCorrecta = "Shakespare"
			puntos = 12
		])

		RepoPregunta.instance.create(new Solidaria(18) => [
			descripcion = "Mas vale pajaro en mano que..."
			autor = pepe
			//fechaHoraCreacion = LocalDateTime.now
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

}
