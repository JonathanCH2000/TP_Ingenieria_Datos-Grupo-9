USE GestionDeEntradas;
GO

create table organizador(
    id_organizador int identity(1,1),
    cuit varchar(13) not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    telefono varchar(20) not null,
    email varchar(100) not null,

    constraint pk_organizador primary key (id_organizador),
    constraint uq_organizador_cuit unique (cuit),
    constraint uq_organizador_email unique (email),
    constraint ck_organizador_cuit
        check (cuit like '[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'),
    constraint ck_organizador_email check (email like '%_@_%._%')
);
GO

create table lugar(
    id_lugar int identity(1,1),
    nombre_lugar varchar(100) not null,
    direccion varchar(100) not null,
    capacidad int not null,

    constraint pk_lugar primary key (id_lugar),
    constraint ck_lugar_capacidad check (capacidad > 0)
);
GO

create table evento(
    id_evento int identity(1,1),
    id_organizador int not null,
    id_lugar int not null,
    nombre_evento varchar(100) not null,
    fecha date not null,
    hora_inicio time(0) not null,
    hora_fin time(0) not null,
    estado varchar(20) not null
        constraint df_evento_estado default 'ACTIVO',

    constraint pk_evento primary key (id_evento),
    constraint fk_evento_organizador foreign key (id_organizador)
        references organizador(id_organizador),
    constraint fk_evento_lugar foreign key (id_lugar)
        references lugar(id_lugar),
    constraint ck_evento_estado check (estado in ('ACTIVO','FINALIZADO')),
    constraint ck_evento_horario check (hora_fin > hora_inicio)
);
GO

create table cliente(
    id_cliente int identity(1,1),
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) not null,

    constraint pk_cliente primary key (id_cliente),
    constraint uq_cliente_email unique (email),
    constraint ck_cliente_email check (email like '%_@_%._%')
);
GO

create table compra(
    id_compra int identity(1,1),
    id_cliente int not null,
    fecha datetime not null
        constraint df_compra_fecha default getdate(),
    total decimal(12,2) not null
        constraint df_compra_total default 0,
    estado_pago varchar(20) not null
        constraint df_compra_estado_pago default 'PENDIENTE',

    constraint pk_compra primary key (id_compra),
    constraint fk_compra_cliente foreign key (id_cliente)
        references cliente(id_cliente),
    constraint ck_compra_total check (total >= 0),
    constraint ck_compra_estado_pago check (estado_pago in ('PENDIENTE','PAGADO','CANCELADO'))
);
GO

create table entrada(
    id_entrada int identity(1,1),
    id_compra int not null,
    id_evento int not null,
    codigo varchar(20) not null,
    precio decimal(10,2) not null,
    estado varchar(20) not null
        constraint df_entrada_estado default 'HABILITADA',

    constraint pk_entrada primary key (id_entrada),
    constraint fk_entrada_compra foreign key (id_compra)
        references compra(id_compra),
    constraint fk_entrada_evento foreign key (id_evento)
        references evento(id_evento),
    constraint uq_entrada_codigo unique (codigo),
    constraint ck_entrada_precio check (precio >= 0),
    constraint ck_entrada_estado check (estado in ('HABILITADA','UTILIZADA','ANULADA'))
);
GO
