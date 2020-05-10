USE fitness
GO

CREATE TRIGGER PURCHASES_AFTER_INSERT
ON PURCHASES 
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE PRODUCTS
	SET QUANTITY = QUANTITY - (SELECT QUANTITY FROM INSERTED)
	WHERE ID = (SELECT PRODUCTID FROM INSERTED);

	UPDATE CLIENTS
	SET TOTALPURCHASEVALUE = TOTALPURCHASEVALUE + (SELECT PRICE FROM PRODUCTS WHERE ID = (SELECT PRODUCTID FROM INSERTED)) * (SELECT QUANTITY FROM INSERTED)
	WHERE ID = (SELECT CLIENTID FROM INSERTED)

END
GO




CREATE TRIGGER  SUBSCRIPTIONS_AFTER_INSERT
ON SUBSCRIPTIONS
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE SUBSCRIPTIONS
	SET EXPIRATIONDATE = (SELECT DATEADD(DAY, (SELECT DURATION FROM SUBSCRIPTIONTYPES WHERE id = (SELECT TYPEid FROM INSERTED)), GETDATE()))
	WHERE ID = (SELECT ID FROM INSERTED);

	UPDATE CLIENTS
	SET TOTALPURCHASEVALUE = TOTALPURCHASEVALUE + (SELECT PRICE FROM SUBSCRIPTIONTYPES WHERE id= (SELECT TYPEid FROM INSERTED))
	WHERE ID = (SELECT CLIENTID FROM INSERTED)

END
GO