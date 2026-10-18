DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE usuario (
    id_usuario INTEGER GENERATED ALWAYS AS IDENTITY,
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

CREATE TABLE interes (
    id_interes INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_interes
        PRIMARY KEY (id_interes),

    CONSTRAINT uq_interes_nombre
        UNIQUE (nombre)
);

CREATE TABLE habilidad (
    id_habilidad INTEGER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_habilidad
        PRIMARY KEY (id_habilidad),

    CONSTRAINT uq_habilidad_nombre
        UNIQUE (nombre)
);

CREATE TABLE usuario_interes (
    id_usuario INTEGER NOT NULL,
    id_interes INTEGER NOT NULL,

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

CREATE TABLE usuario_habilidad (
    id_usuario INTEGER NOT NULL,
    id_habilidad INTEGER NOT NULL,

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

CREATE TABLE publicacion (
    id_publicacion INTEGER GENERATED ALWAYS AS IDENTITY,
    id_usuario INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_hora TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_publicacion VARCHAR(50) NOT NULL,

    CONSTRAINT pk_publicacion
        PRIMARY KEY (id_publicacion),

    CONSTRAINT fk_publicacion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE grupo (
    id_grupo INTEGER GENERATED ALWAYS AS IDENTITY,
    id_usuario_creador INTEGER NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    tipo_grupo VARCHAR(50) NOT NULL,
    foto VARCHAR(500),
    fecha_creacion TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_grupo
        PRIMARY KEY (id_grupo),

    CONSTRAINT fk_grupo_usuario_creador
        FOREIGN KEY (id_usuario_creador)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE usuario_grupo (
    id_usuario INTEGER NOT NULL,
    id_grupo INTEGER NOT NULL,
    fecha_union TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP,
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

CREATE TABLE evento (
    id_evento INTEGER GENERATED ALWAYS AS IDENTITY,
    id_usuario_creador INTEGER NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(200) NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,

    CONSTRAINT pk_evento
        PRIMARY KEY (id_evento),

    CONSTRAINT fk_evento_usuario_creador
        FOREIGN KEY (id_usuario_creador)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE usuario_evento (
    id_usuario INTEGER NOT NULL,
    id_evento INTEGER NOT NULL,
    estado_participacion VARCHAR(30) NOT NULL DEFAULT 'confirmado',

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

CREATE TABLE chat (
    id_chat INTEGER GENERATED ALWAYS AS IDENTITY,
    fecha_creacion TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_chat VARCHAR(20) NOT NULL,

    CONSTRAINT pk_chat
        PRIMARY KEY (id_chat),

    CONSTRAINT ck_chat_tipo
        CHECK (
            tipo_chat IN ('privado', 'grupal')
        )
);

CREATE TABLE usuario_chat (
    id_usuario INTEGER NOT NULL,
    id_chat INTEGER NOT NULL,

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

CREATE TABLE mensaje (
    id_mensaje INTEGER GENERATED ALWAYS AS IDENTITY,
    id_chat INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    contenido TEXT NOT NULL,
    fecha_hora TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
            estado IN ('enviado', 'entregado', 'leido')
        )
);

CREATE TABLE archivo (
    id_archivo INTEGER GENERATED ALWAYS AS IDENTITY,
    id_mensaje INTEGER NOT NULL,
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

CREATE TABLE conexion (
    id_conexion INTEGER GENERATED ALWAYS AS IDENTITY,
    id_usuario_solicitante INTEGER NOT NULL,
    id_usuario_receptor INTEGER NOT NULL,
    fecha_solicitud TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    fecha_conexion TIMESTAMP WITH TIME ZONE,

    CONSTRAINT pk_conexion
        PRIMARY KEY (id_conexion),

    CONSTRAINT fk_conexion_solicitante
        FOREIGN KEY (id_usuario_solicitante)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_conexion_receptor
        FOREIGN KEY (id_usuario_receptor)
        REFERENCES usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

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
            (estado = 'aceptada' AND fecha_conexion IS NOT NULL)
            OR
            (estado <> 'aceptada' AND fecha_conexion IS NULL)
        )
);