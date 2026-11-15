-- ====================================================================
-- 2. CONSULTAS DML 

-- ====================================================================

-- CONSULTA 3: Volumen y temáticas de publicaciones por área de estudio
SELECT 
    u.area_estudio AS "Área de Estudio",
    p.tipo_publicacion AS "Tipo de Publicación",
    COUNT(p.id_publicacion) AS "Total Publicaciones",
    MAX(p.fecha_hora) AS "Última Publicación"
FROM usuario u
INNER JOIN publicacion p ON u.id_usuario = p.id_usuario
GROUP BY u.area_estudio, p.tipo_publicacion
ORDER BY "Total Publicaciones" DESC;

-- CONSULTA 4: Popularidad y adopción de grupos de estudio
SELECT 
    g.nombre AS "Nombre del Grupo",
    g.tipo_grupo AS "Categoría",
    c.nombre AS "Creador del Grupo",
    COUNT(ug.id_usuario) AS "Cantidad de Miembros",
    MIN(ug.fecha_union) AS "Fecha del Primer Miembro"
FROM grupo g
INNER JOIN usuario c ON g.id_usuario_creador = c.id_usuario
LEFT JOIN usuario_grupo ug ON g.id_grupo = ug.id_grupo
GROUP BY g.id_grupo, g.nombre, g.tipo_grupo, c.nombre
ORDER BY "Cantidad de Miembros" DESC;

-- CONSULTA 5: Logística y participación en eventos
SELECT 
    e.nombre AS "Nombre del Evento",
    e.fecha AS "Fecha Programada",
    e.lugar AS "Ubicación",
    COUNT(CASE WHEN ue.estado_participacion = 'confirmado' THEN 1 END) AS "Asistentes Confirmados",
    COUNT(CASE WHEN ue.estado_participacion = 'pendiente' THEN 1 END) AS "Asistentes Pendientes",
    COUNT(CASE WHEN ue.estado_participacion = 'cancelado' THEN 1 END) AS "Asistencias Canceladas"
FROM evento e
LEFT JOIN usuario_evento ue ON e.id_evento = ue.id_evento
GROUP BY e.id_evento, e.nombre, e.fecha, e.lugar
ORDER BY e.fecha ASC, "Asistentes Confirmados" DESC;


-- ====================================================================
-- 3. CREACIÓN DE VISTAS (VIEWS)
-- ====================================================================

-- VISTA 1: Actividad de usuarios
CREATE OR REPLACE VIEW vista_actividad_usuarios AS
SELECT 
    u.id_usuario,
    u.nombre AS estudiante,
    u.area_estudio,
    (SELECT COUNT(*) FROM publicacion p WHERE p.id_usuario = u.id_usuario) AS total_publicaciones,
    (SELECT COUNT(*) FROM usuario_grupo ug WHERE ug.id_usuario = u.id_usuario) AS total_grupos,
    (SELECT COUNT(*) FROM usuario_evento ue WHERE ue.id_usuario = u.id_usuario AND ue.estado_participacion = 'confirmado') AS eventos_confirmados
FROM usuario u;

-- Demostración Vista 1
SELECT * FROM vista_actividad_usuarios ORDER BY total_publicaciones DESC LIMIT 10;


-- VISTA 2: Directorio de grupos
CREATE OR REPLACE VIEW vista_directorio_grupos AS
SELECT 
    g.nombre AS nombre_grupo,
    g.tipo_grupo,
    u.nombre AS nombre_miembro,
    u.correo AS correo_contacto,
    ug.rol,
    ug.fecha_union
FROM grupo g
INNER JOIN usuario_grupo ug ON g.id_grupo = ug.id_grupo
INNER JOIN usuario u ON ug.id_usuario = u.id_usuario;

-- Demostración Vista 2
SELECT * FROM vista_directorio_grupos WHERE rol = 'administrador';


-- VISTA 3: Logística de eventos (Versión corregida con DROP)
DROP VIEW IF EXISTS vista_logistica_eventos;

CREATE VIEW vista_logistica_eventos AS
SELECT 
    e.id_evento,
    e.nombre AS evento,
    e.fecha,
    e.lugar,
    COUNT(CASE WHEN ue.estado_participacion = 'confirmado' THEN 1 END) AS confirmados,
    COUNT(CASE WHEN ue.estado_participacion = 'pendiente' THEN 1 END) AS pendientes,
    COUNT(CASE WHEN ue.estado_participacion = 'cancelado' THEN 1 END) AS cancelados
FROM evento e
LEFT JOIN usuario_evento ue ON e.id_evento = ue.id_evento
GROUP BY 
    e.id_evento, 
    e.nombre, 
    e.fecha, 
    e.lugar;

-- Demostración Vista 3
SELECT evento, lugar, confirmados FROM vista_logistica_eventos;