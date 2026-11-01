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

-- Registra el ingreso cuando la entrada cumple las condiciones.
CREATE PROCEDURE registrar_ingreso
    @codigo varchar(20),
    @id_evento int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Marcamos la entrada como utilizada si está habilitada,
        -- la compra está pagada y el evento está activo.
        UPDATE en
        SET estado = 'UTILIZADA'
        FROM entrada AS en
        JOIN compra AS c
            ON en.id_compra = c.id_compra
        JOIN evento AS ev
            ON en.id_evento = ev.id_evento
        WHERE en.codigo = @codigo
            AND en.id_evento = @id_evento
            AND en.estado = 'HABILITADA'
            AND c.estado_pago = 'PAGADO'
            AND ev.estado = 'ACTIVO';

        -- Si no se actualizó ninguna entrada, rechazamos el ingreso.
        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50004, 'La entrada no cumple las condiciones para ingresar.', 1;
        END;

        COMMIT TRANSACTION;

        SELECT 'Ingreso registrado correctamente.' AS mensaje;
    END TRY
    BEGIN CATCH
        -- Deshacemos los cambios y mostramos el error.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO