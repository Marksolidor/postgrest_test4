CREATE DATABASE desafio4_marco_camargo_123;

\c desafio4_marco_camargo_123

/*1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos. (1 punto) */

CREATE TABLE peliculas(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    anno INTEGER);

CREATE TABLE tags(
    id INTEGER PRIMARY KEY,
    tag VARCHAR(255));

CREATE TABLE pelicula_tags (
  pelicula_id BIGINT,
  tag_id BIGINT,
  FOREIGN KEY (pelicula_id) REFERENCES peliculas (id),
  FOREIGN KEY (tag_id) REFERENCES tags (id));

  /* 2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados. (1 punto) */
INSERT INTO peliculas (id, nombre, anno) VALUES 
(1 ,'Black Adam', 2022),
(2, 'Black Panther 2', 2022),
(3, 'Godzilla vs Kong', 2021),
(4, 'Evil Dead', 2019),
(5, 'Mad God', 2022);

INSERT INTO tags (id, tag) VALUES 
(1, 'accion'),
(2, 'aventura'),
(3, 'animacion'),
(4, 'terror'),
(5, 'ciencia ficcion');

INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES 
(1, 1),
(1, 2),
(1, 5),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 4),
(5, 4);

/*3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0. (1 punto) */

SELECT peliculas.nombre, COUNT(pelicula_tags.tag_id) FROM peliculas 
LEFT JOIN pelicula_tags ON peliculas.id = pelicula_tags.pelicula_id GROUP BY peliculas.nombre ORDER BY peliculas.nombre ASC; 

/* 4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos. (1 punto) */

CREATE TABLE preguntas(
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR);

CREATE TABLE usuarios(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER);

CREATE TABLE respuestas(
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas (id));

/* 5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
(1 punto) */

INSERT INTO usuarios (id, nombre, edad) VALUES 
(1, 'Juan', 20),
(2, 'Pedro', 25),
(3, 'Maria', 30),
(4, 'Jose', 35),
(5, 'Luis', 40);

INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES 
(1, '¿Cual es el color de la naturaleza?', 'verde'),
(2, '¿Cual es el color del sol?', 'amarillo'),
(3, '¿Cual es el color del agua?', 'azul'),
(4, '¿Cual es el color de la muerte?', 'negro'),
(5, '¿Cual es el color del fuego?', 'rojo');

INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES 
(1, 'verde', 1, 1),
(2, 'verde', 2, 1),
(3, 'amarillo', 1, 2),
(4, 'azul', 2, 4),
(5, 'negro', 5, 5);

/* 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta). (1 punto) */

SELECT usuarios.nombre, COUNT(preguntas.respuesta_correcta) AS respuestas_correctas 
FROM preguntas RIGHT JOIN respuestas ON respuestas.respuesta = preguntas.respuesta_correcta 
JOIN usuarios ON usuarios.id = respuestas.usuario_id GROUP by usuario_id, usuarios.nombre;

/*7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta. (1 punto) */

SELECT preguntas.pregunta, COUNT(respuestas.usuario_id) AS respuesta_correctas
FROM respuestas RIGHT JOIN preguntas ON respuestas.pregunta_id = preguntas.id
GROUP BY preguntas.pregunta;

/* 8.Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación. (1 punto) */

ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, 
ADD FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;

DELETE FROM usuarios WHERE id = 1;

/* 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos. (1 punto) */

ALTER TABLE usuarios ADD CHECK (edad > 18); 

/* 10.  Altera la tabla existente de usuarios agregando el campo email con la restricción de
único. (1 punto) */

ALTER TABLE usuarios ADD COLUMN email VARCHAR(255) UNIQUE;
