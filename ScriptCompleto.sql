use master;
go

IF DB_ID('GestionDeEntradas') IS NOT NULL
BEGIN
    ALTER DATABASE GestionDeEntradas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GestionDeEntradas;
END
GO
 
CREATE DATABASE GestionDeEntradas;
GO
USE GestionDeEntradas;
GO

--Tabla 1: organizador. quien produce y es responsable de cada evento

create table organizador(
	id_organizador int identity,
	cuit varchar(13) not null,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	telefono varchar(20) not null,
	email varchar(100) not null,

	constraint pk_organizador primary key (id_organizador),
	constraint uq_organizador_cuit unique (cuit),
	constraint uq_organizador_email unique (email),
	constraint ck_organizador_email check (email like '%@%.%')
);
go

--Tabla 2: lugar. espacios donde se realizan los eventos, con su capacidad

create table lugar(
	id_lugar int identity,
	nombre_lugar varchar(100) not null,
	direccion varchar(100) not null,
	capacidad int not null,

	constraint pk_lugar primary key (id_lugar),
	constraint ck_lugar_capacidad check (capacidad > 0)
);
go

--Tabla 3: evento. cada funcion con su fecha, horario, lugar y organizador

create table evento(
	id_evento int identity,
	id_organizador int not null,
	id_lugar int not null,
	nombre_evento varchar(100) not null,
	fecha date not null,
	hora_inicio time not null,
	hora_fin time not null,
	estado varchar(20) not null default 'ACTIVO',

	constraint pk_evento primary key (id_evento),
	constraint fk_evento_organizador foreign key (id_organizador)
		references organizador(id_organizador),
	constraint fk_evento_lugar foreign key (id_lugar)
		references lugar(id_lugar),
	constraint ck_evento_estado check (estado in ('ACTIVO','FINALIZADO')),
	constraint ck_evento_horario check (hora_fin > hora_inicio)
);
go

--Tabla 4: cliente. quien compra entradas

create table cliente(
	id_cliente int identity,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	email varchar(100) not null,

	constraint pk_cliente primary key (id_cliente),
	constraint uq_cliente_email unique (email),
	constraint ck_cliente_email check (email like '%@%.%')
);
go

--Tabla 5: compra. operacion de compra con su estado de pago y su total

create table compra(
	id_compra int identity,
	id_cliente int not null,
	fecha datetime not null default getdate(),
	total decimal(10,2) not null default 0,
	estado_pago varchar(20) not null default 'PENDIENTE',

	constraint pk_compra primary key (id_compra),
	constraint fk_compra_cliente foreign key (id_cliente)
		references cliente(id_cliente),
	constraint ck_compra_total check (total >= 0),
	constraint ck_compra_estado_pago check (estado_pago in ('PENDIENTE','PAGADO','CANCELADO'))
);
go

--Tabla 6: entrada. cada entrada emitida, con codigo unico, precio y estado

create table entrada(
	id_entrada int identity,
	id_compra int not null,
	id_evento int not null,
	codigo varchar(20) not null,
	precio decimal(10,2) not null,
	estado varchar(20) not null default 'HABILITADA',

	constraint pk_entrada primary key (id_entrada),
	constraint fk_entrada_compra foreign key (id_compra)
		references compra(id_compra),
	constraint fk_entrada_evento foreign key (id_evento)
		references evento(id_evento),
	constraint uq_entrada_codigo unique (codigo),
	constraint ck_entrada_precio check (precio >= 0),
	constraint ck_entrada_estado check (estado in ('HABILITADA','UTILIZADA','ANULADA'))
);
go

use GestionDeEntradas;
go

--Datos de organizador

