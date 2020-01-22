CREATE FUNCTION [dbo].[fnRpt_TransactionsInDateRange]
(
	@StartDate date,
	@EndDate date,
	@AccountId int,
	@CreditDebitFlag smallint
)
RETURNS TABLE AS RETURN
(
	SELECT 
		--SUM(t.Amount * t.CreditDebitFlag) OVER (ORDER BY t.[GLTransactionId]) RunningTotal,
		t.TransactionDate,
		case when es.HouseNumber is null then t.ReportDescription else 'Estoppel for ' + cast(es.HouseNumber as varchar(4)) end ReportDescription,
		t.CheckNumber,
		t.Amount
	from GLTransactions t
	inner join GLAccount a
	on t.AccountId = a.AccountId
	left join Estoppels es
	on t.GLTransactionId = es.GLTransactionId
	where t.TransactionDate between @StartDate and @EndDate
	and t.AccountId = @AccountId
	and t.CreditDebitFlag = @CreditDebitFlag
	and t.ExcludeFromReport = 0
)
