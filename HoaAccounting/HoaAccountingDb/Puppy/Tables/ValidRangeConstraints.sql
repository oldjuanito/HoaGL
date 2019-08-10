CREATE TABLE [puppy].[ValidRangeConstraints] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [UdfName]       NVARCHAR (50)  NOT NULL,
    [From]          NVARCHAR (50)  NULL,
    [To]            NVARCHAR (50)  NULL,
    [CustomMessage] NVARCHAR (150) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

