# Red Social Pascualina

Proyecto académico del **Grupo 9** de Bases de Datos I, orientado al diseño conceptual de una base de datos para una red social estudiantil de la Institución Universitaria Pascual Bravo. La propuesta contempla perfiles, seguimiento de estudiantes, conexiones entre compañeros, publicaciones, grupos de estudio, eventos, chats, mensajes y archivos adjuntos.

## Información académica

| Campo | Información |
| --- | --- |
| Institución | Institución Universitaria Pascual Bravo |
| Programa | Tecnología en Desarrollo de Software |
| Asignatura | Bases de Datos I |
| Actividad | Tarea 1: Modelo Entidad-Relación |
| Grupo | 9 |
| Docente | Oralia Cortes Grajales |
| Lugar y año | Medellín, 2026 |

## Integrantes

- Juan José Marín Luján
- Juan Sebastián Briñez Orjuela
- Juan Pablo Correa Rave
- Simon Madrid Tamayo

## Objetivo y alcance

Diseñar el Modelo Entidad-Relación (MER) que representa la información de la Red Social Pascualina, identificando entidades, atributos, identificadores, relaciones y cardinalidades, y justificando las decisiones de diseño.

Esta entrega corresponde al modelo conceptual. El modelo lógico, los scripts SQL y la aplicación no forman parte de los entregables aquí presentados.

## Entregables de la Tarea 1

| Entregable | Archivo o ubicación | Estado |
| --- | --- | --- |
| Informe PDF | [Informe.pdf](Tarea1/Informe/Informe.pdf) | Disponible; faltan tres conclusiones individuales |
| Informe editable | [Informe.docx](Tarea1/Informe/Informe.docx) | Disponible |
| Diagrama editable en draw.io | [MER.drawio](Tarea1/MER.drawio) | Disponible |
| Diagrama exportado | [MER.png](Tarea1/Informe/MER.png) | Disponible e incluido en el informe |
| Sustentación en YouTube | Enlace de YouTube pendiente | Pendiente de grabación y enlace |

El informe desarrolla el análisis de necesidades, la identificación y justificación de entidades y atributos, las relaciones y cardinalidades, el diagrama MER, las decisiones de diseño, las conclusiones individuales y las referencias. La sección de conclusiones está pendiente de completarse con los aportes de todos los integrantes.

## Estructura del repositorio

```text
bd1-redsocial-grupo9/
├── README.md
└── Tarea1/
    ├── MER.drawio
    ├── Informe/
    │   ├── Informe.docx
    │   ├── Informe.pdf
    │   └── MER.png
    └── Video/                 # Pendiente de crear con el enlace de YouTube
```

## Seguimiento y conexiones

El modelo contiene **ocho entidades y doce relaciones**. Conserva la entidad **Conexión** e incorpora **SIGUE** como relación recursiva entre usuarios.

| Función | Representación | Reglas |
| --- | --- | --- |
| Seguir estudiantes | Usuario SIGUE Usuario, M:N | No requiere aceptación ni reciprocidad. Cada usuario puede seguir a cero o muchos usuarios y tener cero o muchos seguidores. |
| Solicitar una conexión | Usuario SOLICITA Conexión y Usuario RECIBE Conexión, ambas 1:N | Mantiene solicitante, receptor, estado, fecha de solicitud y fecha de aceptación. |

SIGUE distingue los roles **seguidor** y **seguido**, y tiene el atributo **fecha_seguimiento**. Un usuario no puede seguirse a sí mismo ni registrar dos veces el mismo par ordenado (seguidor, seguido). Seguir a otro usuario no crea ni acepta una conexión; aceptar una conexión tampoco crea seguimientos automáticamente.

La relación SIGUE permite cubrir el requisito de seguir compañeros con intereses similares o que puedan ofrecer mentoría. El informe, su PDF y el diagrama documentan ambos comportamientos.
