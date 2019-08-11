CREATE FUNCTION [dbo].[fnRpt_TransactionsInDateRange]
(
	@StartDate date,
	@EndDate date,
	@AccountId int
)
RETURNS TABLE AS RETURN
(
	SELECT 
		--SUM(t.Amount * t.CreditDebitFlag) OVER (ORDER BY t.[GLTransactionId]) RunningTotal,
		t.TransactionDate,
		t.ReportDescription,
		t.CheckNumber,
		t.Amount
	from GLTransactions t
	inner join GLAccount a
	on t.AccountId = a.AccountId
	where t.TransactionDate between @StartDate and @EndDate
	and t.AccountId = @AccountId
)
