CREATE TABLE [puppy].[WorkflowConditionSettings] (
    [ConditionSettingsId]         INT           IDENTITY (1, 1) NOT NULL,
    [ConditionTypeId]             INT           NOT NULL,
    [OriginalConditionSettingsId] INT           NOT NULL,
    [JsonData]                    VARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([ConditionSettingsId] ASC)
);