insert into organizador (cuit, nombre, apellido, telefono, email) values
('20-30123456-7', 'Martin', 'Gomez', '11-4523-1100', 'mgomez@produccionesmg.com'),
('27-28987654-3', 'Lucia', 'Fernandez', '11-4789-2200', 'lfernandez@lfeventos.com'),
('30-71234567-9', 'Diego', 'Ramirez', '11-5034-3300', 'dramirez@sonarte.com'),
('23-33445566-1', 'Carolina', 'Sosa', '11-6120-4400', 'csosa@escenasur.com'),
('20-29876543-2', 'Hernan', 'Castro', '11-4411-6600', 'hcastro@castrolive.com'),
('27-31222333-4', 'Julieta', 'Morales', '11-5522-7700', 'jmorales@jmeventos.com'),
('20-27666777-8', 'Ezequiel', 'Rojas', '11-6633-8800', 'erojas@rojasprod.com'),
('27-35888999-0', 'Micaela', 'Herrera', '11-3744-9900', 'mherrera@escenaviva.com'),
('30-70555444-6', 'Gaston', 'Vega', '11-4855-1010', 'gvega@vegashows.com'),
('20-25111222-5', 'Pablo', 'Ibarra', '11-3987-5500', 'pibarra@ibarrashows.com');
go

--Datos de lugar

insert into lugar (nombre_lugar, direccion, capacidad) values
('Estadio Luna Park', 'Av. Madero 420, CABA', 8000),
('Teatro Gran Rex', 'Av. Corrientes 857, CABA', 3300),
('Niceto Club', 'Niceto Vega 5510, CABA', 1000),
('La Trastienda', 'Balcarce 460, CABA', 700),
('Teatro Coliseo', 'M. T. de Alvear 1125, CABA', 1700),
('Usina del Arte', 'Agustin Caffarena 1, CABA', 1200),
('Sala Palermo Mini', 'Gorriti 4800, CABA', 3),
('Club Cultural Matienzo', 'Pringles 1249, CABA', 300),
('Teatro Maipo', 'Esmeralda 443, CABA', 700),
('Teatro Opera', 'Av. Corrientes 860, CABA', 2000);
go

--Datos de evento

insert into evento (id_organizador, id_lugar, nombre_evento, fecha, hora_inicio, hora_fin, estado) values
(1, 1, 'Rock en el Luna', '20260815', '21:00', '23:30', 'FINALIZADO'),
(2, 2, 'Stand Up Noche de Risas', '20260905', '20:30', '22:30', 'FINALIZADO'),
(3, 3, 'Electro Night', '20260920', '20:00', '23:59', 'FINALIZADO'),
(4, 4, 'Jazz en la Trastienda', '20261010', '21:00', '23:00', 'FINALIZADO'),
(5, 5, 'Festival Indie 2026', '20261205', '18:00', '23:59', 'ACTIVO'),
(6, 6, 'Opera Popular', '20261212', '20:00', '22:30', 'ACTIVO'),
(7, 7, 'Acustico Intimo', '20261219', '21:00', '22:30', 'ACTIVO'),
(8, 8, 'Tango Joven', '20261228', '21:30', '23:30', 'ACTIVO'),
(9, 9, 'Noche de Boleros', '20270109', '21:00', '23:00', 'ACTIVO'),
(1, 2, 'Gala Sinfonica', '20270116', '20:00', '22:00', 'ACTIVO');
go

--Datos de cliente

insert into cliente (nombre, apellido, email) values
('Juan', 'Perez', 'jperez@gmail.com'),
('Maria', 'Lopez', 'mlopez@gmail.com'),
('Santiago', 'Garcia', 'sgarcia@hotmail.com'),
('Valentina', 'Martinez', 'vmartinez@gmail.com'),
('Tomas', 'Rodriguez', 'trodriguez@yahoo.com'),
('Camila', 'Alvarez', 'calvarez@gmail.com'),
('Nicolas', 'Torres', 'ntorres@outlook.com'),
('Sofia', 'Romero', 'sromero@gmail.com'),
('Joaquin', 'Acosta', 'jacosta@gmail.com'),
('Florencia', 'Medina', 'fmedina@gmail.com');
go

--Datos de compra

