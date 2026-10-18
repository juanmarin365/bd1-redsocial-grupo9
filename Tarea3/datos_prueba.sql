-- ============================================================
-- DATOS DE PRUEBA
-- Red Social Estudiantil Pascualina
-- PostgreSQL 16
-- ============================================================


INSERT INTO usuario (
    nombre,
    telefono,
    correo,
    contrasena,
    foto_perfil,
    area_estudio
)
VALUES
(
    'Juan José Marín',
    '3001234567',
    'juan.marin@pascual.edu.co',
    'hash_prueba_1',
    NULL,
    'Tecnología en Desarrollo de Software'
),
(
    'Sebastián Briñez',
    '3011234567',
    'sebastian.brinez@pascual.edu.co',
    'hash_prueba_2',
    NULL,
    'Tecnología en Desarrollo de Software'
),
(
    'Juan Pablo Correa',
    '3021234567',
    'juan.correa@pascual.edu.co',
    'hash_prueba_3',
    NULL,
    'Tecnología en Desarrollo de Software'
),
(
    'Simon Madrid',
    '3031234567',
    'simon.madrid@pascual.edu.co',
    'hash_prueba_4',
    NULL,
    'Tecnología en Desarrollo de Software'
);

INSERT INTO interes (nombre)
VALUES
('Bases de datos'),
('Programación'),
('Videojuegos'),
('Inteligencia artificial'),
('Desarrollo web');

INSERT INTO habilidad (nombre)
VALUES
('SQL'),
('Java'),
('Python'),
('JavaScript'),
('C++');

INSERT INTO usuario_interes (
    id_usuario,
    id_interes
)
VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 2),
(2, 5),
(3, 3),
(3, 5),
(4, 1),
(4, 3);

INSERT INTO usuario_habilidad (
    id_usuario,
    id_habilidad
)
VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 4),
(3, 5),
(4, 1),
(4, 5);

INSERT INTO publicacion (
    id_usuario,
    contenido,
    tipo_publicacion
)
VALUES
(
    1,
    '¿Alguien tiene material para estudiar bases de datos?',
    'pregunta'
),
(
    2,
    'Comparto un recurso para practicar programación.',
    'recurso'
),
(
    3,
    '¿Quién se apunta para formar un grupo de estudio?',
    'pregunta'
),
(
    4,
    'Les comparto una noticia sobre tecnología.',
    'noticia'
);

INSERT INTO grupo (
    id_usuario_creador,
    nombre,
    descripcion,
    tipo_grupo
)
VALUES
(
    1,
    'Grupo de estudio Bases de Datos',
    'Grupo para estudiar y compartir ejercicios de Bases de Datos I.',
    'estudio'
),
(
    2,
    'Club de Programación',
    'Espacio para compartir ejercicios y retos de programación.',
    'club'
);

INSERT INTO usuario_grupo (
    id_usuario,
    id_grupo,
    rol
)
VALUES
(1, 1, 'administrador'),
(2, 1, 'miembro'),
(3, 1, 'miembro'),
(2, 2, 'administrador'),
(3, 2, 'miembro'),
(4, 2, 'miembro');

INSERT INTO evento (
    id_usuario_creador,
    nombre,
    descripcion,
    fecha,
    hora,
    lugar,
    tipo_evento
)
VALUES
(
    1,
    'Repaso de Bases de Datos',
    'Reunión para estudiar antes del parcial.',
    '2026-10-25',
    '10:00',
    'Biblioteca Pascual Bravo',
    'estudio'
),
(
    2,
    'Taller de Programación',
    'Taller práctico para resolver ejercicios de programación.',
    '2026-10-28',
    '14:00',
    'Sala de sistemas',
    'taller'
);

INSERT INTO usuario_evento (
    id_usuario,
    id_evento,
    estado_participacion
)
VALUES
(1, 1, 'confirmado'),
(2, 1, 'confirmado'),
(3, 1, 'pendiente'),
(2, 2, 'confirmado'),
(3, 2, 'confirmado'),
(4, 2, 'cancelado');

INSERT INTO chat (
    tipo_chat
)
VALUES
('grupal'),
('privado');

INSERT INTO usuario_chat (
    id_usuario,
    id_chat
)
VALUES
(1, 1),
(2, 1),
(3, 1),
(1, 2),
(4, 2);

