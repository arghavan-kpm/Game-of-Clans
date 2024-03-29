USE [master]
GO
/****** Object:  Database [DBLAB]    Script Date: 18/12/23 16:26:04 ******/
CREATE DATABASE [DBLAB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBLAB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLDEVELOPER\MSSQL\DATA\DBLAB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBLAB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLDEVELOPER\MSSQL\DATA\DBLAB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [DBLAB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBLAB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DBLAB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DBLAB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DBLAB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DBLAB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DBLAB] SET ARITHABORT OFF 
GO
ALTER DATABASE [DBLAB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DBLAB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DBLAB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DBLAB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DBLAB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DBLAB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DBLAB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DBLAB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DBLAB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DBLAB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DBLAB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DBLAB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DBLAB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DBLAB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DBLAB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DBLAB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DBLAB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DBLAB] SET RECOVERY FULL 
GO
ALTER DATABASE [DBLAB] SET  MULTI_USER 
GO
ALTER DATABASE [DBLAB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DBLAB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DBLAB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DBLAB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DBLAB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DBLAB', N'ON'
GO
ALTER DATABASE [DBLAB] SET QUERY_STORE = OFF
GO
USE [DBLAB]
GO
/****** Object:  User [Kosar]    Script Date: 18/12/23 16:26:04 ******/
CREATE USER [Kosar] FOR LOGIN [Kosar] WITH DEFAULT_SCHEMA=[INFORMATION_SCHEMA]
GO
ALTER ROLE [db_owner] ADD MEMBER [Kosar]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [Kosar]
GO
/****** Object:  UserDefinedFunction [dbo].[barrackCount]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[barrackCount] 
(
	-- Add the parameters for the function here
	@clanId int
)
RETURNS int
AS
BEGIN
	RETURN ( SELECT COUNT(*) 
			FROM Building B, ClanBuildRel C
			WHERE B.BuildingId = C.BuildingId AND C.ClanId = @clanId AND B.type = 'BARRACK' 
			);

END
GO
/****** Object:  UserDefinedFunction [dbo].[farmCount]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[farmCount]
(
	-- Add the parameters for the function here
@clanId int
)
RETURNS int
AS
BEGIN
	
	RETURN ( SELECT COUNT(*) 
			FROM Building B, ClanBuildRel C
			WHERE B.BuildingId = C.BuildingId AND C.ClanId = @clanId AND B.type = 'FARM' AND B.progress = 100
			);

END
GO
/****** Object:  UserDefinedFunction [dbo].[farmerLevelSum]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[farmerLevelSum]
(
	-- Add the parameters for the function here
	@clanId int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @sum INT
	SET @sum = ( SELECT SUM( URR.userLevel ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 3) ; 

	DECLARE @farmer INT
	SET @farmer = ( SELECT COUNT( URR.username ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 3) ; 
		
	IF @farmer = 0
		RETURN 0;
	
	RETURN @sum;

END
GO
/****** Object:  UserDefinedFunction [dbo].[getMin]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getMin]
(
	-- Add the parameters for the function here
	@a int,
	@b int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	IF( @a < @b )
		RETURN @a;
	
	RETURN @b;
END
GO
/****** Object:  UserDefinedFunction [dbo].[minorLevelSum]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[minorLevelSum]
(
	-- Add the parameters for the function here
	@clanId int
)
RETURNS int
AS
BEGIN
	DECLARE @sum INT
	SET @sum = ( SELECT SUM( URR.userLevel ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 1) ; 

	DECLARE @minor INT
	SET @minor = ( SELECT COUNT( URR.username ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 1) ; 
		
	IF @minor = 0
		RETURN 0;
	RETURN @sum;

END
GO
/****** Object:  UserDefinedFunction [dbo].[sawyerLevelSum]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[sawyerLevelSum]
(
	-- Add the parameters for the function here
	@clanId int
)
RETURNS int
AS
BEGIN
	DECLARE @sum INT
	SET @sum = ( SELECT SUM( URR.userLevel ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 2) ; 

	DECLARE @sawyer INT
	SET @sawyer = ( SELECT COUNT( URR.username ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 2) ; 
		
	IF @sawyer = 0
		RETURN 0;
	
	RETURN @sum;

END
GO
/****** Object:  UserDefinedFunction [dbo].[trainerLevelSum]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[trainerLevelSum]
(
	-- Add the parameters for the function here
	@clanId int
)
RETURNS int
AS
BEGIN
	DECLARE @sum INT
	SET @sum = ( SELECT SUM( URR.userLevel ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 4) ; 

	DECLARE @trainer INT
	SET @trainer = ( SELECT COUNT( URR.username ) 
				FROM UserClanRel UCR, UserRoleRel URR
				WHERE UCR.ClanId = @clanId and UCR.username = URR.username and URR.JobId = 4) ; 
		
	IF @trainer = 0
		RETURN 0;
	
	RETURN @sum;

END
GO
/****** Object:  Table [dbo].[Building]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Building](
	[BuildingId] [int] IDENTITY(1,1) NOT NULL,
	[start] [date] NOT NULL,
	[type] [varchar](50) NOT NULL,
	[progress] [int] NOT NULL,
	[active] [int] NOT NULL,
 CONSTRAINT [PK_Building] PRIMARY KEY CLUSTERED 
(
	[BuildingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clan]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clan](
	[ClanId] [int] IDENTITY(1,1) NOT NULL,
	[Army] [int] NOT NULL,
	[expr] [int] NOT NULL,
	[gold] [int] NOT NULL,
	[lumber] [int] NOT NULL,
	[food] [int] NOT NULL,
	[Chant] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Clan] PRIMARY KEY CLUSTERED 
(
	[ClanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClanBuildRel]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClanBuildRel](
	[BuildingId] [int] NOT NULL,
	[ClanId] [int] NOT NULL,
 CONSTRAINT [PK_ClanBuildRel_1] PRIMARY KEY CLUSTERED 
(
	[BuildingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fightRel]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fightRel](
	[Date] [date] NOT NULL,
	[winnerId] [int] NOT NULL,
	[winnerCasuality] [int] NOT NULL,
	[loserCasuality] [int] NOT NULL,
	[ClanId1] [int] NOT NULL,
	[ClanId2] [int] NOT NULL,
	[fightId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_fightRel_1] PRIMARY KEY CLUSTERED 
(
	[fightId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Game]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Game](
	[GameId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameClanRel]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameClanRel](
	[ClanId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
 CONSTRAINT [PK_GameClanRel] PRIMARY KEY CLUSTERED 
(
	[ClanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameUser]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameUser](
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GameUser] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Job]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Job](
	[JobId] [int] IDENTITY(1,1) NOT NULL,
	[JobName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Job] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleTbl]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleTbl](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RoleTbl] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserClanRel]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClanRel](
	[username] [varchar](50) NOT NULL,
	[ClanId] [int] NOT NULL,
	[Start] [date] NOT NULL,
 CONSTRAINT [PK_UserClanRel] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoleRel]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoleRel](
	[username] [varchar](50) NOT NULL,
	[RoleId] [int] NOT NULL,
	[JobId] [int] NOT NULL,
	[userLevel] [int] NOT NULL,
 CONSTRAINT [PK_UserRoleRel] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clan] ADD  CONSTRAINT [DF_Clan_Army]  DEFAULT ((0)) FOR [Army]
GO
ALTER TABLE [dbo].[Clan] ADD  CONSTRAINT [DF_Clan_expr]  DEFAULT ((0)) FOR [expr]
GO
ALTER TABLE [dbo].[Clan] ADD  CONSTRAINT [DF_Clan_gold]  DEFAULT ((0)) FOR [gold]
GO
ALTER TABLE [dbo].[Clan] ADD  CONSTRAINT [DF_Clan_lumber]  DEFAULT ((0)) FOR [lumber]
GO
ALTER TABLE [dbo].[Clan] ADD  CONSTRAINT [DF_Clan_food]  DEFAULT ((0)) FOR [food]
GO
ALTER TABLE [dbo].[fightRel] ADD  CONSTRAINT [DF_fightRel_winnerCasuality]  DEFAULT ((0)) FOR [winnerCasuality]
GO
ALTER TABLE [dbo].[fightRel] ADD  CONSTRAINT [DF_fightRel_loserCasuality]  DEFAULT ((0)) FOR [loserCasuality]
GO
ALTER TABLE [dbo].[UserRoleRel] ADD  CONSTRAINT [DF_UserRoleRel_userLevel]  DEFAULT ((0)) FOR [userLevel]
GO
ALTER TABLE [dbo].[ClanBuildRel]  WITH CHECK ADD  CONSTRAINT [FK_ClanBuildRel_Build] FOREIGN KEY([BuildingId])
REFERENCES [dbo].[Building] ([BuildingId])
GO
ALTER TABLE [dbo].[ClanBuildRel] CHECK CONSTRAINT [FK_ClanBuildRel_Build]
GO
ALTER TABLE [dbo].[ClanBuildRel]  WITH CHECK ADD  CONSTRAINT [FK_ClanBuildRel_Clan] FOREIGN KEY([ClanId])
REFERENCES [dbo].[Clan] ([ClanId])
GO
ALTER TABLE [dbo].[ClanBuildRel] CHECK CONSTRAINT [FK_ClanBuildRel_Clan]
GO
ALTER TABLE [dbo].[fightRel]  WITH CHECK ADD  CONSTRAINT [FK_fightRel_Clan1] FOREIGN KEY([ClanId1])
REFERENCES [dbo].[Clan] ([ClanId])
GO
ALTER TABLE [dbo].[fightRel] CHECK CONSTRAINT [FK_fightRel_Clan1]
GO
ALTER TABLE [dbo].[fightRel]  WITH CHECK ADD  CONSTRAINT [FK_fightRel_Clan2] FOREIGN KEY([ClanId2])
REFERENCES [dbo].[Clan] ([ClanId])
GO
ALTER TABLE [dbo].[fightRel] CHECK CONSTRAINT [FK_fightRel_Clan2]
GO
ALTER TABLE [dbo].[GameClanRel]  WITH CHECK ADD  CONSTRAINT [FK_GameClanRel_Clan] FOREIGN KEY([ClanId])
REFERENCES [dbo].[Clan] ([ClanId])
GO
ALTER TABLE [dbo].[GameClanRel] CHECK CONSTRAINT [FK_GameClanRel_Clan]
GO
ALTER TABLE [dbo].[GameClanRel]  WITH CHECK ADD  CONSTRAINT [FK_GameClanRel_Game] FOREIGN KEY([GameId])
REFERENCES [dbo].[Game] ([GameId])
GO
ALTER TABLE [dbo].[GameClanRel] CHECK CONSTRAINT [FK_GameClanRel_Game]
GO
ALTER TABLE [dbo].[UserClanRel]  WITH CHECK ADD  CONSTRAINT [FK_UserClanRel_Clan] FOREIGN KEY([ClanId])
REFERENCES [dbo].[Clan] ([ClanId])
GO
ALTER TABLE [dbo].[UserClanRel] CHECK CONSTRAINT [FK_UserClanRel_Clan]
GO
ALTER TABLE [dbo].[UserClanRel]  WITH CHECK ADD  CONSTRAINT [FK_UserClanRel_User] FOREIGN KEY([username])
REFERENCES [dbo].[GameUser] ([username])
GO
ALTER TABLE [dbo].[UserClanRel] CHECK CONSTRAINT [FK_UserClanRel_User]
GO
ALTER TABLE [dbo].[UserRoleRel]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleRel_Job] FOREIGN KEY([JobId])
REFERENCES [dbo].[Job] ([JobId])
GO
ALTER TABLE [dbo].[UserRoleRel] CHECK CONSTRAINT [FK_UserRoleRel_Job]
GO
ALTER TABLE [dbo].[UserRoleRel]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleRel_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[RoleTbl] ([RoleId])
GO
ALTER TABLE [dbo].[UserRoleRel] CHECK CONSTRAINT [FK_UserRoleRel_Role]
GO
ALTER TABLE [dbo].[UserRoleRel]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleRel_User] FOREIGN KEY([username])
REFERENCES [dbo].[GameUser] ([username])
GO
ALTER TABLE [dbo].[UserRoleRel] CHECK CONSTRAINT [FK_UserRoleRel_User]
GO
/****** Object:  StoredProcedure [dbo].[activeBuilding]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[activeBuilding]
	@buildingId int,
	@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @activeCount int;
	SET @activeCount = (SELECT COUNT(*) FROM Building b, ClanBuildRel cbr WHERE cbr.ClanId = @clanId and cbr.BuildingId = b.BuildingId and b.active = 1);

	
		UPDATE b
		SET b.active = 1
		FROM Building b
		WHERE b.BuildingId = @buildingId;
	
END
GO
/****** Object:  StoredProcedure [dbo].[addBuilding]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[addBuilding]
@type varchar(50),
@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO [dbo].[Building]
           ([start]
           ,[type]
           ,[progress]
           ,[active])
     VALUES
           (GETDATE()
           ,@type
           ,0
           ,0)

DECLARE @lastId INT;
SET @lastId = (SELECT MAX(BuildingId) FROM Building);


INSERT INTO [dbo].[ClanBuildRel]
           ([BuildingId]
           ,[ClanId])
     VALUES(@lastId,@clanId)

END
GO
/****** Object:  StoredProcedure [dbo].[addClan]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[addClan]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


INSERT INTO [dbo].[Clan]
           ([Army]
           ,[expr]
           ,[gold]
           ,[lumber]
           ,[food]
           ,[Chant])
     VALUES
           (0
           ,0
           ,0
           ,0
           ,0
           ,'')

RETURN(
SELECT MAX(c.ClanId) FROM Clan c )

END
GO
/****** Object:  StoredProcedure [dbo].[addUser]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[addUser]
	-- Add the parameters for the stored procedure here
	@clanId int,
	@username varchar(50),
	@jobId int,
	@roleId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO [dbo].[UserClanRel]
           ([username]
           ,[ClanId]
           ,[Start])
     VALUES
           (@username
           ,@clanId
           ,GETDATE());

INSERT INTO [dbo].[UserRoleRel]
           ([username]
           ,[RoleId]
           ,[JobId]
           ,[userLevel])
     VALUES
           (@username
           ,@roleId
           ,@jobId
           ,1);

END
GO
/****** Object:  StoredProcedure [dbo].[addUserToGame]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[addUserToGame]
	@username varchar(50),
	@password varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO [dbo].[GameUser]
           ([username]
           ,[password])
     VALUES
           (@username
           ,@password)

	
END
GO
/****** Object:  StoredProcedure [dbo].[Attack]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Attack]
	-- Add the parameters for the stored procedure here
	@clanId1 int,
	@clanId2 int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @winnerRand FLOAT ;
	DECLARE @loserRand FLOAT ;
	SET @winnerRand = 0.1 + (RAND() * 0.1);
	SET @loserRand = 0.2 + (RAND() * 0.1);

	INSERT INTO fightRel
	VALUES (GETDATE(), @clanId1,
	FLOOR(@winnerRand * (SELECT c.Army FROM Clan c WHERE c.ClanId = @clanId1) ),
	FLOOR(@loserRand * (SELECT c.Army FROM Clan c WHERE c.ClanId = @clanId2) ),
	@clanId1,
	@clanId2);
    
	-- UPDATE GOLD AT WAR
	DECLARE @winnerGold int  ;
	DECLARE @loserGold int ;
	SET @winnerGold = (SELECT c.gold FROM Clan c WHERE c.ClanId = @clanId1) ;
	SET @loserGold = (SELECT c.gold FROM Clan c WHERE c.ClanId = @clanId2) ;
	-- UPDATE GOLD OF WINNER
	UPDATE c
	SET c.gold = @winnerGold + FLOOR(0.1 * @loserGold)
	FROM Clan c
	WHERE c.ClanId = @clanId1;
	-- UPDATE GOLD OF LOSER
	UPDATE c
	SET c.gold = FLOOR(0.9 * @loserGold)
	FROM Clan c
	WHERE c.ClanId = @clanId2;

	-- UPDATE FOOD AT WAR

	DECLARE @winnerFood int  ;
	DECLARE @loserFood int ;
	SET @winnerFood = (SELECT c.food FROM Clan c WHERE c.ClanId = @clanId1) ;
	SET @loserFood = (SELECT c.food FROM Clan c WHERE c.ClanId = @clanId2) ;
	-- UPDATE FOOD OF WINNER
	UPDATE c
	SET c.food = @winnerFood + FLOOR(0.1 * @loserFood)
	FROM Clan c
	WHERE c.ClanId = @clanId1;
	-- UPDATE FOOD OF LOSER
	UPDATE c
	SET c.food = FLOOR(0.9 * @loserFood)
	FROM Clan c
	WHERE c.ClanId = @clanId2;

	-- UPDATE ARMY AT WAR 

	-- UPDATE ARMY OF WINNER
	UPDATE c
	SET c.Army = FLOOR(( 1 - (0.1 + RAND() * 0.1) )  * c.Army ) 
	FROM Clan c
	WHERE c.ClanId = @clanId1;

	-- UPDATE ARMY OF LOSER
	UPDATE c
	SET c.Army = FLOOR(( 1 - (0.2 + RAND() * 0.1) )  * c.Army ) 
	FROM Clan c
	WHERE c.ClanId = @clanId2;

	 --- EXPERIENCE 


--- WINNER EXPERIENCE
	UPDATE c
	SET c.expr = c.expr + 7
	FROM Clan c
	WHERE c.ClanId = @clanId1;

	--- LOSER EXPERIENCE
	
	UPDATE c
	SET c.expr = c.expr + 5
	FROM Clan c
	WHERE c.ClanId = @clanId2;
END
GO
/****** Object:  StoredProcedure [dbo].[Authen]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Authen]

@username varchar(50),
@password varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	RETURN (SELECT COUNT(*) FROM GameUser u WHERE u.username = @username and u.password = @password)
  
END
GO
/****** Object:  StoredProcedure [dbo].[deActive]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[deActive]
	-- Add the parameters for the stored procedure here
	@buildingId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE b
	SET b.active = 0
	FROM Building b
	WHERE b.BuildingId = @buildingId;

END
GO
/****** Object:  StoredProcedure [dbo].[deleteUser]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[deleteUser] 
	@userName varChar(50),
	@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DELETE FROM [dbo].[UserClanRel]
      WHERE username = @userName and ClanId = @clanId;
    -- Insert statements for procedure here

DELETE FROM [dbo].[UserRoleRel]
      WHERE username = @userName;
    -- Insert statements for procedure here

END
GO
/****** Object:  StoredProcedure [dbo].[doAtCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[doAtCycle]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @clanId INT;

	DECLARE @clanIdCursor as CURSOR;
	SET @clanIdCursor = CURSOR FOR
	SELECT ClanId FROM Clan;

	OPEN @clanIdCursor;
	FETCH NEXT FROM @clanIdCursor INTO @clanId;
	WHILE @@FETCH_STATUS = 0		-- LOOP ON CLAN IDS
	BEGIN
		DECLARE @progress INT
		EXEC @progress = dbo.getProgressInCycle @clanId = @clanId
		
		DECLARE @amount INT
		SET @amount = -25 * @progress;

		EXEC dbo.updateGoldAtCycle @clanId = @clanId, @amount = @amount
		EXEC dbo.updateBuildingProgressAtCycle @clanId = @clanId , @progress = @progress
		EXEC dbo.updateLumberAtCycle @clanId = @clanId, @amount = @amount
		
		SET @amount = dbo.minorLevelSum(@clanId) * 10
		EXEC dbo.updateGoldAtCycle @clanId = @clanId, @amount = @amount

		DECLARE @gold INT
		EXEC @gold = dbo.getGold @clanId = @clanId
		SET @amount = dbo.getMin(FLOOR(@gold/10), dbo.sawyerLevelSum(@clanId)) * 10;
		EXEC dbo.updateLumberAtCycle @clanId = @clanId, @amount = @amount
		SET @amount = -1 * @amount
		EXEC dbo.updateGoldAtCycle @clanId = @clanId, @amount = @amount

		EXEC @gold = dbo.getGold @clanId = @clanId
		SET @amount = dbo.getMin(FLOOR(@gold/5), dbo.trainerLevelSum(@clanId)*10) ;
		EXEC dbo.updateArmyAtCycle @clanId = @clanId, @amount = @amount
		SET @amount = -5 * @amount
		EXEC dbo.updateGoldAtCycle @clanId = @clanId, @amount = @amount

		SET @amount = dbo.farmCount(@clanId)
		SET @amount = dbo.farmerLevelSum(@clanId) * @amount
		EXEC dbo.updateFoodAtCycle @clanId = @clanId , @amount = @amount

		DECLARE @foodNeededPercentage FLOAT
		SET @foodNeededPercentage = 0.1 + ( RAND() * 0.02 )

		DECLARE @prevArmy INT
		SET @prevArmy = FLOOR((SELECT Army FROM Clan WHERE ClanId = @clanId) * @foodNeededPercentage)

		

		DECLARE @leftOver INT;
		DECLARE @killed INT;
		SET @leftOver = (SELECT c.food FROM Clan c WHERE c.ClanId = @clanId)
		SET @leftOver = @leftOver - @prevArmy;
		IF (@leftOver < 0) BEGIN
			SET @killed = (1/@foodNeededPercentage)*(@leftOver);
			UPDATE Clan SET food = 0 FROM Clan WHERE ClanId = @clanId
		END
		ELSE BEGIN
			SET @killed = 0;
			UPDATE Clan SET food = @leftOver FROM Clan WHERE ClanId = @clanId
		END
		EXEC dbo.updateArmyAtCycle @clanId = @clanId, @amount = @killed

		
		FETCH NEXT FROM @clanIdCursor INTO @clanId;
	END
    EXEC dbo.levelUp
END
GO
/****** Object:  StoredProcedure [dbo].[getActiveBuildingId]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getActiveBuildingId]
@clanId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	RETURN(
		SELECT b.BuildingId FROM Building b, ClanBuildRel cbl WHERE b.BuildingId = cbl.BuildingId and cbl.ClanId = @clanId	
	)
    
END
GO
/****** Object:  StoredProcedure [dbo].[getArmy]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getArmy]
	-- Add the parameters for the stored procedure here
	@clanId INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	RETURN(
	SELECT c.Army FROM Clan c WHERE c.ClanId = @clanId
	)
END
GO
/****** Object:  StoredProcedure [dbo].[getAttacks]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getAttacks]
	-- Add the parameters for the stored procedure here
@clanId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT f.fightId, f.ClanId1, f.ClanId2, f.Date FROM fightRel f WHERE f.ClanId1 = @clanId OR f.ClanId2 = @clanId

END
GO
/****** Object:  StoredProcedure [dbo].[getChant]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getChant]
	-- Add the parameters for the stored procedure here
	@clanId INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT c.Chant FROM Clan c WHERE c.ClanId = @clanId
	
END
GO
/****** Object:  StoredProcedure [dbo].[getClanBuildings]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getClanBuildings]
@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.BuildingId,b.type, b.start,b.progress,b.active FROM ClanBuildRel cbl, Building b WHERE cbl.ClanId = @clanId and b.BuildingId = cbl.BuildingId 
END
GO
/****** Object:  StoredProcedure [dbo].[getClanIds]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getClanIds]
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT c.ClanId FROM Clan c 
	
END
GO
/****** Object:  StoredProcedure [dbo].[getClanLevel]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getClanLevel]

@clanId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @clanExpr INT;

	SET @clanExpr = (SELECT c.expr FROM clan c WHERE c.ClanId = @clanId);

	RETURN (
		FLOOR(@clanExpr / 100)
	); 
END
GO
/****** Object:  StoredProcedure [dbo].[getClanUsers]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getClanUsers]
@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

SELECT [username]  FROM [dbo].[UserClanRel] WHERE [ClanId] = @clanId




END
GO
/****** Object:  StoredProcedure [dbo].[getExpr]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getExpr]
@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	RETURN (
		SELECT c.expr FROM Clan c WHERE c.ClanId = @clanId
	)
END
GO
/****** Object:  StoredProcedure [dbo].[getFood]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getFood]
	-- Add the parameters for the stored procedure here
	@clanId INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	RETURN(
	SELECT c.food FROM Clan c WHERE c.ClanId = @clanId
	)
END
GO
/****** Object:  StoredProcedure [dbo].[getGold]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getGold]
	-- Add the parameters for the stored procedure here
	@clanId INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	RETURN(
	SELECT c.gold FROM Clan c WHERE c.ClanId = @clanId
	)
END
GO
/****** Object:  StoredProcedure [dbo].[getLumber]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getLumber]
	-- Add the parameters for the stored procedure here
	@clanId INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	RETURN(
	SELECT c.lumber FROM Clan c WHERE c.ClanId = @clanId
	)
END
GO
/****** Object:  StoredProcedure [dbo].[getProgressInCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getProgressInCycle]
	-- Add the parameters for the stored procedure here
	@clanId int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @activeCount INT ;
	DECLARE @sawyerCount INT ;
	DECLARE @clanGoldCount INT;
	DECLARE @clanLumberCount INT;

	SET @activeCount = (SELECT COUNT(*) FROM Building b, ClanBuildRel cbr WHERE cbr.ClanId = @clanId and cbr.BuildingId = b.BuildingId and b.active = 1);
	SET @sawyerCount = (SELECT COUNT(ucr.username) FROM UserRoleRel urr, UserClanRel ucr WHERE ucr.ClanId = @clanId and ucr.username = urr.username and urr.JobId = 2)
	SET @clanGoldCount = (SELECT c.gold FROM Clan c WHERE c.ClanId = @clanId);
	SET @clanLumberCount = (SELECT c.lumber FROM Clan c WHERE c.ClanId = @clanId);

	IF ( @activeCount > 0) BEGIN 
		IF ( @clanLumberCount >= @sawyerCount * 25 and @clanGoldCount >= @sawyerCount*25)
			RETURN @sawyerCount;
		ELSE BEGIN
			RETURN FLOOR(dbo.getMin(@clanLumberCount,@clanGoldCount) / 25);
		END
	END
	ELSE
		RETURN 0;
END
GO
/****** Object:  StoredProcedure [dbo].[getRoleId]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getRoleId]
@username varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	RETURN (
		SELECT urr.RoleId FROM UserRoleRel urr WHERE urr.username = @username
	);
END
GO
/****** Object:  StoredProcedure [dbo].[getUserClan]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getUserClan]
@username varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	RETURN(
	SELECT ucr.ClanId FROM UserClanRel ucr WHERE ucr.username = @username
	)
END
GO
/****** Object:  StoredProcedure [dbo].[getUserJob]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getUserJob]
@username varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	RETURN ( 
	SELECT urr.JobId FROM UserRoleRel urr WHERE urr.username = @username
	)
END
GO
/****** Object:  StoredProcedure [dbo].[isUserAlreadyExist]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[isUserAlreadyExist]
@username varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	RETURN (SELECT COUNT(*) FROM GameUser u WHERE u.username = @username)
END
GO
/****** Object:  StoredProcedure [dbo].[levelUp]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[levelUp]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE UserRoleRel
	SET userLevel = userLevel + 1;
	RETURN
END
GO
/****** Object:  StoredProcedure [dbo].[ScoreBoard]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ScoreBoard]
@clanId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	DECLARE @expr int;
	SET @expr = (SELECT c.expr FROM Clan c WHERE c.ClanId = @clanId);

	DECLARE @won int;
	SET @won = (SELECT COUNT(*) FROM fightRel fr WHERE fr.winnerId = @clanId);

	DECLARE @lose int;
	SET @lose = (SELECT COUNT(*) FROM fightRel fr WHERE fr.ClanId2 = @clanId);

	SELECT @expr, @won, @lose;
END
GO
/****** Object:  StoredProcedure [dbo].[setRole]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[setRole]
@username varchar(50),
@roleId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

UPDATE [dbo].[UserRoleRel]
   SET 
      [RoleId] = @roleId
      
 WHERE username = @username

END
GO
/****** Object:  StoredProcedure [dbo].[updateArmyAtCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateArmyAtCycle]
/*@clanId int,
@rand float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Army INT;
	DECLARE @leftOver INT;
	DECLARE @killed INT;

	SET @leftOver = (SELECT c.food FROM Clan c WHERE c.ClanId = @clanId) - FLOOR(@rand * @Army);
	SET @Army = (SELECT c.Army FROM Clan c WHERE c.ClanId = @clanId);

	IF (@leftOver < 0) BEGIN
		SET @killed = (1/@rand)*(-1 * @leftOver);
	END
	ELSE BEGIN
		SET @killed = 0;
	END

	UPDATE c
	SET c.Army = @Army
	+ dbo.trainerLevelSum(@clanId) * 10 
	- @killed
	FROM Clan c
	WHERE c.ClanId = @clanId;
    
	UPDATE c
	SET c.Army = 0
	FROM Clan c
	WHERE c.ClanId = @clanId and c.Army < 0;*/

@clanId int,
@amount int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE c
	SET c.Army = c.Army + @amount FROM Clan c WHERE c.ClanId = @clanId;
	
END
GO
/****** Object:  StoredProcedure [dbo].[updateBuildingProgressAtCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateBuildingProgressAtCycle]
@clanId int,
@progress int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		UPDATE b
		SET b.progress = b.progress + @progress
		FROM Building b
		WHERE b.active = 1;

		UPDATE b
		SET b.progress = 100
		FROM Building b
		WHERE b.active = 1 and b.progress > 100;
	

END
GO
/****** Object:  StoredProcedure [dbo].[updateChant]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateChant]
@NewChant varchar(50),
@clanId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

UPDATE [dbo].[Clan]
   SET 
      [Chant] = @NewChant
 WHERE ClanId = @clanId




END
GO
/****** Object:  StoredProcedure [dbo].[updateClanChant]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateClanChant]
@clanId int,
@chant varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE c
	SET c.Chant = @chant
	FROM Clan c
	WHERE c.ClanId = @clanId;
END
GO
/****** Object:  StoredProcedure [dbo].[updateFoodAtCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateFoodAtCycle]
@clanId int,
@amount int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE c
	SET c.food = 
	c.food
	+ @amount
	FROM Clan c
	WHERE c.ClanId = @clanId;

	RETURN 
END
GO
/****** Object:  StoredProcedure [dbo].[updateGoldAtCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateGoldAtCycle]
@clanId int,
@amount int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE c
	SET c.gold = c.gold + @amount FROM Clan c WHERE c.ClanId = @clanId;
	/*c.gold
	+ dbo.minorLevelSum(@clanId) * 10 
	- dbo.sawyerLevelSum(@clanId) * 10 
	- dbo.trainerLevelSum(@clanId)*50 
	- 25 * (@progress)
	FROM Clan c
	WHERE c.ClanId = @clanId;

	UPDATE c
	SET c.gold = 0
	FROM Clan c
	WHERE c.ClanId = @clanId and c.gold < 0; 
	*/
	RETURN 
END
GO
/****** Object:  StoredProcedure [dbo].[updateLumberAtCycle]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateLumberAtCycle]
@clanId int,
@amount int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE c
	SET c.lumber = c.lumber + @amount FROM Clan c WHERE c.ClanId = @clanId;	/*
	SET c.lumber = c.lumber + dbo.sawyerLevelSum(@clanId) * 10 - 25 * @progress
	FROM Clan c
	WHERE c.ClanId = @clanId;
	*/
	
END
GO
/****** Object:  StoredProcedure [dbo].[updateUserJob]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateUserJob]
@username varchar(50),
@newJobId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

UPDATE [dbo].[UserRoleRel]
   SET 
      [JobId] = @newJobId
      
 WHERE username = @username


END
GO
/****** Object:  StoredProcedure [dbo].[userHasClan]    Script Date: 18/12/23 16:26:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[userHasClan]
@username varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	RETURN(
		SELECT COUNT(ClanId)
		FROM [dbo].[UserClanRel] WHERE username = @username 
	)
END
GO
USE [master]
GO
ALTER DATABASE [DBLAB] SET  READ_WRITE 
GO