insert into compra (id_cliente, fecha, total, estado_pago) values
(1, '20260720 10:15:00', 45000.00, 'PAGADO'),
(2, '20260725 18:40:00', 45000.00, 'PAGADO'),
(3, '20260820 09:30:00', 28000.00, 'PAGADO'),
(4, '20260828 21:10:00', 28000.00, 'CANCELADO'),
(5, '20260901 16:45:00', 32000.00, 'PAGADO'),
(1, '20261005 19:00:00', 25000.00, 'PAGADO'),
(6, '20261012 22:30:00', 38000.00, 'PAGADO'),
(7, '20261020 14:00:00', 18000.00, 'PAGADO'),
(8, '20261022 20:15:00', 18000.00, 'PAGADO'),
(2, '20261027 12:40:00', 52000.00, 'PENDIENTE'),
(1, '20261029 11:20:00', 42000.00, 'PAGADO'),
(1, '20261030 18:05:00', 22000.00, 'PAGADO');
go

--Datos de entrada

insert into entrada (id_compra, id_evento, codigo, precio, estado) values
(1, 1, 'ENT-0001', 45000.00, 'UTILIZADA'),
(2, 1, 'ENT-0002', 45000.00, 'HABILITADA'),
(3, 2, 'ENT-0003', 28000.00, 'UTILIZADA'),
(4, 2, 'ENT-0004', 28000.00, 'ANULADA'),
(5, 3, 'ENT-0005', 32000.00, 'UTILIZADA'),
(6, 4, 'ENT-0006', 25000.00, 'UTILIZADA'),
(7, 5, 'ENT-0007', 38000.00, 'HABILITADA'),
(8, 7, 'ENT-0008', 18000.00, 'HABILITADA'),
(9, 7, 'ENT-0009', 18000.00, 'HABILITADA'),
(10, 6, 'ENT-0010', 52000.00, 'HABILITADA'),
(11, 5, 'ENT-0011', 42000.00, 'HABILITADA'),
(12, 8, 'ENT-0012', 22000.00, 'HABILITADA');
go

use GestionDeEntradas;
go

--Funcion 1: monto vigente de una compra
create function dbo.fn_monto_vigente_compra (@id_compra int)
returns decimal(12,2)
as
begin
    declare @monto decimal(12,2);

    select @monto = isnull(sum(e.precio), 0)
    from entrada as e
    where e.id_compra = @id_compra and e.estado <> 'ANULADA';

    return @monto;
end;
go

--Funcion 2: total calculado de una compra
create function dbo.fn_total_calculado_compra (@id_compra int)
returns decimal(12,2)
as
begin
    declare @total decimal(12,2);

    select @total = isnull(sum(e.precio), 0)
    from entrada as e
    where e.id_compra = @id_compra;

    return @total;
end;
go

--Funcion 3: cupo disponible de un evento
create function dbo.fn_cupo_disponible_evento (@id_evento int)
returns int
as
begin
    declare @capacidad int;
    declare @vendidas int;

    select @capacidad = l.capacidad
    from evento as e
    join lugar as l
    on e.id_lugar = l.id_lugar
    where e.id_evento = @id_evento;

    select @vendidas = count(*)
    from entrada
    where id_evento = @id_evento and estado <> 'ANULADA';

    return isnull(@capacidad, 0) - @vendidas;
end;
go

--Funcion 4: indica si una entrada habilita el ingreso
create function dbo.fn_puede_ingresar (@codigo varchar(20))
returns bit
as
begin
    declare @resultado bit;

    if exists (select 1
               from entrada as en
               join compra as co
               on en.id_compra = co.id_compra
               join evento as ev
               on en.id_evento = ev.id_evento
               where en.codigo = @codigo
                 and en.estado = 'HABILITADA'
                 and co.estado_pago = 'PAGADO'
                 and ev.estado = 'ACTIVO')
        set @resultado = 1;
    else
        set @resultado = 0;

    return @resultado;
end;
go

use GestionDeEntradas;
go

--Vista 1: ocupacion de cada evento segun la capacidad del lugar

