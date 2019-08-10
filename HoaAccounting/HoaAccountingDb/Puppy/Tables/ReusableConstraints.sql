CREATE TABLE [puppy].[ReusableConstraints] (
    [UdtName]        VARCHAR (25)    NOT NULL,
    [ConstraintCode] NVARCHAR (1024) NOT NULL,
    PRIMARY KEY CLUSTERED ([UdtName] ASC)
);

