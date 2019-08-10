CREATE TABLE [puppy].[DomainValueCustomValidations] (
    [Id]                   INT           NOT NULL,
    [UdfName]              NVARCHAR (50) NOT NULL,
    [CustomValidationName] NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

