DROP DATABASE IF EXISTS red_social_pascualina;

CREATE DATABASE red_social_pascualina
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE red_social_pascualina;


-- ============================================================
-- 1. TABLA USUARIO
-- ============================================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(150) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    foto_perfil VARCHAR(500),
    area_estudio VARCHAR(120) NOT NULL,

    CONSTRAINT pk_usuario
        PRIMARY KEY (id_usuario),

    CONSTRAINT uq_usuario_correo
        UNIQUE (correo)
);


-- ============================================================
-- 2. TABLA INTERES
-- ============================================================

CREATE TABLE interes (
    id_interes INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_interes
        PRIMARY KEY (id_interes),

    CONSTRAINT uq_interes_nombre
        UNIQUE (nombre)
);


-- ============================================================
-- 3. TABLA HABILIDAD
-- ============================================================

CREATE TABLE habilidad (
    id_habilidad INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_habilidad
        PRIMARY KEY (id_habilidad),

    CONSTRAINT uq_habilidad_nombre
        UNIQUE (nombre)
);


-- ============================================================
-- 4. TABLA USUARIO_INTERES
-- ============================================================

CREATE TABLE usuario_interes (
    id_usuario INT NOT NULL,
    id_interes INT NOT NULL,

    CONSTRAINT pk_usuario_interes
        PRIMARY KEY (id_usuario, id_interes),

    CONSTRAINT fk_usuario_interes_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_interes_interes
        FOREIGN KEY (id_interes)
        REFERENCES interes (id_interes)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- ============================================================
-- 5. TABLA USUARIO_HABILIDAD
-- ============================================================

CREATE TABLE usuario_habilidad (
    id_usuario INT NOT NULL,
    id_habilidad INT NOT NULL,

    CONSTRAINT pk_usuario_habilidad
        PRIMARY KEY (id_usuario, id_habilidad),

    CONSTRAINT fk_usuario_habilidad_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_habilidad_habilidad
        FOREIGN KEY (id_habilidad)
        REFERENCES habilidad (id_habilidad)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- ============================================================
-- 6. TABLA PUBLICACION
-- ============================================================

CREATE TABLE publicacion (
    id_publicacion INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_publicacion VARCHAR(50) NOT NULL,

    CONSTRAINT pk_publicacion
        PRIMARY KEY (id_publicacion),

    CONSTRAINT fk_publicacion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- ============================================================
-- 7. TABLA GRUPO
-- ============================================================

CREATE TABLE grupo (
    id_grupo INT AUTO_INCREMENT,
    id_usuario_creador INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    tipo_grupo VARCHAR(50) NOT NULL,
    foto VARCHAR(500),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_grupo
        PRIMARY KEY (id_grupo),

    CONSTRAINT fk_grupo_usuario_creador
        FOREIGN KEY (id_usuario_creador)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- 8. TABLA USUARIO_GRUPO
-- ============================================================

CREATE TABLE usuario_grupo (
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rol VARCHAR(50) NOT NULL DEFAULT 'miembro',

    CONSTRAINT pk_usuario_grupo
        PRIMARY KEY (id_usuario, id_grupo),

    CONSTRAINT fk_usuario_grupo_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_grupo_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- ============================================================
-- 9. TABLA EVENTO
-- Incluye JSON para información semiestructurada
-- relacionada con ubicación, GPS e IoT.
-- ============================================================

CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT,
    id_usuario_creador INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(200) NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,

    datos_ubicacion JSON,

    CONSTRAINT pk_evento
        PRIMARY KEY (id_evento),

    CONSTRAINT fk_evento_usuario_creador
        FOREIGN KEY (id_usuario_creador)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- 10. TABLA USUARIO_EVENTO
-- ============================================================

CREATE TABLE usuario_evento (
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    estado_participacion VARCHAR(30)
        NOT NULL DEFAULT 'confirmado',

    CONSTRAINT pk_usuario_evento
        PRIMARY KEY (id_usuario, id_evento),

    CONSTRAINT fk_usuario_evento_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_evento_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT ck_usuario_evento_estado
        CHECK (
            estado_participacion IN (
                'pendiente',
                'confirmado',
                'cancelado'
            )
        )
);


-- ============================================================
-- 11. TABLA CHAT
-- ============================================================

CREATE TABLE chat (
    id_chat INT AUTO_INCREMENT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_chat VARCHAR(20) NOT NULL,

    CONSTRAINT pk_chat
        PRIMARY KEY (id_chat),

    CONSTRAINT ck_chat_tipo
        CHECK (
            tipo_chat IN ('privado', 'grupal')
        )
);


-- ============================================================
-- 12. TABLA USUARIO_CHAT
-- ============================================================

CREATE TABLE usuario_chat (
    id_usuario INT NOT NULL,
    id_chat INT NOT NULL,

    CONSTRAINT pk_usuario_chat
        PRIMARY KEY (id_usuario, id_chat),

    CONSTRAINT fk_usuario_chat_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_chat_chat
        FOREIGN KEY (id_chat)
        REFERENCES chat (id_chat)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- ============================================================
-- 13. TABLA MENSAJE
-- ============================================================

CREATE TABLE mensaje (
    id_mensaje INT AUTO_INCREMENT,
    id_chat INT NOT NULL,
    id_usuario INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'enviado',

    CONSTRAINT pk_mensaje
        PRIMARY KEY (id_mensaje),

    CONSTRAINT fk_mensaje_chat
        FOREIGN KEY (id_chat)
        REFERENCES chat (id_chat)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_mensaje_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_mensaje_estado
        CHECK (
            estado IN (
                'enviado',
                'entregado',
                'leido'
            )
        )
);


-- ============================================================
-- 14. TABLA ARCHIVO
-- ============================================================

CREATE TABLE archivo (
    id_archivo INT AUTO_INCREMENT,
    id_mensaje INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    tamano BIGINT NOT NULL,
    ubicacion VARCHAR(500) NOT NULL,

    CONSTRAINT pk_archivo
        PRIMARY KEY (id_archivo),

    CONSTRAINT fk_archivo_mensaje
        FOREIGN KEY (id_mensaje)
        REFERENCES mensaje (id_mensaje)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT ck_archivo_tamano
        CHECK (tamano >= 0)
);


-- ============================================================
-- 15. TABLA CONEXION
-- En MySQL 8.4 usamos RESTRICT en las FK de esta tabla
-- para evitar conflicto entre CHECK y acciones referenciales.
-- ============================================================

CREATE TABLE conexion (
    id_conexion INT AUTO_INCREMENT,
    id_usuario_solicitante INT NOT NULL,
    id_usuario_receptor INT NOT NULL,
    fecha_solicitud TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    fecha_conexion TIMESTAMP NULL,

    CONSTRAINT pk_conexion
        PRIMARY KEY (id_conexion),

    CONSTRAINT fk_conexion_solicitante
        FOREIGN KEY (id_usuario_solicitante)
        REFERENCES usuario (id_usuario)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_conexion_receptor
        FOREIGN KEY (id_usuario_receptor)
        REFERENCES usuario (id_usuario)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT ck_conexion_usuarios_diferentes
        CHECK (
            id_usuario_solicitante <> id_usuario_receptor
        ),

    CONSTRAINT ck_conexion_estado
        CHECK (
            estado IN (
                'pendiente',
                'aceptada',
                'rechazada'
            )
        ),

    CONSTRAINT ck_conexion_fecha
        CHECK (
            (
                estado = 'aceptada'
                AND fecha_conexion IS NOT NULL
            )
            OR
            (
                estado <> 'aceptada'
                AND fecha_conexion IS NULL
            )
        )
);