INSERT INTO mensaje (
    id_chat,
    id_usuario,
    contenido
)
VALUES
(
    1,
    1,
    'Hola, ¿a qué hora nos reunimos para estudiar?'
),
(
    1,
    2,
    'Podemos reunirnos a las 10 de la mañana.'
),
(
    1,
    3,
    'Yo también puedo a esa hora.'
),
(
    2,
    1,
    'Hola Simon, ¿vas a participar en el taller?'
),
(
    2,
    4,
    'Sí, tengo pensado asistir.'
);

INSERT INTO archivo (
    id_mensaje,
    nombre,
    tipo,
    tamano,
    ubicacion
)
VALUES
(
    1,
    'guia_bases_datos.pdf',
    'application/pdf',
    250000,
    '/archivos/guia_bases_datos.pdf'
),
(
    2,
    'ejercicios_sql.pdf',
    'application/pdf',
    180000,
    '/archivos/ejercicios_sql.pdf'
),
(
    4,
    'informacion_taller.png',
    'image/png',
    95000,
    '/archivos/informacion_taller.png'
);

INSERT INTO conexion (
    id_usuario_solicitante,
    id_usuario_receptor,
    estado
)
VALUES
(
    1,
    2,
    'pendiente'
),
(
    3,
    4,
    'rechazada'
);

INSERT INTO conexion (
    id_usuario_solicitante,
    id_usuario_receptor,
    estado,
    fecha_conexion
)
VALUES
(
    2,
    3,
    'aceptada',
    CURRENT_TIMESTAMP
),
(
    1,
    4,
    'aceptada',
    CURRENT_TIMESTAMP
);

SELECT * FROM usuario;

SELECT * FROM interes;

SELECT * FROM habilidad;

SELECT * FROM usuario_interes;

SELECT * FROM usuario_habilidad;

SELECT * FROM publicacion;

SELECT * FROM grupo;

SELECT * FROM usuario_grupo;

SELECT * FROM evento;

SELECT * FROM usuario_evento;

SELECT * FROM chat;

SELECT * FROM usuario_chat;

SELECT * FROM mensaje;

SELECT * FROM archivo;

SELECT * FROM conexion;

SELECT
    u.nombre AS usuario,
    p.contenido,
    p.tipo_publicacion,
    p.fecha_hora
FROM publicacion p
INNER JOIN usuario u
    ON p.id_usuario = u.id_usuario;

SELECT
    u.nombre AS usuario,
    i.nombre AS interes
FROM usuario u
INNER JOIN usuario_interes ui
    ON u.id_usuario = ui.id_usuario
INNER JOIN interes i
    ON ui.id_interes = i.id_interes
ORDER BY u.nombre;

SELECT
    u.nombre AS usuario,
    h.nombre AS habilidad
FROM usuario u
INNER JOIN usuario_habilidad uh
    ON u.id_usuario = uh.id_usuario
INNER JOIN habilidad h
    ON uh.id_habilidad = h.id_habilidad
ORDER BY u.nombre;

SELECT
    u.nombre AS usuario,
    g.nombre AS grupo,
    ug.rol,
    ug.fecha_union
FROM usuario_grupo ug
INNER JOIN usuario u
    ON ug.id_usuario = u.id_usuario
INNER JOIN grupo g
    ON ug.id_grupo = g.id_grupo
ORDER BY g.nombre, u.nombre;

SELECT
    u.nombre AS usuario,
    e.nombre AS evento,
    ue.estado_participacion
FROM usuario_evento ue
INNER JOIN usuario u
    ON ue.id_usuario = u.id_usuario
INNER JOIN evento e
    ON ue.id_evento = e.id_evento
ORDER BY e.nombre, u.nombre;

SELECT
    m.id_mensaje,
    u.nombre AS usuario,
    m.id_chat,
    m.contenido,
    m.estado,
    m.fecha_hora
FROM mensaje m
INNER JOIN usuario u
    ON m.id_usuario = u.id_usuario
ORDER BY m.id_chat, m.fecha_hora;

SELECT
    c.id_conexion,
    solicitante.nombre AS solicitante,
    receptor.nombre AS receptor,
    c.estado,
    c.fecha_solicitud,
    c.fecha_conexion
FROM conexion c
INNER JOIN usuario solicitante
    ON c.id_usuario_solicitante = solicitante.id_usuario
INNER JOIN usuario receptor
    ON c.id_usuario_receptor = receptor.id_usuario
ORDER BY c.id_conexion;