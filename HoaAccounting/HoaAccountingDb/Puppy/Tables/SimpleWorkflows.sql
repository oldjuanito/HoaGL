CREATE TABLE [puppy].[SimpleWorkflows] (
    [WorkflowDefinitionId] INT          NOT NULL,
    [WorkflowId]           INT          NOT NULL,
    [VersionNumber]        INT          NOT NULL,
    [Name]                 VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([WorkflowDefinitionId] ASC)
);

