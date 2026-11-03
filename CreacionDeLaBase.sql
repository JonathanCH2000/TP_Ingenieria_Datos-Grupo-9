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
