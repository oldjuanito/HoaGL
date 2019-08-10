CREATE TABLE [puppy].[Workflow_DotNetFuncStepSettings] (
    [OriginalStepSettingsId] INT           IDENTITY (1, 1) NOT NULL,
    [StepTypeId]             INT           DEFAULT (3) NOT NULL,
    [Assembly]               VARCHAR (120) NOT NULL,
    [FullClassName]          VARCHAR (120) NOT NULL,
    [FunctionName]           VARCHAR (120) NOT NULL,
    PRIMARY KEY CLUSTERED ([OriginalStepSettingsId] ASC)
);


GO
CREATE TRIGGER puppy.trgWorkflow_DotNetFuncStepSettings_OnDelete
	ON puppy.[Workflow_DotNetFuncStepSettings]
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
CREATE TRIGGER puppy.[trgWorkflow_DotNetFuncStepSettings_OnUpdate]
	ON puppy.[Workflow_DotNetFuncStepSettings]
	FOR INSERT, UPDATE
	AS
	BEGIN
		SET NOCOUNT ON

		update puppy.[WorkflowStepSettings] set [JsonData] =
		 (select [Assembly] , [FullClassName], [FunctionName] FOR JSON PATH)
		FROM inserted 
		inner join puppy.[WorkflowStepSettings]
		on inserted.OriginalStepSettingsId = [WorkflowStepSettings].OriginalStepSettingsId 
		and inserted.StepTypeId = [WorkflowStepSettings].StepTypeId;

		insert into puppy.[WorkflowStepSettings]([StepTypeId], [OriginalStepSettingsId], [JsonData])
		select inserted.[StepTypeId], inserted.[OriginalStepSettingsId], (select [Assembly] , [FullClassName], [FunctionName]  FOR JSON PATH)
		FROM inserted 
		left join puppy.[WorkflowStepSettings]
		on inserted.OriginalStepSettingsId = [WorkflowStepSettings].OriginalStepSettingsId 
		and inserted.StepTypeId = [WorkflowStepSettings].StepTypeId
		where [WorkflowStepSettings].OriginalStepSettingsId is null;
	END