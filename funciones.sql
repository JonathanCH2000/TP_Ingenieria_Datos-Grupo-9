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

CREATE FUNCTION dbo.fn_cupo_disponible_evento (@id_evento INT)
RETURNS INT
AS
BEGIN
    DECLARE @cupo INT;

    SELECT @cupo = cupo_disponible
    FROM vw_ocupacion_evento
    WHERE id_evento = @id_evento;

    RETURN ISNULL(@cupo, 0);
END;
GO