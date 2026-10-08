create database GestionDeEntradas
use GestionDeEntradas
go
create table organizador(
	id_organizador int identity,
	cuit varchar(30) not null,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	telefono varchar(30) not null,
	email varchar(30) not null,

	constraint pk_id_organizador primary key (id_organizador) 
);
go
create table lugar(
	id_lugar int identity,
	nombre_lugar varchar(30) not null,
	direccion varchar(30)not null, 
	capacidad int not null,

	constraint pk_id_lugar primary key (id_lugar)
);
go
create table evento(
	id_evento int identity,
	id_organizador int not null,
	id_lugar int not null,
	nombre_evento varchar(30) not null, 
	fecha datetime not null, 
	hora_inicio varchar(20) not null,
	hora_fin varchar(20) not null,
	estado varchar (30) not null,

	constraint pk_id_evento primary key (id_evento),
	constraint fk_id_organizador foreign key (id_organizador)
		references organizador(id_organizador),
	constraint fk_id_lugar foreign key (id_lugar)
		references lugar(id_lugar),
	constraint check_estado check (estado IN ('ACTIVO','FINALIZADO'))
);
go
create table cliente(
	id_cliente int identity,
	nombre varchar(30) not null,
	apellido varchar(30) not null,
	email varchar(30) not null,

	constraint pk_id_cliente primary key (id_cliente)
);
