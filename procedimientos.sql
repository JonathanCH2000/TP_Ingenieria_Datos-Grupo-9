USE GestionDeEntradas;
GO

-- Comprueba que las entradas no superen la capacidad del lugar.
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
        GROUP BY ev.id_evento, l.capacidad
        HAVING COUNT(*) > l.capacidad
    )
    BEGIN
        THROW 50003, 'La cantidad de entradas supera la capacidad del lugar.', 1;
    END;
END;
GO