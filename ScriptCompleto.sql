/*LA IDEA DE ESTE ARCHIVO ES PODER CORRER TODO DE UNA A VER SI DA ERRORS O ALGO POR EL ESTILO*/

use master;
go

drop database if exists GestionDeEntradas;
go

create database GestionDeEntradas;
go

use GestionDeEntradas;
go

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

create table lugar(
	id_lugar int identity,
	nombre_lugar varchar(100) not null,
	direccion varchar(100) not null,
	capacidad int not null,

	constraint pk_lugar primary key (id_lugar),
	constraint ck_lugar_capacidad check (capacidad > 0)
);
go

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

create trigger tr_actualizar_total
on entrada
after insert
as
begin
	update compra
	set total = (select sum(precio) from entrada where entrada.id_compra = compra.id_compra)
	where id_compra in (select id_compra from inserted);
end;
go

use GestionDeEntradas;
go

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

--Eventos activos y el lugar de realizacion.
select e.id_evento, e.nombre_evento, e.fecha, e.hora_inicio, e.hora_fin, l.nombre_lugar, l.direccion
from evento as e
join lugar as l
on e.id_lugar = l.id_lugar
where e.estado = 'ACTIVO'
order by e.fecha, e.hora_inicio;
go

--Contacto del organizador de un evento
select e.nombre_evento, o.nombre, o.apellido, o.telefono, o.email
from evento as e
join organizador as o
on e.id_organizador = o.id_organizador;
go

--Consultar las compras
select id_compra, fecha, total, estado_pago
from compra
order by fecha desc;
go

--Muestra las compras pendientes y los datos del cliente
select co.id_compra, co.fecha, co.total, c.nombre, c.apellido, c.email, co.estado_pago
from compra as co
join cliente as c
on co.id_cliente = c.id_cliente
where co.estado_pago = 'PENDIENTE'
order by co.fecha;
go

--Entradas utilizadas de un evento.
select ev.id_evento, ev.nombre_evento, ev.fecha, count(en.id_entrada) as entradas_utilizadas
from evento as ev
left join entrada as en
on en.id_evento = ev.id_evento and en.estado = 'UTILIZADA'
group by ev.id_evento, ev.nombre_evento, ev.fecha
order by entradas_utilizadas desc;
go

--Recaudacion por evento
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

--Clientes frecuentes (mas de una compra pagada)
select c.id_cliente, c.nombre, c.apellido, c.email, count(co.id_compra) as compras_pagadas
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
where co.estado_pago = 'PAGADO'
group by c.id_cliente, c.nombre, c.apellido, c.email
having count(co.id_compra) > 1;
go

--Estadisticas de compra por cliente.
select c.id_cliente, c.nombre, c.apellido, count(co.id_compra) as cantidad_compras,
min(co.total) as compra_minima, max(co.total) as compra_maxima,
avg(co.total) as ticket_promedio, sum(co.total) as total_gastado
from cliente as c
join compra as co
on c.id_cliente = co.id_cliente
group by c.id_cliente, c.nombre, c.apellido
order by total_gastado desc;
go

-- procedimientos (pendiente)

-- triggers (pendiente)

use GestionDeEntradas;
go

if not exists (select name from sys.server_principals where name = 'login_admin')
	create login login_admin with password = 'Admin.2026';
if not exists (select name from sys.server_principals where name = 'login_vendedor')
	create login login_vendedor with password = 'Vendedor.2026';
if not exists (select name from sys.server_principals where name = 'login_analista')
	create login login_analista with password = 'Analista.2026';
go

create user usr_admin for login login_admin;
create user usr_vendedor for login login_vendedor;
create user usr_analista for login login_analista;
go

create role rol_administrador;
create role rol_vendedor;
create role rol_consulta;
go

alter role rol_administrador add member usr_admin;
alter role rol_vendedor add member usr_vendedor;
alter role rol_consulta add member usr_analista;
go

grant select, insert, update, delete on organizador to rol_administrador;
grant select, insert, update, delete on lugar to rol_administrador;
grant select, insert, update, delete on evento to rol_administrador;
grant select, insert, update, delete on cliente to rol_administrador;
grant select, insert, update, delete on compra to rol_administrador;
grant select, insert, update, delete on entrada to rol_administrador;
go

grant select on evento to rol_vendedor;
grant select on lugar to rol_vendedor;
grant select, insert, update on cliente to rol_vendedor;
grant select, insert, update, delete on compra to rol_vendedor;
grant select, insert, update, delete on entrada to rol_vendedor;
go

revoke delete on compra from rol_vendedor;
revoke delete on entrada from rol_vendedor;
go

grant select on evento to rol_consulta;
grant select on lugar to rol_consulta;
grant select on compra to rol_consulta;
grant select on entrada to rol_consulta;
grant select (id_organizador, nombre, apellido) on organizador to rol_consulta;
grant select (id_cliente, nombre, apellido) on cliente to rol_consulta;
go

select db_name() as base_actual;
go
