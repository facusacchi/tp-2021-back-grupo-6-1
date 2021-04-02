package appPregunta3

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

@SpringBootApplication class PreguntasApplication {
	def static void main(String[] args) {
		new Bootstrap => [run]
		SpringApplication.run(PreguntasApplication, args)
	}
}
