CREATE TABLE [puppy].[WorkflowStepSettings] (
    [StepSettingsId]         INT           IDENTITY (1, 1) NOT NULL,
    [StepTypeId]             INT           NOT NULL,
    [OriginalStepSettingsId] INT           NOT NULL,
    [JsonData]               VARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([StepSettingsId] ASC)
);

