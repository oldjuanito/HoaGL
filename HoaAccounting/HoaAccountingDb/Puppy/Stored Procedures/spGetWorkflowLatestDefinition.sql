CREATE PROCEDURE puppy.spGetWorkflowLatestDefinition
	@WorkflowId int 
AS
DECLARE @workflowDefinitionId int = 
	(select top 1 w.WorkflowDefinitionId FROM Puppy.SimpleWorkflows w WHERE WorkflowId = @WorkflowId order by w.VersionNumber desc);

	SELECT [WorkflowDefinitionId], [StepNumber], settings.StepTypeId, settings.JsonData 
	, condSettings.ConditionTypeId, condSettings.JsonData ConditionJsonData
	, errSettings.ErrorMapTypeId, errSettings.JsonData ErrorMapJsonData

	FROM Puppy.WorkflowSteps steps
	inner join Puppy.WorkflowStepSettings settings
	on steps.StepSettingsId = settings.StepSettingsId
	left join Puppy.WorkflowConditionSettings condSettings
	on steps.ConditionSettingsId = condSettings.ConditionSettingsId
	left join Puppy.WorkflowErrorMapSettings errSettings
	on steps.ErrorMapSettingsId = errSettings.ErrorMapSettingsId
	WHERE WorkflowDefinitionId = @workflowDefinitionId 
	ORDER BY StepNumber

	SELECT [WorkflowDefinitionId], [StepNumber], [StaticValue], [FromResultSet], [FromFieldName], [ToResultSet], [ToFieldName], [CopyToOutput] 
	FROM Puppy.WorkflowStepInputMappings WHERE WorkflowDefinitionId = @workflowDefinitionId 
	ORDER BY StepNumber