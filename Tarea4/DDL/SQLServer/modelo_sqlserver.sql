USE master;
GO

IF DB_ID('red_social_pascualina') IS NOT NULL
BEGIN
    ALTER DATABASE red_social_pascualina
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE red_social_pascualina;
END;
GO

CREATE DATABASE red_social_pascualina;
GO

USE red_social_pascualina;
GO


-- ============================================================
-- 1. TABLA USUARIO
-- ============================================================

CREATE TABLE usuario (
    id_usuario INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20) NULL,
    correo NVARCHAR(150) NOT NULL,
    contrasena NVARCHAR(255) NOT NULL,
    foto_perfil NVARCHAR(500) NULL,
    area_estudio NVARCHAR(120) NOT NULL,

    CONSTRAINT pk_usuario
        PRIMARY KEY (id_usuario),

    CONSTRAINT uq_usuario_correo
        UNIQUE (correo)
);
GO


-- ============================================================
-- 2. TABLA INTERES
-- ============================================================

CREATE TABLE interes (
    id_interes INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,

    CONSTRAINT pk_interes
        PRIMARY KEY (id_interes),

    CONSTRAINT uq_interes_nombre
        UNIQUE (nombre)
);
GO


-- ============================================================
-- 3. TABLA HABILIDAD
-- ============================================================

CREATE TABLE habilidad (
    id_habilidad INT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,

    CONSTRAINT pk_habilidad
        PRIMARY KEY (id_habilidad),

    CONSTRAINT uq_habilidad_nombre
        UNIQUE (nombre)
);
GO


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
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_interes_interes
        FOREIGN KEY (id_interes)
        REFERENCES interes (id_interes)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO


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
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_habilidad_habilidad
        FOREIGN KEY (id_habilidad)
        REFERENCES habilidad (id_habilidad)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO


-- ============================================================
-- 6. TABLA PUBLICACION
-- ============================================================