create view vw_ocupacion_evento as
select e.id_evento, e.nombre_evento, e.fecha, l.nombre_lugar, l.capacidad,
count(en.id_entrada) as entradas_vendidas,
l.capacidad - count(en.id_entrada) as cupo_disponible
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
left join entrada as en
on e.id_evento = en.id_evento and en.estado <> 'ANULADA'
group by e.id_evento, e.nombre_evento, e.fecha, l.nombre_lugar, l.capacidad;
go

--Vista 2: compras con el cliente y el monto que sigue vigente

create view vw_compras_detalle as
select co.id_compra, co.fecha, co.estado_pago, c.nombre, c.apellido, co.total,
dbo.fn_monto_vigente_compra(co.id_compra) as monto_vigente,
co.total - dbo.fn_monto_vigente_compra(co.id_compra) as monto_anulado
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente;
go

--Vista 3: entradas que cumplen las tres condiciones de ingreso

create view vw_entradas_habilitadas as
select en.id_entrada, en.codigo, en.precio, ev.id_evento, ev.nombre_evento, ev.fecha,
ev.hora_inicio, l.nombre_lugar, co.id_compra, c.id_cliente,
c.nombre as nombre_cliente, c.apellido as apellido_cliente
from entrada as en
join compra as co
on en.id_compra = co.id_compra
join evento as ev
on en.id_evento = ev.id_evento
join lugar as l
on ev.id_lugar = l.id_lugar
join cliente as c
on co.id_cliente = c.id_cliente
where en.estado = 'HABILITADA'
and co.estado_pago = 'PAGADO'
and ev.estado = 'ACTIVO';
go

--Vista 4: recaudacion total por organizador

create view vw_recaudacion_organizador as
select o.id_organizador, o.nombre, o.apellido,
count(en.id_entrada) as entradas_vendidas,
sum(en.precio) as recaudacion
from organizador as o
join evento as e
on o.id_organizador = e.id_organizador
join entrada as en
on e.id_evento = en.id_evento
join compra as co
on en.id_compra = co.id_compra
where co.estado_pago = 'PAGADO' and en.estado <> 'ANULADA'
group by o.id_organizador, o.nombre, o.apellido;
go

use GestionDeEntradas;
go

--Consulta 1: eventos activos y el lugar de realizacion
select e.id_evento, e.nombre_evento, e.fecha, e.hora_inicio, e.hora_fin, l.nombre_lugar, l.direccion
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
where e.estado = 'ACTIVO'
order by e.fecha, e.hora_inicio;
go

--Consulta 2: contacto del organizador de cada evento
select e.nombre_evento, o.nombre, o.apellido, o.telefono, o.email
from evento as e
join organizador as o
on e.id_organizador = o.id_organizador;
go

--Consulta 3: listado de compras ordenado por fecha
select id_compra, fecha, total, estado_pago
from compra
order by fecha desc;
go

--Consulta 4: compras pendientes con los datos del cliente
select co.id_compra, co.fecha, co.total, c.nombre, c.apellido, c.email, co.estado_pago
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente
where co.estado_pago = 'PENDIENTE'
order by co.fecha;
go

--Consulta 5: entradas utilizadas por evento
select ev.id_evento, ev.nombre_evento, ev.fecha, count(en.id_entrada) as entradas_utilizadas
from evento as ev
left join entrada as en
on en.id_evento = ev.id_evento and en.estado = 'UTILIZADA'
group by ev.id_evento, ev.nombre_evento, ev.fecha
order by entradas_utilizadas desc;
go

--Consulta 6: recaudacion por evento, solo compras pagadas
select e.id_evento, e.nombre_evento, count(en.id_entrada) as entradas_vendidas, sum(en.precio) as recaudacion
from evento as e
join entrada as en
on e.id_evento = en.id_evento
join compra as co
on en.id_compra = co.id_compra
where co.estado_pago = 'PAGADO' and en.estado <> 'ANULADA'
group by e.id_evento, e.nombre_evento
order by recaudacion desc;
go

