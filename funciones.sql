USE GestionDeEntradas;
GO

-- monto vigente de una compra
-- Devuelve el monto que sigue siendo válido de una compra, descontando las entradas anuladas.

CREATE FUNCTION dbo.fn_monto_vigente_compra (@id_compra INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @monto DECIMAL(12,2);

    SELECT @monto = ISNULL(SUM(e.precio), 0)
    FROM entrada AS e
    WHERE e.id_compra = @id_compra
      AND e.estado <> 'ANULADA';

    RETURN @monto;
END;
GO


-- Suma el precio de todas las entradas de una compra, sin distinción de estado.

CREATE FUNCTION dbo.fn_total_calculado_compra (@id_compra INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @total DECIMAL(12,2);

    SELECT @total = ISNULL(SUM(e.precio), 0)
    FROM entrada AS e
    WHERE e.id_compra = @id_compra;

    RETURN @total;
END;
GO

-- fn_cupo_disponible_evento
-- Lugares disponibles en un evento.

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

-- Indica si una entrada cumple las tres condiciones de ingreso.

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