CREATE TABLE [Puppy].[LookupValueConstraints] (
    [UdfName]         NVARCHAR (50) NOT NULL,
    [SpForSearch]     NVARCHAR (50) NOT NULL,
    [LookupTable]     NVARCHAR (50) NULL,
    [SpForValidation] NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([UdfName] ASC),
    CONSTRAINT [CK_LookupValueConstraints_TblOrSp] CHECK ((LookupTable is not null) or (SpForValidation is not null))
);

