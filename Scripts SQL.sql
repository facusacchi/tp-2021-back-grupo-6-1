USE pregunta3;

-- 2. TRIGGER ------

CREATE TABLE modificacion(
id_modificacion INT UNSIGNED AUTO_INCREMENT NOT NULL,
id_pregunta bigint NOT NULL,
fecha DATE NOT NULL,
hora TIME NOT NULL,
texto_anterior varchar(150) NOT NULL,
texto_posterior varchar(150) NOT NULL,
CONSTRAINT pk_modificacion
PRIMARY KEY(id_modificacion)
);

delimiter !
CREATE TRIGGER MODIFICACION_TEXTO_PREGUNTA
AFTER UPDATE ON pregunta
FOR EACH ROW 
BEGIN
INSERT INTO modificacion(id_pregunta, fecha, hora, texto_anterior, texto_posterior)
VALUES(OLD.id, curdate(), curtime(), OLD.descripcion, NEW.descripcion);
END; !
delimiter ;

-- FIN TRIGGER ------
