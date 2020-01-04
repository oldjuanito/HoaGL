CREATE FUNCTION [dbo].[fnRpt_BudgetExpense] (@Year INT)
RETURNS TABLE
AS
RETURN (
		SELECT coalesce(ActualExpense.GLCategory, b.GLCategory) GLCategory
			,b.BudgetAmount
			,ActualExpense.ActualAmount
			,proposed.BudgetAmount ProposedAmount
		FROM (
			SELECT t.GLCategory
				,sum(t.Amount) ActualAmount
			FROM GLTransactions t
			WHERE t.TransactionDate BETWEEN cast(@Year AS VARCHAR(4)) + '-01-01'
					AND cast(@Year AS VARCHAR(4)) + '-12-31'
				AND t.CreditDebitFlag = - 1
			GROUP BY t.GLCategory
			) ActualExpense
		FULL JOIN Budgets b ON b.GLCategory = ActualExpense.GLCategory
			AND b.BudgetYear = @Year
		LEFT JOIN Budgets proposed ON proposed.GLCategory = ActualExpense.GLCategory
			AND proposed.BudgetYear = @Year + 1
		)