--Consulta 7: clientes frecuentes, mas de una compra pagada
select c.id_cliente, c.nombre, c.apellido, c.email, count(co.id_compra) as compras_pagadas
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
where co.estado_pago = 'PAGADO'
group by c.id_cliente, c.nombre, c.apellido, c.email
having count(co.id_compra) > 1;
go

--Consulta 8: estadisticas de compra por cliente
select c.id_cliente, c.nombre, c.apellido, count(co.id_compra) as cantidad_compras,
min(co.total) as compra_minima, max(co.total) as compra_maxima,
avg(co.total) as ticket_promedio, sum(co.total) as total_gastado
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
group by c.id_cliente, c.nombre, c.apellido
order by total_gastado desc;
go

use GestionDeEntradas;
go

--Subconsulta 1: clientes cuyo ticket promedio supera el ticket promedio del sistema
select c.id_cliente, c.nombre, c.apellido, c.email,
count(co.id_compra) as cantidad_compras,
avg(co.total) as ticket_promedio
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
where co.estado_pago = 'PAGADO'
group by c.id_cliente, c.nombre, c.apellido, c.email
having avg(co.total) > (select avg(total) from compra where estado_pago = 'PAGADO')
order by ticket_promedio desc;
go

--Subconsulta 2: eventos que no registran ninguna entrada vendida
select e.id_evento, e.nombre_evento, e.fecha, e.estado, l.nombre_lugar
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
where not exists (select 1 from entrada as en where en.id_evento = e.id_evento)
order by e.fecha;
go

--Subconsulta 3: compras cuyo importe supera el promedio de ese mismo cliente
select c.id_cliente, c.nombre, c.apellido, co.id_compra, co.fecha, co.total, co.estado_pago
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente
where co.total > (select avg(co2.total) from compra as co2 where co2.id_cliente = co.id_cliente)
order by c.apellido, co.total desc;
go

--Subconsulta 4: entradas cuyo precio supera el precio promedio de todas las entradas
select en.id_entrada, en.codigo, en.precio, ev.nombre_evento, ev.fecha
from entrada as en
join evento as ev
on en.id_evento = ev.id_evento
where en.precio > (select avg(precio) from entrada)
order by en.precio desc;
go

USE GestionDeEntradas;
GO

--Procedimiento 1: comprueba que las entradas no superen la capacidad del lugar
CREATE PROCEDURE validar_cupo_eventos
AS
BEGIN
    SET NOCOUNT ON;

    -- Contamos las entradas de compras pendientes y pagadas por evento.
    IF EXISTS (
        SELECT 1
        FROM evento AS ev
        JOIN lugar AS l
            ON ev.id_lugar = l.id_lugar
        JOIN entrada AS en
            ON ev.id_evento = en.id_evento
        JOIN compra AS c
            ON en.id_compra = c.id_compra
        WHERE c.estado_pago IN ('PENDIENTE', 'PAGADO')
          AND en.estado <> 'ANULADA'
        GROUP BY ev.id_evento, l.capacidad
        HAVING COUNT(*) > l.capacidad
    )
    BEGIN
        THROW 50003, 'La cantidad de entradas supera la capacidad del lugar.', 1;
    END;
END;
GO

--Procedimiento 2: registra el ingreso cuando la entrada cumple las condiciones
CREATE PROCEDURE registrar_ingreso
    @codigo varchar(20),
    @id_evento int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Marcamos la entrada como utilizada si está habilitada,
        -- la compra está pagada y el evento está activo.
        UPDATE en
        SET estado = 'UTILIZADA'
        FROM entrada AS en
        JOIN compra AS c
            ON en.id_compra = c.id_compra
        JOIN evento AS ev
            ON en.id_evento = ev.id_evento
        WHERE en.codigo = @codigo
            AND en.id_evento = @id_evento
            AND en.estado = 'HABILITADA'
            AND c.estado_pago = 'PAGADO'
            AND ev.estado = 'ACTIVO';

        -- Si no se actualizó ninguna entrada, rechazamos el ingreso.
        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50004, 'La entrada no cumple las condiciones para ingresar.', 1;
        END;

        COMMIT TRANSACTION;

        SELECT 'Ingreso registrado correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        -- Deshacemos los cambios y mostramos el error.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

