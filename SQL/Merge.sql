MERGE INTO [dbo].[PriceLimitation] t1
	USING @PriceLimit t2 ON t1.UserID = t2.UserID 
		AND t1.ProdcutGroupID= @ProdcutGroupID
		AND t1.CategoryID=@CategoryID 
		AND t1.ProductID = @ProductID
	WHEN MATCHED THEN
		UPDATE SET t1.StakeAmount = t1.StakeAmount + t2.StakeAmount
	WHEN NOT MATCHED THEN
		INSERT VALUES(@CategoryID, @ProdcutGroupID, t2.UserID ,t2.StakeAmount, @ProductID);
END


MERGE INTO [dbo].[PriceLimitation] t1
	USING @PriceLimit t2 ON t1.UserID = t2.UserID 
	WHEN MATCHED   
        AND t1.ProdcutGroupID= @ProdcutGroupID
        AND t1.CategoryID=@CategoryID 
        AND t1.ProductID = @ProductID 
    THEN
		UPDATE SET t1.StakeAmount = t1.StakeAmount + t2.StakeAmount
	WHEN NOT MATCHED THEN
		INSERT VALUES(@CategoryID, @ProdcutGroupID, t2.UserID ,t2.StakeAmount, @ProductID);
END
