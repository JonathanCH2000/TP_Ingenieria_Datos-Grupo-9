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
            AND en.estado <> 'ANULADA'
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

-- Registra una compra y sus entradas en una misma transacción.
CREATE PROCEDURE registrar_compra
    @id_cliente int,
    @id_evento int,
    @cantidad int,
    @precio_unitario decimal(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_compra int;
    DECLARE @numero int = 1;
    DECLARE @ahora datetime = GETDATE();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Revisamos la cantidad y el precio de las entradas.
        IF @cantidad IS NULL OR @cantidad <= 0
            THROW 50005, 'La cantidad de entradas debe ser mayor que cero.', 1;

        IF @precio_unitario IS NULL OR @precio_unitario < 0
            THROW 50006, 'El precio no puede ser negativo ni quedar vacío.', 1;

        -- Comprobamos que el cliente esté registrado.
        IF NOT EXISTS (
            SELECT 1
            FROM cliente
            WHERE id_cliente = @id_cliente
        )
            THROW 50007, 'El cliente no está registrado.', 1;

        -- Solo vendemos entradas para eventos activos que no comenzaron.
        IF NOT EXISTS (
            SELECT 1
            FROM evento
            WHERE id_evento = @id_evento
                AND estado = 'ACTIVO'
                AND (
                    fecha > CAST(@ahora AS date)
                    OR (
                        fecha = CAST(@ahora AS date)
                        AND hora_inicio > CAST(@ahora AS time)
                    )
                )
        )
            THROW 50008, 'El evento no está disponible para vender entradas.', 1;

        -- Creamos la compra con los valores por defecto.
        INSERT INTO compra (id_cliente)
        VALUES (@id_cliente);

        -- Recuperamos el identificador de la compra que acabamos de crear.
        SET @id_compra = SCOPE_IDENTITY();

        -- Creamos las entradas. El trigger actualiza el total de la compra.
        WHILE @numero <= @cantidad
        BEGIN
            INSERT INTO entrada (
                id_compra, id_evento, codigo, precio, estado
            )
            VALUES (
                @id_compra,
                @id_evento,
                CONCAT('C', @id_compra, '-E', @numero),
                @precio_unitario,
                'HABILITADA'
            );

            SET @numero = @numero + 1;
        END;

        COMMIT TRANSACTION;

        -- Mostramos la compra y sus entradas.
        SELECT id_compra, total, estado_pago
        FROM compra
        WHERE id_compra = @id_compra;

        SELECT codigo, id_evento, precio, estado
        FROM entrada
        WHERE id_compra = @id_compra
        ORDER BY id_entrada;
    END TRY
    BEGIN CATCH
        -- Si algo falla, deshacemos la compra y sus entradas.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