--Procedimiento 3: registra una compra y sus entradas en una misma transaccion
CREATE PROCEDURE registrar_compra
    @id_cliente int,
    @id_evento int,
    @cantidad int,
    @precio_unitario decimal(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_compra int;
    DECLARE @numero int = 1;
    DECLARE @ahora datetime = GETDATE();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Revisamos la cantidad y el precio de las entradas.
        IF @cantidad IS NULL OR @cantidad <= 0
            THROW 50005, 'La cantidad de entradas debe ser mayor que cero.', 1;

        IF @precio_unitario IS NULL OR @precio_unitario < 0
            THROW 50006, 'El precio no puede ser negativo ni quedar vacío.', 1;

        -- Comprobamos que el cliente esté registrado.
        IF NOT EXISTS (
            SELECT 1
            FROM cliente
            WHERE id_cliente = @id_cliente
        )
            THROW 50007, 'El cliente no está registrado.', 1;

        -- Solo vendemos entradas para eventos activos que no comenzaron.
        IF NOT EXISTS (
            SELECT 1
            FROM evento
            WHERE id_evento = @id_evento
                AND estado = 'ACTIVO'
                AND (
                    fecha > CAST(@ahora AS date)
                    OR (
                        fecha = CAST(@ahora AS date)
                        AND hora_inicio > CAST(@ahora AS time)
                    )
                )
        )
            THROW 50008, 'El evento no está disponible para vender entradas.', 1;

        -- Creamos la compra con los valores por defecto.
        INSERT INTO compra (id_cliente)
        VALUES (@id_cliente);

        -- Recuperamos el identificador de la compra que acabamos de crear.
        SET @id_compra = SCOPE_IDENTITY();

        -- Creamos las entradas. El trigger actualiza el total de la compra.
        WHILE @numero <= @cantidad
        BEGIN
            INSERT INTO entrada (
                id_compra, id_evento, codigo, precio, estado
            )
            VALUES (
                @id_compra,
                @id_evento,
                CONCAT('C', @id_compra, '-E', @numero),
                @precio_unitario,
                'HABILITADA'
            );

            SET @numero = @numero + 1;
        END;

        COMMIT TRANSACTION;

        -- Mostramos la compra y sus entradas.
        SELECT id_compra, total, estado_pago
        FROM compra
        WHERE id_compra = @id_compra;

        SELECT codigo, id_evento, precio, estado
        FROM entrada
        WHERE id_compra = @id_compra
        ORDER BY id_entrada;
    END TRY
    BEGIN CATCH
        -- Si algo falla, deshacemos la compra y sus entradas.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

USE GestionDeEntradas;
GO

--Trigger 1: actualiza el total de la compra al agregar, modificar o eliminar entradas
CREATE TRIGGER trg_actualizar_total_compra
ON entrada
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sumamos los precios de las entradas, incluyendo las anuladas.
    -- Si la compra queda sin entradas, el total es 0.
    UPDATE compra
    SET total = ISNULL(
        (
            SELECT SUM(e.precio)
            FROM entrada AS e
            WHERE e.id_compra = compra.id_compra
        ), 0
    )
    -- Actualizamos las compras que tuvieron cambios en sus entradas.
    -- Si una entrada pasa a otra compra, recalculamos las dos.
    WHERE id_compra IN (
        SELECT id_compra FROM inserted
        UNION
        SELECT id_compra FROM deleted
    );
END;
GO

--Trigger 2: anula las entradas cuando se cancela una compra
CREATE TRIGGER trg_cancelar_compra
ON compra
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Si no se actualiza el estado de pago, terminamos.
    IF NOT UPDATE(estado_pago)
        RETURN;

    -- Revisamos si alguna compra que se cancela tiene entradas utilizadas.
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN entrada AS e
            ON i.id_compra = e.id_compra
        WHERE i.estado_pago = 'CANCELADO'
            AND e.estado = 'UTILIZADA'
    )
    BEGIN
        THROW 50001, 'No se puede cancelar una compra con entradas utilizadas.', 1;
    END;

    -- Anulamos las entradas de las compras canceladas.
    UPDATE e
    SET estado = 'ANULADA'
    FROM entrada AS e
    JOIN inserted AS i
        ON e.id_compra = i.id_compra
    WHERE i.estado_pago = 'CANCELADO'
        AND e.estado <> 'ANULADA';
END;
GO

--Trigger 3: evita que dos eventos se superpongan en el mismo lugar y fecha
CREATE TRIGGER trg_evitar_superposicion_eventos
ON evento
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Comparamos con otros eventos del mismo lugar y fecha.
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN evento AS e
            ON i.id_lugar = e.id_lugar
            AND i.fecha = e.fecha
            AND i.id_evento <> e.id_evento
        -- Revisamos si los horarios se cruzan.
        WHERE i.hora_inicio < e.hora_fin
            AND i.hora_fin > e.hora_inicio
    )
    BEGIN
        THROW 50002, 'El lugar ya tiene un evento en ese horario.', 1;
    END;
END;
GO

--Trigger 4: controla el cupo al agregar o modificar entradas
CREATE TRIGGER trg_controlar_cupo_entradas
ON entrada
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Ejecutamos el procedimiento que comprueba la capacidad.
    EXEC validar_cupo_eventos;
END;
GO

--Trigger 5: controla el cupo cuando se actualiza el estado de pago
CREATE TRIGGER trg_controlar_cupo_compras
ON compra
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(estado_pago)
        EXEC validar_cupo_eventos;
END;
GO

--Trigger 6: controla el cupo cuando se cambia el lugar de un evento
CREATE TRIGGER trg_controlar_cupo_eventos
ON evento
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(id_lugar)
        EXEC validar_cupo_eventos;
END;
GO

--Trigger 7: controla el cupo cuando se modifica la capacidad de un lugar
CREATE TRIGGER trg_controlar_cupo_lugares
ON lugar
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(capacidad)
        EXEC validar_cupo_eventos;
END;
GO

USE GestionDeEntradas;
GO

--Cursor 1: procesa las cancelaciones de un evento compra por compra
CREATE PROCEDURE cancelar_compras_evento
    @id_evento int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_compra int;
    DECLARE @entradas_utilizadas int;
    DECLARE @transacciones_iniciales int = @@TRANCOUNT;

    -- Seleccionamos compras pendientes o pagadas.
    -- Todas las entradas de cada compra deben ser del evento indicado.
    DECLARE cursor_compras CURSOR FOR
        SELECT c.id_compra
        FROM compra AS c
        JOIN entrada AS en
            ON c.id_compra = en.id_compra
        WHERE c.estado_pago = 'PENDIENTE'
           OR c.estado_pago = 'PAGADO'
        GROUP BY c.id_compra
        HAVING SUM(CASE WHEN en.id_evento = @id_evento THEN 1 ELSE 0 END) = COUNT(*)
        ORDER BY c.id_compra;

    OPEN cursor_compras;

    FETCH NEXT FROM cursor_compras INTO @id_compra;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Revisamos si ya se usó alguna entrada de la compra.
        SELECT @entradas_utilizadas = COUNT(*)
        FROM entrada
        WHERE id_compra = @id_compra
            AND estado = 'UTILIZADA';

        IF @entradas_utilizadas > 0
        BEGIN
            PRINT CONCAT('Compra ', @id_compra, ': omitida porque tiene entradas utilizadas.');
        END
        ELSE
        BEGIN
            BEGIN TRY
                -- Al cancelar la compra, el trigger anula sus entradas.
                UPDATE compra
                SET estado_pago = 'CANCELADO'
                WHERE id_compra = @id_compra
                    AND (estado_pago = 'PENDIENTE' OR estado_pago = 'PAGADO');

                -- Mostramos cómo quedó la compra.
                SELECT id_compra, estado_pago
                FROM compra
                WHERE id_compra = @id_compra;
            END TRY
            BEGIN CATCH
                -- Si ya había una transacción abierta, devolvemos el error.
                IF @transacciones_iniciales > 0
                BEGIN
                    CLOSE cursor_compras;
                    DEALLOCATE cursor_compras;
                    THROW;
                END;

                PRINT CONCAT('Compra ', @id_compra, ': ', ERROR_MESSAGE());
            END CATCH;
        END;

        FETCH NEXT FROM cursor_compras INTO @id_compra;
    END;

    CLOSE cursor_compras;
    DEALLOCATE cursor_compras;
