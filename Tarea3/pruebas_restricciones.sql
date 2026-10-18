-- ============================================================
-- PRUEBAS DE RESTRICCIONES
-- Red Social Estudiantil Pascualina
-- PostgreSQL 16
--
-- IMPORTANTE:
-- Estas pruebas están diseñadas para FALLAR a propósito.
-- Cada error demuestra que una restricción está funcionando.
-- ============================================================


-- ============================================================
-- 1. PRUEBA UNIQUE
-- No debe permitir dos usuarios con el mismo correo.
-- ============================================================

INSERT INTO usuario (
    nombre,
    telefono,
    correo,
    contrasena,
    foto_perfil,
    area_estudio
)
VALUES (
    'Usuario Repetido',
    '3009999999',
    'juan.marin@pascual.edu.co',
    'hash_prueba',
    NULL,
    'Tecnología en Desarrollo de Software'
);


-- ============================================================
-- 2. PRUEBA FOREIGN KEY
-- No debe permitir una publicación de un usuario inexistente.
-- ============================================================

INSERT INTO publicacion (
    id_usuario,
    contenido,
    tipo_publicacion
)
VALUES (
    9999,
    'Publicación de prueba con usuario inexistente',
    'prueba'
);


-- ============================================================
-- 3. PRUEBA CHECK - CONEXIÓN ENTRE EL MISMO USUARIO
-- No debe permitir que un usuario se conecte consigo mismo.
-- ============================================================

INSERT INTO conexion (
    id_usuario_solicitante,
    id_usuario_receptor,
    estado
)
VALUES (
    1,
    1,
    'pendiente'
);


-- ============================================================
-- 4. PRUEBA CHECK - ESTADO DE CONEXIÓN
-- Solo se permiten:
-- pendiente
-- aceptada
-- rechazada
-- ============================================================

INSERT INTO conexion (
    id_usuario_solicitante,
    id_usuario_receptor,
    estado
)
VALUES (
    1,
    2,
    'bloqueada'
);


-- ============================================================
-- 5. PRUEBA CHECK - FECHA DE CONEXIÓN
-- Si el estado es aceptada, fecha_conexion debe tener valor.
-- ============================================================

INSERT INTO conexion (
    id_usuario_solicitante,
    id_usuario_receptor,
    estado,
    fecha_conexion
)
VALUES (
    2,
    4,
    'aceptada',
    NULL
);


-- ============================================================
-- 6. PRUEBA CHECK - CHAT
-- Solo se permiten chats:
-- privado
-- grupal
-- ============================================================

INSERT INTO chat (
    tipo_chat
)
VALUES (
    'publico'
);


-- ============================================================
-- 7. PRUEBA CHECK - ESTADO DEL MENSAJE
-- Solo se permiten:
-- enviado
-- entregado
-- leido
-- ============================================================

INSERT INTO mensaje (
    id_chat,
    id_usuario,
    contenido,
    estado
)
VALUES (
    1,
    1,
    'Mensaje de prueba',
    'eliminado'
);


-- ============================================================
-- 8. PRUEBA CHECK - ESTADO DE PARTICIPACIÓN
-- Solo se permiten:
-- pendiente
-- confirmado
-- cancelado
-- ============================================================

INSERT INTO usuario_evento (
    id_usuario,
    id_evento,
    estado_participacion
)
VALUES (
    4,
    1,
    'asistio'
);


-- ============================================================
-- 9. PRUEBA CHECK - TAMAÑO DEL ARCHIVO
-- No debe permitir un tamaño negativo.
-- ============================================================

INSERT INTO archivo (
    id_mensaje,
    nombre,
    tipo,
    tamano,
    ubicacion
)
VALUES (
    1,
    'archivo_invalido.pdf',
    'application/pdf',
    -100,
    '/archivos/archivo_invalido.pdf'
);


-- ============================================================
-- 10. PRUEBA PRIMARY KEY COMPUESTA
-- El usuario 1 ya pertenece al grupo 1.
-- No debe permitir repetir la misma combinación.
-- ============================================================

INSERT INTO usuario_grupo (
    id_usuario,
    id_grupo,
    rol
)
VALUES (
    1,
    1,
    'miembro'
);