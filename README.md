# TP-Grupo-9


# Gestión de Entradas — TP Integrador Ingeniería de Datos 1 (Grupo 9)

Base de datos en SQL Server para la venta de entradas a eventos: organizadores, lugares, eventos, clientes, compras y entradas.

## Integrantes

| Integrante | Rol en el TP |
|---|---|
| Gonzalo | Modelo, datos y seguridad |
| """" | """"|
| """" | """"|

## Archivos

| Archivo | Contenido |
|---|---|
| CreacionDeLaBase.sql | Base, tablas y restricciones |
| insertsBase.sql | Datos de prueba |
| seguridad.sql | Roles, usuarios y permisos |

## Orden de ejecución

Opción rápida: correr `script_completo.sql` en una instancia limpia.

Por partes, en este orden:

1. `CreacionDeLaBase.sql`
2. `insertsBase.sql`
3. Funciones
4. Vistas
5. Stored procedures
6. Triggers
7. `seguridad.sql`

`CreacionDeLaBase.sql` borra la base si ya existe, así que se puede volver a correr desde cero.

## Verificación

Después de correr el script, `SELECT DB_NAME();` tiene que devolver `GestionDeEntradas`.