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
