--1. Coздание таблицы Catalog

CREATE TABLE [dbo].[Catalog] (
    [ID]   INT            IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Catalog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

--2. Заполнение таблицы Catalog данными

INSERT INTO [Catalog] ([Name]) VALUES (N'VOLVO')
INSERT INTO [Catalog] ([Name]) VALUES (N'ER')

--3. Сoздание таблицы Aggregate

CREATE TABLE [dbo].[Aggregate] (
    [ID]        INT            IDENTITY (1, 1) NOT NULL,
    [Name]      NVARCHAR (MAX) NULL,
    [Catalog_ID] INT            NOT NULL,
    CONSTRAINT [PK_Aggregate] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Aggregate_Catalog_Catalog_ID] FOREIGN KEY ([Catalog_ID]) REFERENCES [Catalog] ([ID])
	ON DELETE CASCADE
);

GO

CREATE NONCLUSTERED INDEX [IX_Catalog_ID]
    ON [dbo].[Aggregate]([Catalog_ID] ASC);

--4. Заполнение таблицы Aggregate данными

INSERT INTO [Aggregate] ([Name],[Catalog_ID]) VALUES (N'КПП',1)
INSERT INTO [Aggregate] ([Name],[Catalog_ID]) VALUES (N'Двигатель',2)
INSERT INTO [Aggregate] ([Name],[Catalog_ID]) VALUES (N'КПП',2)

--5. Сoздание таблицы Model

CREATE TABLE [dbo].[Model]
(
	[ID] INT IDENTITY(1,1) NOT NULL , 
    [Name] NVARCHAR(MAX) NULL, 
    [Aggregate_ID] INT NOT NULL, 
    CONSTRAINT [PK_Model] PRIMARY KEY ([ID] ASC), 
    CONSTRAINT [FK_Model_Aggregate_Aggregate_ID] FOREIGN KEY ([Aggregate_ID]) REFERENCES [Aggregate]([ID])
	ON DELETE CASCADE 
);

GO

CREATE INDEX [IX_Aggregate_ID]
	ON [dbo].[Model] ([Aggregate_ID] ASC)

--6. Заполнение таблицы Model данными

INSERT INTO [Model] ([Name],[Aggregate_ID]) VALUES (N'A365',1)
INSERT INTO [Model] ([Name],[Aggregate_ID]) VALUES (N'M4566',2)
INSERT INTO [Model] ([Name],[Aggregate_ID]) VALUES (N'FG4511',2)
INSERT INTO [Model] ([Name],[Aggregate_ID]) VALUES (N'T45459',3)

--7. Сoздание таблицы Catalog_Level

CREATE TABLE [dbo].[Catalog_Level]
(
     [ID]       INT            IDENTITY (1, 1) NOT NULL,
    [Parent_ID] INT            NULL,
    [Name]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Catalog_Level] PRIMARY KEY CLUSTERED ([ID] ASC)
);

 --8. Coздание табличной переменной @CL_Consolidation для: 
 --	1) консалидации данных из таблиц Catalog, Aggregate, Model
 -- 2) представления каким образом будет устроена иерархия в таблице Catalog_Level

