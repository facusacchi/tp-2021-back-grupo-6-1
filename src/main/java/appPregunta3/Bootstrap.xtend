package appPregunta3

import dominio.Usuario
import repos.RepoUsuario
import java.time.LocalDate

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
	}

	def crearUsuarios() {
		pepe = new Usuario => [
			nombre = "Pepe"
			apellido = "Palala"
			userName = "pepito"
			password = "123"
			fechaDeNacimiento = LocalDate.of(1990, 7, 28)
		]
		RepoUsuario.instance.create(pepe)

		manolo = new Usuario => [
			nombre = "Manolo"
			apellido = "Palala"
			userName = "manolito"
			password = "456"
			fechaDeNacimiento = LocalDate.of(1995, 10, 4)
		]
		RepoUsuario.instance.create(manolo)

		nancy = new Usuario => [
			nombre = "Nancy"
			apellido = "Vargas"
			userName = "nan"
			password = "123"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(nancy)

		casandra = new Usuario => [
			nombre = "Casandra"
			apellido = "Malandra"
			userName = "casalandra"
			password = "774"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(casandra)

		lucrecia = new Usuario => [
			nombre = "Lucrecia"
			apellido = "Magnesia"
			userName = "lugenesia"
			password = "122"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(lucrecia)

		pancho = new Usuario => [
			nombre = "Pancho"
			apellido = "Rancho"
			userName = "zafarancho"
			password = "999"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(pancho)

		elena = new Usuario => [
			nombre = "Elena"
			apellido = "Melena"
			userName = "melinena"
			password = "364"
			fechaDeNacimiento = LocalDate.of(1985, 5, 7)
		]
		RepoUsuario.instance.create(elena)
	}

}
