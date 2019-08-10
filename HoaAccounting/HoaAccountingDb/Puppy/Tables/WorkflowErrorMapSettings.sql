CREATE TABLE [puppy].[WorkflowErrorMapSettings] (
    [ErrorMapSettingsId]         INT           IDENTITY (1, 1) NOT NULL,
    [ErrorMapTypeId]             INT           NOT NULL,
    [OriginalErrorMapSettingsId] INT           NOT NULL,
    [JsonData]                   VARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([ErrorMapSettingsId] ASC)
);

