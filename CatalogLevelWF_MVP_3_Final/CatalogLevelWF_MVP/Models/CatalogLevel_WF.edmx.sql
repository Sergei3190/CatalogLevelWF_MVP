
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 02/12/2020 18:37:35
-- Generated from EDMX file: E:\Портфолио\CatalogLevelWF_MVP\CatalogLevelWF_MVP\Models\CatalogLevel_WF.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [CatalogLevel_WF];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_Aggregate_Catalog_Catalog_ID]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Aggregate] DROP CONSTRAINT [FK_Aggregate_Catalog_Catalog_ID];
GO
IF OBJECT_ID(N'[dbo].[FK_Model_Aggregate_Aggregate_ID]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Model] DROP CONSTRAINT [FK_Model_Aggregate_Aggregate_ID];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[Aggregate]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Aggregate];
GO
IF OBJECT_ID(N'[dbo].[Catalog]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Catalog];
GO
IF OBJECT_ID(N'[dbo].[Model]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Model];
GO
IF OBJECT_ID(N'[dbo].[Catalog_LevelSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Catalog_LevelSet];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Aggregate'
CREATE TABLE [dbo].[Aggregate] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NULL,
    [Catalog_ID] int  NOT NULL
);
GO

-- Creating table 'Catalog'
CREATE TABLE [dbo].[Catalog] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NULL
);
GO

-- Creating table 'Model'
CREATE TABLE [dbo].[Model] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NULL,
    [Aggregate_ID] int  NOT NULL
);
GO

-- Creating table 'Catalog_LevelSet'
CREATE TABLE [dbo].[Catalog_LevelSet] (
    [ID] int IDENTITY(1,1) NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [ID] in table 'Aggregate'
ALTER TABLE [dbo].[Aggregate]
ADD CONSTRAINT [PK_Aggregate]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'Catalog'
ALTER TABLE [dbo].[Catalog]
ADD CONSTRAINT [PK_Catalog]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'Model'
ALTER TABLE [dbo].[Model]
ADD CONSTRAINT [PK_Model]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'Catalog_LevelSet'
ALTER TABLE [dbo].[Catalog_LevelSet]
ADD CONSTRAINT [PK_Catalog_LevelSet]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [Catalog_ID] in table 'Aggregate'
ALTER TABLE [dbo].[Aggregate]
ADD CONSTRAINT [FK_Aggregate_Catalog_Catalog_ID]
    FOREIGN KEY ([Catalog_ID])
    REFERENCES [dbo].[Catalog]
        ([ID])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Aggregate_Catalog_Catalog_ID'
CREATE INDEX [IX_FK_Aggregate_Catalog_Catalog_ID]
ON [dbo].[Aggregate]
    ([Catalog_ID]);
GO

-- Creating foreign key on [Aggregate_ID] in table 'Model'
ALTER TABLE [dbo].[Model]
ADD CONSTRAINT [FK_Model_Aggregate_Aggregate_ID]
    FOREIGN KEY ([Aggregate_ID])
    REFERENCES [dbo].[Aggregate]
        ([ID])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Model_Aggregate_Aggregate_ID'
CREATE INDEX [IX_FK_Model_Aggregate_Aggregate_ID]
ON [dbo].[Model]
    ([Aggregate_ID]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------