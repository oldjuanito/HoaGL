CREATE TABLE [Puppy].[ValidValuesConstraints] (
    [Id]      INT           IDENTITY (1, 1) NOT NULL,
    [UdfName] NVARCHAR (50) NOT NULL,
    [Value]   NVARCHAR (50) NOT NULL,
    [Label]   NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

