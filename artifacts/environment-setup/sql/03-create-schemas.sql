IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'wwi')
    EXEC('CREATE SCHEMA [wwi]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'wwi_security')
    EXEC('CREATE SCHEMA [wwi_security]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'wwi_staging')
    EXEC('CREATE SCHEMA [wwi_staging]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'wwi_perf')
    EXEC('CREATE SCHEMA [wwi_perf]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'wwi_poc')
    EXEC('CREATE SCHEMA [wwi_poc]')
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'wwi_ml')
    EXEC('CREATE SCHEMA [wwi_ml]')
GO