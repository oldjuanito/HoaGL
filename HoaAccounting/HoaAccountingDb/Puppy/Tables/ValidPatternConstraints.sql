CREATE TABLE [puppy].[ValidPatternConstraints] (
    [Id]            INT            NOT NULL,
    [UdfName]       NVARCHAR (50)  NOT NULL,
    [Regex]         NVARCHAR (150) NULL,
    [CustomMessage] NVARCHAR (150) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

