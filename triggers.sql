USE GestionDeEntradas;
GO

-- Actualiza el total de la compra al agregar, modificar o eliminar entradas.
CREATE TRIGGER trg_actualizar_total_compra
ON entrada
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sumamos los precios de las entradas, incluyendo las anuladas.
    -- Si la compra queda sin entradas, el total es 0.
    UPDATE compra
    SET total = ISNULL(
        (
            SELECT SUM(e.precio)
            FROM entrada AS e
            WHERE e.id_compra = compra.id_compra
        ), 0
    )
    -- Actualizamos las compras que tuvieron cambios en sus entradas.
    -- Si una entrada pasa a otra compra, recalculamos las dos.
    WHERE id_compra IN (
        SELECT id_compra FROM inserted
        UNION
        SELECT id_compra FROM deleted
    );
END;
GO

-- Anula las entradas cuando se cancela una compra.
CREATE TRIGGER trg_cancelar_compra
ON compra
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Si no se actualiza el estado de pago, terminamos.
    IF NOT UPDATE(estado_pago)
        RETURN;

    -- Revisamos si alguna compra que se cancela tiene entradas utilizadas.
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN entrada AS e
            ON i.id_compra = e.id_compra
        WHERE i.estado_pago = 'CANCELADO'
            AND e.estado = 'UTILIZADA'
    )
    BEGIN
        THROW 50001, 'No se puede cancelar una compra con entradas utilizadas.', 1;
    END;

    -- Anulamos las entradas de las compras canceladas.
    UPDATE e
    SET estado = 'ANULADA'
    FROM entrada AS e
    JOIN inserted AS i
        ON e.id_compra = i.id_compra
    WHERE i.estado_pago = 'CANCELADO'
        AND e.estado <> 'ANULADA';
END;
GO

-- Evita que dos eventos se superpongan en el mismo lugar y fecha.
CREATE TRIGGER trg_evitar_superposicion_eventos
ON evento
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Comparamos con otros eventos del mismo lugar y fecha.
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        JOIN evento AS e
            ON i.id_lugar = e.id_lugar
            AND i.fecha = e.fecha
            AND i.id_evento <> e.id_evento
        -- Revisamos si los horarios se cruzan.
        WHERE i.hora_inicio < e.hora_fin
            AND i.hora_fin > e.hora_inicio
    )
    BEGIN
        THROW 50002, 'El lugar ya tiene un evento en ese horario.', 1;
    END;
END;
GO