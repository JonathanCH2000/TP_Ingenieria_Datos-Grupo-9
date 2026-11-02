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