DECLARE @CL_Consolidation TABLE 
(
	[ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [Parent_ID] INT NULL, 
    [Name] NVARCHAR(MAX) NULL, 
    [Catalog_ID] INT NULL, 
    [Aggregate_ID] INT NULL, 
    [Aggregate_Catalog_ID] INT NULL, 
    [Model_Aggregate_ID] INT NULL
);

 --9. Заполнение таблицы @CL_Consolidation данными и вывод данных из таблиц 
 -- Catalog, Aggregate, Model, @CL_Consolidation

 INSERT INTO @CL_Consolidation ([Name],[Catalog_ID]) 
 SELECT 
	[Catalog].[Name],
	[Catalog].[ID] 
 FROM 
	[Catalog] 

 INSERT INTO @CL_Consolidation ([Name],[Aggregate_ID],[Aggregate_Catalog_ID]) 
 SELECT 
	[Aggregate].[Name],
	[Aggregate].[ID],
	[Aggregate].[Catalog_ID]
 FROM 
	[Aggregate]

 INSERT INTO @CL_Consolidation ([Name],[Model_Aggregate_ID])
 SELECT 
	[Model].[Name],
	[Model].[Aggregate_ID] 
 FROM 
	[Model]

 SELECT* FROM [Catalog]
 SELECT* FROM [Aggregate]
 SELECT* FROM [Model]
 SELECT* FROM @CL_Consolidation

 --10. Cоздание временной таблицы #CLC для 
 -- получения корректных данных всех элементов таблицы Catalog 
 -- для результирующей таблице Catalog_Level 

 CREATE TABLE #CLC 
(	
	[ID] INT NOT NULL,
	[Parent_ID] INT NULL,
	[Name] NVARCHAR(MAX) NULL,
	[Catalog_ID] INT NULL
);

 --11. Заполнение таблицы #CLC данными

 INSERT INTO #CLC ([ID],[Parent_ID],[Name],[Catalog_ID]) 
 SELECT 
	[CL].[ID],
	[CL].[Parent_ID],
	[CL].[Name],
	[CL].[Catalog_ID]
 FROM 
	@CL_Consolidation AS [CL]
 WHERE 
	[CL].[Catalog_ID] IS NOT NULL 

 --12. Cоздание временной таблицы #CLA для 
 -- получения корректных данных всех элементов таблицы Aggregate
 -- для результирующей таблице Catalog_Level 

  CREATE TABLE #CLA
 (
	[ID] INT NOT NULL,
	[Parent_ID] INT NULL,
	[Name] NVARCHAR(MAX) NULL,
	[Aggregate_ID] INT NULL,
 );

 --13. Заполнение таблицы #CLA данными

 INSERT INTO #CLA ([ID],[Parent_ID],[Name],[Aggregate_ID])
 SELECT 
	[CL].[ID],
	#CLC.[ID],
	[CL].[Name],
	[CL].[Aggregate_ID]
 FROM 
	@CL_Consolidation AS [CL]
 INNER JOIN 
	#CLC ON #CLC.[Catalog_ID] = [CL].[Aggregate_Catalog_ID]
 WHERE 
	[CL].[Aggregate_ID] IS NOT NULL

 --14. Cоздание временной таблицы #CLM для 
 -- получения корректных данных всех элементов таблицы Model
 -- для результирующей таблице Catalog_Level

 CREATE TABLE #CLM 
 (
	[ID] INT NOT NULL,
	[Parent_ID] INT NULL,
	[Name] NVARCHAR(MAX) NULL,
 );

 --15. Заполнение таблицы #CLM данными

 INSERT INTO #CLM ([ID],[Parent_ID],[Name]) 
 SELECT 
	[CL].[ID],
	#CLA.[ID],
	[CL].[Name]
 FROM 
	@CL_Consolidation AS [CL] 
 INNER JOIN
	#CLA on #CLA.[Aggregate_ID] = [CL].[Model_Aggregate_ID]
 WHERE 
	[CL].[Model_Aggregate_ID] IS NOT NULL

 --16. Заполнение таблицы Catalog_Level данными, если колонка ID не содержит IDENTITY 

 INSERT INTO [Catalog_Level] 
 SELECT #CLC.[ID], #CLC.[Parent_ID], #CLC.[Name] FROM #CLC
 UNION
 SELECT #CLA.[ID], #CLA.[Parent_ID], #CLA.[Name] FROM #CLA
 UNION
 SELECT #CLM.[ID], #CLM.[Parent_ID], #CLM.[Name] FROM #CLM

  --16.1 Заполнение таблицы Catalog_Level данными, если колонка ID содержит IDENTITY 
 SET IDENTITY_INSERT [Catalog_Level] ON
 SELECT #CLC.[ID], #CLC.[Parent_ID], #CLC.[Name] FROM #CLC
 UNION
 SELECT #CLA.[ID], #CLA.[Parent_ID], #CLA.[Name] FROM #CLA
 UNION
 SELECT #CLM.[ID], #CLM.[Parent_ID], #CLM.[Name] FROM #CLM
 

