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
		isnull(StartBal.TranBalance,0.0) + a.InitialBalance Balance,
		@StartDate BalanceDate,
		isnull(StartBal.TranBalance,0.0) + isnull(EndBal.TranBalance,0.0) + a.InitialBalance EndBalance,
		@EndDate EndBalanceDate
	from GLAccount a 
	left join (
		select SUM(t.Amount * t.CreditDebitFlag) TranBalance 
		from GLTransactions t
		where  t.TransactionDate < @StartDate
		and t.AccountId = @AccountId
		and t.ExcludeFromReport = 0
		) StartBal
	on 1 = 1
	left join (
		select SUM(t.Amount * t.CreditDebitFlag) TranBalance 
		from GLTransactions t
		where  t.TransactionDate between @StartDate and @EndDate
		and t.AccountId = @AccountId
		and t.ExcludeFromReport = 0
		) EndBal
	on 1 = 1
	where a.AccountId = @AccountId

)
