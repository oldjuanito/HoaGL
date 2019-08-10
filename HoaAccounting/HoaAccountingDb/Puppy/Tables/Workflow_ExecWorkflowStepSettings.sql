CREATE TABLE [puppy].[Workflow_ExecWorkflowStepSettings] (
    [OriginalStepSettingsId] INT           IDENTITY (1, 1) NOT NULL,
    [StepTypeId]             INT           DEFAULT (2) NOT NULL,
    [ConnectionString]       VARCHAR (120) NOT NULL,
    [WorkflowId]             INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([OriginalStepSettingsId] ASC)
);


GO
CREATE TRIGGER puppy.trgWorkflow_ExecWorkflowStepSettings_OnDelete
	ON puppy.[Workflow_ExecWorkflowStepSettings]
	FOR DELETE
	AS
	BEGIN
		SET NOCOUNT ON

		delete puppy.[WorkflowStepSettings] 
		FROM deleted 
		inner join puppy.[WorkflowStepSettings]
		on deleted.OriginalStepSettingsId = [WorkflowStepSettings].OriginalStepSettingsId 
		and deleted.StepTypeId = [WorkflowStepSettings].StepTypeId;
		

	END
GO
CREATE TRIGGER puppy.[trgWorkflow_ExecWorkflowStepSettings_OnUpdate]
	ON puppy.[Workflow_ExecWorkflowStepSettings]
	FOR INSERT, UPDATE
	AS
	BEGIN
		SET NOCOUNT ON

		update puppy.[WorkflowStepSettings] set [JsonData] =
		 (select [ConnectionString] , WorkflowId  FOR JSON PATH)
		FROM inserted 
		inner join puppy.[WorkflowStepSettings]
		on inserted.OriginalStepSettingsId = [WorkflowStepSettings].OriginalStepSettingsId 
		and inserted.StepTypeId = [WorkflowStepSettings].StepTypeId;

		insert into puppy.[WorkflowStepSettings]([StepTypeId], [OriginalStepSettingsId], [JsonData])
		select inserted.[StepTypeId], inserted.[OriginalStepSettingsId], (select [ConnectionString] , WorkflowId  FOR JSON PATH)
		FROM inserted 
		left join puppy.[WorkflowStepSettings]
		on inserted.OriginalStepSettingsId = [WorkflowStepSettings].OriginalStepSettingsId 
		and inserted.StepTypeId = [WorkflowStepSettings].StepTypeId
		where [WorkflowStepSettings].OriginalStepSettingsId is null;
	END