CREATE FUNCTION puppy.[GetWorkflowStepTypeIncorrect] (
	@WorkflowId INT
	)
RETURNS INT
AS
BEGIN
	DECLARE @errStepNum INT = 0;

	SELECT @errStepNum = MAX(err)
	FROM (
		SELECT CASE 
				WHEN lag([OutputType], 1, '') OVER (
						ORDER BY [StepNumber]
						) <> InputType
					THEN [StepNumber]
				ELSE 0
				END err
		FROM puppy.[WorkflowStepsV1] s
		WHERE [WorkflowId] = @WorkflowId
		) t

	RETURN @errStepNum
END