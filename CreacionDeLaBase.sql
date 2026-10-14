create database GestionDeEntradas;
go
use GestionDeEntradas;
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
go

create table compra(
	id_compra int identity,
	id_cliente int not null,
	fecha datetime not null,
	total float not null,
	estado_pago varchar(30) not null,

	constraint pk_id_compra primary key (id_compra),
	constraint fk_id_cliente foreign key (id_cliente) 
		references cliente(id_cliente),
	constraint check_estado_pago check (estado_pago IN ('PENDIENTE','PAGADO','CANCELADO'))
);
go
create table entrada(
    id_entrada int identity,
    id_compra int not null,
    id_evento int not null,
    codigo varchar(30) not null,
    precio decimal(10,2) not null,
    estado varchar(30) not null,

    constraint pk_id_entrada primary key (id_entrada),
    constraint fk_id_compra foreign key (id_compra)
        references compra(id_compra),
    constraint fk_id_evento foreign key (id_evento)
        references evento(id_evento),
    constraint uq_codigo unique (codigo),
    constraint check_precio check (precio >= 0),
    constraint check_estado_entrada
        check (estado IN ('HABILITADA','UTILIZADA','ANULADA'))
);
go


