CREATE TABLE [puppy].[WorkflowStepInputMappings] (
    [WorkflowDefinitionId] INT          NOT NULL,
    [StepNumber]           INT          NOT NULL,
    [StaticValue]          VARCHAR (60) NULL,
    [FromResultSet]        INT          DEFAULT (0) NOT NULL,
    [FromFieldName]        VARCHAR (60) NULL,
    [ToResultSet]          INT          DEFAULT (0) NOT NULL,
    [ToFieldName]          VARCHAR (60) NULL,
    [CopyToOutput]         BIT          DEFAULT 0 NOT NULL,
    CONSTRAINT [FK_WorkflowStepInputMappings_WorkflowSteps] FOREIGN KEY ([WorkflowDefinitionId], [StepNumber]) REFERENCES [puppy].[WorkflowSteps] ([WorkflowDefinitionId], [StepNumber])
);