CREATE TABLE publicacion (
    id_publicacion INT IDENTITY(1,1) NOT NULL,
    id_usuario INT NOT NULL,
    contenido NVARCHAR(MAX) NOT NULL,
    fecha_hora DATETIMEOFFSET NOT NULL
        CONSTRAINT df_publicacion_fecha_hora
        DEFAULT SYSDATETIMEOFFSET(),
    tipo_publicacion NVARCHAR(50) NOT NULL,

    CONSTRAINT pk_publicacion
        PRIMARY KEY (id_publicacion),

    CONSTRAINT fk_publicacion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO


-- ============================================================
-- 7. TABLA GRUPO
-- ============================================================

CREATE TABLE grupo (
    id_grupo INT IDENTITY(1,1) NOT NULL,
    id_usuario_creador INT NOT NULL,
    nombre NVARCHAR(120) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    tipo_grupo NVARCHAR(50) NOT NULL,
    foto NVARCHAR(500) NULL,
    fecha_creacion DATETIMEOFFSET NOT NULL
        CONSTRAINT df_grupo_fecha_creacion
        DEFAULT SYSDATETIMEOFFSET(),

    CONSTRAINT pk_grupo
        PRIMARY KEY (id_grupo),

    CONSTRAINT fk_grupo_usuario_creador
        FOREIGN KEY (id_usuario_creador)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
GO


-- ============================================================
-- 8. TABLA USUARIO_GRUPO
-- Ajustada para evitar múltiples rutas de cascada.
-- ============================================================

CREATE TABLE usuario_grupo (
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union DATETIMEOFFSET NOT NULL
        CONSTRAINT df_usuario_grupo_fecha_union
        DEFAULT SYSDATETIMEOFFSET(),
    rol NVARCHAR(50) NOT NULL
        CONSTRAINT df_usuario_grupo_rol
        DEFAULT N'miembro',

    CONSTRAINT pk_usuario_grupo
        PRIMARY KEY (id_usuario, id_grupo),

    CONSTRAINT fk_usuario_grupo_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_grupo_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO


-- ============================================================
-- 9. TABLA EVENTO
-- SQL Server almacena JSON dentro de NVARCHAR(MAX)
-- y se valida mediante ISJSON().
-- ============================================================

CREATE TABLE evento (
    id_evento INT IDENTITY(1,1) NOT NULL,
    id_usuario_creador INT NOT NULL,
    nombre NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX) NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar NVARCHAR(200) NOT NULL,
    tipo_evento NVARCHAR(50) NOT NULL,

    datos_ubicacion NVARCHAR(MAX) NULL,

    CONSTRAINT pk_evento
        PRIMARY KEY (id_evento),

    CONSTRAINT fk_evento_usuario_creador
        FOREIGN KEY (id_usuario_creador)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT ck_evento_datos_ubicacion_json
        CHECK (
            datos_ubicacion IS NULL
            OR ISJSON(datos_ubicacion) = 1
        )
);
GO


-- ============================================================
-- 10. TABLA USUARIO_EVENTO
-- Ajustada para evitar múltiples rutas de cascada.
-- ============================================================

CREATE TABLE usuario_evento (
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    estado_participacion NVARCHAR(30) NOT NULL
        CONSTRAINT df_usuario_evento_estado
        DEFAULT N'confirmado',

    CONSTRAINT pk_usuario_evento
        PRIMARY KEY (id_usuario, id_evento),

    CONSTRAINT fk_usuario_evento_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_evento_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT ck_usuario_evento_estado
        CHECK (
            estado_participacion IN (
                N'pendiente',
                N'confirmado',
                N'cancelado'
            )
        )
);
GO


-- ============================================================
-- 11. TABLA CHAT
-- ============================================================

CREATE TABLE chat (
    id_chat INT IDENTITY(1,1) NOT NULL,
    fecha_creacion DATETIMEOFFSET NOT NULL
        CONSTRAINT df_chat_fecha_creacion
        DEFAULT SYSDATETIMEOFFSET(),
    tipo_chat NVARCHAR(20) NOT NULL,

    CONSTRAINT pk_chat
        PRIMARY KEY (id_chat),

    CONSTRAINT ck_chat_tipo
        CHECK (
            tipo_chat IN (
                N'privado',
                N'grupal'
            )
        )
);
GO


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
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_usuario_chat_chat
        FOREIGN KEY (id_chat)
        REFERENCES chat (id_chat)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO


-- ============================================================
-- 13. TABLA MENSAJE
-- ============================================================

CREATE TABLE mensaje (
    id_mensaje INT IDENTITY(1,1) NOT NULL,
    id_chat INT NOT NULL,
    id_usuario INT NOT NULL,
    contenido NVARCHAR(MAX) NOT NULL,
    fecha_hora DATETIMEOFFSET NOT NULL
        CONSTRAINT df_mensaje_fecha_hora
        DEFAULT SYSDATETIMEOFFSET(),
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT df_mensaje_estado
        DEFAULT N'enviado',

    CONSTRAINT pk_mensaje
        PRIMARY KEY (id_mensaje),

    CONSTRAINT fk_mensaje_chat
        FOREIGN KEY (id_chat)
        REFERENCES chat (id_chat)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_mensaje_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT ck_mensaje_estado
        CHECK (
            estado IN (
                N'enviado',
                N'entregado',
                N'leido'
            )
        )
);
GO


-- ============================================================
-- 14. TABLA ARCHIVO
-- ============================================================

CREATE TABLE archivo (
    id_archivo INT IDENTITY(1,1) NOT NULL,
    id_mensaje INT NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    tipo NVARCHAR(100) NOT NULL,
    tamano BIGINT NOT NULL,
    ubicacion NVARCHAR(500) NOT NULL,

    CONSTRAINT pk_archivo
        PRIMARY KEY (id_archivo),

    CONSTRAINT fk_archivo_mensaje
        FOREIGN KEY (id_mensaje)
        REFERENCES mensaje (id_mensaje)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT ck_archivo_tamano
        CHECK (tamano >= 0)
);
GO


-- ============================================================
-- 15. TABLA CONEXION
-- En SQL Server se mantiene NO ACTION en las relaciones
-- con usuario para evitar conflictos con las restricciones.
-- ============================================================

CREATE TABLE conexion (
    id_conexion INT IDENTITY(1,1) NOT NULL,
    id_usuario_solicitante INT NOT NULL,
    id_usuario_receptor INT NOT NULL,
    fecha_solicitud DATETIMEOFFSET NOT NULL
        CONSTRAINT df_conexion_fecha_solicitud
        DEFAULT SYSDATETIMEOFFSET(),
    estado NVARCHAR(20) NOT NULL
        CONSTRAINT df_conexion_estado
        DEFAULT N'pendiente',
    fecha_conexion DATETIMEOFFSET NULL,

    CONSTRAINT pk_conexion
        PRIMARY KEY (id_conexion),

    CONSTRAINT fk_conexion_solicitante
        FOREIGN KEY (id_usuario_solicitante)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_conexion_receptor
        FOREIGN KEY (id_usuario_receptor)
        REFERENCES usuario (id_usuario)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT ck_conexion_usuarios_diferentes
        CHECK (
            id_usuario_solicitante <> id_usuario_receptor
        ),

    CONSTRAINT ck_conexion_estado
        CHECK (
            estado IN (
                N'pendiente',
                N'aceptada',
                N'rechazada'
            )
        ),

    CONSTRAINT ck_conexion_fecha
        CHECK (
            (
                estado = N'aceptada'
                AND fecha_conexion IS NOT NULL
            )
            OR
            (
                estado <> N'aceptada'
                AND fecha_conexion IS NULL
            )
        )
);
GO