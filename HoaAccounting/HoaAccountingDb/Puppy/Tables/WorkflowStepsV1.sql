CREATE TABLE [puppy].[WorkflowStepsV1] (
    [WorkflowId] INT          NOT NULL,
    [StepNumber] INT          NOT NULL,
    [NameToCall] VARCHAR (60) NOT NULL,
    [InputType]  VARCHAR (60) NOT NULL,
    [OutputType] VARCHAR (60) NOT NULL,
    CONSTRAINT [PK_WorkflowStepsV1] PRIMARY KEY CLUSTERED ([WorkflowId] ASC, [StepNumber] ASC),
    CONSTRAINT [CHK_InputTypeIsCorrect] CHECK (puppy.[GetWorkflowStepTypeIncorrect]([WorkflowId] ) = 0)
);

