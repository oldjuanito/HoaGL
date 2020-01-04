CREATE TABLE [dbo].[Budgets]
(
	[BudgetYear] [BudgetYear] 
	,[GLCategory] [GLCategory]
	,BudgetAmount money NOT NULL, 
    PRIMARY KEY ([BudgetYear], [GLCategory])
)
