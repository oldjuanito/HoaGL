CREATE TABLE [puppy].[WorkflowSteps] (
    [WorkflowDefinitionId] INT NOT NULL,
    [StepNumber]           INT NOT NULL,
    [StepSettingsId]       INT NOT NULL,
    [ConditionSettingsId]  INT NULL,
    [ErrorMapSettingsId]   INT NULL,
    CONSTRAINT [PK_WorkflowSteps] PRIMARY KEY CLUSTERED ([WorkflowDefinitionId] ASC, [StepNumber] ASC),
    CONSTRAINT [FK_WorkflowSteps_SimpleWorkflows] FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [puppy].[SimpleWorkflows] ([WorkflowDefinitionId]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowSteps_WorkflowConditionSettings] FOREIGN KEY ([ConditionSettingsId]) REFERENCES [puppy].[WorkflowConditionSettings] ([ConditionSettingsId]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowSteps_WorkflowErrorMapSettings] FOREIGN KEY ([ErrorMapSettingsId]) REFERENCES [puppy].[WorkflowErrorMapSettings] ([ErrorMapSettingsId]) ON DELETE CASCADE,
    CONSTRAINT [FK_WorkflowSteps_WorkflowStepSettings] FOREIGN KEY ([StepSettingsId]) REFERENCES [puppy].[WorkflowStepSettings] ([StepSettingsId]) ON DELETE CASCADE
);