END;
GO

use GestionDeEntradas;
go

--Logins de servidor

if not exists (select name from sys.server_principals where name = 'login_admin')
	create login login_admin with password = 'Admin.2026';
if not exists (select name from sys.server_principals where name = 'login_vendedor')
	create login login_vendedor with password = 'Vendedor.2026';
if not exists (select name from sys.server_principals where name = 'login_analista')
	create login login_analista with password = 'Analista.2026';
go

--Usuarios de la base

create user usr_admin for login login_admin;
create user usr_vendedor for login login_vendedor;
create user usr_analista for login login_analista;
go

--Roles

create role rol_administrador;
create role rol_vendedor;
create role rol_consulta;
go

--Asignacion de usuarios a roles

alter role rol_administrador add member usr_admin;
alter role rol_vendedor add member usr_vendedor;
alter role rol_consulta add member usr_analista;
go

--Permisos del administrador

grant select, insert, update, delete on organizador to rol_administrador;
grant select, insert, update, delete on lugar to rol_administrador;
grant select, insert, update, delete on evento to rol_administrador;
grant select, insert, update, delete on cliente to rol_administrador;
grant select, insert, update, delete on compra to rol_administrador;
grant select, insert, update, delete on entrada to rol_administrador;
go

--Permisos del vendedor

grant select on evento to rol_vendedor;
grant select on lugar to rol_vendedor;
grant select, insert, update on cliente to rol_vendedor;
grant select, insert, update on compra to rol_vendedor;
grant select, insert, update on entrada to rol_vendedor;
go

--DENY prohibe explicitamente y prevalece sobre cualquier GRANT
--que el usuario pudiera heredar por pertenecer a otro rol.
deny delete on compra to rol_vendedor;
deny delete on entrada to rol_vendedor;
go

--Permisos del rol de consulta

grant select on evento to rol_consulta;
grant select on lugar to rol_consulta;
grant select on compra to rol_consulta;
grant select on entrada to rol_consulta;
grant select (id_organizador, nombre, apellido) on organizador to rol_consulta;
grant select (id_cliente, nombre, apellido) on cliente to rol_consulta;
go

--Permisos sobre las vistas

grant select on vw_ocupacion_evento to rol_vendedor;
grant select on vw_entradas_habilitadas to rol_vendedor;
go

grant select on vw_ocupacion_evento to rol_consulta;
grant select on vw_compras_detalle to rol_consulta;
grant select on vw_entradas_habilitadas to rol_consulta;
grant select on vw_recaudacion_organizador to rol_consulta;
go

--Permisos sobre funciones y procedimientos

grant execute on dbo.fn_monto_vigente_compra to rol_vendedor;
grant execute on dbo.fn_cupo_disponible_evento to rol_vendedor;
grant execute on dbo.fn_puede_ingresar to rol_vendedor;
grant execute on dbo.registrar_compra to rol_vendedor;
grant execute on dbo.registrar_ingreso to rol_vendedor;
go

grant execute on dbo.fn_total_calculado_compra to rol_administrador;
grant execute on dbo.validar_cupo_eventos to rol_administrador;
grant execute on dbo.cancelar_compras_evento to rol_administrador;
go
