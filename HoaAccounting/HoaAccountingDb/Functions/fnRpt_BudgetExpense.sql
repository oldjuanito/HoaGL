CREATE FUNCTION [dbo].[fnRpt_BudgetExpense] (@Year INT)
RETURNS TABLE
AS
RETURN (
		SELECT coalesce(ActualExpense.GLCategory, b.GLCategory) GLCategory
			,b.BudgetAmount
			,coalesce(ActualExpense.ActualAmount, cast(0.0 AS MONEY)) ActualAmount
			,b.ProposedAmount
		FROM (
			SELECT t.GLCategory
				,sum(t.Amount) ActualAmount
			FROM GLTransactions t
			WHERE t.TransactionDate BETWEEN cast(@Year AS VARCHAR(4)) + '-01-01'
					AND cast(@Year AS VARCHAR(4)) + '-12-31'
				AND t.CreditDebitFlag = - 1
			GROUP BY t.GLCategory
			) ActualExpense
		FULL JOIN (
			SELECT proposed.GLCategory
				,prev.BudgetAmount
				,proposed.BudgetAmount ProposedAmount
			FROM Budgets proposed
			LEFT JOIN Budgets prev ON proposed.GLCategory = prev.GLCategory
				AND prev.BudgetYear = proposed.BudgetYear - 1
			WHERE proposed.BudgetYear = @Year + 1
			) b ON b.GLCategory = ActualExpense.GLCategory
		)
