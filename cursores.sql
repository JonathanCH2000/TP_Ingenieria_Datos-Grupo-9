USE GestionDeEntradas;
GO

-- Procesa las cancelaciones de un evento compra por compra.
CREATE PROCEDURE cancelar_compras_evento
    @id_evento int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_compra int;
    DECLARE @entradas_utilizadas int;
    DECLARE @transacciones_iniciales int = @@TRANCOUNT;

    -- Seleccionamos compras pendientes o pagadas.
    -- Todas las entradas de cada compra deben ser del evento indicado.
    DECLARE cursor_compras CURSOR FOR
        SELECT c.id_compra
        FROM compra AS c
        JOIN entrada AS en
            ON c.id_compra = en.id_compra
        WHERE c.estado_pago = 'PENDIENTE'
           OR c.estado_pago = 'PAGADO'
        GROUP BY c.id_compra
        HAVING SUM(CASE WHEN en.id_evento = @id_evento THEN 1 ELSE 0 END) = COUNT(*)
        ORDER BY c.id_compra;

    OPEN cursor_compras;

    FETCH NEXT FROM cursor_compras INTO @id_compra;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Revisamos si ya se usó alguna entrada de la compra.
        SELECT @entradas_utilizadas = COUNT(*)
        FROM entrada
        WHERE id_compra = @id_compra
            AND estado = 'UTILIZADA';

        IF @entradas_utilizadas > 0
        BEGIN
            PRINT CONCAT('Compra ', @id_compra, ': omitida porque tiene entradas utilizadas.');
        END
        ELSE
        BEGIN
            BEGIN TRY
                -- Al cancelar la compra, el trigger anula sus entradas.
                UPDATE compra
                SET estado_pago = 'CANCELADO'
                WHERE id_compra = @id_compra
                    AND (estado_pago = 'PENDIENTE' OR estado_pago = 'PAGADO');

                -- Mostramos cómo quedó la compra.
                SELECT id_compra, estado_pago
                FROM compra
                WHERE id_compra = @id_compra;
            END TRY
            BEGIN CATCH
                -- Si ya había una transacción abierta, devolvemos el error.
                IF @transacciones_iniciales > 0
                BEGIN
                    CLOSE cursor_compras;
                    DEALLOCATE cursor_compras;
                    THROW;
                END;

                PRINT CONCAT('Compra ', @id_compra, ': ', ERROR_MESSAGE());
            END CATCH;
        END;

        FETCH NEXT FROM cursor_compras INTO @id_compra;
    END;

    CLOSE cursor_compras;
    DEALLOCATE cursor_compras;
END;
GO
