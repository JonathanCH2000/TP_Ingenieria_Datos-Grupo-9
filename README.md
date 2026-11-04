# Gestión de Entradas — TP Integrador Ingeniería de Datos 1 (Grupo 9)

Base de datos en SQL Server para la venta de entradas a eventos: organizadores, lugares, eventos, clientes, compras y entradas.

## Integrantes

| Integrante | Parte del trabajo |
|---|---|
| John | Universo del discurso, DER y modelo relacional, primeros datos de prueba y primeras consultas. Creación del repositorio |
| Gonza | Modelo de datos, datos de prueba, seguridad e integración del script completo |
| Maxi | Consultas, subconsultas, vistas y funciones |
| Naza | Procedimientos almacenados, triggers, cursores y manejo de errores |

## Modelo

| Tabla | Qué representa |

| `organizador` | Quien produce y es responsable de cada evento |
| `lugar` | Espacios donde se realizan los eventos, con su capacidad |
| `evento` | Cada función, con su fecha, horario, lugar y organizador |
| `cliente` | Quien compra entradas |
| `compra` | Operación de compra, con su estado de pago y su total |
| `entrada` | Cada entrada emitida, con código único, precio y estado |

Reglas de negocio principales:

- Un evento no puede vender más entradas que la capacidad del lugar donde se realiza.
- Dos eventos no pueden superponerse en el mismo lugar y horario.
- Al cancelarse una compra, sus entradas se anulan automáticamente.
- No se puede cancelar una compra que ya tenga entradas utilizadas.
- Una entrada habilita el ingreso solo si está habilitada, su compra está pagada y el evento está activo.
- `compra.total` se mantiene actualizado por trigger ante cualquier alta, modificación o baja de sus entradas.

## Archivos

| Archivo | Contenido |
|---|---|
| `CreacionDeLaBase.sql` | Base de datos, seis tablas y restricciones nombradas |
| `DML.sql` | Datos de prueba |
| `funciones.sql` | Cuatro funciones escalares |
| `vistas.sql` | Cuatro vistas |
| `DQL.sql` | Ocho consultas |
| `subconsultas.sql` | Cuatro subconsultas: dos independientes y dos correlacionadas |
| `procedimientos.sql` | Tres procedimientos con transacciones y manejo de errores |
| `triggers.sql` | Siete triggers |
| `cursores.sql` | Procedimiento que recorre compras con un cursor |
| `seguridad.sql` | Logins, usuarios, roles y permisos |
| `ScriptCompleto.sql` | Todo lo anterior en un único archivo, en orden |

## Orden de ejecución

**Opción rápida:** correr `ScriptCompleto.sql` sobre una instancia limpia.

**Por partes,** en este orden:

1. `CreacionDeLaBase.sql`
2. `DML.sql`
3. `funciones.sql`
4. `vistas.sql`
5. `DQL.sql`
6. `subconsultas.sql`
7. `procedimientos.sql`
8. `triggers.sql`
9. `cursores.sql`
10. `seguridad.sql`

El orden no es intercambiable en tres puntos:

- `vistas.sql` va después de `funciones.sql`, porque `vw_compras_detalle` invoca a `fn_monto_vigente_compra`.
- `triggers.sql` va después de `procedimientos.sql`, porque `trg_controlar_cupo_entradas` ejecuta `validar_cupo_eventos`.
- `seguridad.sql` va último, porque otorga permisos sobre vistas, funciones y procedimientos que deben existir previamente.

`CreacionDeLaBase.sql` ejecuta `DROP DATABASE` si la base ya existe, así que todo el proceso se puede repetir desde cero.

## Requisitos

SQL Server con permisos de administrador del servidor. La sección de seguridad crea logins, que son objetos de nivel servidor y no de base de datos.

`CreacionDeLaBase.sql` borra la base si ya existe, así que se puede volver a correr desde cero.

## Verificación

El script termina devolviendo la base activa, que debe ser `GestionDeEntradas`:

```sql
select db_name() as base_actual;
```

Para confirmar que se crearon todos los objetos:

```sql
select 'tablas' as tipo, count(*) as cantidad from sys.tables
union all
select 'vistas', count(*) from sys.views
union all
select 'funciones', count(*) from sys.objects where type = 'FN'
union all
select 'procedimientos', count(*) from sys.procedures
union all
select 'triggers', count(*) from sys.triggers where is_ms_shipped = 0;
```

| Tipo | Cantidad esperada |
|---|---|
| tablas | 6 |
| vistas | 4 |
| funciones | 4 |
| procedimientos | 4 |
| triggers | 7 |
