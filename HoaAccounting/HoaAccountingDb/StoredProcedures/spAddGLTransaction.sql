CREATE PROCEDURE [dbo].[spAddGLTransaction]
 (
 @AccountId [AccountId],
 @TransactionDate date,
 @Amount money,
 @OptionalCheckNumber varchar(20)=NULL,
 @Description varchar(150),
 @ReportDescription varchar(150)
 )
AS
BEGIN
      INSERT INTO dbo.[GLTransactions]
        ([AccountId],[CreditDebitFlag],[Description],[ReportDescription], [TransactionDate],[BillPayConfirmation],[CheckNumber],[Amount],[TranCount],[GLCategory])
      VALUES
        (@AccountId,
		(case when @Amount < 0 then -1 else 1 end),
		@Description,
		@ReportDescription,
		@TransactionDate,
		null,
		@OptionalCheckNumber,
		abs(@Amount),
		1,

		'Imported');
      SELECT [GLTransactionId],[AccountId],[CreditDebitFlag],[Description],ReportDescription, [TransactionDate],[BillPayConfirmation],[CheckNumber],[Amount],[TranCount],[GLCategory] FROM dbo.[GLTransactions] WHERE [GLTransactionId] = SCOPE_IDENTITY();
    
END;
