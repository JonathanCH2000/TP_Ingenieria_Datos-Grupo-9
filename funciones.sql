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