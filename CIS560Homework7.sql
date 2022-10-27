IF SCHEMA_ID(N'Accounts') IS NULL
    EXEC(N'CREATE SCHEMA [Accounts];');
GO
DROP TABLE IF EXISTS Accounts.Transactions;
DROP TABLE IF EXISTS Accounts.Account;
DROP TABLE IF EXISTS Accounts.AccountHolder;
GO

/***********************
* CREATE TABLES         
************************/

CREATE TABLE Accounts.AccountHolder
(
    AccountHolderId INT NOT NULL IDENTITY(1,1) PRIMARY KEY, --Seeds, Increment--
    Email NVARCHAR(128),
    FirstName NVARCHAR(32),
    LastName NVARCHAR(32),
    CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
    UpdatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
    UNIQUE(Email)
);

CREATE TABLE Accounts.Account
(
    AccountId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    AccountHolderId INT,
    AccountNumber INT,
    NickName NVARCHAR(32),
    CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
    UpdatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
    ClosedOn DATETIMEOFFSET DEFAULT(SYSDATETIMEOFFSET())

    UNIQUE(NickName, AccountHolderId, AccountNumber),
    FOREIGN KEY(AccountHolderId) REFERENCES Accounts.AccountHolder(AccountHolderId)    
);

CREATE TABLE Accounts.Transactions
(
    TransactionId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    AccountId INT,
    Amount DECIMAL(12, 2),
    CreatedOn DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())

    FOREIGN KEY(AccountId) REFERENCES Accounts.Account(AccountId)
);



