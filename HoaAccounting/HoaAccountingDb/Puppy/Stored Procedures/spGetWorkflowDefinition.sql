CREATE PROCEDURE puppy.[spGetWorkflowDefinition]
	@WorkflowId int ,
	@VersionNumber int
AS
DECLARE @workflowDefinitionId int = 0

	SELECT @workflowDefinitionId = w.WorkflowDefinitionId FROM Puppy.SimpleWorkflows w WHERE WorkflowId = @WorkflowId AND VersionNumber = @VersionNumber;

	SELECT [WorkflowDefinitionId], [StepNumber], settings.StepTypeId, settings.JsonData 
	FROM Puppy.WorkflowSteps steps
	inner join Puppy.WorkflowStepSettings settings
	on steps.StepSettingsId = settings.StepSettingsId
	WHERE WorkflowDefinitionId = @workflowDefinitionId ORDER BY StepNumber

	SELECT [WorkflowDefinitionId], [StepNumber], [StaticValue], [FromResultSet], [FromFieldName], [ToResultSet], [ToFieldName], [CopyToOutput] FROM Puppy.WorkflowStepInputMappings WHERE WorkflowDefinitionId = @workflowDefinitionId ORDER BY StepNumber