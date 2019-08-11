CREATE FUNCTION [dbo].fnRpt_AccountBalancesDateRange
(
	@StartDate date,
	@EndDate date,
	@AccountId int
)
RETURNS TABLE AS RETURN
(
	SELECT @AccountId AccountId,
		a.ReportName,
		isnull(t.TranBalance,0.0) + a.InitialBalance Balance,
		@StartDate BalanceDate
	from GLAccount a 
	left join (
		select SUM(t.Amount * t.CreditDebitFlag) TranBalance 
		from GLTransactions t
		where  t.TransactionDate < @StartDate
		and t.AccountId = @AccountId
		) t
	on 1 = 1
	where a.AccountId = @AccountId

	union all

	SELECT @AccountId AccountId,
		a.ReportName,
		isnull(t.TranBalance,0.0) + a.InitialBalance Balance,
		@EndDate BalanceDate
	from GLAccount a 
	left join (
		select SUM(t.Amount * t.CreditDebitFlag) TranBalance 
		from GLTransactions t
		where  t.TransactionDate between @StartDate and @EndDate
		and t.AccountId = @AccountId
		) t
	on 1 = 1
	where a.AccountId = @AccountId
)
