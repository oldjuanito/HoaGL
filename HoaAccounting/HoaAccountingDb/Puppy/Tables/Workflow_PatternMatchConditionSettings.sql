CREATE TABLE [puppy].[Workflow_PatternMatchConditionSettings] (
    [OriginalConditionSettingsId] INT           IDENTITY (1, 1) NOT NULL,
    [ConditionTypeId]             INT           DEFAULT (1) NOT NULL,
    [FieldName]                   VARCHAR (120) NOT NULL,
    [FieldValue]                  VARCHAR (150) NOT NULL,
    [IsFieldNameRegex]            BIT           NOT NULL,
    [IsFieldValueRegex]           BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([OriginalConditionSettingsId] ASC)
);


GO
CREATE TRIGGER puppy.trgWorkflow_PatternMatchConditionSettings_OnDelete
	ON puppy.[Workflow_PatternMatchConditionSettings]
	FOR DELETE
	AS
	BEGIN
		SET NOCOUNT ON

		delete puppy.[WorkflowConditionSettings] 
		FROM deleted 
		inner join puppy.[WorkflowConditionSettings]
		on deleted.OriginalConditionSettingsId = [WorkflowConditionSettings].OriginalConditionSettingsId 
		and deleted.ConditionTypeId = [WorkflowConditionSettings].ConditionTypeId;
		

	END
GO
CREATE TRIGGER puppy.[trgWorkflow_PatternMatchConditionSettings_OnUpdate]
	ON puppy.[Workflow_PatternMatchConditionSettings]
	FOR INSERT, UPDATE
	AS
	BEGIN
		SET NOCOUNT ON
		
		update puppy.[WorkflowConditionSettings] set [JsonData] =
		 (select [FieldName] , [FieldValue], IsFieldNameRegex, IsFieldValueRegex  FOR JSON PATH)
		FROM inserted 
		inner join puppy.[WorkflowConditionSettings]
		on inserted.OriginalConditionSettingsId = [WorkflowConditionSettings].OriginalConditionSettingsId 
		and inserted.ConditionTypeId = [WorkflowConditionSettings].ConditionTypeId;

		insert into puppy.[WorkflowConditionSettings]([ConditionTypeId], [OriginalConditionSettingsId], [JsonData])
		select inserted.[ConditionTypeId], inserted.[OriginalConditionSettingsId], 
			(select [FieldName] , [FieldValue], IsFieldNameRegex, IsFieldValueRegex  FOR JSON PATH)
		FROM inserted 
		left join puppy.[WorkflowConditionSettings]
		on inserted.OriginalConditionSettingsId = [WorkflowConditionSettings].OriginalConditionSettingsId 
		and inserted.ConditionTypeId = [WorkflowConditionSettings].ConditionTypeId
		where [WorkflowConditionSettings].OriginalConditionSettingsId is null;
	END