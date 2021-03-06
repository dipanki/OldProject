USE [master]
GO
/****** Object:  Database [ntsb]    Script Date: 04-10-2016 2.24.23 AM ******/
CREATE DATABASE [ntsb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ntsb_data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ntsb_data.mdf' , SIZE = 5184KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ntsb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ntsb_log.ldf' , SIZE = 1280KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ntsb] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ntsb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ntsb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ntsb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ntsb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ntsb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ntsb] SET ARITHABORT OFF 
GO
ALTER DATABASE [ntsb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ntsb] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ntsb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ntsb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ntsb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ntsb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ntsb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ntsb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ntsb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ntsb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ntsb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ntsb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ntsb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ntsb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ntsb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ntsb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ntsb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ntsb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ntsb] SET RECOVERY FULL 
GO
ALTER DATABASE [ntsb] SET  MULTI_USER 
GO
ALTER DATABASE [ntsb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ntsb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ntsb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ntsb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ntsb', N'ON'
GO
USE [ntsb]
GO
/****** Object:  User [ntsb]    Script Date: 04-10-2016 2.24.26 AM ******/
CREATE USER [ntsb] FOR LOGIN [ntsb] WITH DEFAULT_SCHEMA=[ntsb]
GO
ALTER ROLE [db_owner] ADD MEMBER [ntsb]
GO
/****** Object:  Schema [ntsb]    Script Date: 04-10-2016 2.24.27 AM ******/
CREATE SCHEMA [ntsb]
GO
/****** Object:  StoredProcedure [dbo].[sp_Active_Deactive_Country_Status]    Script Date: 04-10-2016 2.24.27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Active_Deactive_Country_Status] 
  -- Add the parameters for the stored procedure here 
  @PK_Country_Id BIGINT, 
  @Status        BIT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      UPDATE country_master 
      SET    active_status = @Status 
      WHERE  pk_country_id = @PK_Country_Id 
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_Active_Deactive_State_Status]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
Create PROCEDURE [dbo].[sp_Active_Deactive_State_Status] 
  -- Add the parameters for the stored procedure here 
  @PK_State_Id   BIGINT, 
  @Status        bit 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      UPDATE State_Master 
      SET    active_status = @Status 
      WHERE  PK_State_Id = @PK_State_Id 
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_City_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_GetAll_City_Master_Details] 
@PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 

  
      SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'City_Name' AND @SortDirection='ASC')
					THEN ct.City_Name
						END ASC,
						CASE WHEN (@SortName = 'City_Name' AND @SortDirection='DESC')
					 THEN ct.City_Name
						END DESC,

						 CASE WHEN (@SortName = 'State_Name' AND @SortDirection='ASC')
                   THEN sm.State_Name
						END ASC,
						CASE WHEN (@SortName = 'State_Name' AND @SortDirection='DESC')
                   THEN sm.State_Name
						END DESC,

                        CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='ASC')
                   THEN cm.Country_Name
						END ASC,
						CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='DESC')
                   THEN cm.Country_Name
						END DESC,

						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
			       THEN sm.Active_Status
						END ASC,
					   CASE WHEN @SortName = 'Active_Status' AND @SortDirection='DESC'
                   THEN sm.Active_Status
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 ct.City_Name,
					 sm.State_Name,
                     cm.Country_Name, 
                     sm.Active_Status,
					 sm.FK_Country_Id,
					 cm.PK_Country_Id
              FROM  City_Master ct 
			  LEFT OUTER JOIN State_Master sm on sm.PK_State_Id = ct.FK_State_Id
			  LEFT OUTER JOIN Country_Master cm on cm.PK_Country_Id = ct.FK_Country_Id
              WHERE  ( @Search = '' 
                        OR cm.Country_Name LIKE '%' + @Search + '%'
						OR ct.City_Name LIKE '%' + @Search + '%' 
                        OR sm.Active_Status LIKE '%' + @Search + '%' 
						OR sm.State_Name LIKE '%' + @Search + '%') 
                     AND ( @Status = -1 
                            OR sm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Country_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_GetAll_Country_Master_Details] 
  -- Add the parameters for the stored procedure here 
  @PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      -- Insert statements for procedure here 
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 

      -- Insert statements for procedure here 
      SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
                        CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='ASC')
                   THEN Country_Name
						END ASC,
						CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='DESC')
                   THEN Country_Name
						END DESC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
			       THEN Active_Status
						END ASC,
					   CASE WHEN @SortName = 'Active_Status' AND @SortDirection='DESC'
                   THEN Active_Status
                       END DESC) AS NUMBER, 
                     Count(*) OVER () AS TotalCount, 
                     country_name, 
                     active_status,
					 PK_Country_Id 
              FROM   country_master 
              WHERE  ( @Search = '' 
                        OR country_name LIKE '%' + @Search + '%' 
                        OR active_status LIKE '%' + @Search + '%' ) 
                     AND ( @Status = -1 
                            OR active_status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
  END 


GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Feeds_Category_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Feeds_Category_Details 1,10,'Category_Name','','ASC',-1,1
CREATE PROCEDURE [dbo].[sp_GetAll_Feeds_Category_Details] 
	-- Add the parameters for the stored procedure here
  @PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	  if (@RoleType = 2 OR @RoleType = 3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN cm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN cm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN cm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN cm.Active_Status
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 cm.Description,
                     cm.Active_Status,
					 cm.PK_Category_Id,
					 cm.FK_Role_Id,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id
              FROM  Category_Master cm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id ===
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = cm.FK_User_Id
              WHERE  (cm.FK_Role_Id = um.FK_Role_Id) AND ( @Search = '' 
                        OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR cm.Description LIKE '%' + @Search + '%' 
					    OR cm.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR cm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
			 ELSE if (@RoleType =1)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN cm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN cm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN cm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN cm.Active_Status
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 cm.Description,
                     cm.Active_Status,
					 cm.PK_Category_Id,
					 cm.FK_Role_Id,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name
              FROM  Category_Master cm 
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = cm.FK_User_Id
			  --
              WHERE  (cm.FK_Role_Id = au.FK_Role_Id) AND ( @Search = '' 
                        OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR cm.Description LIKE '%' + @Search + '%' 
					    OR cm.Active_Status LIKE '%' + @Search + '%'
						OR au.First_Name LIKE '%' + @Search + '%'
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR cm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
	         ELSE
			  BEGIN
			      SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN cm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN cm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN cm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN cm.Active_Status
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC,

					    CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 cm.Description,
                     cm.Active_Status,
					 cm.PK_Category_Id,
					 cm.FK_Role_Id,
					um.First_Name,au.First_Name as User_First_Name,
					 um.Last_Name,au.Last_Name as User_Last_Name,
					 um.PK_User_Id,au.PK_Admin_User_Id as User_PK_Id			 
              FROM  Category_Master cm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id ===
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = cm.FK_User_Id
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = cm.FK_User_Id
              WHERE  (um.FK_Role_Id = 2 OR um.FK_Role_Id = 3 OR au.FK_Role_Id = 1) AND ( @Search = '' 
                        OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR cm.Description LIKE '%' + @Search + '%' 
					    OR cm.Active_Status LIKE '%' + @Search + '%' 
						OR au.First_Name LIKE '%' + @Search + '%'
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%'
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR cm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec			
			  END

  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Feeds_Master_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Feeds_Master_Comment_Details 1,10,'Category_Name','','ASC',1,1,5
CREATE  PROCEDURE [dbo].[sp_GetAll_Feeds_Master_Comment_Details]  
  @PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint ,
  @FeedId      AS bigint
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	  if (@RoleType = 2 OR @RoleType = 3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
					

						 CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
                   THEN fc.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
                   THEN fc.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN fc.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN fc.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fc.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fc.Active_Status
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 fc.Active_Status,
					 fc.Modified_DateTime,
					 fc.Video_Link,
					 fc.Image_Path,
					 fc.Comment,	
					 fm.PK_Feed_Id,
					 fc.PK_Feed_Comment_Id,
					 fm.Feed_Title,
					 fm.Image_Path as mainImage,
					 fm.Description,
					 cm.PK_Category_Id,
					 fc.FK_Role_Id,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id
              FROM  Feed_Comment_Details fc
			  LEFT OUTER JOIN Feed_Master fm on fm.PK_Feed_Id = fc.FK_Feed_Id 
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = fm.FK_User_Id
              WHERE (fc.FK_Feed_Id = @FeedId) AND ( @Search = '' 
                        OR  fc.Comment LIKE '%' + @Search + '%'
						OR  fc.Modified_DateTime LIKE '%' + @Search + '%'
					    OR fc.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR fc.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
			 ELSE IF (@RoleType = 1)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						  CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
                   THEN fc.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
                   THEN fc.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN fc.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN fc.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fc.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fc.Active_Status
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 fc.Active_Status,
					 fc.Modified_DateTime,
					 fc.Video_Link,
					 fc.Image_Path,
					 fc.Comment,	
					 fm.PK_Feed_Id,
					 fc.PK_Feed_Comment_Id,
					 fm.Feed_Title,
					 fm.Image_Path as mainImage,
					 fm.Description,
					 cm.PK_Category_Id,
					 fc.FK_Role_Id,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name
              FROM  Feed_Comment_Details fc
			  LEFT OUTER JOIN Feed_Master fm on fm.PK_Feed_Id = fc.FK_Feed_Id 
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = cm.FK_User_Id
             WHERE (fc.FK_Feed_Id = @FeedId) AND ( @Search = '' 
                        OR  fc.Comment LIKE '%' + @Search + '%'
						OR  fc.Modified_DateTime LIKE '%' + @Search + '%'
					    OR fc.Active_Status LIKE '%' + @Search + '%' 
						OR au.First_Name LIKE '%' + @Search + '%'
						OR au.Last_Name LIKE '%' + @Search + '%') 
					    AND (@Status = -1 
                            OR fc.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
	         ELSE
      BEGIN
	       SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
					

						 CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
                   THEN fc.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
                   THEN fc.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN fc.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN fc.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fc.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fc.Active_Status
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 fc.Active_Status,
					 fc.Modified_DateTime,
					 fc.Video_Link,
					 fc.Image_Path,
					 fc.Comment,	
					 fm.PK_Feed_Id,
					 fc.PK_Feed_Comment_Id,
					 fm.Feed_Title,
					 fm.Image_Path as mainImage,
					 fm.Description,
					 cm.PK_Category_Id,
					 fc.FK_Role_Id,
					 um.PK_User_Id as User_PK_Id,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name					 
              FROM  Feed_Comment_Details fc
			  LEFT OUTER JOIN Feed_Master fm on fm.PK_Feed_Id = fc.FK_Feed_Id 
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = fm.FK_User_Id
              WHERE (fc.FK_Feed_Id = @FeedId) AND ( @Search = '' 
                        OR  fc.Comment LIKE '%' + @Search + '%'
						OR  fc.Modified_DateTime LIKE '%' + @Search + '%'
					    OR fc.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR fc.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec    
			 
			 UNION ALL
			 
			  SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						  CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
                   THEN fc.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
                   THEN fc.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN fc.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN fc.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fc.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fc.Active_Status
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 cm.Category_Name,
					 fc.Active_Status,
					 fc.Modified_DateTime,
					 fc.Video_Link,
					 fc.Image_Path,
					 fc.Comment,	
					 fm.PK_Feed_Id,
					 fc.PK_Feed_Comment_Id,
					 fm.Feed_Title,
					 fm.Image_Path as mainImage,
					 fm.Description,
					 cm.PK_Category_Id,
					 fc.FK_Role_Id,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name
              FROM  Feed_Comment_Details fc
			  LEFT OUTER JOIN Feed_Master fm on fm.PK_Feed_Id = fc.FK_Feed_Id 
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = cm.FK_User_Id
             WHERE (fc.FK_Feed_Id = @FeedId) AND ( @Search = '' 
                        OR  fc.Comment LIKE '%' + @Search + '%'
						OR  fc.Modified_DateTime LIKE '%' + @Search + '%'
					    OR fc.Active_Status LIKE '%' + @Search + '%' 
						OR au.First_Name LIKE '%' + @Search + '%'
						OR au.Last_Name LIKE '%' + @Search + '%') 
					    AND (@Status = -1 
                            OR fc.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec  
	  END
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Feeds_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Feeds_Master_Details 1,11,'Feed_Title','','ASC',-1,-1
CREATE PROCEDURE [dbo].[sp_GetAll_Feeds_Master_Details]  
  @PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 

	  print @lPageNbr;
	  print @lPageSize;
	  print @lFirstRec;
	  print @lLastRec;

	  if (@RoleType = 2 OR @RoleType =3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Feed_Title' AND @SortDirection='ASC')
                   THEN fm.Feed_Title
						END ASC,
						CASE WHEN (@SortName = 'Feed_Title' AND @SortDirection='DESC')
                   THEN fm.Feed_Title
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN fm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN fm.Description
						END DESC,

						 CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN fm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN fm.Created_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fm.Active_Status
						END DESC,
					   
					    CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN fm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN fm.View_Count
						END DESC,

					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount,
					 cm.Category_Name,
					 fm.Active_Status,
					 fm.Video_Link,
					 fm.Image_Path,
					 fm.Feed_Title,
					 fm.Created_DateTime,				
				     fm.Modified_DateTime,
					 fm.Description,
					 cm.PK_Category_Id,
					 fm.PK_Feed_Id,
					 fm.FK_Role_Id,
					 fm.View_Count,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id
              FROM  Feed_Master fm
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = fm.FK_User_Id
			  LEFT OUTER JOIN Feed_Status_Details as mstatus on mstatus.FK_Feed_Id = fm.PK_Feed_Id
              WHERE (fm.FK_Role_Id = um.FK_Role_Id) AND ( @Search = '' 
                        OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR  fm.Feed_Title LIKE '%' + @Search + '%'
						OR  fm.Description LIKE '%' + @Search + '%'
						OR fm.Created_DateTime LIKE '%' + @Search + '%'  
					    OR fm.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR fm.View_Count LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR fm.Active_Status = @Status )
							GROUP BY 
							cm.Category_Name,
					 fm.Active_Status,
					 fm.Video_Link,
					 fm.Image_Path,
					 fm.Feed_Title,
					 fm.View_Count,
					 fm.Description,
					 fm.Created_DateTime,				
				     fm.Modified_DateTime,
					 cm.PK_Category_Id,
					 fm.PK_Feed_Id,
					 fm.FK_Role_Id,
					 um.First_Name,
					 um.Last_Name,
					 um.PK_User_Id) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
			 ELSE IF(@RoleType = 1)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Feed_Title' AND @SortDirection='ASC')
                   THEN fm.Feed_Title
						END ASC,
						CASE WHEN (@SortName = 'Feed_Title' AND @SortDirection='DESC')
                   THEN fm.Feed_Title
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN fm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN fm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fm.Active_Status
						END DESC,

						 CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN fm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN fm.Created_DateTime
						END DESC,

						 CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN fm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN fm.View_Count
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					  Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount,
					 cm.Category_Name,
					 fm.Active_Status,
					 fm.Video_Link,
					 fm.Image_Path,
					 fm.Feed_Title,
					 fm.Created_DateTime,				
				     fm.Modified_DateTime,
					 fm.PK_Feed_Id,
					 fm.Description,
					 fm.FK_Role_Id,
					 fm.View_Count,
					 cm.PK_Category_Id,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name
             FROM  Feed_Master fm
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = cm.FK_User_Id
			  LEFT OUTER JOIN Feed_Status_Details as mstatus on mstatus.FK_Feed_Id = fm.PK_Feed_Id
              WHERE (fm.FK_Role_Id = au.FK_Role_Id) AND  ( @Search = '' 
                        OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR  fm.Feed_Title LIKE '%' + @Search + '%'
						OR  fm.Description LIKE '%' + @Search + '%'
					    OR fm.Active_Status LIKE '%' + @Search + '%'
						OR fm.Created_DateTime LIKE '%' + @Search + '%'  
						OR au.First_Name LIKE '%' + @Search + '%'
						OR fm.View_Count LIKE '%' + @Search + '%' 
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR fm.Active_Status = @Status )
								GROUP BY 
							cm.Category_Name,
					 fm.Active_Status,
					 fm.Video_Link,
					 fm.Image_Path,
					 fm.Feed_Title,
					 fm.Description,
					 cm.PK_Category_Id,
					 fm.PK_Feed_Id,
					 fm.Created_DateTime,				
				     fm.Modified_DateTime,
					 fm.View_Count,
					 fm.FK_Role_Id,
					 au.First_Name,
					 au.Last_Name,
					 au.PK_Admin_User_Id) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
	         ELSE
      BEGIN 
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Feed_Title' AND @SortDirection='ASC')
                   THEN fm.Feed_Title
						END ASC,
						CASE WHEN (@SortName = 'Feed_Title' AND @SortDirection='DESC')
                   THEN fm.Feed_Title
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN fm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN fm.Description
						END DESC,

						 CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN fm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN fm.Created_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN fm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN fm.Active_Status
						END DESC,
					   
					    CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN fm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN fm.View_Count
						END DESC,

					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC,
					   
					    CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount,
					 cm.Category_Name,
					 fm.Active_Status,
					 fm.Video_Link,
					 fm.Image_Path,
					 fm.Feed_Title,
					 fm.Created_DateTime,				
				     fm.Modified_DateTime,
					 fm.Description,
					 cm.PK_Category_Id,
					 fm.PK_Feed_Id,
					 fm.FK_Role_Id,
					 fm.View_Count,
					 um.First_Name,au.First_Name as User_First_Name,
					 um.Last_Name,au.Last_Name as User_Last_Name,
					 um.PK_User_Id,au.PK_Admin_User_Id as User_PK_Id
              FROM  Feed_Master fm
			  LEFT OUTER JOIN Category_Master cm on fm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = fm.FK_User_Id		  
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = fm.FK_User_Id
			  LEFT OUTER JOIN Feed_Status_Details as mstatus on mstatus.FK_Feed_Id = fm.PK_Feed_Id
              WHERE (um.FK_Role_Id = 2 OR um.FK_Role_Id = 3 OR au.FK_Role_Id = 1) AND ( @Search = '' 
                        OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR  fm.Feed_Title LIKE '%' + @Search + '%'
						OR  fm.Description LIKE '%' + @Search + '%'
						OR fm.Created_DateTime LIKE '%' + @Search + '%'  
					    OR fm.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR au.First_Name LIKE '%' + @Search + '%'
						OR fm.View_Count LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%'
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR fm.Active_Status = @Status )
							GROUP BY 
							cm.Category_Name,
					 fm.Active_Status,
					 fm.Video_Link,
					 fm.Image_Path,
					 fm.Feed_Title,
					 fm.View_Count,
					 fm.Description,
					 fm.Created_DateTime,				
				     fm.Modified_DateTime,
					 cm.PK_Category_Id,
					 fm.PK_Feed_Id,
					 fm.FK_Role_Id,
					 um.First_Name,
					 um.Last_Name,
					 um.PK_User_Id,
					 au.First_Name,
					 au.Last_Name,
					 au.PK_Admin_User_Id) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Global_Topics_Comments_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Global_Topics_Comments_Details 1,10,'Trending_Title','','ASC',-1,1,1
CREATE PROCEDURE [dbo].[sp_GetAll_Global_Topics_Comments_Details]  
	-- Add the parameters for the stored procedure here
@PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint,
  @FK_Global_Topics_Id AS bigint 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	  if (@RoleType = 2 OR @RoleType = 3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
					THEN tm.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
					 THEN tm.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN tm.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN tm.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 tm.Comment,
					 tm.Modified_DateTime,
                     tm.Active_Status,
					 tm.FK_Global_Topics_Id,
					 tm.PK_Global_Comment_Details_ID,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.Created_DateTime,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id,
					 t.Global_Topics_Title,
					 t.Image_Path as mainImage
              FROM  Global_Topic_Comment_Details tm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id ==(tm.FK_Role_Id = um.FK_Role_Id) AND
			  LEFT OUTER JOIN Global_Topics_Master t on t.PK_Global_Topics_Id = tm.FK_Global_Topics_Id
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = tm.FK_User_Id
              WHERE  (tm.FK_Global_Topics_Id = @FK_Global_Topics_Id) AND ( @Search = '' 
                        OR  tm.Comment LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%' 
						OR tm.Modified_DateTime LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
			 ELSE
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
					THEN tm.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
					 THEN tm.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN tm.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN tm.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 tm.Comment,
					 tm.Modified_DateTime,
                     tm.Active_Status,
					 tm.FK_Global_Topics_Id,
					 tm.PK_Global_Comment_Details_ID,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.Created_DateTime,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name,
					 t.Global_Topics_Title,
					 t.Image_Path as mainImage
              FROM  Global_Topic_Comment_Details tm 
			  LEFT OUTER JOIN Global_Topics_Master t on t.PK_Global_Topics_Id = tm.FK_Global_Topics_Id
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id
			  --(tm.FK_Role_Id = au.FK_Role_Id) AND
              WHERE  (tm.FK_Global_Topics_Id = @FK_Global_Topics_Id) AND ( @Search = '' 
                        OR  tm.Comment LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%'
						OR au.First_Name LIKE '%' + @Search + '%'
						OR tm.Modified_DateTime LIKE '%' + @Search + '%' 
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Global_Topics_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Global_Topics_Details 1,10,'Trending_Title','','ASC',-1,1
CREATE PROCEDURE [dbo].[sp_GetAll_Global_Topics_Details] 
	-- Add the parameters for the stored procedure here
  @PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	  if (@RoleType = 2 OR @RoleType = 3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Title' AND @SortDirection='ASC')
					THEN tm.Global_Topics_Title
						END ASC,
						CASE WHEN (@SortName = 'Title' AND @SortDirection='DESC')
					 THEN tm.Global_Topics_Title
						END DESC,

						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN tm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN tm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,
					   
					      CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN tm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN tm.Created_DateTime
						END DESC,

						 CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN tm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN tm.View_Count
						END DESC,

					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount,
					 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Global_Topics_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Global_Topics_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Created_DateTime,				
				     tm.Modified_DateTime,
					 tm.View_Count,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id
              FROM  Global_Topics_Master tm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id ==
			  LEFT OUTER JOIN Category_Master cm on tm.FK_Category_Id = cm.PK_Category_Id
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = tm.FK_User_Id
			  LEFT OUTER JOIN Global_Topics_Status_Details as mstatus on mstatus.FK_Global_Topics_Id = tm.PK_Global_Topics_Id
              WHERE (tm.FK_Role_Id = um.FK_Role_Id) AND ( @Search = '' 
                        OR  tm.Global_Topics_Title LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						 OR  cm.Category_Name LIKE '%' + @Search + '%'
						 OR tm.Created_DateTime LIKE '%' + @Search + '%' 
						 OR tm.View_Count LIKE '%' + @Search + '%'
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )
							GROUP BY 
							cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Global_Topics_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.View_Count,
					 tm.Created_DateTime,				
					 tm.Modified_DateTime,
					 tm.PK_Global_Topics_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,um.PK_User_Id,
					 um.First_Name,
					 um.Last_Name) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
			 ELSE
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Title' AND @SortDirection='ASC')
					THEN tm.Global_Topics_Title
						END ASC,
						CASE WHEN (@SortName = 'Title' AND @SortDirection='DESC')
					 THEN tm.Global_Topics_Title
						END DESC,

						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN tm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN tm.Description
						END DESC,

						 CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN tm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN tm.Created_DateTime
						END DESC,


                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,

						 CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN tm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN tm.View_Count
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
				     Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount,
					 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Global_Topics_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Global_Topics_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Created_DateTime,				
				     tm.Modified_DateTime,
					 tm.View_Count,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name
              FROM  Global_Topics_Master tm 
			  LEFT OUTER JOIN Category_Master cm on tm.FK_Category_Id = cm.PK_Category_Id
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id
			  LEFT OUTER JOIN Global_Topics_Status_Details as mstatus on mstatus.FK_Global_Topics_Id = tm.PK_Global_Topics_Id
              WHERE (tm.FK_Role_Id = au.FK_Role_Id) AND  ( @Search = '' 
                        OR  tm.Global_Topics_Title LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%'
						 OR  cm.Category_Name LIKE '%' + @Search + '%'
						OR au.First_Name LIKE '%' + @Search + '%'
						 OR tm.View_Count LIKE '%' + @Search + '%'
						OR tm.Created_DateTime LIKE '%' + @Search + '%' 
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )
							GROUP BY 
							cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Global_Topics_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Global_Topics_Id,
					 tm.Created_DateTime,				
				     tm.Modified_DateTime,
					 tm.FK_Role_Id,
					 tm.View_Count,
					 tm.Image_Path,au.PK_Admin_User_Id,
					 au.First_Name,
					 au.Last_Name) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_State_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
--exec sp_GetAll_State_Master_Details 1,10, 'Frst_Name','','ASC',1,-1,-1
CREATE PROCEDURE [dbo].[sp_GetAll_State_Master_Details] 
  -- Add the parameters for the stored procedure here 
  @PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      -- Insert statements for procedure here 
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 

      -- Insert statements for procedure here 
      SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'State_Name' AND @SortDirection='ASC')
                   THEN sm.State_Name
						END ASC,
						CASE WHEN (@SortName = 'State_Name' AND @SortDirection='DESC')
                   THEN sm.State_Name
						END DESC,
                        CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='ASC')
                   THEN cm.Country_Name
						END ASC,
						CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='DESC')
                   THEN cm.Country_Name
						END DESC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
			       THEN sm.Active_Status
						END ASC,
					   CASE WHEN @SortName = 'Active_Status' AND @SortDirection='DESC'
                   THEN sm.Active_Status
                       END DESC) AS NUMBER, 
                     Count(*) OVER () AS TotalCount, 
					 sm.State_Name,
                     cm.Country_Name, 
                     sm.Active_Status,
					 sm.FK_Country_Id,
					 cm.PK_Country_Id
              FROM  State_Master sm 
			  LEFT OUTER JOIN Country_Master cm on cm.PK_Country_Id = sm.FK_Country_Id
              WHERE  ( @Search = '' 
                        OR cm.Country_Name LIKE '%' + @Search + '%' 
                        OR sm.Active_Status LIKE '%' + @Search + '%' 
						OR sm.State_Name LIKE '%' + @Search + '%') 
                     AND ( @Status = -1 
                            OR sm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
  END 


GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Trending_Comments_Story_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Trending_Comments_Story_Details 1,10,'Trending_Title','','ASC',-1,1
CREATE PROCEDURE [dbo].[sp_GetAll_Trending_Comments_Story_Details]  
	-- Add the parameters for the stored procedure here
@PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint,
  @FK_Trending_Id AS bigint 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	  if (@RoleType = 2 OR @RoleType = 3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
					THEN tm.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
					 THEN tm.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN tm.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN tm.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 tm.Comment,
					 tm.Modified_DateTime,
                     tm.Active_Status,
					 tm.FK_Trending_Id,
					 tm.PK_Trending_Comment_Details,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.Created_DateTime,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id,
					 t.Trending_Title,
					 t.Image_Path as mainImage
              FROM  Trending_Comment_Details tm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id ==(tm.FK_Role_Id = um.FK_Role_Id) AND
			  LEFT OUTER JOIN Trending_Master t on t.PK_Trending_Id = tm.FK_Trending_Id
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = tm.FK_User_Id
              WHERE  (tm.FK_Trending_Id = @FK_Trending_Id) AND ( @Search = '' 
                        OR  tm.Comment LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%' 
						OR tm.Modified_DateTime LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
			 ELSE
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						 CASE WHEN (@SortName = 'Comment' AND @SortDirection='ASC')
					THEN tm.Comment
						END ASC,
						CASE WHEN (@SortName = 'Comment' AND @SortDirection='DESC')
					 THEN tm.Comment
						END DESC,

						 CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='ASC')
                   THEN tm.Modified_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Modified_DateTime' AND @SortDirection='DESC')
                   THEN tm.Modified_DateTime
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,

						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					 tm.Comment,
					 tm.Modified_DateTime,
                     tm.Active_Status,
					 tm.FK_Trending_Id,
					 tm.PK_Trending_Comment_Details,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.Created_DateTime,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name,
					 t.Trending_Title,
					 t.Image_Path as mainImage
              FROM  Trending_Comment_Details tm 
			  LEFT OUTER JOIN Trending_Master t on t.PK_Trending_Id = tm.FK_Trending_Id
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id
			  --(tm.FK_Role_Id = au.FK_Role_Id) AND 
              WHERE (tm.FK_Trending_Id = @FK_Trending_Id) AND ( @Search = '' 
                        OR  tm.Comment LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%'
						OR au.First_Name LIKE '%' + @Search + '%'
						OR tm.Modified_DateTime LIKE '%' + @Search + '%' 
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Trending_Story_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Trending_Story_Details 1,10,'Trending_Title','','ASC',-1,-1
CREATE PROCEDURE [dbo].[sp_GetAll_Trending_Story_Details] 
	-- Add the parameters for the stored procedure here
@PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @RoleType      AS bigint 
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	       IF (@RoleType = 2 OR @RoleType = 3)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						  CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,
						 CASE WHEN (@SortName = 'Trending_Title' AND @SortDirection='ASC')
					THEN tm.Trending_Title
						END ASC,
						CASE WHEN (@SortName = 'Trending_Title' AND @SortDirection='DESC')
					 THEN tm.Trending_Title
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN tm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN tm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,
						
                        CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN tm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN tm.Created_DateTime
						END DESC,

						 CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN tm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN tm.View_Count
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount,
					  Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount, 
					 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Trending_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Trending_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.View_Count,
					 tm.Created_DateTime,
					 tm.Modified_DateTime,
					 um.First_Name as User_First_Name,
					 um.Last_Name as User_Last_Name,
					 um.PK_User_Id as User_PK_Id
              FROM  Trending_Master tm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id == 
			  LEFT OUTER JOIN Category_Master cm on tm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = tm.FK_User_Id
			  LEFT OUTER JOIN Trending_Status_Details as mstatus on mstatus.FK_Trending_Id = tm.PK_Trending_Id
              WHERE (tm.FK_Role_Id = um.FK_Role_Id) AND ( @Search = '' 
                        OR  tm.Trending_Title LIKE '%' + @Search + '%'
						OR  tm.Description LIKE '%' + @Search + '%'
						 OR  cm.Category_Name LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR tm.View_Count LIKE '%' + @Search + '%' 
						OR tm.Created_DateTime LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )
							GROUP BY 
							 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Trending_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Trending_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.View_Count,
					 tm.Created_DateTime,				
					 tm.Modified_DateTime,
					 tm.Video_Link,
					 um.First_Name ,
					 um.Last_Name,
					 um.PK_User_Id) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
	       ELSE IF (@RoleType = 1)
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						  CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,
						 CASE WHEN (@SortName = 'Trending_Title' AND @SortDirection='ASC')
					THEN tm.Trending_Title
						END ASC,
						CASE WHEN (@SortName = 'Trending_Title' AND @SortDirection='DESC')
					 THEN tm.Trending_Title
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN tm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN tm.Description
						END DESC,

						 CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN tm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN tm.View_Count
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,

						  CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN tm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN tm.Created_DateTime
						END DESC,

						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN tm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN tm.View_Count
						END DESC,


						CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount, 
					  Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount,
					 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Trending_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Trending_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.View_Count,
					 tm.Created_DateTime,				
					 tm.Modified_DateTime,
					 au.PK_Admin_User_Id as User_PK_Id,
					 au.First_Name as User_First_Name,
					 au.Last_Name as User_Last_Name
              FROM  Trending_Master tm 
			   LEFT OUTER JOIN Category_Master cm on tm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id
			  LEFT OUTER JOIN Trending_Status_Details as mstatus on mstatus.FK_Trending_Id = tm.PK_Trending_Id
              WHERE (tm.FK_Role_Id = au.FK_Role_Id) AND ( @Search = '' 
                        OR  tm.Trending_Title LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%'
						OR  tm.Description LIKE '%' + @Search + '%'
						OR  cm.Category_Name LIKE '%' + @Search + '%'
					    OR  tm.View_Count LIKE '%' + @Search + '%'
						OR au.First_Name LIKE '%' + @Search + '%'
						OR tm.Created_DateTime LIKE '%' + @Search + '%' 
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )
							GROUP BY 
							 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Trending_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Trending_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.View_Count,
					 tm.Video_Link,
					 tm.Created_DateTime,				
					 tm.Modified_DateTime,
					 au.PK_Admin_User_Id,
					 au.First_Name,
					 au.Last_Name) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
	       ELSE 
      BEGIN
	      SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						  CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='ASC')
					THEN cm.Category_Name
						END ASC,
						CASE WHEN (@SortName = 'Category_Name' AND @SortDirection='DESC')
					 THEN cm.Category_Name
						END DESC,
						 CASE WHEN (@SortName = 'Trending_Title' AND @SortDirection='ASC')
					THEN tm.Trending_Title
						END ASC,
						CASE WHEN (@SortName = 'Trending_Title' AND @SortDirection='DESC')
					 THEN tm.Trending_Title
						END DESC,

						 CASE WHEN (@SortName = 'Description' AND @SortDirection='ASC')
                   THEN tm.Description
						END ASC,
						CASE WHEN (@SortName = 'Description' AND @SortDirection='DESC')
                   THEN tm.Description
						END DESC,

                        CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN tm.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN tm.Active_Status
						END DESC,
						
                        CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN tm.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN tm.Created_DateTime
						END DESC,

						 CASE WHEN (@SortName = 'View_Count' AND @SortDirection='ASC')
                   THEN tm.View_Count
						END ASC,
						CASE WHEN (@SortName = 'View_Count' AND @SortDirection='DESC')
                   THEN tm.View_Count
						END DESC,
					   
					   CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN um.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN um.First_Name
                       END DESC,
					   	    CASE WHEN (@SortName = 'User_Name' AND @SortDirection='ASC')
			       THEN au.First_Name
						END ASC,
					   CASE WHEN @SortName = 'User_Name' AND @SortDirection='DESC'
                   THEN au.First_Name
                       END DESC) AS NUMBER,

					    
                     Count(*) OVER () AS TotalCount,
					  Count(case mstatus.Like_Status when 1 then 1 else null end) as likecount,
					 Count(case mstatus.Like_Status when 0 then 1 else null end) as unlikecount, 
					 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Trending_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Trending_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.View_Count,
					 tm.Created_DateTime,
					 tm.Modified_DateTime,
					 um.First_Name,au.First_Name as User_First_Name,
					 um.Last_Name,au.Last_Name as User_Last_Name,
					 um.PK_User_Id,au.PK_Admin_User_Id as User_PK_Id	 
              FROM  Trending_Master tm 
			 -- LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id == 
			  LEFT OUTER JOIN Category_Master cm on tm.FK_Category_Id = cm.PK_Category_Id 
			  LEFT OUTER JOIN User_Master um on um.PK_User_Id = tm.FK_User_Id
			   LEFT OUTER JOIN Admin_User au on au.PK_Admin_User_Id = tm.FK_User_Id
			  LEFT OUTER JOIN Trending_Status_Details as mstatus on mstatus.FK_Trending_Id = tm.PK_Trending_Id
              WHERE (um.FK_Role_Id = 2 OR um.FK_Role_Id = 3 OR au.FK_Role_Id = 1) AND ( @Search = '' 
                        OR  tm.Trending_Title LIKE '%' + @Search + '%'
						OR  tm.Description LIKE '%' + @Search + '%'
						 OR  cm.Category_Name LIKE '%' + @Search + '%'
					    OR tm.Active_Status LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR au.First_Name LIKE '%' + @Search + '%'
						OR tm.View_Count LIKE '%' + @Search + '%' 
						OR tm.Created_DateTime LIKE '%' + @Search + '%' 
						OR um.Last_Name LIKE '%' + @Search + '%'
						OR au.Last_Name LIKE '%' + @Search + '%') 
                     AND (@Status = -1 
                            OR tm.Active_Status = @Status )
							GROUP BY 
							 cm.Category_Name,
					 cm.PK_Category_Id,
					 tm.Trending_Title,
					 tm.Description,
                     tm.Active_Status,
					 tm.PK_Trending_Id,
					 tm.FK_Role_Id,
					 tm.Image_Path,
					 tm.Video_Link,
					 tm.View_Count,
					 tm.Created_DateTime,
					 tm.Modified_DateTime,
					 um.PK_User_Id,
					 um.First_Name ,
					 um.Last_Name,
					  au.First_Name,
					 au.Last_Name,
					 au.PK_Admin_User_Id) AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 		

	  END
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAll_Users_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_GetAll_Users_Details 1,10,'','kau','ASC',-1,'a2F1'
CREATE PROCEDURE [dbo].[sp_GetAll_Users_Details] 
	-- Add the parameters for the stored procedure here
	@PageNumber    AS INT = 1, 
  @RowspPage     AS INT = 10, 
  @SortName      AS NVARCHAR(max), 
  @Search        AS NVARCHAR(max) = '', 
  @SortDirection NVARCHAR(4) = 'asc', 
  @Status        AS INT,
  @SearchEncrypt AS NVARCHAR(max) = ''
AS 
  BEGIN 
 
      DECLARE @lFirstRec INT, 
              @lLastRec  INT, 
              @lPageNbr  INT, 
              @lPageSize INT 

      
      SET @lPageNbr = @PageNumber 
      SET @lPageSize = @RowspPage 
      SET @lFirstRec = ( @lPageNbr - 1 ) * @lPageSize 
      SET @lLastRec = ( @lPageNbr * @lPageSize + 1 ) 
      SET nocount ON; 
	  BEGIN
            SELECT * 
      FROM   (SELECT Row_number() 
                       OVER( 
                         ORDER BY 
						  CASE WHEN (@SortName = 'First_Name' AND @SortDirection='ASC')
					THEN um.First_Name
						END ASC,
						CASE WHEN (@SortName = 'First_Name' AND @SortDirection='DESC')
					 THEN um.First_Name
						END DESC,
						 CASE WHEN (@SortName = 'Email' AND @SortDirection='ASC')
					THEN um.Email
						END ASC,
						CASE WHEN (@SortName = 'Email' AND @SortDirection='DESC')
					 THEN um.Email
						END DESC,

						 CASE WHEN (@SortName = 'Gender' AND @SortDirection='ASC')
                   THEN um.Gender
						END ASC,
						CASE WHEN (@SortName = 'Gender' AND @SortDirection='DESC')
                   THEN um.Gender
						END DESC,

                        CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='ASC')
                   THEN cm.Country_Name
						END ASC,
						CASE WHEN (@SortName = 'Country_Name' AND @SortDirection='DESC')
                   THEN cm.Country_Name
						END DESC,
						
                        CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='ASC')
                   THEN um.Created_DateTime
						END ASC,
						CASE WHEN (@SortName = 'Created_Date' AND @SortDirection='DESC')
                   THEN um.Created_DateTime
						END DESC,

						   CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='ASC')
                   THEN um.Active_Status
						END ASC,
						CASE WHEN (@SortName = 'Active_Status' AND @SortDirection='DESC')
                   THEN um.Active_Status
						END DESC) AS NUMBER,
					    
                     Count(*) OVER () AS TotalCount,um.First_Name,					
					 um.Email,um.Gender,um.Created_DateTime,cm.Country_Name,um.Active_Status,um.Profile_Image,
					 sm.State_Name,um.PK_User_Id,cm.PK_Country_Id,sm.PK_State_Id,um.FK_Role_Id
              FROM  User_Master um 
			  LEFT OUTER JOIN State_Master sm on sm.PK_State_Id = um.FK_State_Id
			  LEFT OUTER JOIN Country_Master cm on cm.PK_Country_Id = um.FK_Country_Id
			  LEFT OUTER JOIN Role_Master rm on rm.PK_Role_Id = um.FK_Role_Id
              WHERE ((@SearchEncrypt = '' OR um.Email LIKE '%'+ @SearchEncrypt +'%') OR ( @Search = '' 
                        OR  um.First_Name LIKE '%' + @Search + '%'
						OR  um.Email LIKE '%' + @Search + '%'
						 OR  um.Gender LIKE '%' + @Search + '%'
					    OR cm.Country_Name LIKE '%' + @Search + '%' 
						OR um.First_Name LIKE '%' + @Search + '%' 
						OR um.Created_DateTime LIKE '%' + @Search + '%' 
						OR um.Active_Status LIKE '%' + @Search + '%' )) 						
                        AND (@Status = -1 OR um.Active_Status = @Status )
					    AND (rm.PK_Role_Id = 2))AS TBL 
      WHERE  number > @lFirstRec 
             AND number < @lLastRec 
	  END
		
  END 

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_City_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Insert_City_Master] 
@FK_Country_Id bigint,
@FK_State_Id bigint,
@City_Name nvarchar(50),
@Active_Status BIT
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 
      -- Insert statements for procedure here 
      SET nocount ON; 

      -- Insert statements for procedure here 
      INSERT INTO dbo.City_Master
                  (City_Name,FK_State_Id,FK_Country_Id, 
                   Active_Status) 
      VALUES      ( @City_Name , @FK_State_Id,@FK_Country_Id, 
                    @Active_Status ) 

      SELECT Scope_identity() AS PK_City_Id 
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Country_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Insert_Country_Master] 
  -- Add the parameters for the stored procedure here 
  @Country_Name VARCHAR(50), 
  @Status       BIT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 
      -- Insert statements for procedure here 
      SET nocount ON; 

      -- Insert statements for procedure here 
      INSERT INTO dbo.country_master 
                  (country_name, 
                   active_status) 
      VALUES      ( @Country_Name, 
                    @Status ) 

      SELECT Scope_identity() AS PK_Country_Id 
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_State_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Insert_State_Master] 
  -- Add the parameters for the stored procedure here 
  @State_Name VARCHAR(50),
  @FK_Country_Id bigint, 
  @Status       BIT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 
      -- Insert statements for procedure here 
      SET nocount ON; 

      -- Insert statements for procedure here 
      INSERT INTO dbo.State_Master 
                  (State_Name,FK_Country_Id, 
                   Active_Status) 
      VALUES      ( @State_Name,@FK_Country_Id, 
                    @Status ) 

      SELECT Scope_identity() AS PK_State_Id 
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_Select_City_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Select_City_Master] 
	
	
AS
BEGIN
 SELECT  * from		[dbo].City_Master
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Select_Country_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Select_Country_Master] 
-- Add the parameters for the stored procedure here 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      SELECT * 
      FROM   [dbo].[country_master] 
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_Select_Country_Master_By_Id]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Select_Country_Master_By_Id] 
	-- Add the parameters for the stored procedure here
	 @PK_Country_Id BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Country_Master WHERE PK_Country_Id = @PK_Country_Id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Select_State_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Select_State_Master] 
-- Add the parameters for the stored procedure here 
@FK_Country_Id bigint
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      SELECT * 
      FROM   [dbo].[State_Master] where FK_Country_Id=@FK_Country_Id
  END 
GO
/****** Object:  StoredProcedure [dbo].[sp_Update_City_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Update_City_Master] 
  -- Add the parameters for the stored procedure here 
  @PK_City_Id BIGINT, 
  @FK_State_Id BIGINT,
  @FK_Country_Id bigint,
  @City_Name  VARCHAR(50), 
  @Status        BIT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      UPDATE City_Master 
      SET    City_Name = @City_Name, 
             active_status = @Status,
			 FK_Country_Id=@FK_Country_Id,
			 FK_State_Id=@FK_State_Id
      WHERE  PK_City_Id = @PK_City_Id 
  END 


GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Country_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Update_Country_Master] 
  -- Add the parameters for the stored procedure here 
  @PK_Country_Id BIGINT, 
  @Country_Name  VARCHAR(50), 
  @Status        BIT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      UPDATE country_master 
      SET    country_name = @Country_Name, 
             active_status = @Status 
      WHERE  pk_country_id = @PK_Country_Id 
  END 


GO
/****** Object:  StoredProcedure [dbo].[sp_Update_State_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_Update_State_Master] 
  -- Add the parameters for the stored procedure here 
  
  @PK_State_Id BIGINT,
  @FK_Country_Id bigint,
  @State_Name  VARCHAR(50), 
  @Status        BIT 
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      SET nocount ON; 

      -- Insert statements for procedure here 
      UPDATE State_Master 
      SET    State_Name = @State_Name, 
             active_status = @Status,
			 FK_Country_Id=@FK_Country_Id
		WHERE	 PK_State_Id=@PK_State_Id
       
  END 


GO
/****** Object:  StoredProcedure [dbo].[sp_View_Category_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_View_Category_Master_Details 6
CREATE PROCEDURE [dbo].[sp_View_Category_Master_Details]
	-- Add the parameters for the stored procedure here
	@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select  data.PK_Category_Id,data.FK_Role_Id,user1.First_Name,user1.Last_Name,data.Active_Status,data.Description,data.Category_Name,
	data.Created_DateTime,data.Modified_DateTime,data.FK_User_Id
	                       from Category_Master as data
                           join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           where data.PK_Category_Id = @id
						   Union
	select  data.PK_Category_Id,data.FK_Role_Id,user1.First_Name,user1.Last_Name,data.Active_Status,data.Description,data.Category_Name,
	data.Created_DateTime,data.Modified_DateTime,data.FK_User_Id
						   from Category_Master as data
                           join Admin_User as user1 on data.FK_Role_Id = user1.FK_Role_Id
                            where data.PK_Category_Id = @id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_View_Feed_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_View_Feed_Comment_Details 52
CREATE PROCEDURE [dbo].[sp_View_Feed_Comment_Details] 
	-- Add the parameters for the stored procedure here
	@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select data.PK_Feed_Comment_Id,
	PK_Feed_Id,
	PK_Category_Id,
	Feed_Title,
	alias.Description,
	Category_Name,
	data.Comment,
	data.Image_Path,
	data.Video_Link,
	data.Video_Type,
	data.Active_Status,
	user1.First_Name,user1.Last_Name,
	data.Modified_DateTime,data.Created_DateTime
	                       from Feed_Comment_Details as data
						   join Feed_Master as alias on data.FK_Feed_Id = alias.PK_Feed_Id
                           join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on alias.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Feed_Comment_Id = @id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_View_Feed_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_View_Feed_Master_Details 5
CREATE PROCEDURE [dbo].[sp_View_Feed_Master_Details] 
	-- Add the parameters for the stored procedure here
	@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select PK_Feed_Id,PK_Category_Id,Feed_Title,data.Video_Type,Category_Name,data.View_Count,data.Description,data.Image_Path,data.Video_Link,data.Active_Status,user1.First_Name,user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
	                       from Feed_Master as data
                           join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on data.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Feed_Id = @id
						   Union
						   select PK_Feed_Id,PK_Category_Id,Feed_Title,data.Video_Type,Category_Name,data.View_Count,data.Description,data.Image_Path,data.Video_Link,data.Active_Status,user1.First_Name,user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
						   from Feed_Master as data
                           join Admin_User as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on data.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Feed_Id = @id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_View_Global_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_View_Global_Comment_Details] 
	-- Add the parameters for the stored procedure here
	@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  select PK_Global_Comment_Details_ID,
	  PK_Global_Topics_Id,
	  PK_Category_Id,
	  alias.Global_Topics_Title,Category_Name,
	  alias.View_Count,alias.Description,
	  data.Comment,data.Image_Path,
	  data.Video_Link,
	  data.Video_Type,
	  data.Active_Status,user1.First_Name,
	  user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
		 from Global_Topic_Comment_Details as data
		 join Global_Topics_Master as alias on data.FK_Global_Topics_Id = alias.PK_Global_Topics_Id
         join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
         join Category_Master as cat on alias.FK_Category_Id = cat.PK_Category_Id
         where data.PK_Global_Comment_Details_ID = @id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_View_Global_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_View_Global_Master_Details 18
CREATE PROCEDURE [dbo].[sp_View_Global_Master_Details] 
	-- Add the parameters for the stored procedure here
	@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	     select PK_Global_Topics_Id,PK_Category_Id,data.Global_Topics_Title,Category_Name,data.View_Count,data.Description,data.Image_Path,data.Active_Status,user1.First_Name,user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
		 from Global_Topics_Master as data
                           join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on data.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Global_Topics_Id = @id
						   Union
						   select PK_Global_Topics_Id,PK_Category_Id,data.Global_Topics_Title,Category_Name,data.View_Count,data.Description,data.Image_Path,data.Active_Status,user1.First_Name,user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
						   from Global_Topics_Master as data
                           join Admin_User as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on data.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Global_Topics_Id = @id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_View_Trending_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec sp_View_Trending_Comment_Details 11
-- =============================================
CREATE PROCEDURE [dbo].[sp_View_Trending_Comment_Details] 
	-- Add the parameters for the stored procedure here
@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	    select data.PK_Trending_Comment_Details,
		alias.Description,
		PK_Trending_Id,
		data.Video_Link,PK_Category_Id,
		data.Video_Type,
		alias.Trending_Title,Category_Name,
		alias.View_Count,data.Comment,data.Image_Path,
		data.Active_Status,user1.First_Name,user1.Last_Name,
		data.Modified_DateTime,data.Created_DateTime
			   from Trending_Comment_Details as data
			   join Trending_Master as alias on data.FK_Trending_Id = alias.PK_Trending_Id
               join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
               join Category_Master as cat on alias.FK_Category_Id = cat.PK_Category_Id
               where data.PK_Trending_Comment_Details = @id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_View_Trending_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_View_Feed_Master_Details 17
CREATE PROCEDURE [dbo].[sp_View_Trending_Master_Details]  
	-- Add the parameters for the stored procedure here
		@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
               select PK_Trending_Id,data.Video_Type,data.Video_Link,PK_Category_Id,data.Trending_Title,Category_Name,data.View_Count,data.Description,data.Image_Path,data.Active_Status,user1.First_Name,user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
			   from Trending_Master as data
                           join User_Master as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on data.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Trending_Id = @id
						   Union
						   select PK_Trending_Id,data.Video_Type,data.Video_Link,PK_Category_Id,data.Trending_Title,Category_Name,data.View_Count,data.Description,data.Image_Path,data.Active_Status,user1.First_Name,user1.Last_Name,data.Modified_DateTime,data.Created_DateTime
						   from Trending_Master as data
                           join Admin_User as user1 on data.FK_Role_Id = user1.FK_Role_Id
                           join Category_Master as cat on data.FK_Category_Id = cat.PK_Category_Id
                           where data.PK_Trending_Id = @id
END


GO
/****** Object:  StoredProcedure [dbo].[sp_View_User_Master_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_View_User_Master_Details 2
CREATE PROCEDURE [dbo].[sp_View_User_Master_Details]
	-- Add the parameters for the stored procedure here
	@id as bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT um.PK_User_Id,um.First_Name,um.Created_DateTime,um.Email,um.FK_Role_Id,um.Gender,um.Profile_Image,city.City_Name,um.Birth_Date,cm.Country_Name,sm.State_Name,um.Active_Status
	FROM  User_Master um 
			  LEFT OUTER JOIN State_Master sm on sm.PK_State_Id = um.FK_State_Id
			  LEFT OUTER JOIN Country_Master cm on cm.PK_Country_Id = um.FK_Country_Id
			  LEFT OUTER JOIN City_Master city on city.PK_City_Id = um.FK_City_Id
			  LEFT OUTER JOIN Role_Master rm on rm.PK_Role_Id = um.FK_Role_Id
			  WHERE um.PK_User_Id = @id
END

GO
/****** Object:  StoredProcedure [ntsb].[spGetServerTimeZone]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec spGetServerTimeZone
-- =============================================
CREATE PROCEDURE [ntsb].[spGetServerTimeZone] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TimeZone VARCHAR(50)
	EXEC MASTER.dbo.xp_regread 'HKEY_LOCAL_MACHINE',
	'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
	'TimeZoneKeyName',@TimeZone OUT
	SELECT @TimeZone 'TimeZone'

    
END

GO
/****** Object:  Table [dbo].[Admin_Settings]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin_Settings](
	[PK_Admin_Setting_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SiteDescripton] [nvarchar](max) NULL,
 CONSTRAINT [PK_Admin_Settings] PRIMARY KEY CLUSTERED 
(
	[PK_Admin_Setting_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Admin_User]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admin_User](
	[PK_Admin_User_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Role_Id] [bigint] NULL,
	[Prefix] [nvarchar](20) NULL,
	[First_Name] [nvarchar](50) NULL,
	[Middle_Name] [nvarchar](50) NULL,
	[Last_Name] [nvarchar](50) NULL,
	[Email] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[Gender] [nvarchar](50) NULL,
	[Birth_Date] [datetime] NULL,
	[Marital_Status] [nvarchar](20) NULL,
	[FK_Country_Id] [bigint] NULL,
	[FK_State_Id] [bigint] NULL,
	[FK_City_Id] [nvarchar](max) NULL,
	[Profile_Image] [nvarchar](max) NULL,
	[Active_Status] [bit] NULL,
	[Forget_Pswd_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Admin_User] PRIMARY KEY CLUSTERED 
(
	[PK_Admin_User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category_Master](
	[PK_Category_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Category_Name] [nvarchar](150) NULL,
	[Description] [nvarchar](max) NULL,
	[Active_Status] [bit] NULL,
	[Modified_By_Id] [bigint] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Category_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[City_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City_Master](
	[PK_City_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Country_Id] [bigint] NULL,
	[FK_State_Id] [bigint] NULL,
	[City_Name] [nvarchar](50) NULL,
	[Active_Status] [bit] NULL,
 CONSTRAINT [PK_City_Master] PRIMARY KEY CLUSTERED 
(
	[PK_City_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country_Master](
	[PK_Country_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Country_Name] [nvarchar](50) NULL,
	[Active_Status] [bit] NULL,
 CONSTRAINT [PK_Country_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Country_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Feed_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feed_Comment_Details](
	[PK_Feed_Comment_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Feed_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[Video_Type] [bigint] NULL,
	[Video_Link] [nvarchar](max) NULL,
	[Image_Path] [nvarchar](max) NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Feed_Comment_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Feed_Comment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Feed_Comment_Status_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feed_Comment_Status_Details](
	[PK_Feed_Comment_Status_Details] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Feed_Comment_Id] [bigint] NULL,
	[FK_Feed_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Like_Status] [bit] NULL,
	[Twiter_Status] [bit] NULL,
	[Facebook_Status] [bit] NULL,
	[Instagram_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Feed_Comment_Status_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Feed_Comment_Status_Details] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Feed_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feed_Master](
	[PK_Feed_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Category_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Feed_Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Image_Path] [nvarchar](250) NULL,
	[Video_Link] [nvarchar](250) NULL,
	[Video_Type] [bigint] NULL,
	[Active_Status] [bit] NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[View_Count] [bigint] NULL,
	[Modified_By_Id] [bigint] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Feed_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Feed_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Feed_Status_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feed_Status_Details](
	[PK_Feed_Status_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Feed_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[Like_Status] [bit] NULL,
	[Twiter_Status] [bit] NULL,
	[Facebook_Status] [bit] NULL,
	[Instagram_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Feed_Status_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Feed_Status_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Global_Topic_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Global_Topic_Comment_Details](
	[PK_Global_Comment_Details_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Global_Topics_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[Video_Type] [bigint] NULL,
	[Video_Link] [nvarchar](max) NULL,
	[Image_Path] [nvarchar](max) NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Global_Comment_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Global_Comment_Details_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Global_Topic_Comment_Status_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Global_Topic_Comment_Status_Details](
	[PK_Global_Comment_Status_Details] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Global_Comment_Details_ID] [bigint] NULL,
	[FK_Global_Topics_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Like_Status] [bit] NULL,
	[Twiter_Status] [bit] NULL,
	[Facebook_Status] [bit] NULL,
	[Instagram_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Global_Topic_Comment_Status_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Global_Comment_Status_Details] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Global_Topics_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Global_Topics_Master](
	[PK_Global_Topics_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Category_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Global_Topics_Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Image_Path] [varchar](250) NULL,
	[Active_Status] [bit] NULL,
	[View_Count] [bigint] NULL,
	[Modified_By_Id] [bigint] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Global_Topics] PRIMARY KEY CLUSTERED 
(
	[PK_Global_Topics_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Global_Topics_Status_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Global_Topics_Status_Details](
	[PK_Global_Topics_Status_Details] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Global_Topics_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[Like_Status] [bit] NULL,
	[Twiter_Status] [bit] NULL,
	[Facebook_Status] [bit] NULL,
	[Instagram_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Global_Topics_Status_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Global_Topics_Status_Details] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Page_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Page_Master](
	[PK_Page_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Page_Name] [nvarchar](100) NULL,
	[Page_Description] [nvarchar](max) NULL,
	[Created_Date] [datetime] NULL,
	[Active_Status] [bit] NULL,
 CONSTRAINT [PK_Page_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Page_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Page_Permission]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Page_Permission](
	[PK_Page_Permission_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Rep_Level_Id] [bigint] NULL,
	[FK_Page_Id] [bigint] NULL,
	[Status] [bit] NULL,
	[Created_Date] [datetime] NULL,
	[Modified_Date] [datetime] NULL,
 CONSTRAINT [PK_Page_Permission] PRIMARY KEY CLUSTERED 
(
	[PK_Page_Permission_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Rep_Level_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rep_Level_Master](
	[PK_Rep_Level_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Level_Name] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [bit] NULL,
	[Created_Date] [datetime] NULL,
 CONSTRAINT [PK_Rep_Level_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Rep_Level_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role_Master](
	[PK_Role_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Role_Name] [nvarchar](100) NULL,
	[Active_Status] [bit] NULL,
	[Created_Date] [datetime] NULL,
 CONSTRAINT [PK_Role_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Role_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[State_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State_Master](
	[PK_State_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Country_Id] [bigint] NULL,
	[State_Name] [nvarchar](150) NULL,
	[Active_Status] [bit] NULL,
 CONSTRAINT [PK_State_Master] PRIMARY KEY CLUSTERED 
(
	[PK_State_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Trending_Comment_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trending_Comment_Details](
	[PK_Trending_Comment_Details] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Trending_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Comment] [nvarchar](max) NULL,
	[Video_Type] [bigint] NULL,
	[Video_Link] [nvarchar](max) NULL,
	[Image_Path] [nvarchar](max) NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Trending_Comment_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Trending_Comment_Details] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Trending_Comment_Status_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trending_Comment_Status_Details](
	[PK_Trending_Comment_Status_Details] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Trending_Comment_Details] [bigint] NULL,
	[FK_Trending_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Like_Status] [bit] NULL,
	[Twiter_Status] [bit] NULL,
	[Facebook_Status] [bit] NULL,
	[Instagram_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Trending_Comment_Status_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Trending_Comment_Status_Details] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Trending_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trending_Master](
	[PK_Trending_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Category_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Trending_Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Image_Path] [nvarchar](250) NULL,
	[Video_Type] [bigint] NULL,
	[Video_Link] [nvarchar](250) NULL,
	[Active_Status] [bit] NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[View_Count] [bigint] NULL,
	[Modified_By_Id] [bigint] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Trending_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Trending_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Trending_Status_Details]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trending_Status_Details](
	[PK_Trending_Status_Details] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Trending_Id] [bigint] NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Guest_User_Id] [nvarchar](500) NULL,
	[Like_Status] [bit] NULL,
	[Dislike_Status] [bit] NULL,
	[Twiter_Status] [bit] NULL,
	[Facebook_Status] [bit] NULL,
	[Instagram_Status] [bit] NULL,
	[Active_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Trending_Status_Details] PRIMARY KEY CLUSTERED 
(
	[PK_Trending_Status_Details] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_Login_History]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Login_History](
	[PK_UserLoginLog_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[IP_Address] [nvarchar](100) NULL,
	[LoginDateTime] [datetime] NULL,
 CONSTRAINT [PK_User_Login_History] PRIMARY KEY CLUSTERED 
(
	[PK_UserLoginLog_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Master](
	[PK_User_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_Role_Id] [bigint] NULL,
	[Prefix] [nvarchar](50) NULL,
	[First_Name] [nvarchar](50) NULL,
	[Middle_Name] [nvarchar](50) NULL,
	[Last_Name] [nvarchar](50) NULL,
	[Email] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[Gender] [int] NULL,
	[Birth_Date] [datetime] NULL,
	[Marital_Status] [nvarchar](20) NULL,
	[FK_Country_Id] [bigint] NULL,
	[FK_State_Id] [bigint] NULL,
	[FK_City_Id] [nvarchar](max) NULL,
	[Profile_Image] [nvarchar](max) NULL,
	[Active_Status] [bit] NULL,
	[Forget_Pswd_Status] [bit] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_User_Master] PRIMARY KEY CLUSTERED 
(
	[PK_User_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Video_Adv_Master]    Script Date: 04-10-2016 2.24.28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Video_Adv_Master](
	[PK_Video_Adv_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FK_User_Id] [bigint] NULL,
	[FK_Role_Id] [bigint] NULL,
	[Video_Link] [nvarchar](max) NULL,
	[Video_Type] [bigint] NULL,
	[Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Active_Status] [bit] NULL,
	[Modified_By_Id] [bigint] NULL,
	[Created_DateTime] [datetime] NULL,
	[Modified_DateTime] [datetime] NULL,
 CONSTRAINT [PK_Video_Adv_Master] PRIMARY KEY CLUSTERED 
(
	[PK_Video_Adv_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Admin_Settings] ON 

INSERT [dbo].[Admin_Settings] ([PK_Admin_Setting_Id], [SiteDescripton]) VALUES (2, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscin')
SET IDENTITY_INSERT [dbo].[Admin_Settings] OFF
SET IDENTITY_INSERT [dbo].[Admin_User] ON 

INSERT [dbo].[Admin_User] ([PK_Admin_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (1, 1, N'Mr', N'Kaushik', N'R', N'Gohel', N'a2F1c2hpa2dvaGVsQGFsaWFuc29mdHdhcmUubmV0', N'YWJjQDIyMzEzMw==', N'Male      ', CAST(0x0000818200000000 AS DateTime), N'Married', 1, 1, N'1', N'/ImageCollection/AdminProfilePic/Profile_pic.png', 1, NULL, CAST(0x0000A59100000000 AS DateTime), CAST(0x0000A59100000000 AS DateTime))
INSERT [dbo].[Admin_User] ([PK_Admin_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (2, 1, N'Mrs', N'Dipanki Jadav', N'', N'', N'ZGlwYW5raS5qYWRhdkBhbGlhbnNvZnR3YXJlLm5ldA==', N'YWJjQDIyMzEzMw==', N'Female', CAST(0x00007CAE00000000 AS DateTime), N'Married', 1, 17, N'Anand', N'/ImageCollection/AdminProfilePic/Admin_Profile_img_1639239020_55_28.jpg', 1, 0, CAST(0x0000A59100000000 AS DateTime), CAST(0x0000A680011694A7 AS DateTime))
SET IDENTITY_INSERT [dbo].[Admin_User] OFF
SET IDENTITY_INSERT [dbo].[Category_Master] ON 

INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (1, 1, 1, N'HEALTH', N'Lorem ipsum dolor sit amet, dolore eiusmod
quis tempor incididunt. Sed unde omnis iste.', 1, 1, CAST(0x0000A595011DF455 AS DateTime), CAST(0x0000A5A3012D5A1B AS DateTime))
INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (2, 1, 1, N'SPORTS', N' Lorem ipsum dolor sit amet, dolore eiusmod
quis tempor incididunt. Sed unde omnis iste.', 1, 1, CAST(0x0000A595011DA2E0 AS DateTime), CAST(0x0000A5E700EBCF69 AS DateTime))
INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (6, 1, 1, N'POLITICS', N' Lorem ipsum dolor sit amet, dolore eiusmod
quis tempor incididunt. Sed unde omnis iste.', 1, 1, CAST(0x0000A595011DEC16 AS DateTime), CAST(0x0000A5A301215CBD AS DateTime))
INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (7, 1, 1, N'ENTERTAINMENTS', N' Lorem ipsum dolor sit amet, dolore eiusmod
quis tempor incididunt. Sed unde omnis iste.', 1, 1, CAST(0x0000A59800B00458 AS DateTime), CAST(0x0000A5E801200AE8 AS DateTime))
INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (11, 1, 1, N'Science', N'For testing purpose', 1, 1, CAST(0x0000A5A00112D428 AS DateTime), CAST(0x0000A5EE0092343A AS DateTime))
INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (16, 1, 1, N'new test', N'test', 0, 1, CAST(0x0000A5D7017B7C61 AS DateTime), CAST(0x0000A5E700EBD469 AS DateTime))
INSERT [dbo].[Category_Master] ([PK_Category_Id], [FK_User_Id], [FK_Role_Id], [Category_Name], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (17, 1, 1, N'Comedy', N'This category involves all comedy news', 1, 1, CAST(0x0000A5F3008EB193 AS DateTime), CAST(0x0000A5F3008EB193 AS DateTime))
SET IDENTITY_INSERT [dbo].[Category_Master] OFF
SET IDENTITY_INSERT [dbo].[City_Master] ON 

INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (8, 1, 17, N'Anand', 1)
INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (9, 1, 17, N'Vadodara', 1)
INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (10, 1, 17, N'Ahmedabad', 1)
INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (11, 2, 16, N'Jersey City', 1)
INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (12, 2, 16, N'Paterson', 1)
INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (13, 2, 1, N'Albany', 1)
INSERT [dbo].[City_Master] ([PK_City_Id], [FK_Country_Id], [FK_State_Id], [City_Name], [Active_Status]) VALUES (14, 2, 1, N'Niagara Falls', 1)
SET IDENTITY_INSERT [dbo].[City_Master] OFF
SET IDENTITY_INSERT [dbo].[Country_Master] ON 

INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (1, N'Afghanistan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (2, N'Albania', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (3, N'Algeria', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (4, N'American Samoa', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (5, N'Angola', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (6, N'Anguilla', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (7, N'Antartica', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (8, N'Antigua and Barbuda', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (9, N'Argentina', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (10, N'Armenia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (11, N'Aruba', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (12, N'Ashmore and Cartier Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (13, N'Australia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (14, N'Austria', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (15, N'Azerbaijan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (16, N'Bahamas', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (17, N'Bahrain', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (18, N'Bangladesh', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (19, N'Barbados', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (20, N'Belarus', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (21, N'Belgium', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (22, N'Belize', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (23, N'Benin', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (24, N'Bermuda', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (25, N'Bhutan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (26, N'Bolivia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (27, N'Bosnia and Herzegovina', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (28, N'Botswana', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (29, N'Brazil', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (30, N'British Virgin Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (31, N'Brunei', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (32, N'Bulgaria', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (33, N'Burkina Faso', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (34, N'Burma', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (35, N'Burundi', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (36, N'Cambodia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (37, N'Cameroon', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (38, N'Canada', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (39, N'Cape Verde', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (40, N'Cayman Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (41, N'Central African Republic', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (42, N'Chad', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (43, N'Chile', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (44, N'China', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (45, N'Christmas Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (46, N'Clipperton Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (47, N'Cocos (Keeling) Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (48, N'Colombia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (49, N'Comoros', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (50, N'Congo, Democratic Republic of the', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (51, N'Congo, Republic of the', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (52, N'Cook Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (53, N'Costa Rica', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (54, N'Cote d''Ivoire', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (55, N'Croatia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (56, N'Cuba', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (57, N'Cyprus', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (58, N'Czeck Republic', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (59, N'Denmark', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (60, N'Djibouti', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (61, N'Dominica', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (62, N'Dominican Republic', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (63, N'Ecuador', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (64, N'Egypt', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (65, N'El Salvador', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (66, N'Equatorial Guinea', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (67, N'Eritrea', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (68, N'Estonia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (69, N'Ethiopia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (70, N'Europa Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (71, N'Falkland Islands (Islas Malvinas)', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (72, N'Faroe Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (73, N'Fiji', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (74, N'Finland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (75, N'France', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (76, N'French Guiana', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (77, N'French Polynesia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (78, N'French Southern and Antarctic Lands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (79, N'Gabon', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (80, N'Gambia, The', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (81, N'Gaza Strip', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (82, N'Georgia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (83, N'Germany', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (84, N'Ghana', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (85, N'Gibraltar', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (86, N'Glorioso Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (87, N'Greece', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (88, N'Greenland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (89, N'Grenada', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (90, N'Guadeloupe', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (91, N'Guam', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (92, N'Guatemala', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (93, N'Guernsey', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (94, N'Guinea', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (95, N'Guinea-Bissau', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (96, N'Guyana', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (97, N'Haiti', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (98, N'Heard Island and McDonald Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (99, N'Holy See (Vatican City)', 1)
GO
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (100, N'Honduras', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (101, N'Hong Kong', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (102, N'Howland Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (103, N'Hungary', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (104, N'Iceland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (105, N'India', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (106, N'Indonesia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (107, N'Iran', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (108, N'Iraq', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (109, N'Ireland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (110, N'Ireland, Northern', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (111, N'Israel', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (112, N'Italy', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (113, N'Jamaica', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (114, N'Jan Mayen', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (115, N'Japan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (116, N'Jarvis Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (117, N'Jersey', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (118, N'Johnston Atoll', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (119, N'Jordan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (120, N'Juan de Nova Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (121, N'Kazakhstan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (122, N'Kenya', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (123, N'Kiribati', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (124, N'Korea, North', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (125, N'Korea, South', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (126, N'Kuwait', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (127, N'Kyrgyzstan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (128, N'Laos', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (129, N'Latvia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (130, N'Lebanon', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (131, N'Lesotho', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (132, N'Liberia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (133, N'Libya', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (134, N'Liechtenstein', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (135, N'Lithuania', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (136, N'Luxembourg', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (137, N'Macau', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (138, N'Macedonia, Former Yugoslav Republic of', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (139, N'Madagascar', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (140, N'Malawi', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (141, N'Malaysia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (142, N'Maldives', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (143, N'Mali', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (144, N'Malta', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (145, N'Man, Isle of', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (146, N'Marshall Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (147, N'Martinique', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (148, N'Mauritania', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (149, N'Mauritius', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (150, N'Mayotte', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (151, N'Mexico', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (152, N'Micronesia, Federated States of', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (153, N'Midway Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (154, N'Moldova', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (155, N'Monaco', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (156, N'Mongolia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (157, N'Montserrat', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (158, N'Morocco', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (159, N'Mozambique', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (160, N'Namibia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (161, N'Nauru', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (162, N'Nepal', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (163, N'Netherlands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (164, N'Netherlands Antilles', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (165, N'New Caledonia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (166, N'New Zealand', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (167, N'Nicaragua', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (168, N'Niger', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (169, N'Nigeria', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (170, N'Niue', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (171, N'Norfolk Island', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (172, N'Northern Mariana Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (173, N'Norway', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (174, N'Oman', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (175, N'Pakistan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (176, N'Palau', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (177, N'Panama', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (178, N'Papua New Guinea', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (179, N'Paraguay', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (180, N'Peru', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (181, N'Philippines', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (182, N'Pitcaim Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (183, N'Poland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (184, N'Portugal', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (185, N'Puerto Rico', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (186, N'Qatar', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (187, N'Reunion', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (188, N'Romainia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (189, N'Russia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (190, N'Rwanda', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (191, N'Saint Helena', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (192, N'Saint Kitts and Nevis', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (193, N'Saint Lucia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (194, N'Saint Pierre and Miquelon', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (195, N'Saint Vincent and the Grenadines', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (196, N'Samoa', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (197, N'San Marino', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (198, N'Sao Tome and Principe', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (199, N'Saudi Arabia', 1)
GO
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (200, N'Scotland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (201, N'Senegal', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (202, N'Seychelles', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (203, N'Sierra Leone', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (204, N'Singapore', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (205, N'Slovakia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (206, N'Slovenia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (207, N'Solomon Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (208, N'Somalia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (209, N'South Africa', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (210, N'South Georgia and South Sandwich Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (211, N'Spain', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (212, N'Spratly Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (213, N'Sri Lanka', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (214, N'Sudan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (215, N'Suriname', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (216, N'Svalbard', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (217, N'Swaziland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (218, N'Sweden', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (219, N'Switzerland', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (220, N'Syria', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (221, N'Taiwan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (222, N'Tajikistan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (223, N'Tanzania', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (224, N'Thailand', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (225, N'Tobago', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (226, N'Toga', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (227, N'Tokelau', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (228, N'Tonga', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (229, N'Trinidad', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (230, N'Tunisia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (231, N'Turkey', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (232, N'Turkmenistan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (233, N'Tuvalu', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (234, N'Uganda', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (235, N'Ukraine', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (236, N'United Arab Emirates', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (237, N'United Kingdom', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (238, N'Uruguay', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (239, N'USA', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (240, N'Uzbekistan', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (241, N'Vanuatu', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (242, N'Venezuela', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (243, N'Vietnam', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (244, N'Virgin Islands', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (245, N'Wales', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (246, N'Wallis and Futuna', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (247, N'West Bank', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (248, N'Western Sahara', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (249, N'Yemen', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (250, N'Yugoslavia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (251, N'Zambia', 1)
INSERT [dbo].[Country_Master] ([PK_Country_Id], [Country_Name], [Active_Status]) VALUES (252, N'Zimbabwe', 1)
SET IDENTITY_INSERT [dbo].[Country_Master] OFF
SET IDENTITY_INSERT [dbo].[Feed_Comment_Details] ON 

INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10148, 54, 2, 3, N'This is a test 1', 2, N'//www.youtube.com/embed/0NfGPWu3qAQ', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A009F3EF2 AS DateTime), CAST(0x0000A673010BE8F5 AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10149, 54, 2, 3, N'This is a test 2', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A009F52FF AS DateTime), CAST(0x0000A60A009F52FF AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20186, 56, 2, 3, N'Testing Purpose', 2, N'https://www.youtube.com/watch?v=mvHDUB0_R5E', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A66400A26F36 AS DateTime), CAST(0x0000A66400A26F36 AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20187, 56, 2, 3, N'Testing Purpose', 2, N'https://www.youtube.com/watch?v=mvHDUB0_R5E', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A66400A3C8B0 AS DateTime), CAST(0x0000A66400A3C8B0 AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30186, 60, 2, 3, N'                    Testing ....', 2, N'//www.youtube.com/embed/Z6LcUVh7-18', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A6730098A97D AS DateTime), CAST(0x0000A6730098A97D AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30187, 60, 2, 3, N'this is crazy       ', NULL, N'#', N'#', N'a513fa08-f482-48f7-ae9b-546420fee53b', 1, CAST(0x0000A6740072570A AS DateTime), CAST(0x0000A6740072570A AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30188, 60, 2, 3, N'Ridiculous
', NULL, N'#', N'#', N'a513fa08-f482-48f7-ae9b-546420fee53b', 1, CAST(0x0000A67400728615 AS DateTime), CAST(0x0000A67400728615 AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30189, 60, 2, 3, N'This man needs help', NULL, N'#', N'#', N'a513fa08-f482-48f7-ae9b-546420fee53b', 1, CAST(0x0000A6740072B52B AS DateTime), CAST(0x0000A6740072B52B AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30190, 60, 2, 3, N'This man needs help', NULL, N'#', N'#', N'a513fa08-f482-48f7-ae9b-546420fee53b', 1, CAST(0x0000A6740072B58E AS DateTime), CAST(0x0000A6740072B58E AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30191, 60, 2, 3, N'www.google.com
  ', NULL, N'#', N'#', N'39b8c187-b2d5-432f-b104-dbaf0a5406b7', 1, CAST(0x0000A6790012241C AS DateTime), CAST(0x0000A6790012241C AS DateTime))
INSERT [dbo].[Feed_Comment_Details] ([PK_Feed_Comment_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30192, 60, 2, 3, N'                    http://ntsb.aliansoftware.com/', NULL, N'#', N'#', N'39b8c187-b2d5-432f-b104-dbaf0a5406b7', 1, CAST(0x0000A6790012A130 AS DateTime), CAST(0x0000A6790012A130 AS DateTime))
SET IDENTITY_INSERT [dbo].[Feed_Comment_Details] OFF
SET IDENTITY_INSERT [dbo].[Feed_Master] ON 

INSERT [dbo].[Feed_Master] ([PK_Feed_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Feed_Title], [Description], [Image_Path], [Video_Link], [Video_Type], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (51, 7, 10042, 2, N'Testing 1.4', N'Testing Purpose', N'/ImageCollection/Feeds/Feed_Master_img_1901391480_36_25.png', N'//www.youtube.com/embed/embed/embed/wFAhCYSiVvY', 2, 0, NULL, 14, 10042, CAST(0x0000A5FE00E03C7B AS DateTime), CAST(0x0000A68201005590 AS DateTime))
INSERT [dbo].[Feed_Master] ([PK_Feed_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Feed_Title], [Description], [Image_Path], [Video_Link], [Video_Type], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (54, 7, 2, 3, N'uuuuuuuuuuuuuuuuuuuuuuuuuuuuuu', N'uoopoihgggll', N'/ImageCollection/Feeds/story_img_1976212313_54_17.jpg', N'//www.youtube.com/embed/0NfGPWu3qAQ', 2, 1, N'04502393-c867-4e25-99d1-a14b8c4b96f6', 30, 2, CAST(0x0000A606001F6416 AS DateTime), CAST(0x0000A673010AC764 AS DateTime))
INSERT [dbo].[Feed_Master] ([PK_Feed_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Feed_Title], [Description], [Image_Path], [Video_Link], [Video_Type], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (56, 17, 2, 3, N'Test12345', N'greyry', N'/ImageCollection/Feeds/story_img_1339704182_45_58.jpg', N'//www.youtube.com/embed/0NfGPWu3qAQ', 2, 1, N'99654a2d-5ae5-45a6-a080-223346509183', 54, 2, CAST(0x0000A61000E2DC8D AS DateTime), CAST(0x0000A673010B0C2C AS DateTime))
INSERT [dbo].[Feed_Master] ([PK_Feed_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Feed_Title], [Description], [Image_Path], [Video_Link], [Video_Type], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (58, 6, 0, 0, N'At what point do we hold the politicians accountable', N'Doctor: Trump’s Only Medical Records Documentation Written in 5 Minutes', N'/ImageCollection/Feeds/story_img_479950483_29_52.jpg', N'https://www.youtube.com/watch?v=kkv9SFyTnuw', 2, 1, NULL, NULL, 0, CAST(0x0000A671008C0AD0 AS DateTime), CAST(0x0000A671008C0AD0 AS DateTime))
INSERT [dbo].[Feed_Master] ([PK_Feed_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Feed_Title], [Description], [Image_Path], [Video_Link], [Video_Type], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (59, 6, 2, 3, N'This is a test', N'This is another test', N'/ImageCollection/Feeds/story_img_491002745_37_9.jpg', N'//www.youtube.com/embed/kkv9SFyTnuw', 2, 1, N'a513fa08-f482-48f7-ae9b-546420fee53b', 15, 2, CAST(0x0000A671008E0AB1 AS DateTime), CAST(0x0000A6730113476A AS DateTime))
INSERT [dbo].[Feed_Master] ([PK_Feed_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Feed_Title], [Description], [Image_Path], [Video_Link], [Video_Type], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (60, 6, 2, 3, N'Really?!: At what point do we start to hold politicians accountable', N'Doctor: Trump’s Only Medical Records Documentation Written in 5 Minutes', N'/ImageCollection/Feeds/story_img_769980266_39_48.jpg', N'//www.youtube.com/embed/kkv9SFyTnuw', 2, 1, N'a513fa08-f482-48f7-ae9b-546420fee53b', 37, 2, CAST(0x0000A671008EC479 AS DateTime), CAST(0x0000A673010A9659 AS DateTime))
SET IDENTITY_INSERT [dbo].[Feed_Master] OFF
SET IDENTITY_INSERT [dbo].[Feed_Status_Details] ON 

INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20056, 54, 2, 3, N'99654a2d-5ae5-45a6-a080-223346509183', 0, NULL, NULL, NULL, 1, CAST(0x0000A60F0116570D AS DateTime), CAST(0x0000A613012D661D AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20057, 54, 2, 3, N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 0, NULL, NULL, NULL, 1, CAST(0x0000A60F011B0A09 AS DateTime), CAST(0x0000A61601052C9B AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20063, 56, 3, 3, N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 1, NULL, NULL, NULL, 1, CAST(0x0000A612010A4B62 AS DateTime), CAST(0x0000A612010A4B62 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20065, 56, 2, 3, N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, NULL, NULL, NULL, 1, CAST(0x0000A6120113AD81 AS DateTime), CAST(0x0000A6120138C93F AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20067, 56, 4, 3, N'6b0e7a6e-7e4a-4c45-b211-0e89097f6ef1', 0, NULL, NULL, NULL, 1, CAST(0x0000A612013633F7 AS DateTime), CAST(0x0000A612013633F7 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20069, 56, 3, 3, N'99654a2d-5ae5-45a6-a080-223346509183', 1, NULL, NULL, NULL, 1, CAST(0x0000A613009FCD4C AS DateTime), CAST(0x0000A613009FCD4C AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20070, 56, 2, 3, N'99654a2d-5ae5-45a6-a080-223346509183', 0, NULL, NULL, NULL, 1, CAST(0x0000A61300AC0B48 AS DateTime), CAST(0x0000A613012D5787 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20073, 56, 2, 3, N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 1, NULL, NULL, NULL, 1, CAST(0x0000A61601052233 AS DateTime), CAST(0x0000A61601053379 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20076, 56, 2, 3, N'b3d995cc-7bbd-4802-becd-46a3df607640', 1, NULL, NULL, NULL, 1, CAST(0x0000A65600A753D9 AS DateTime), CAST(0x0000A65600A9923B AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20077, 51, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, 1, CAST(0x0000A66000B0E1AC AS DateTime), CAST(0x0000A67200B26012 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20078, 54, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, 1, CAST(0x0000A66000B0E5E7 AS DateTime), CAST(0x0000A67200A7506F AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20079, 56, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, 1, CAST(0x0000A66000B0EEE1 AS DateTime), CAST(0x0000A67A00E12A9B AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20080, 56, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 1, NULL, NULL, NULL, 1, CAST(0x0000A66100D912E1 AS DateTime), CAST(0x0000A673011796DD AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20081, 54, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 0, NULL, NULL, NULL, 1, CAST(0x0000A66100D939BB AS DateTime), CAST(0x0000A66100D9726D AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20082, 51, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 0, NULL, NULL, NULL, 1, CAST(0x0000A66100D9447A AS DateTime), CAST(0x0000A67301179A08 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20083, 56, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 0, NULL, NULL, NULL, 1, CAST(0x0000A66101001D03 AS DateTime), CAST(0x0000A67801128C82 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30083, 51, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 0, NULL, NULL, NULL, 1, CAST(0x0000A67100C24081 AS DateTime), CAST(0x0000A67A00C0122F AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30084, 54, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 0, NULL, NULL, NULL, 1, CAST(0x0000A67100C5D2D3 AS DateTime), CAST(0x0000A67A00C0133F AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30085, 60, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, NULL, NULL, NULL, 1, CAST(0x0000A67100C61799 AS DateTime), CAST(0x0000A67A00E13441 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30086, 59, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, NULL, NULL, NULL, 1, CAST(0x0000A67100C61D13 AS DateTime), CAST(0x0000A67200B25659 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30087, 60, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 1, NULL, NULL, NULL, 1, CAST(0x0000A67100F8CD7E AS DateTime), CAST(0x0000A67100F8E9A4 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30088, 59, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 0, NULL, NULL, NULL, 1, CAST(0x0000A67100FFBCE9 AS DateTime), CAST(0x0000A67A00BFFF16 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30089, 60, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, 1, CAST(0x0000A6730098B580 AS DateTime), CAST(0x0000A67A00C018C7 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30090, 59, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 1, NULL, NULL, NULL, 1, CAST(0x0000A67301178B6B AS DateTime), CAST(0x0000A673011790A7 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30091, 59, 2, 3, N'210ab051-e7e0-44ce-98e1-81358aacce99', 0, NULL, NULL, NULL, 1, CAST(0x0000A67800DD8F7A AS DateTime), CAST(0x0000A67800DD91D3 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30092, 60, 10042, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A67D00959C16 AS DateTime), CAST(0x0000A67D0095A0AC AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30093, 60, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A68200100BB4 AS DateTime), CAST(0x0000A68200100BB4 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30094, 54, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A68200101748 AS DateTime), CAST(0x0000A68200101748 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30095, 56, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A68200101D95 AS DateTime), CAST(0x0000A68200101D95 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30096, 59, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A68200102000 AS DateTime), CAST(0x0000A68200102000 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30097, 60, 2, 3, N'4ae2688f-7c09-40b8-81c0-063432fa0a23', 1, NULL, NULL, NULL, 1, CAST(0x0000A68700F50A19 AS DateTime), CAST(0x0000A68700F50A19 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30098, 54, 2, 3, N'4ae2688f-7c09-40b8-81c0-063432fa0a23', 1, NULL, NULL, NULL, 1, CAST(0x0000A68700F50E1C AS DateTime), CAST(0x0000A68700F50E1C AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30099, 56, 2, 3, N'4ae2688f-7c09-40b8-81c0-063432fa0a23', 1, NULL, NULL, NULL, 1, CAST(0x0000A68700F510F2 AS DateTime), CAST(0x0000A68700F510F2 AS DateTime))
INSERT [dbo].[Feed_Status_Details] ([PK_Feed_Status_Id], [FK_Feed_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30100, 59, 2, 3, N'4ae2688f-7c09-40b8-81c0-063432fa0a23', 0, NULL, NULL, NULL, 1, CAST(0x0000A68700F51533 AS DateTime), CAST(0x0000A68700F51533 AS DateTime))
SET IDENTITY_INSERT [dbo].[Feed_Status_Details] OFF
SET IDENTITY_INSERT [dbo].[Global_Topic_Comment_Details] ON 

INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10129, 18, 2, 3, N'"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..." "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."', 1, N'/VideoCollection/GlobalTopicsComment/Global_Comment_video_355829400_6_32.mp4', N'/ImageCollection/GlobalTopicsComment/Global_Comment_img_2014354924_59_39.jpg', NULL, 1, CAST(0x0000A5A10096CD04 AS DateTime), CAST(0x0000A5AE00E88304 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10130, 18, 2, 3, N'"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit..." "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."', 1, N'~/VideoCollection/GlobalTopicsComment/Global_Comment_video_1520920036_9_26.mp4', N'#', NULL, 1, CAST(0x0000A5A10096ECE5 AS DateTime), CAST(0x0000A5A10096ECE5 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10131, 18, 2, 3, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a libero ante. Mauris imperdiet eget felis non tristique. Vivamus ac lobortis lorem. Phasellus vehicula leo sit amet egestas ullamcorper. Sed sit amet congue nisi, quis fermentum tellus. Praesent ultrices congue nibh nec sodales. Vestibulum eget justo pulvinar nisi porttitor fringilla et et diam. Sed gravida ut nunc id ullamcorper. Ut laoreet magna nec accumsan vehicula. Mauris luctus tellus eget purus luctus pharetra. Maecenas molestie odio vitae auctor placerat. Nam dapibus lorem at accumsan lobortis. Aenean velit erat, pharetra vel sodales a, egestas in augue. Donec rhoncus pretium ex et fermentum. Aliquam pellentesque, elit eget bibendum venenatis, mi lacus luctus orci, et mattis lacus quam ut neque. Etiam imperdiet justo sem.', 0, N'#', N'#', NULL, 1, CAST(0x0000A5A1009E897B AS DateTime), CAST(0x0000A5A301288B2D AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10132, 18, 2, 3, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a libero ante. Mauris imperdiet eget felis non tristique. Vivamus ac lobortis lorem. Phasellus vehicula leo sit amet egestas ullamcorper. Sed sit amet congue nisi, quis fermentum tellus. Praesent ultrices congue nibh nec sodales. Vestibulum eget justo pulvinar nisi porttitor fringilla et et diam. Sed gravida ut nunc id ullamcorper. Ut laoreet magna nec accumsan vehicula. Mauris luctus tellus eget purus luctus pharetra. Maecenas molestie odio vitae auctor placerat. Nam dapibus lorem at accumsan lobortis. Aenean velit erat, pharetra vel sodales a, egestas in augue. Donec rhoncus pretium ex et fermentum. Aliquam pellentesque, elit eget bibendum venenatis, mi lacus luctus orci, et mattis lacus quam ut neque. Etiam imperdiet justo sem.', 0, N'#', N'#', NULL, 1, CAST(0x0000A5A1009F9761 AS DateTime), CAST(0x0000A5A600BA6B92 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10139, 18, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', 2, N'https://www.youtube.com/watch?v=Cg_gbQDfJ7Y', N'#', NULL, 1, CAST(0x0000A5A100A401DD AS DateTime), CAST(0x0000A5A100A401DD AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10145, 18, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', 1, N'/VideoCollection/GlobalTopicsComment/Global_Comment_video_632334217_2_2.mp4', N'#', NULL, 1, CAST(0x0000A5A100B943B1 AS DateTime), CAST(0x0000A5A700B5D548 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10146, 18, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. id', 1, N'~/VideoCollection/GlobalTopicsComment/Global_Comment_video_268202175_40_51.mp4', N'#', NULL, 0, CAST(0x0000A5A100C08640 AS DateTime), CAST(0x0000A5A100C26C9E AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10148, 18, 2, 3, N'testing comment', 1, N'/VideoCollection/GlobalTopicsComment/Global_Comment_video_1731596945_1_14.mp4', N'#', NULL, 1, CAST(0x0000A5A10125F403 AS DateTime), CAST(0x0000A5A700B59E03 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10153, 18, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry.', 0, N'#', N'#', NULL, 1, CAST(0x0000A5A3009EF34D AS DateTime), CAST(0x0000A5A3009EF34D AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10154, 18, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', 0, N'#', N'#', N'232e8df6-52c3-4cea-ae1e-1817a43c11b3', 1, CAST(0x0000A5A3009F7BA2 AS DateTime), CAST(0x0000A5A3009F7BA2 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10156, 18, 2, 3, N'LOREM IPSUM DOLOR SIT AMET, CONSECTETUR ADIPISCING ELIT, SED DO EIUSMOD TEMPOR', 0, N'#', N'#', N'4fd677d7-a77f-4ca2-893a-9e42a6d17847', 1, CAST(0x0000A5A40131A753 AS DateTime), CAST(0x0000A5A40131A753 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10157, 18, 2, 3, N'Vimeo Video Url Testing', 2, N'https://player.vimeo.com/video/6370469', N'#', N'2c88be08-3e45-402a-988d-48f8bb0e1b41', 1, CAST(0x0000A5A600ED6E2E AS DateTime), CAST(0x0000A5A600ED6E2E AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10158, 26, 2, 3, N'test', 0, N'#', N'#', N'73d96216-bb92-4f0e-9b80-083264380269', 1, CAST(0x0000A5A9009F68A0 AS DateTime), CAST(0x0000A5A9009F68A0 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10159, 26, 2, 3, N'tesddfds', 0, N'#', N'#', N'73d96216-bb92-4f0e-9b80-083264380269', 1, CAST(0x0000A5A9009F6D9B AS DateTime), CAST(0x0000A5A9009F6D9B AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10160, 26, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ', 0, N'#', N'#', N'67d519ab-ff1b-48f8-8b18-93591d8bbcff', 1, CAST(0x0000A5A90125988D AS DateTime), CAST(0x0000A5A90125988D AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10163, 26, 2, 3, N't', 0, N'#', N'#', N'cc1e58e4-6c9a-4ba5-912d-ee2518c7ae67', 1, CAST(0x0000A5AB00E3637B AS DateTime), CAST(0x0000A5AB00E3637B AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10164, 26, 2, 3, N't', 0, N'#', N'#', N'cc1e58e4-6c9a-4ba5-912d-ee2518c7ae67', 1, CAST(0x0000A5AB00E365EB AS DateTime), CAST(0x0000A5AB00E365EB AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10165, 26, 2, 3, N't', 0, N'#', N'#', N'cc1e58e4-6c9a-4ba5-912d-ee2518c7ae67', 1, CAST(0x0000A5AB00E367D7 AS DateTime), CAST(0x0000A5AB00E367D7 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10166, 26, 2, 3, N't', 0, N'#', N'#', N'cc1e58e4-6c9a-4ba5-912d-ee2518c7ae67', 1, CAST(0x0000A5AB00E369AC AS DateTime), CAST(0x0000A5AB00E369AC AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10167, 26, 2, 3, N't', 0, N'#', N'#', N'cc1e58e4-6c9a-4ba5-912d-ee2518c7ae67', 1, CAST(0x0000A5AB00E36CF3 AS DateTime), CAST(0x0000A5AB00E36CF3 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10168, 26, 2, 3, N'sadfsfsffs', 0, N'#', N'#', N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, CAST(0x0000A5AE00BF2112 AS DateTime), CAST(0x0000A5AE00BF2112 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10169, 28, 2, 3, N'Hello World !!', 0, N'#', N'#', N'c9951f6c-8674-4263-be7b-1009cbd067bc', 1, CAST(0x0000A5AF00D32A29 AS DateTime), CAST(0x0000A5AF00D32A29 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10170, 28, 2, 3, N'Hello World !! :)', 2, N'//www.youtube.com/embed/0NfGPWu3qAQ', N'~/ImageCollection/GlobalTopicsComment/Global_Comment_img_1017045530_41_0.jpg', N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, CAST(0x0000A5B001237743 AS DateTime), CAST(0x0000A6730111BF15 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10171, 18, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', 0, N'#', N'~/ImageCollection/GlobalTopicsComment/Global_Comment_img_1085400170_49_33.gif', N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, CAST(0x0000A5BD0104FDEE AS DateTime), CAST(0x0000A5BD0104FDEE AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20173, 26, 2, 3, N'Testing ...', 2, N'https://youtu.be/qVIwHGI2e1U', N'#', N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, CAST(0x0000A5C400C62531 AS DateTime), CAST(0x0000A5C400C62531 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20174, 28, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', 0, N'#', N'~/ImageCollection/GlobalTopicsComment/Global_Comment_img_322115453_49_44.jpg', N'5c636cae-e92c-423e-8c8d-bef6ff2eb576', 1, CAST(0x0000A5C500918B2F AS DateTime), CAST(0x0000A5C500918B2F AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20175, 18, 2, 3, N'test', 0, N'#', N'#', N'b6114762-19a6-4eca-8131-848bae50d6de', 1, CAST(0x0000A5C6008FB64D AS DateTime), CAST(0x0000A5C6008FB64D AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20176, 18, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. id', 0, N'#', N'#', N'5c636cae-e92c-423e-8c8d-bef6ff2eb576', 1, CAST(0x0000A5C700D59BF5 AS DateTime), CAST(0x0000A5C700D59BF6 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20177, 18, 2, 3, N'test', 0, N'#', N'#', N'5c636cae-e92c-423e-8c8d-bef6ff2eb576', 1, CAST(0x0000A5C700E58DE2 AS DateTime), CAST(0x0000A5C700E58DE2 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20178, 28, 2, 3, N'rfgggg', 0, N'#', N'#', N'5c636cae-e92c-423e-8c8d-bef6ff2eb576', 1, CAST(0x0000A5C700E66D9A AS DateTime), CAST(0x0000A5C700E66D9A AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20179, 28, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. id 2323', 0, N'#', N'~/ImageCollection/GlobalTopicsComment/Global_Comment_img_951059812_4_25.jpg', N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, CAST(0x0000A5C7011965E9 AS DateTime), CAST(0x0000A5C7011965E9 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20180, 26, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. id', 0, N'#', N'#', N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, CAST(0x0000A5C7011B6DC7 AS DateTime), CAST(0x0000A5C7011B6DC7 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20183, 28, 0, 0, N'https://www.yahoo.com/news/peter-dinklage-gwen-stefani-show-154538213.html', 0, N'#', N'#', NULL, 1, CAST(0x0000A5DE00128A16 AS DateTime), CAST(0x0000A5DE00128A16 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20184, 28, 0, 0, N'https://www.yahoo.com/news/peter-dinklage-gwen-stefani-show-154538213.html', 0, N'#', N'#', NULL, 1, CAST(0x0000A5DE0012A54E AS DateTime), CAST(0x0000A5DE0012A54E AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20185, 28, 0, 0, N'what is going on? I cannot post a link', 0, N'#', N'#', NULL, 1, CAST(0x0000A5DE0012CE75 AS DateTime), CAST(0x0000A5DE0012CE75 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20186, 28, 0, 0, N'jufdiufdiufdifdoifdi', 0, N'#', N'#', NULL, 1, CAST(0x0000A5DE00134A75 AS DateTime), CAST(0x0000A5DE00134A75 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20187, 18, 0, 0, N'jusudsuds', 0, N'#', N'#', NULL, 1, CAST(0x0000A5DE009DD8C6 AS DateTime), CAST(0x0000A5DE009DD8C6 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20189, 29, 2, 3, N'https://www.google.co.in', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E100C2A80C AS DateTime), CAST(0x0000A5E100C2A80C AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20190, 29, 2, 3, N'https://www.google.co.in/', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E100C30BF9 AS DateTime), CAST(0x0000A5E100C30BF9 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20191, 29, 2, 3, N'https://www.google.co.in', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E100C65DDE AS DateTime), CAST(0x0000A5E100C65DDE AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20192, 29, 2, 3, N'https://www.google.co.in ', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E100C6AF31 AS DateTime), CAST(0x0000A5E100C6AF31 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20193, 29, 2, 3, N'www.google.co.in', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E100E16B78 AS DateTime), CAST(0x0000A5E100E16B78 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20194, 29, 2, 3, N'http://www.google.co.in', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E100E2E6E4 AS DateTime), CAST(0x0000A5E100E2E6E4 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20198, 29, 2, 3, N'abc.com', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E20094689C AS DateTime), CAST(0x0000A5E20094689C AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20199, 29, 2, 3, N'www.Google.co.in', 0, N'#', N'#', N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, CAST(0x0000A5E2009CE6F2 AS DateTime), CAST(0x0000A5E2009CE6F2 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20201, 29, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', 0, N'#', N'#', N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, CAST(0x0000A5E2010CF0DF AS DateTime), CAST(0x0000A5E2010CF0DF AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20202, 28, 2, 3, N'google.c', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012E5138 AS DateTime), CAST(0x0000A5E2012E5138 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20203, 28, 2, 3, N'google.in', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012E5E18 AS DateTime), CAST(0x0000A5E2012E5E18 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20204, 28, 2, 3, N'google.org', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012E69AB AS DateTime), CAST(0x0000A5E2012E69AB AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20205, 28, 2, 3, N'google.co.u', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012E7348 AS DateTime), CAST(0x0000A5E2012E7348 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20206, 28, 2, 3, N'google.co.in', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012E7DDA AS DateTime), CAST(0x0000A5E2012E7DDA AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20207, 28, 2, 3, N'ntsb.aliansoftware.net', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012E8EC3 AS DateTime), CAST(0x0000A5E2012E8EC3 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20208, 28, 2, 3, N'ntsb.aliansoftware.com', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012EA49A AS DateTime), CAST(0x0000A5E2012EA49A AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20209, 28, 2, 3, N'http://aliansoftware.com', 0, N'#', N'#', N'64d06b0c-efc0-4484-a5da-03324aa200c0', 1, CAST(0x0000A5E2012EB865 AS DateTime), CAST(0x0000A5E2012EB865 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20210, 29, 2, 3, N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. id', NULL, N'#', N'#', N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, CAST(0x0000A5E300B92089 AS DateTime), CAST(0x0000A5E300B92089 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30210, 29, 2, 3, N'www.google.co.in', NULL, N'#', N'#', N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, CAST(0x0000A5E50104B331 AS DateTime), CAST(0x0000A5E50104B331 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30211, 35, 26, 2, N'www.google.co.in', NULL, N'#', N'#', NULL, 1, CAST(0x0000A5E80107A578 AS DateTime), CAST(0x0000A5E80107A578 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30212, 35, 2, 3, N'http://ntsb.aliansoftware.com/', NULL, N'#', N'#', N'c5bee947-799e-45a8-9744-3e625be7fe50', 1, CAST(0x0000A5EE01254A10 AS DateTime), CAST(0x0000A5EE01254A10 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30213, 33, 2, 3, N'Ut a semper augue. Aliquam pulvinar at nulla eu accumsan. Nam bibendum dignissim diam, ornare bibendum ex gravida et. Mauris condimentum fermentum nulla quis tincidunt. Integer nec velit semper, hendrerit turpis non, tristique ligula. Maecenas ultricies sollicitudin turpis, vel iaculis massa dapibus vel. Proin egestas justo ac ante dictum sagittis. Maecenas nisl mi, mollis id finibus quis, egestas a nisi. Donec quis libero vulputate, sodales ligula a, viverra nunc.', NULL, N'#', N'#', N'c5bee947-799e-45a8-9744-3e625be7fe50', 1, CAST(0x0000A5EE01268CC3 AS DateTime), CAST(0x0000A5EE01268CC3 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30214, 36, 2, 3, N'test', NULL, N'#', N'#', N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 1, CAST(0x0000A5FB00FB3E54 AS DateTime), CAST(0x0000A5FB00FB3E54 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30215, 35, 2, 3, N'Where is this?', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004BD1BD AS DateTime), CAST(0x0000A608004BD1BD AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30216, 35, 2, 3, N'Where is this?', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004BD212 AS DateTime), CAST(0x0000A608004BD212 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30217, 35, 2, 3, N'what is this?', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004BF0AB AS DateTime), CAST(0x0000A608004BF0AB AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30218, 35, 2, 3, N'what is this?', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004BF146 AS DateTime), CAST(0x0000A608004BF146 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30219, 35, 2, 3, N'hhhhhhh', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004C141B AS DateTime), CAST(0x0000A608004C141B AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30220, 35, 2, 3, N'hhhhhhh', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004C14B1 AS DateTime), CAST(0x0000A608004C14B1 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30221, 35, 2, 3, N'that is cool', NULL, N'#', N'~/ImageCollection/GlobalTopicsComment/Global_Comment_img_1759241290_38_16.png', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A608004C7B94 AS DateTime), CAST(0x0000A608004C7B94 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30222, 31, 2, 3, N'1', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A0078B6B7 AS DateTime), CAST(0x0000A60A0078B6B7 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30223, 31, 2, 3, N'2', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A0078BF33 AS DateTime), CAST(0x0000A60A0078BF33 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30224, 31, 2, 3, N'3', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A0078C61F AS DateTime), CAST(0x0000A60A0078C61F AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30225, 31, 2, 3, N'4', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A0078E443 AS DateTime), CAST(0x0000A60A0078E443 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30226, 31, 2, 3, N'5', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A0078F259 AS DateTime), CAST(0x0000A60A0078F259 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30227, 32, 2, 3, N'Remove upvote', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A008FF2EE AS DateTime), CAST(0x0000A60A008FF2EE AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30228, 32, 2, 3, N'Remove upvote', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A008FF389 AS DateTime), CAST(0x0000A60A008FF389 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30229, 32, 2, 3, N'you there', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A008FFF9B AS DateTime), CAST(0x0000A60A008FFF9B AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30230, 32, 2, 3, N'you there', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A00900035 AS DateTime), CAST(0x0000A60A00900035 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30231, 32, 2, 3, N'what are you doing', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A00901087 AS DateTime), CAST(0x0000A60A00901087 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30232, 32, 2, 3, N'what are you doing', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A00901121 AS DateTime), CAST(0x0000A60A00901121 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30233, 31, 2, 3, N'this is a test', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A00998A29 AS DateTime), CAST(0x0000A60A00998A29 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (30234, 31, 2, 3, N'test 2', NULL, N'#', N'#', N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, CAST(0x0000A60A0099D5A7 AS DateTime), CAST(0x0000A60A0099D5A7 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40228, 36, 2, 3, N'uio', NULL, N'#', N'#', N'99654a2d-5ae5-45a6-a080-223346509183', 1, CAST(0x0000A60F00F12694 AS DateTime), CAST(0x0000A60F00F12694 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40229, 36, 2, 3, N'uytrt', NULL, N'#', N'#', N'99654a2d-5ae5-45a6-a080-223346509183', 1, CAST(0x0000A60F00F95965 AS DateTime), CAST(0x0000A60F00F95965 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40230, 36, 2, 3, N'rhu
rr', NULL, N'#', N'#', N'99654a2d-5ae5-45a6-a080-223346509183', 1, CAST(0x0000A60F00F9618A AS DateTime), CAST(0x0000A60F00F9618A AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40231, 36, 2, 3, N'uturu
eryyyy', NULL, N'#', N'#', N'99654a2d-5ae5-45a6-a080-223346509183', 1, CAST(0x0000A60F00F96E75 AS DateTime), CAST(0x0000A60F00F96E75 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40232, 36, 2, 3, N'gjggjdf', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A6110115015F AS DateTime), CAST(0x0000A6110115015F AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40233, 36, 2, 3, N'gfjfgj', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A61101150408 AS DateTime), CAST(0x0000A61101150408 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40234, 36, 2, 3, N'jfgjfg', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A61101150619 AS DateTime), CAST(0x0000A61101150619 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40235, 36, 2, 3, N'fgj', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A61101150838 AS DateTime), CAST(0x0000A61101150838 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40236, 36, 2, 3, N'fgj', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A61101150ABB AS DateTime), CAST(0x0000A61101150ABB AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40237, 36, 2, 3, N'fgj', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A61101150D53 AS DateTime), CAST(0x0000A61101150D53 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40238, 36, 2, 3, N'test', NULL, N'#', N'#', N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 1, CAST(0x0000A6160128B374 AS DateTime), CAST(0x0000A6160128B374 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40239, 36, 2, 3, N'test', NULL, N'#', N'#', N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 1, CAST(0x0000A6160128C694 AS DateTime), CAST(0x0000A6160128C694 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40240, 36, 2, 3, N'tesrt12', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A617012A5763 AS DateTime), CAST(0x0000A617012A5763 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40241, 36, 2, 3, N'tt', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A617012CF242 AS DateTime), CAST(0x0000A617012CF242 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40242, 36, 2, 3, N'terh', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A6170132A3AF AS DateTime), CAST(0x0000A6170132A3AF AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40243, 36, 2, 3, N'rrr', NULL, N'#', N'#', N'771367e8-c767-48dc-a5ba-8e16b63c64e6', 1, CAST(0x0000A6170139D0AE AS DateTime), CAST(0x0000A6170139D0AE AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40244, 36, 2, 3, N'tttewaytey', NULL, N'#', N'#', N'16a69737-778c-4536-ba8a-f22f032f1ea9', 1, CAST(0x0000A61701401DD1 AS DateTime), CAST(0x0000A61701401DD1 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (40245, 33, 2, 3, N'very nice', NULL, N'#', N'#', N'ad5d7ea6-b36b-466b-a69a-f60a6c6e86af', 1, CAST(0x0000A61901789FDF AS DateTime), CAST(0x0000A61901789FDF AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50245, 33, 2, 3, N'test', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A672012A984B AS DateTime), CAST(0x0000A672012A984B AS DateTime))
GO
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50246, 33, 2, 3, N'Testing Purpose', 2, N'//www.youtube.com/embed/wFAhCYSiVvY', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A672012B5B69 AS DateTime), CAST(0x0000A672012B5B69 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50247, 34, 2, 3, N'testing', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A6730112CB7A AS DateTime), CAST(0x0000A6730112CB7A AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50248, 35, 2, 3, N'Testing', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A673011CC3AB AS DateTime), CAST(0x0000A673011CC3AB AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50249, 28, 2, 3, N'google.com
', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67400DC0049 AS DateTime), CAST(0x0000A67400DC0049 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50250, 34, 2, 3, N'testing', NULL, N'#', N'#', N'210ab051-e7e0-44ce-98e1-81358aacce99', 1, CAST(0x0000A678010F5EFE AS DateTime), CAST(0x0000A678010F5EFE AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50251, 34, 2, 3, N'abc', NULL, N'#', N'#', N'210ab051-e7e0-44ce-98e1-81358aacce99', 1, CAST(0x0000A678010F6FE5 AS DateTime), CAST(0x0000A678010F6FE5 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50252, 33, 2, 3, N'http://ntsb.aliansoftware.com/', NULL, N'#', N'#', N'39b8c187-b2d5-432f-b104-dbaf0a5406b7', 1, CAST(0x0000A6790012B432 AS DateTime), CAST(0x0000A6790012B432 AS DateTime))
INSERT [dbo].[Global_Topic_Comment_Details] ([PK_Global_Comment_Details_ID], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (50253, 35, 2, 3, N'https://translate.google.co.in', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67900C329E0 AS DateTime), CAST(0x0000A67900C329E0 AS DateTime))
SET IDENTITY_INSERT [dbo].[Global_Topic_Comment_Details] OFF
SET IDENTITY_INSERT [dbo].[Global_Topics_Master] ON 

INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (18, 6, 1, 1, N'Global topic 3 for testing', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_622704447_14_13.jpg', 1, 633, 1, CAST(0x0000A59C00A7150E AS DateTime), CAST(0x0000A5E700EA9E58 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (26, 7, 1, 1, N'Global topic 1 for testing', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_1456626195_13_3.jpg', 1, 652, NULL, CAST(0x0000A5A7009C5DE8 AS DateTime), CAST(0x0000A5E700EA4CA3 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (28, 1, 1, 1, N'Global topic 2 for testing', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. ', N'/ImageCollection/GlobalTopics/Global_img_495216378_13_41.jpg', 1, 189, NULL, CAST(0x0000A5AE011A656E AS DateTime), CAST(0x0000A5E700EA7940 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (29, 7, 1, 1, N'Global topic4 for testing', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_99152196_14_44.jpg', 1, 193, NULL, CAST(0x0000A5D7017428E4 AS DateTime), CAST(0x0000A5E700EAD8F8 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (30, 2, 1, 1, N'Global topic 5 for testing of Sports', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_367467425_19_18.jpg', 1, 27, NULL, CAST(0x0000A5E700EC0415 AS DateTime), CAST(0x0000A673010C1637 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (31, 11, 1, 1, N'Global topic 6 for testing of science', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_338401054_20_5.jpg', 1, 48, NULL, CAST(0x0000A5E700EC3B88 AS DateTime), CAST(0x0000A5E700EC3B88 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (32, 2, 1, 1, N'Global topic 7 for testing of Sports', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_1580529896_20_36.jpg', 1, 36, NULL, CAST(0x0000A5E700EC5F91 AS DateTime), CAST(0x0000A5E700EC5F91 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (33, 11, 1, 1, N'Global topic 8 for testing of science', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_697189305_21_37.jpg', 1, 49, NULL, CAST(0x0000A5E700ECA6AD AS DateTime), CAST(0x0000A5E700ECA6AD AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (34, 1, 1, 1, N'Global topic 9 for testing of health', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_651290036_23_22.jpg', 1, 71, NULL, CAST(0x0000A5E700ED2267 AS DateTime), CAST(0x0000A5E700ED2267 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (35, 7, 1, 1, N'Global topic 10 for testing entertainment ', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_624340171_23_59.jpg', 1, 220, NULL, CAST(0x0000A5E700ED4DAC AS DateTime), CAST(0x0000A5E700ED4DAC AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (36, 6, 1, 1, N'Woman Who Set Newborn on Fire in Road Sentenced to 30 Years', N'A New Jersey woman who set her newborn on fire and left her in the middle of a street was sentenced Friday to 30 years in prison. Hyphernkemberly Dorvilier pleaded guilty in February to aggravated manslaughter and prosecutors recommended the sentence. The 23-year-old Pemberton Township woman doused her newborn with accelerant and set her on fire in January 2015, investigators said. 

http://abcnews.go.com/US/wireStory/woman-set-newborn-fire-road-sentenced-30-years-38599846', N'/ImageCollection/GlobalTopics/Global_img_668989901_36_12.jpg', 0, 149, 1, CAST(0x0000A5F3008DC7BF AS DateTime), CAST(0x0000A66100D6E789 AS DateTime))
INSERT [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Global_Topics_Title], [Description], [Image_Path], [Active_Status], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (39, 7, 2, 1, N'Global topic for testing entertainment', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/GlobalTopics/Global_img_1815656179_39_17.jpg', 1, 10, NULL, CAST(0x0000A67B00EDD3FF AS DateTime), CAST(0x0000A67B00F180FB AS DateTime))
SET IDENTITY_INSERT [dbo].[Global_Topics_Master] OFF
SET IDENTITY_INSERT [dbo].[Global_Topics_Status_Details] ON 

INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (29, 18, 2, 3, N'5e96b424-6a8f-4f77-bad8-3991f96df25d', 0, NULL, NULL, NULL, 1, CAST(0x0000A59C00F65D98 AS DateTime), CAST(0x0000A59C00FBC016 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10037, 18, 2, 3, N'412e9288-eb96-4a39-9a4e-c0eae3726331', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A000F8547B AS DateTime), CAST(0x0000A5A000F8547B AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10040, 18, 2, 3, N'4a987740-ffe2-4cc1-9c07-1f90a7209327', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A0012B7483 AS DateTime), CAST(0x0000A5A0012B8D04 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10041, 18, 2, 3, N'20d93f25-fd2b-467c-a420-62fb67619808', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A100ABD30A AS DateTime), CAST(0x0000A5A1012D685D AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10042, 18, 0, 0, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5A100F0B254 AS DateTime), CAST(0x0000A5D3009486E9 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10043, 18, 2, 3, N'0f0bba60-cb66-4aa5-b061-5ca37eeee89b', 0, NULL, NULL, NULL, 1, CAST(0x0000A5A100F51C60 AS DateTime), CAST(0x0000A5A100F98779 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10045, 18, 2, 3, N'b8393ed0-9ec3-4208-a1e8-2b5a60b4e2f8', 0, NULL, NULL, NULL, 1, CAST(0x0000A5A10125C6B4 AS DateTime), CAST(0x0000A5A10125CDD8 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10047, 18, 2, 3, N'e7dacad3-1ee9-4dc0-bbe1-8c2350571b70', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A30134B95F AS DateTime), CAST(0x0000A5A30134B95F AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10048, 18, 2, 3, N'4fd677d7-a77f-4ca2-893a-9e42a6d17847', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A40131BD06 AS DateTime), CAST(0x0000A5A40131BD06 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10049, 18, 2, 3, N'2c88be08-3e45-402a-988d-48f8bb0e1b41', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A600E0F777 AS DateTime), CAST(0x0000A5A600ED30DA AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10050, 18, 2, 3, N'42aa6f27-c81f-46a1-b053-07ad02b808b7', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A70093EA96 AS DateTime), CAST(0x0000A5A70093EA96 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10051, 26, 2, 3, N'67d519ab-ff1b-48f8-8b18-93591d8bbcff', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A901259CF2 AS DateTime), CAST(0x0000A5A901259CF2 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10052, 18, 2, 3, N'67d519ab-ff1b-48f8-8b18-93591d8bbcff', 1, NULL, NULL, NULL, 1, CAST(0x0000A5A90125AE45 AS DateTime), CAST(0x0000A5A90125AE45 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10053, 18, 2, 3, N'cdcdaeef-2f30-4e47-8b0b-9195064dfa22', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AA009341B9 AS DateTime), CAST(0x0000A5AA009341B9 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10054, 26, 2, 3, N'9c13008a-a5ad-4049-a91d-2bfedafe4ea9', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AA009CE78D AS DateTime), CAST(0x0000A5AA009CE78D AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10055, 26, 2, 3, N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AA009D0541 AS DateTime), CAST(0x0000A5C70125B207 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10056, 18, 2, 3, N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AA009DBA2E AS DateTime), CAST(0x0000A5AA009DBA2E AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10057, 18, 2, 3, N'1adb0741-9296-4e58-869d-007803d18827', 0, NULL, NULL, NULL, 1, CAST(0x0000A5AA00DB647A AS DateTime), CAST(0x0000A5AA00E177CF AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10058, 26, 2, 3, N'1adb0741-9296-4e58-869d-007803d18827', 0, NULL, NULL, NULL, 1, CAST(0x0000A5AA00E1644E AS DateTime), CAST(0x0000A5AA00E18155 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10059, 26, 2, 3, N'5c636cae-e92c-423e-8c8d-bef6ff2eb576', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AA01220B2D AS DateTime), CAST(0x0000A5AA01220ECB AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10060, 18, 2, 3, N'5c636cae-e92c-423e-8c8d-bef6ff2eb576', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AE00F71B01 AS DateTime), CAST(0x0000A5C9010C9D89 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10061, 28, 2, 3, N'c9951f6c-8674-4263-be7b-1009cbd067bc', 1, NULL, NULL, NULL, 1, CAST(0x0000A5AF00D30ECE AS DateTime), CAST(0x0000A5AF00D30ECE AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10062, 18, 2, 3, N'c70aa5eb-232d-4f93-b531-8c22ecd580a3', 1, NULL, NULL, NULL, 1, CAST(0x0000A5B000B9A4E5 AS DateTime), CAST(0x0000A5B000B9A4E5 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10063, 28, 2, 3, N'c6724052-43e2-45c9-b72f-63b57dd923ae', 1, NULL, NULL, NULL, 1, CAST(0x0000A5B0012383B2 AS DateTime), CAST(0x0000A5B0012383B2 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10064, 26, 2, 3, N'a3d030e5-edff-4194-a2b7-92a4eefa66c0', 1, NULL, NULL, NULL, 1, CAST(0x0000A5B400FB3777 AS DateTime), CAST(0x0000A5B400FB3777 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10065, 28, 2, 3, N'a3d030e5-edff-4194-a2b7-92a4eefa66c0', 0, NULL, NULL, NULL, 1, CAST(0x0000A5B400FBA013 AS DateTime), CAST(0x0000A5B400FBA013 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10066, 18, 2, 3, N'a3d030e5-edff-4194-a2b7-92a4eefa66c0', 1, NULL, NULL, NULL, 1, CAST(0x0000A5B400FC90C1 AS DateTime), CAST(0x0000A5B400FC90C1 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10067, 28, 2, 3, N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, NULL, NULL, NULL, 1, CAST(0x0000A5C9008FBCEA AS DateTime), CAST(0x0000A5C9008FBCEA AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10068, 26, 2, 3, N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, NULL, NULL, NULL, 1, CAST(0x0000A5C9008FC812 AS DateTime), CAST(0x0000A5E50120E334 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10069, 18, 2, 3, N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, NULL, NULL, NULL, 1, CAST(0x0000A5C9008FD3AE AS DateTime), CAST(0x0000A5C9008FD3AE AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10070, 28, 2, 3, N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 0, NULL, NULL, NULL, 1, CAST(0x0000A5DA0093EB80 AS DateTime), CAST(0x0000A5DF012858A7 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10071, 28, 0, 0, NULL, 0, NULL, NULL, NULL, 1, CAST(0x0000A5DE000FD433 AS DateTime), CAST(0x0000A5DE000FDDBB AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10072, 29, 2, 3, N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 0, NULL, NULL, NULL, 1, CAST(0x0000A5DF012919B0 AS DateTime), CAST(0x0000A5DF01291D96 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10073, 29, 2, 3, N'3c10f598-ab29-4414-9940-9e9ebaef684b', 1, NULL, NULL, NULL, 1, CAST(0x0000A5E2010CF8E9 AS DateTime), CAST(0x0000A5E2010CF8E9 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10074, 29, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5E501210145 AS DateTime), CAST(0x0000A5E501210145 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10075, 28, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5E501210C9B AS DateTime), CAST(0x0000A5E501210C9B AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10076, 18, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5E501211087 AS DateTime), CAST(0x0000A5E501211087 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10077, 35, 2, 3, N'c5bee947-799e-45a8-9744-3e625be7fe50', 1, NULL, NULL, NULL, 1, CAST(0x0000A5E7012A04FF AS DateTime), CAST(0x0000A5E7012A04FF AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10078, 32, 2, 3, N'f5f142b8-76c2-4f4a-a2d3-25d6eaa5fd41', 1, NULL, NULL, NULL, 1, CAST(0x0000A5E7016224CF AS DateTime), CAST(0x0000A5E7016224CF AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10079, 18, 2, 3, N'f5f142b8-76c2-4f4a-a2d3-25d6eaa5fd41', 0, NULL, NULL, NULL, 1, CAST(0x0000A5E701625D0D AS DateTime), CAST(0x0000A5E7016279F8 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10080, 26, 2, 3, N'f5f142b8-76c2-4f4a-a2d3-25d6eaa5fd41', 0, NULL, NULL, NULL, 1, CAST(0x0000A5E7016285C3 AS DateTime), CAST(0x0000A5E701680AB1 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10081, 31, 2, 3, N'f5f142b8-76c2-4f4a-a2d3-25d6eaa5fd41', 1, NULL, NULL, NULL, 1, CAST(0x0000A5E70166DEAC AS DateTime), CAST(0x0000A5E70166DEAC AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10082, 33, 2, 3, N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, NULL, NULL, NULL, 1, CAST(0x0000A5E800FC4FB2 AS DateTime), CAST(0x0000A5E901089B55 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10083, 26, 2, 3, N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, NULL, NULL, NULL, 1, CAST(0x0000A5E80100D95B AS DateTime), CAST(0x0000A5E80100DBA7 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10084, 35, 26, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5E80107E1DE AS DateTime), CAST(0x0000A5E80107E1DE AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10085, 34, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5E8012A3C39 AS DateTime), CAST(0x0000A5E8012A3C39 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10086, 35, 27, 2, NULL, 1, NULL, NULL, NULL, 1, CAST(0x0000A5E8012A4582 AS DateTime), CAST(0x0000A5E8012A4582 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10087, 33, 2, 3, N'5b7b282f-ff11-4bc9-ae16-a2b2e6099aad', 1, NULL, NULL, NULL, 1, CAST(0x0000A5EA00E524C0 AS DateTime), CAST(0x0000A5EA00E524C0 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10088, 35, 2, 3, N'2ad39c39-ec58-4c9c-b30e-35f8c39a359e', 1, NULL, NULL, NULL, 1, CAST(0x0000A5EE011149B7 AS DateTime), CAST(0x0000A5EE011149B7 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10089, 30, 2, 3, N'c5bee947-799e-45a8-9744-3e625be7fe50', 1, NULL, NULL, NULL, 1, CAST(0x0000A5FE00FDC285 AS DateTime), CAST(0x0000A5FE00FDC285 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10090, 35, 2, 3, N'04502393-c867-4e25-99d1-a14b8c4b96f6', 1, NULL, NULL, NULL, 1, CAST(0x0000A60A0079C202 AS DateTime), CAST(0x0000A60A0079C8B8 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10091, 35, 2, 3, N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 0, NULL, NULL, NULL, 1, CAST(0x0000A60F011B4E94 AS DateTime), CAST(0x0000A60F011B8D7A AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10092, 35, 2, 3, N'9c46f2c6-8b48-42bf-920c-d266bc9270a7', 0, NULL, NULL, NULL, 1, CAST(0x0000A60F011BA3F7 AS DateTime), CAST(0x0000A60F011BA3F7 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10093, 32, 2, 3, N'99654a2d-5ae5-45a6-a080-223346509183', 0, NULL, NULL, NULL, 1, CAST(0x0000A61000B90EEC AS DateTime), CAST(0x0000A613012F70C7 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10094, 35, 2, 3, N'99654a2d-5ae5-45a6-a080-223346509183', 1, NULL, NULL, NULL, 1, CAST(0x0000A61000B941ED AS DateTime), CAST(0x0000A61000B941ED AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10095, 36, 2, 3, N'99654a2d-5ae5-45a6-a080-223346509183', 1, NULL, NULL, NULL, 1, CAST(0x0000A61000BA0647 AS DateTime), CAST(0x0000A61301315D10 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10096, 32, 2, 3, N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 0, NULL, NULL, NULL, 1, CAST(0x0000A6120109FD0B AS DateTime), CAST(0x0000A6120109FD0B AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10097, 36, 2, 3, N'4bc344c1-b2bb-4ceb-b3d5-d73e95cc0e04', 0, NULL, NULL, NULL, 1, CAST(0x0000A612010A264A AS DateTime), CAST(0x0000A612010A264A AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10098, 34, 2, 3, N'c7ec196b-3ea6-4d45-b46d-e0800fa7dfca', 1, NULL, NULL, NULL, 1, CAST(0x0000A619013FC261 AS DateTime), CAST(0x0000A619013FCB26 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10099, 33, 2, 3, N'ad5d7ea6-b36b-466b-a69a-f60a6c6e86af', 0, NULL, NULL, NULL, 1, CAST(0x0000A619017879E6 AS DateTime), CAST(0x0000A61901787EA0 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10100, 33, 2, 3, N'c7ec196b-3ea6-4d45-b46d-e0800fa7dfca', 0, NULL, NULL, NULL, 1, CAST(0x0000A62A0012A073 AS DateTime), CAST(0x0000A62A0012AEB7 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20098, 30, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, 1, CAST(0x0000A67200B26E55 AS DateTime), CAST(0x0000A67200B270A5 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20099, 35, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, 1, CAST(0x0000A67200B2959C AS DateTime), CAST(0x0000A67800DD662F AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20100, 35, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, 1, CAST(0x0000A67200BACA4A AS DateTime), CAST(0x0000A67200BCAEE9 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20101, 34, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, NULL, NULL, NULL, 1, CAST(0x0000A67200BC931C AS DateTime), CAST(0x0000A67200BC9C78 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20102, 32, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, 1, CAST(0x0000A67200BCA04A AS DateTime), CAST(0x0000A67200BCA2C9 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20103, 32, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 0, NULL, NULL, NULL, 1, CAST(0x0000A67301169674 AS DateTime), CAST(0x0000A674011F005E AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20104, 32, 2, 3, N'b595aeb9-9b30-4285-956f-7ae55ea08124', 1, NULL, NULL, NULL, 1, CAST(0x0000A678014A15CA AS DateTime), CAST(0x0000A678014A15CA AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20105, 33, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, 1, CAST(0x0000A67A00C01F64 AS DateTime), CAST(0x0000A67A00C022DB AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20106, 39, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, 1, CAST(0x0000A67B00F195CA AS DateTime), CAST(0x0000A67B00F19681 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20107, 31, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, 1, CAST(0x0000A67C00BCDE2C AS DateTime), CAST(0x0000A67C00BCE250 AS DateTime))
INSERT [dbo].[Global_Topics_Status_Details] ([PK_Global_Topics_Status_Details], [FK_Global_Topics_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (20108, 39, 2, 3, N'4ae2688f-7c09-40b8-81c0-063432fa0a23', 1, NULL, NULL, NULL, 1, CAST(0x0000A68700F4FF9C AS DateTime), CAST(0x0000A68700F4FF9C AS DateTime))
SET IDENTITY_INSERT [dbo].[Global_Topics_Status_Details] OFF
SET IDENTITY_INSERT [dbo].[Role_Master] ON 

INSERT [dbo].[Role_Master] ([PK_Role_Id], [Role_Name], [Active_Status], [Created_Date]) VALUES (1, N'Admin', 1, CAST(0x0000A59100000000 AS DateTime))
INSERT [dbo].[Role_Master] ([PK_Role_Id], [Role_Name], [Active_Status], [Created_Date]) VALUES (2, N'User', 1, CAST(0x0000A59100000000 AS DateTime))
INSERT [dbo].[Role_Master] ([PK_Role_Id], [Role_Name], [Active_Status], [Created_Date]) VALUES (3, N'Guest_User', 1, CAST(0x0000A59100000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[Role_Master] OFF
SET IDENTITY_INSERT [dbo].[State_Master] ON 

INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1, 1, N'Badakhshan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2, 1, N'Badghis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3, 1, N'Baghlan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4, 1, N'Balkh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5, 1, N'Bamian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (6, 1, N'Farah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (7, 1, N'Faryab', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (8, 1, N'Ghazni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (9, 1, N'Ghowr', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (10, 1, N'Helmand', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (11, 1, N'Herat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (12, 1, N'Jowzjan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (13, 1, N'Kabol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (14, 1, N'Kandahar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (15, 1, N'Kapisa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (16, 1, N'Konar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (17, 1, N'Kondoz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (18, 1, N'Laghman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (19, 1, N'Lowgar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (20, 1, N'Nangarhar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (21, 1, N'Nimruz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (22, 1, N'Oruzgan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (23, 1, N'Paktia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (24, 1, N'Paktika', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (25, 1, N'Parvan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (26, 1, N'Samangan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (27, 1, N'Sar-e Pol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (28, 1, N'Takhar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (29, 1, N'Vardak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (30, 1, N'Zabol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (31, 2, N'Berat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (32, 2, N'Bulqize', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (33, 2, N'Delvine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (34, 2, N'Devoll (Bilisht)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (35, 2, N'Diber (Peshkopi)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (36, 2, N'Durres', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (37, 2, N'Elbasan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (38, 2, N'Fier', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (39, 2, N'Gjirokaster', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (40, 2, N'Gramsh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (41, 2, N'Has (Krume)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (42, 2, N'Kavaje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (43, 2, N'Kolonje (Erseke)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (44, 2, N'Korce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (45, 2, N'Kruje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (46, 2, N'Kucove', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (47, 2, N'Kukes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (48, 2, N'Kurbin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (49, 2, N'Lezhe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (50, 2, N'Librazhd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (51, 2, N'Lushnje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (52, 2, N'Malesi e Madhe (Koplik)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (53, 2, N'Mallakaster (Ballsh)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (54, 2, N'Mat (Burrel)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (55, 2, N'Mirdite (Rreshen)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (56, 2, N'Peqin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (57, 2, N'Permet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (58, 2, N'Pogradec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (59, 2, N'Puke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (60, 2, N'Sarande', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (61, 2, N'Shkoder', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (62, 2, N'Skrapar (Corovode)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (63, 2, N'Tepelene', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (64, 2, N'Tirane (Tirana)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (65, 2, N'Tirane (Tirana)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (66, 2, N'Tropoje (Bajram Curri)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (67, 2, N'Vlore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (68, 3, N'Adrar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (69, 3, N'Ain Defla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (70, 3, N'Ain Temouchent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (71, 3, N'Alger', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (72, 3, N'Annaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (73, 3, N'Batna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (74, 3, N'Bechar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (75, 3, N'Bejaia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (76, 3, N'Biskra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (77, 3, N'Blida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (78, 3, N'Bordj Bou Arreridj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (79, 3, N'Bouira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (80, 3, N'Boumerdes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (81, 3, N'Chlef', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (82, 3, N'Constantine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (83, 3, N'Djelfa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (84, 3, N'El Bayadh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (85, 3, N'El Oued', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (86, 3, N'El Tarf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (87, 3, N'Ghardaia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (88, 3, N'Guelma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (89, 3, N'Illizi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (90, 3, N'Jijel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (91, 3, N'Khenchela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (92, 3, N'Laghouat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (93, 3, N'M''Sila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (94, 3, N'Mascara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (95, 3, N'Medea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (96, 3, N'Mila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (97, 3, N'Mostaganem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (98, 3, N'Naama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (99, 3, N'Oran', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (100, 3, N'Ouargla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (101, 3, N'Oum el Bouaghi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (102, 3, N'Relizane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (103, 3, N'Saida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (104, 3, N'Setif', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (105, 3, N'Sidi Bel Abbes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (106, 3, N'Skikda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (107, 3, N'Souk Ahras', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (108, 3, N'Tamanghasset', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (109, 3, N'Tebessa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (110, 3, N'Tiaret', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (111, 3, N'Tindouf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (112, 3, N'Tipaza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (113, 3, N'Tissemsilt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (114, 3, N'Tizi Ouzou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (115, 3, N'Tlemcen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (116, 4, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (117, 4, N'Manu''a', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (118, 4, N'Rose Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (119, 4, N'Swains Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (120, 4, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (121, 5, N'Andorra la Vella', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (122, 5, N'Bengo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (123, 5, N'Benguela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (124, 5, N'Bie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (125, 5, N'Cabinda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (126, 5, N'Canillo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (127, 5, N'Cuando Cubango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (128, 5, N'Cuanza Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (129, 5, N'Cuanza Sul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (130, 5, N'Cunene', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (131, 5, N'Encamp', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (132, 5, N'Escaldes-Engordany', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (133, 5, N'Huambo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (134, 5, N'Huila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (135, 5, N'La Massana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (136, 5, N'Luanda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (137, 5, N'Lunda Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (138, 5, N'Lunda Sul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (139, 5, N'Malanje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (140, 5, N'Moxico', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (141, 5, N'Namibe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (142, 5, N'Ordino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (143, 5, N'Sant Julia de Loria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (144, 5, N'Uige', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (145, 5, N'Zaire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (146, 6, N'Anguilla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (147, 7, N'Antartica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (148, 8, N'Barbuda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (149, 8, N'Redonda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (150, 8, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (151, 8, N'Saint John', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (152, 8, N'Saint Mary', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (153, 8, N'Saint Paul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (154, 8, N'Saint Peter', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (155, 8, N'Saint Philip', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (156, 9, N'Antartica e Islas del Atlantico Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (157, 9, N'Buenos Aires', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (158, 9, N'Buenos Aires Capital Federal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (159, 9, N'Catamarca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (160, 9, N'Chaco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (161, 9, N'Chubut', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (162, 9, N'Cordoba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (163, 9, N'Corrientes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (164, 9, N'Entre Rios', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (165, 9, N'Formosa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (166, 9, N'Jujuy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (167, 9, N'La Pampa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (168, 9, N'La Rioja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (169, 9, N'Mendoza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (170, 9, N'Misiones', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (171, 9, N'Neuquen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (172, 9, N'Rio Negro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (173, 9, N'Salta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (174, 9, N'San Juan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (175, 9, N'San Luis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (176, 9, N'Santa Cruz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (177, 9, N'Santa Fe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (178, 9, N'Santiago del Estero', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (179, 9, N'Tierra del Fuego', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (180, 9, N'Tucuman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (181, 10, N'Aragatsotn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (182, 10, N'Ararat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (183, 10, N'Armavir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (184, 10, N'Geghark''unik''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (185, 10, N'Kotayk''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (186, 10, N'Lorri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (187, 10, N'Shirak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (188, 10, N'Syunik''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (189, 10, N'Tavush', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (190, 10, N'Vayots'' Dzor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (191, 10, N'Yerevan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (192, 11, N'Aruba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (193, 12, N'Ashmore and Cartier Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (194, 13, N'Australian Capital Territory', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (195, 13, N'New South Wales', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (196, 13, N'Northern Territory', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (197, 13, N'Queensland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (198, 13, N'South Australia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (199, 13, N'Tasmania', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (200, 13, N'Victoria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (201, 13, N'Western Australia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (238, 14, N'Burgenland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (239, 14, N'Kaernten', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (240, 14, N'Niederoesterreich', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (241, 14, N'Oberoesterreich', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (242, 14, N'Salzburg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (243, 14, N'Steiermark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (244, 14, N'Tirol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (245, 14, N'Vorarlberg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (246, 14, N'Wien', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (247, 15, N'Abseron Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (248, 15, N'Agcabadi Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (249, 15, N'Agdam Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (250, 15, N'Agdas Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (251, 15, N'Agstafa Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (252, 15, N'Agsu Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (253, 15, N'Ali Bayramli Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (254, 15, N'Astara Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (255, 15, N'Baki Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (256, 15, N'Balakan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (257, 15, N'Barda Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (258, 15, N'Beylaqan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (259, 15, N'Bilasuvar Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (260, 15, N'Cabrayil Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (261, 15, N'Calilabad Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (262, 15, N'Daskasan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (263, 15, N'Davaci Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (264, 15, N'Fuzuli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (265, 15, N'Gadabay Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (266, 15, N'Ganca Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (267, 15, N'Goranboy Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (268, 15, N'Goycay Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (269, 15, N'Haciqabul Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (270, 15, N'Imisli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (271, 15, N'Ismayilli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (272, 15, N'Kalbacar Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (273, 15, N'Kurdamir Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (274, 15, N'Lacin Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (275, 15, N'Lankaran Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (276, 15, N'Lankaran Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (277, 15, N'Lerik Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (278, 15, N'Masalli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (279, 15, N'Mingacevir Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (280, 15, N'Naftalan Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (281, 15, N'Naxcivan Muxtar Respublikasi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (282, 15, N'Neftcala Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (283, 15, N'Oguz Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (284, 15, N'Qabala Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (285, 15, N'Qax Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (286, 15, N'Qazax Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (287, 15, N'Qobustan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (288, 15, N'Quba Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (289, 15, N'Qubadli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (290, 15, N'Qusar Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (291, 15, N'Saatli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (292, 15, N'Sabirabad Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (293, 15, N'Saki Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (294, 15, N'Saki Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (295, 15, N'Salyan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (296, 15, N'Samaxi Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (297, 15, N'Samkir Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (298, 15, N'Samux Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (299, 15, N'Siyazan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (300, 15, N'Sumqayit Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (301, 15, N'Susa Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (302, 15, N'Susa Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (303, 15, N'Tartar Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (304, 15, N'Tovuz Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (305, 15, N'Ucar Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (306, 15, N'Xacmaz Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (307, 15, N'Xankandi Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (308, 15, N'Xanlar Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (309, 15, N'Xizi Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (310, 15, N'Xocali Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (311, 15, N'Xocavand Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (312, 15, N'Yardimli Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (313, 15, N'Yevlax Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (314, 15, N'Yevlax Sahari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (315, 15, N'Zangilan Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (316, 15, N'Zaqatala Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (317, 15, N'Zardab Rayonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (318, 16, N'Acklins and Crooked Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (319, 16, N'Bimini', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (320, 16, N'Cat Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (321, 16, N'Exuma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (322, 16, N'Freeport', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (323, 16, N'Fresh Creek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (324, 16, N'Governor''s Harbour', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (325, 16, N'Green Turtle Cay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (326, 16, N'Harbour Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (327, 16, N'High Rock', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (328, 16, N'Inagua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (329, 16, N'Kemps Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (330, 16, N'Long Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (331, 16, N'Marsh Harbour', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (332, 16, N'Mayaguana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (333, 16, N'New Providence', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (334, 16, N'Nicholls Town and Berry Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (335, 16, N'Ragged Island', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (336, 16, N'Rock Sound', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (337, 16, N'San Salvador and Rum Cay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (338, 16, N'Sandy Point', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (339, 17, N'Al Hadd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (340, 17, N'Al Manamah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (341, 17, N'Al Mintaqah al Gharbiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (342, 17, N'Al Mintaqah al Wusta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (343, 17, N'Al Mintaqah ash Shamaliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (344, 17, N'Al Muharraq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (345, 17, N'Ar Rifa'' wa al Mintaqah al Janubiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (346, 17, N'Jidd Hafs', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (347, 17, N'Juzur Hawar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (348, 17, N'Madinat ''Isa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (349, 17, N'Madinat Hamad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (350, 17, N'Sitrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (351, 18, N'Barguna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (352, 18, N'Barisal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (353, 18, N'Bhola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (354, 18, N'Jhalokati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (355, 18, N'Patuakhali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (356, 18, N'Pirojpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (357, 18, N'Bandarban', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (358, 18, N'Brahmanbaria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (359, 18, N'Chandpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (360, 18, N'Chittagong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (361, 18, N'Comilla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (362, 18, N'Cox''s Bazar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (363, 18, N'Feni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (364, 18, N'Khagrachari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (365, 18, N'Lakshmipur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (366, 18, N'Noakhali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (367, 18, N'Rangamati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (368, 18, N'Dhaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (369, 18, N'Faridpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (370, 18, N'Gazipur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (371, 18, N'Gopalganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (372, 18, N'Jamalpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (373, 18, N'Kishoreganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (374, 18, N'Madaripur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (375, 18, N'Manikganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (376, 18, N'Munshiganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (377, 18, N'Mymensingh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (378, 18, N'Narayanganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (379, 18, N'Narsingdi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (380, 18, N'Netrokona', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (381, 18, N'Rajbari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (382, 18, N'Shariatpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (383, 18, N'Sherpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (384, 18, N'Tangail', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (385, 18, N'Bagerhat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (386, 18, N'Chuadanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (387, 18, N'Jessore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (388, 18, N'Jhenaidah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (389, 18, N'Khulna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (390, 18, N'Kushtia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (391, 18, N'Magura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (392, 18, N'Meherpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (393, 18, N'Narail', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (394, 18, N'Satkhira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (395, 18, N'Bogra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (396, 18, N'Dinajpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (397, 18, N'Gaibandha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (398, 18, N'Jaipurhat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (399, 18, N'Kurigram', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (400, 18, N'Lalmonirhat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (401, 18, N'Naogaon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (402, 18, N'Natore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (403, 18, N'Nawabganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (404, 18, N'Nilphamari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (405, 18, N'Pabna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (406, 18, N'Panchagarh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (407, 18, N'Rajshahi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (408, 18, N'Rangpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (409, 18, N'Sirajganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (410, 18, N'Thakurgaon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (411, 18, N'Habiganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (412, 18, N'Maulvi bazar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (413, 18, N'Sunamganj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (414, 18, N'Sylhet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (415, 19, N'Bridgetown', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (416, 19, N'Christ Church', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (417, 19, N'Saint Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (418, 19, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (419, 19, N'Saint James', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (420, 19, N'Saint John', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (421, 19, N'Saint Joseph', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (422, 19, N'Saint Lucy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (423, 19, N'Saint Michael', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (424, 19, N'Saint Peter', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (425, 19, N'Saint Philip', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (426, 19, N'Saint Thomas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (427, 20, N'Brestskaya (Brest)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (428, 20, N'Homyel''skaya (Homyel'')', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (429, 20, N'Horad Minsk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (430, 20, N'Hrodzyenskaya (Hrodna)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (431, 20, N'Mahilyowskaya (Mahilyow)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (432, 20, N'Minskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (433, 20, N'Vitsyebskaya (Vitsyebsk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (434, 21, N'Antwerpen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (435, 21, N'Brabant Wallon', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (436, 21, N'Brussels Capitol Region', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (437, 21, N'Hainaut', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (438, 21, N'Liege', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (439, 21, N'Limburg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (440, 21, N'Luxembourg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (441, 21, N'Namur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (442, 21, N'Oost-Vlaanderen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (443, 21, N'Vlaams Brabant', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (444, 21, N'West-Vlaanderen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (445, 22, N'Belize', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (446, 22, N'Cayo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (447, 22, N'Corozal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (448, 22, N'Orange Walk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (449, 22, N'Stann Creek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (450, 22, N'Toledo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (451, 23, N'Alibori', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (452, 23, N'Atakora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (453, 23, N'Atlantique', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (454, 23, N'Borgou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (455, 23, N'Collines', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (456, 23, N'Couffo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (457, 23, N'Donga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (458, 23, N'Littoral', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (459, 23, N'Mono', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (460, 23, N'Oueme', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (461, 23, N'Plateau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (462, 23, N'Zou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (463, 24, N'Devonshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (464, 24, N'Hamilton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (465, 24, N'Hamilton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (466, 24, N'Paget', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (467, 24, N'Pembroke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (468, 24, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (469, 24, N'Saint Georges', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (470, 24, N'Sandys', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (471, 24, N'Smiths', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (472, 24, N'Southampton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (473, 24, N'Warwick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (474, 25, N'Bumthang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (475, 25, N'Chhukha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (476, 25, N'Chirang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (477, 25, N'Daga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (478, 25, N'Geylegphug', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (479, 25, N'Ha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (480, 25, N'Lhuntshi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (481, 25, N'Mongar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (482, 25, N'Paro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (483, 25, N'Pemagatsel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (484, 25, N'Punakha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (485, 25, N'Samchi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (486, 25, N'Samdrup Jongkhar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (487, 25, N'Shemgang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (488, 25, N'Tashigang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (489, 25, N'Thimphu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (490, 25, N'Tongsa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (491, 25, N'Wangdi Phodrang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (492, 26, N'Beni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (493, 26, N'Chuquisaca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (494, 26, N'Cochabamba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (495, 26, N'La Paz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (496, 26, N'Oruro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (497, 26, N'Pando', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (498, 26, N'Potosi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (499, 26, N'Santa Cruz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (500, 26, N'Tarija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (501, 27, N'Federation of Bosnia and Herzegovina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (502, 27, N'Republika Srpska', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (503, 28, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (504, 28, N'Chobe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (505, 28, N'Francistown', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (506, 28, N'Gaborone', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (507, 28, N'Ghanzi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (508, 28, N'Kgalagadi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (509, 28, N'Kgatleng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (510, 28, N'Kweneng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (511, 28, N'Lobatse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (512, 28, N'Ngamiland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (513, 28, N'North-East', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (514, 28, N'Selebi-Pikwe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (515, 28, N'South-East', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (516, 28, N'Southern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (517, 29, N'Acre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (518, 29, N'Alagoas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (519, 29, N'Amapa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (520, 29, N'Amazonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (521, 29, N'Bahia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (522, 29, N'Ceara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (523, 29, N'Distrito Federal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (524, 29, N'Espirito Santo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (525, 29, N'Goias', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (526, 29, N'Maranhao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (527, 29, N'Mato Grosso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (528, 29, N'Mato Grosso do Sul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (529, 29, N'Minas Gerais', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (530, 29, N'Para', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (531, 29, N'Paraiba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (532, 29, N'Parana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (533, 29, N'Pernambuco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (534, 29, N'Piaui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (535, 29, N'Rio de Janeiro', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (536, 29, N'Rio Grande do Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (537, 29, N'Rio Grande do Sul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (538, 29, N'Rondonia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (539, 29, N'Roraima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (540, 29, N'Santa Catarina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (541, 29, N'Sao Paulo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (542, 29, N'Sergipe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (543, 29, N'Tocantins', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (544, 30, N'Anegada', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (545, 30, N'Jost Van Dyke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (546, 30, N'Tortola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (547, 30, N'Virgin Gorda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (548, 31, N'Belait', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (549, 31, N'Brunei and Muara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (550, 31, N'Temburong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (551, 31, N'Tutong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (552, 32, N'Blagoevgrad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (553, 32, N'Burgas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (554, 32, N'Dobrich', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (555, 32, N'Gabrovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (556, 32, N'Khaskovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (557, 32, N'Kurdzhali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (558, 32, N'Kyustendil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (559, 32, N'Lovech', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (560, 32, N'Montana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (561, 32, N'Pazardzhik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (562, 32, N'Pernik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (563, 32, N'Pleven', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (564, 32, N'Plovdiv', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (565, 32, N'Razgrad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (566, 32, N'Ruse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (567, 32, N'Shumen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (568, 32, N'Silistra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (569, 32, N'Sliven', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (570, 32, N'Smolyan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (571, 32, N'Sofiya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (572, 32, N'Sofiya-Grad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (573, 32, N'Stara Zagora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (574, 32, N'Turgovishte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (575, 32, N'Varna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (576, 32, N'Veliko Turnovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (577, 32, N'Vidin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (578, 32, N'Vratsa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (579, 32, N'Yambol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (580, 33, N'Bale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (581, 33, N'Bam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (582, 33, N'Banwa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (583, 33, N'Bazega', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (584, 33, N'Bougouriba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (585, 33, N'Boulgou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (586, 33, N'Boulkiemde', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (587, 33, N'Comoe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (588, 33, N'Ganzourgou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (589, 33, N'Gnagna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (590, 33, N'Gourma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (591, 33, N'Houet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (592, 33, N'Ioba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (593, 33, N'Kadiogo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (594, 33, N'Kenedougou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (595, 33, N'Komandjari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (596, 33, N'Kompienga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (597, 33, N'Kossi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (598, 33, N'Koupelogo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (599, 33, N'Kouritenga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (600, 33, N'Kourweogo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (601, 33, N'Leraba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (602, 33, N'Loroum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (603, 33, N'Mouhoun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (604, 33, N'Nahouri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (605, 33, N'Namentenga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (606, 33, N'Naumbiel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (607, 33, N'Nayala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (608, 33, N'Oubritenga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (609, 33, N'Oudalan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (610, 33, N'Passore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (611, 33, N'Poni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (612, 33, N'Samentenga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (613, 33, N'Sanguie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (614, 33, N'Seno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (615, 33, N'Sissili', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (616, 33, N'Soum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (617, 33, N'Sourou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (618, 33, N'Tapoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (619, 33, N'Tuy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (620, 33, N'Yagha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (621, 33, N'Yatenga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (622, 33, N'Ziro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (623, 33, N'Zondomo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (624, 33, N'Zoundweogo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (625, 34, N'Ayeyarwady', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (626, 34, N'Bago', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (627, 34, N'Chin State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (628, 34, N'Kachin State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (629, 34, N'Kayah State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (630, 34, N'Kayin State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (631, 34, N'Magway', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (632, 34, N'Mandalay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (633, 34, N'Mon State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (634, 34, N'Rakhine State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (635, 34, N'Sagaing', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (636, 34, N'Shan State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (637, 34, N'Tanintharyi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (638, 34, N'Yangon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (639, 35, N'Bubanza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (640, 35, N'Bujumbura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (641, 35, N'Bururi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (642, 35, N'Cankuzo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (643, 35, N'Cibitoke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (644, 35, N'Gitega', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (645, 35, N'Karuzi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (646, 35, N'Kayanza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (647, 35, N'Kirundo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (648, 35, N'Makamba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (649, 35, N'Muramvya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (650, 35, N'Muyinga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (651, 35, N'Mwaro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (652, 35, N'Ngozi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (653, 35, N'Rutana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (654, 35, N'Ruyigi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (655, 36, N'Banteay Mean Cheay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (656, 36, N'Batdambang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (657, 36, N'Kampong Cham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (658, 36, N'Kampong Chhnang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (659, 36, N'Kampong Spoe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (660, 36, N'Kampong Thum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (661, 36, N'Kampot', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (662, 36, N'Kandal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (663, 36, N'Kaoh Kong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (664, 36, N'Keb', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (665, 36, N'Kracheh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (666, 36, N'Mondol Kiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (667, 36, N'Otdar Mean Cheay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (668, 36, N'Pailin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (669, 36, N'Phnum Penh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (670, 36, N'Pouthisat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (671, 36, N'Preah Seihanu (Sihanoukville)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (672, 36, N'Preah Vihear', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (673, 36, N'Prey Veng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (674, 36, N'Rotanah Kiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (675, 36, N'Siem Reab', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (676, 36, N'Stoeng Treng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (677, 36, N'Svay Rieng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (678, 36, N'Takev', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (679, 37, N'Adamaoua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (680, 37, N'Centre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (681, 37, N'Est', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (682, 37, N'Extreme-Nord', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (683, 37, N'Littoral', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (684, 37, N'Nord', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (685, 37, N'Nord-Ouest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (686, 37, N'Ouest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (687, 37, N'Sud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (688, 37, N'Sud-Ouest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (689, 38, N'Alberta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (690, 38, N'British Columbia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (691, 38, N'Manitoba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (692, 38, N'New Brunswick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (693, 38, N'Newfoundland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (694, 38, N'Northwest Territories', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (695, 38, N'Nova Scotia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (696, 38, N'Nunavut', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (697, 38, N'Ontario', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (698, 38, N'Prince Edward Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (699, 38, N'Quebec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (700, 38, N'Saskatchewan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (701, 38, N'Yukon Territory', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (702, 39, N'Boa Vista', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (703, 39, N'Brava', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (704, 39, N'Maio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (705, 39, N'Mosteiros', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (706, 39, N'Paul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (707, 39, N'Porto Novo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (708, 39, N'Praia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (709, 39, N'Ribeira Grande', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (710, 39, N'Sal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (711, 39, N'Santa Catarina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (712, 39, N'Santa Cruz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (713, 39, N'Sao Domingos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (714, 39, N'Sao Filipe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (715, 39, N'Sao Nicolau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (716, 39, N'Sao Vicente', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (717, 39, N'Tarrafal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (718, 40, N'Creek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (719, 40, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (720, 40, N'Midland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (721, 40, N'South Town', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (722, 40, N'Spot Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (723, 40, N'Stake Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (724, 40, N'West End', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (725, 40, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (726, 41, N'Bamingui-Bangoran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (727, 41, N'Bangui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (728, 41, N'Basse-Kotto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (729, 41, N'Gribingui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (730, 41, N'Haut-Mbomou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (731, 41, N'Haute-Kotto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (732, 41, N'Haute-Sangha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (733, 41, N'Kemo-Gribingui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (734, 41, N'Lobaye', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (735, 41, N'Mbomou', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (736, 41, N'Nana-Mambere', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (737, 41, N'Ombella-Mpoko', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (738, 41, N'Ouaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (739, 41, N'Ouham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (740, 41, N'Ouham-Pende', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (741, 41, N'Sangha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (742, 41, N'Vakaga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (743, 42, N'Batha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (744, 42, N'Biltine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (745, 42, N'Borkou-Ennedi-Tibesti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (746, 42, N'Chari-Baguirmi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (747, 42, N'Guera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (748, 42, N'Kanem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (749, 42, N'Lac', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (750, 42, N'Logone Occidental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (751, 42, N'Logone Oriental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (752, 42, N'Mayo-Kebbi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (753, 42, N'Moyen-Chari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (754, 42, N'Ouaddai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (755, 42, N'Salamat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (756, 42, N'Tandjile', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (757, 43, N'Aisen del General Carlos Ibanez del Campo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (758, 43, N'Antofagasta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (759, 43, N'Araucania', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (760, 43, N'Atacama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (761, 43, N'Bio-Bio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (762, 43, N'Coquimbo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (763, 43, N'Libertador General Bernardo O''Higgins', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (764, 43, N'Los Lagos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (765, 43, N'Magallanes y de la Antartica Chilena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (766, 43, N'Maule', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (767, 43, N'Region Metropolitana (Santiago)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (768, 43, N'Tarapaca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (769, 43, N'Valparaiso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (770, 44, N'Anhui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (771, 44, N'Beijing', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (772, 44, N'Chongqing', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (773, 44, N'Fujian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (774, 44, N'Gansu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (775, 44, N'Guangdong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (776, 44, N'Guangxi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (777, 44, N'Guizhou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (778, 44, N'Hainan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (779, 44, N'Hebei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (780, 44, N'Heilongjiang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (781, 44, N'Henan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (782, 44, N'Hubei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (783, 44, N'Hunan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (784, 44, N'Jiangsu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (785, 44, N'Jiangxi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (786, 44, N'Jilin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (787, 44, N'Liaoning', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (788, 44, N'Nei Mongol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (789, 44, N'Ningxia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (790, 44, N'Qinghai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (791, 44, N'Shaanxi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (792, 44, N'Shandong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (793, 44, N'Shanghai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (794, 44, N'Shanxi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (795, 44, N'Sichuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (796, 44, N'Tianjin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (797, 44, N'Xinjiang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (798, 44, N'Xizang (Tibet)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (799, 44, N'Yunnan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (800, 44, N'Zhejiang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (801, 45, N'Christmas Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (802, 46, N'Clipperton Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (803, 47, N'Direction Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (804, 47, N'Home Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (805, 47, N'Horsburgh Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (806, 47, N'North Keeling Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (807, 47, N'South Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (808, 47, N'West Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (809, 48, N'Amazonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (810, 48, N'Antioquia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (811, 48, N'Arauca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (812, 48, N'Atlantico', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (813, 48, N'Bolivar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (814, 48, N'Boyaca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (815, 48, N'Caldas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (816, 48, N'Caqueta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (817, 48, N'Casanare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (818, 48, N'Cauca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (819, 48, N'Cesar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (820, 48, N'Choco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (821, 48, N'Cordoba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (822, 48, N'Cundinamarca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (823, 48, N'Distrito Capital de Santa Fe de Bogota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (824, 48, N'Guainia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (825, 48, N'Guaviare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (826, 48, N'Huila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (827, 48, N'La Guajira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (828, 48, N'Magdalena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (829, 48, N'Meta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (830, 48, N'Narino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (831, 48, N'Norte de Santander', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (832, 48, N'Putumayo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (833, 48, N'Quindio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (834, 48, N'Risaralda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (835, 48, N'San Andres y Providencia', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (836, 48, N'Santander', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (837, 48, N'Sucre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (838, 48, N'Tolima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (839, 48, N'Valle del Cauca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (840, 48, N'Vaupes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (841, 48, N'Vichada', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (842, 49, N'Anjouan (Nzwani)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (843, 49, N'Domoni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (844, 49, N'Fomboni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (845, 49, N'Grande Comore (Njazidja)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (846, 49, N'Moheli (Mwali)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (847, 49, N'Moroni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (848, 49, N'Moutsamoudou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (849, 50, N'Bandundu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (850, 50, N'Bas-Congo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (851, 50, N'Equateur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (852, 50, N'Kasai-Occidental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (853, 50, N'Kasai-Oriental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (854, 50, N'Katanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (855, 50, N'Kinshasa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (856, 50, N'Maniema', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (857, 50, N'Nord-Kivu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (858, 50, N'Orientale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (859, 50, N'Sud-Kivu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (860, 51, N'Bouenza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (861, 51, N'Brazzaville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (862, 51, N'Cuvette', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (863, 51, N'Kouilou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (864, 51, N'Lekoumou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (865, 51, N'Likouala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (866, 51, N'Niari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (867, 51, N'Plateaux', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (868, 51, N'Pool', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (869, 51, N'Sangha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (870, 52, N'Aitutaki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (871, 52, N'Atiu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (872, 52, N'Avarua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (873, 52, N'Mangaia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (874, 52, N'Manihiki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (875, 52, N'Manuae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (876, 52, N'Mauke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (877, 52, N'Mitiaro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (878, 52, N'Nassau Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (879, 52, N'Palmerston', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (880, 52, N'Penrhyn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (881, 52, N'Pukapuka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (882, 52, N'Rakahanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (883, 52, N'Rarotonga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (884, 52, N'Suwarrow', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (885, 52, N'Takutea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (886, 53, N'Alajuela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (887, 53, N'Cartago', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (888, 53, N'Guanacaste', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (889, 53, N'Heredia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (890, 53, N'Limon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (891, 53, N'Puntarenas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (892, 53, N'San Jose', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (893, 54, N'Abengourou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (894, 54, N'Abidjan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (895, 54, N'Aboisso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (896, 54, N'Adiake''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (897, 54, N'Adzope', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (898, 54, N'Agboville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (899, 54, N'Agnibilekrou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (900, 54, N'Ale''pe''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (901, 54, N'Bangolo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (902, 54, N'Beoumi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (903, 54, N'Biankouma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (904, 54, N'Bocanda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (905, 54, N'Bondoukou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (906, 54, N'Bongouanou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (907, 54, N'Bouafle', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (908, 54, N'Bouake', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (909, 54, N'Bouna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (910, 54, N'Boundiali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (911, 54, N'Dabakala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (912, 54, N'Dabon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (913, 54, N'Daloa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (914, 54, N'Danane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (915, 54, N'Daoukro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (916, 54, N'Dimbokro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (917, 54, N'Divo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (918, 54, N'Duekoue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (919, 54, N'Ferkessedougou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (920, 54, N'Gagnoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (921, 54, N'Grand Bassam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (922, 54, N'Grand-Lahou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (923, 54, N'Guiglo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (924, 54, N'Issia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (925, 54, N'Jacqueville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (926, 54, N'Katiola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (927, 54, N'Korhogo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (928, 54, N'Lakota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (929, 54, N'Man', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (930, 54, N'Mankono', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (931, 54, N'Mbahiakro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (932, 54, N'Odienne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (933, 54, N'Oume', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (934, 54, N'Sakassou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (935, 54, N'San-Pedro', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (936, 54, N'Sassandra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (937, 54, N'Seguela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (938, 54, N'Sinfra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (939, 54, N'Soubre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (940, 54, N'Tabou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (941, 54, N'Tanda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (942, 54, N'Tiassale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (943, 54, N'Tiebissou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (944, 54, N'Tingrela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (945, 54, N'Touba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (946, 54, N'Toulepleu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (947, 54, N'Toumodi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (948, 54, N'Vavoua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (949, 54, N'Yamoussoukro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (950, 54, N'Zuenoula', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (951, 55, N'Bjelovarsko-Bilogorska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (952, 55, N'Brodsko-Posavska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (953, 55, N'Dubrovacko-Neretvanska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (954, 55, N'Istarska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (955, 55, N'Karlovacka Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (956, 55, N'Koprivnicko-Krizevacka Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (957, 55, N'Krapinsko-Zagorska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (958, 55, N'Licko-Senjska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (959, 55, N'Medimurska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (960, 55, N'Osjecko-Baranjska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (961, 55, N'Pozesko-Slavonska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (962, 55, N'Primorsko-Goranska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (963, 55, N'Sibensko-Kninska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (964, 55, N'Sisacko-Moslavacka Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (965, 55, N'Splitsko-Dalmatinska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (966, 55, N'Varazdinska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (967, 55, N'Viroviticko-Podravska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (968, 55, N'Vukovarsko-Srijemska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (969, 55, N'Zadarska Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (970, 55, N'Zagreb', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (971, 55, N'Zagrebacka Zupanija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (972, 56, N'Camaguey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (973, 56, N'Ciego de Avila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (974, 56, N'Cienfuegos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (975, 56, N'Ciudad de La Habana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (976, 56, N'Granma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (977, 56, N'Guantanamo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (978, 56, N'Holguin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (979, 56, N'Isla de la Juventud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (980, 56, N'La Habana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (981, 56, N'Las Tunas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (982, 56, N'Matanzas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (983, 56, N'Pinar del Rio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (984, 56, N'Sancti Spiritus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (985, 56, N'Santiago de Cuba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (986, 56, N'Villa Clara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (987, 57, N'Famagusta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (988, 57, N'Kyrenia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (989, 57, N'Larnaca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (990, 57, N'Limassol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (991, 57, N'Nicosia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (992, 57, N'Paphos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (993, 58, N'Brnensky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (994, 58, N'Budejovicky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (995, 58, N'Jihlavsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (996, 58, N'Karlovarsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (997, 58, N'Kralovehradecky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (998, 58, N'Liberecky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (999, 58, N'Olomoucky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1000, 58, N'Ostravsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1001, 58, N'Pardubicky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1002, 58, N'Plzensky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1003, 58, N'Praha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1004, 58, N'Stredocesky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1005, 58, N'Ustecky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1006, 58, N'Zlinsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1007, 59, N'Arhus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1008, 59, N'Bornholm', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1009, 59, N'Fredericksberg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1010, 59, N'Frederiksborg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1011, 59, N'Fyn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1012, 59, N'Kobenhavn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1013, 59, N'Kobenhavns', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1014, 59, N'Nordjylland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1015, 59, N'Ribe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1016, 59, N'Ringkobing', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1017, 59, N'Roskilde', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1018, 59, N'Sonderjylland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1019, 59, N'Storstrom', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1020, 59, N'Vejle', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1021, 59, N'Vestsjalland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1022, 59, N'Viborg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1023, 60, N'Ali Sabih', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1024, 60, N'Dikhil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1025, 60, N'Djibouti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1026, 60, N'Obock', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1027, 60, N'Tadjoura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1028, 61, N'Saint Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1029, 61, N'Saint David', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1030, 61, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1031, 61, N'Saint John', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1032, 61, N'Saint Joseph', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1033, 61, N'Saint Luke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1034, 61, N'Saint Mark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1035, 61, N'Saint Patrick', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1036, 61, N'Saint Paul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1037, 61, N'Saint Peter', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1038, 62, N'Azua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1039, 62, N'Baoruco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1040, 62, N'Barahona', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1041, 62, N'Dajabon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1042, 62, N'Distrito Nacional', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1043, 62, N'Duarte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1044, 62, N'El Seibo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1045, 62, N'Elias Pina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1046, 62, N'Espaillat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1047, 62, N'Hato Mayor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1048, 62, N'Independencia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1049, 62, N'La Altagracia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1050, 62, N'La Romana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1051, 62, N'La Vega', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1052, 62, N'Maria Trinidad Sanchez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1053, 62, N'Monsenor Nouel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1054, 62, N'Monte Cristi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1055, 62, N'Monte Plata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1056, 62, N'Pedernales', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1057, 62, N'Peravia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1058, 62, N'Puerto Plata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1059, 62, N'Salcedo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1060, 62, N'Samana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1061, 62, N'San Cristobal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1062, 62, N'San Juan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1063, 62, N'San Pedro de Macoris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1064, 62, N'Sanchez Ramirez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1065, 62, N'Santiago', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1066, 62, N'Santiago Rodriguez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1067, 62, N'Valverde', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1068, 63, N'Azuay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1069, 63, N'Bolivar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1070, 63, N'Canar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1071, 63, N'Carchi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1072, 63, N'Chimborazo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1073, 63, N'Cotopaxi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1074, 63, N'El Oro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1075, 63, N'Esmeraldas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1076, 63, N'Galapagos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1077, 63, N'Guayas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1078, 63, N'Imbabura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1079, 63, N'Loja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1080, 63, N'Los Rios', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1081, 63, N'Manabi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1082, 63, N'Morona-Santiago', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1083, 63, N'Napo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1084, 63, N'Orellana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1085, 63, N'Pastaza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1086, 63, N'Pichincha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1087, 63, N'Sucumbios', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1088, 63, N'Tungurahua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1089, 63, N'Zamora-Chinchipe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1090, 64, N'Ad Daqahliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1091, 64, N'Al Bahr al Ahmar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1092, 64, N'Al Buhayrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1093, 64, N'Al Fayyum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1094, 64, N'Al Gharbiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1095, 64, N'Al Iskandariyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1096, 64, N'Al Isma''iliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1097, 64, N'Al Jizah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1098, 64, N'Al Minufiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1099, 64, N'Al Minya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1100, 64, N'Al Qahirah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1101, 64, N'Al Qalyubiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1102, 64, N'Al Wadi al Jadid', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1103, 64, N'As Suways', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1104, 64, N'Ash Sharqiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1105, 64, N'Aswan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1106, 64, N'Asyut', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1107, 64, N'Bani Suwayf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1108, 64, N'Bur Sa''id', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1109, 64, N'Dumyat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1110, 64, N'Janub Sina''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1111, 64, N'Kafr ash Shaykh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1112, 64, N'Matruh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1113, 64, N'Qina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1114, 64, N'Shamal Sina''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1115, 64, N'Suhaj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1116, 65, N'Ahuachapan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1117, 65, N'Cabanas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1118, 65, N'Chalatenango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1119, 65, N'Cuscatlan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1120, 65, N'La Libertad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1121, 65, N'La Paz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1122, 65, N'La Union', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1123, 65, N'Morazan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1124, 65, N'San Miguel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1125, 65, N'San Salvador', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1126, 65, N'San Vicente', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1127, 65, N'Santa Ana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1128, 65, N'Sonsonate', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1129, 65, N'Usulutan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1130, 66, N'Annobon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1131, 66, N'Bioko Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1132, 66, N'Bioko Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1133, 66, N'Centro Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1134, 66, N'Kie-Ntem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1135, 66, N'Litoral', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1136, 66, N'Wele-Nzas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1137, 67, N'Akale Guzay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1138, 67, N'Barka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1139, 67, N'Denkel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1140, 67, N'Hamasen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1141, 67, N'Sahil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1142, 67, N'Semhar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1143, 67, N'Senhit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1144, 67, N'Seraye', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1145, 68, N'Harjumaa (Tallinn)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1146, 68, N'Hiiumaa (Kardla)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1147, 68, N'Ida-Virumaa (Johvi)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1148, 68, N'Jarvamaa (Paide)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1149, 68, N'Jogevamaa (Jogeva)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1150, 68, N'Laane-Virumaa (Rakvere)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1151, 68, N'Laanemaa (Haapsalu)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1152, 68, N'Parnumaa (Parnu)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1153, 68, N'Polvamaa (Polva)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1154, 68, N'Raplamaa (Rapla)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1155, 68, N'Saaremaa (Kuessaare)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1156, 68, N'Tartumaa (Tartu)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1157, 68, N'Valgamaa (Valga)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1158, 68, N'Viljandimaa (Viljandi)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1159, 68, N'Vorumaa (Voru)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1160, 69, N'Adis Abeba (Addis Ababa)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1161, 69, N'Afar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1162, 69, N'Amara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1163, 69, N'Dire Dawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1164, 69, N'Gambela Hizboch', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1165, 69, N'Hareri Hizb', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1166, 69, N'Oromiya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1167, 69, N'Sumale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1168, 69, N'Tigray', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1169, 69, N'YeDebub Biheroch Bihereseboch na Hizboch', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1170, 70, N'Europa Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1171, 71, N'Falkland Islands (Islas Malvinas)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1172, 72, N'Bordoy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1173, 72, N'Eysturoy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1174, 72, N'Mykines', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1175, 72, N'Sandoy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1176, 72, N'Skuvoy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1177, 72, N'Streymoy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1178, 72, N'Suduroy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1179, 72, N'Tvoroyri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1180, 72, N'Vagar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1181, 73, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1182, 73, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1183, 73, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1184, 73, N'Rotuma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1185, 73, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1186, 74, N'Aland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1187, 74, N'Etela-Suomen Laani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1188, 74, N'Ita-Suomen Laani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1189, 74, N'Lansi-Suomen Laani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1190, 74, N'Lappi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1191, 74, N'Oulun Laani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1192, 75, N'Alsace', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1193, 75, N'Aquitaine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1194, 75, N'Auvergne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1195, 75, N'Basse-Normandie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1196, 75, N'Bourgogne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1197, 75, N'Bretagne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1198, 75, N'Centre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1199, 75, N'Champagne-Ardenne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1200, 75, N'Corse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1201, 75, N'Franche-Comte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1202, 75, N'Haute-Normandie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1203, 75, N'Ile-de-France', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1204, 75, N'Languedoc-Roussillon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1205, 75, N'Limousin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1206, 75, N'Lorraine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1207, 75, N'Midi-Pyrenees', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1208, 75, N'Nord-Pas-de-Calais', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1209, 75, N'Pays de la Loire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1210, 75, N'Picardie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1211, 75, N'Poitou-Charentes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1212, 75, N'Provence-Alpes-Cote d''Azur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1213, 75, N'Rhone-Alpes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1214, 76, N'French Guiana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1215, 77, N'Archipel des Marquises', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1216, 77, N'Archipel des Tuamotu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1217, 77, N'Archipel des Tubuai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1218, 77, N'Iles du Vent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1219, 77, N'Iles Sous-le-Vent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1220, 78, N'Adelie Land', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1221, 78, N'Ile Crozet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1222, 78, N'Iles Kerguelen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1223, 78, N'Iles Saint-Paul et Amsterdam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1224, 79, N'Estuaire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1225, 79, N'Haut-Ogooue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1226, 79, N'Moyen-Ogooue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1227, 79, N'Ngounie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1228, 79, N'Nyanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1229, 79, N'Ogooue-Ivindo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1230, 79, N'Ogooue-Lolo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1231, 79, N'Ogooue-Maritime', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1232, 79, N'Woleu-Ntem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1233, 80, N'Banjul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1234, 80, N'Central River', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1235, 80, N'Lower River', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1236, 80, N'North Bank', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1237, 80, N'Upper River', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1238, 80, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1239, 81, N'Gaza Strip', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1243, 82, N'Abashis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1244, 82, N'Abkhazia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1245, 82, N'Adigenis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1246, 82, N'Ajaria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1247, 82, N'Akhalgoris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1248, 82, N'Akhalk''alak''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1249, 82, N'Akhalts''ikhis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1250, 82, N'Akhmetis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1251, 82, N'Ambrolauris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1252, 82, N'Aspindzis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1253, 82, N'Baghdat''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1254, 82, N'Bolnisis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1255, 82, N'Borjomis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1256, 82, N'Ch''khorotsqus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1257, 82, N'Ch''okhatauris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1258, 82, N'Chiat''ura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1259, 82, N'Dedop''listsqaros', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1260, 82, N'Dmanisis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1261, 82, N'Dushet''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1262, 82, N'Gardabanis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1263, 82, N'Gori', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1264, 82, N'Goris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1265, 82, N'Gurjaanis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1266, 82, N'Javis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1267, 82, N'K''arelis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1268, 82, N'K''ut''aisi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1269, 82, N'Kaspis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1270, 82, N'Kharagaulis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1271, 82, N'Khashuris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1272, 82, N'Khobis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1273, 82, N'Khonis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1274, 82, N'Lagodekhis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1275, 82, N'Lanch''khut''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1276, 82, N'Lentekhis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1277, 82, N'Marneulis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1278, 82, N'Martvilis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1279, 82, N'Mestiis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1280, 82, N'Mts''khet''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1281, 82, N'Ninotsmindis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1282, 82, N'Onis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1283, 82, N'Ozurget''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1284, 82, N'P''ot''i', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1285, 82, N'Qazbegis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1286, 82, N'Qvarlis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1287, 82, N'Rust''avi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1288, 82, N'Sach''kheris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1289, 82, N'Sagarejos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1290, 82, N'Samtrediis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1291, 82, N'Senakis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1292, 82, N'Sighnaghis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1293, 82, N'T''bilisi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1294, 82, N'T''elavis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1295, 82, N'T''erjolis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1296, 82, N'T''et''ritsqaros', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1297, 82, N'T''ianet''is', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1298, 82, N'Tqibuli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1299, 82, N'Ts''ageris', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1300, 82, N'Tsalenjikhis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1301, 82, N'Tsalkis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1302, 82, N'Tsqaltubo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1303, 82, N'Vanis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1304, 82, N'Zestap''onis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1305, 82, N'Zugdidi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1306, 82, N'Zugdidis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1307, 83, N'Baden-Wuerttemberg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1308, 83, N'Bayern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1309, 83, N'Berlin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1310, 83, N'Brandenburg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1311, 83, N'Bremen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1312, 83, N'Hamburg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1313, 83, N'Hessen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1314, 83, N'Mecklenburg-Vorpommern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1315, 83, N'Niedersachsen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1316, 83, N'Nordrhein-Westfalen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1317, 83, N'Rheinland-Pfalz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1318, 83, N'Saarland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1319, 83, N'Sachsen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1320, 83, N'Sachsen-Anhalt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1321, 83, N'Schleswig-Holstein', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1322, 83, N'Thueringen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1323, 84, N'Ashanti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1324, 84, N'Brong-Ahafo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1325, 84, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1326, 84, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1327, 84, N'Greater Accra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1328, 84, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1329, 84, N'Upper East', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1330, 84, N'Upper West', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1331, 84, N'Volta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1332, 84, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1333, 85, N'Gibraltar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1335, 87, N'Aitolia kai Akarnania', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1336, 87, N'Akhaia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1337, 87, N'Argolis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1338, 87, N'Arkadhia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1339, 87, N'Arta', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1340, 87, N'Attiki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1341, 87, N'Ayion Oros (Mt. Athos)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1342, 87, N'Dhodhekanisos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1343, 87, N'Drama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1344, 87, N'Evritania', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1345, 87, N'Evros', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1346, 87, N'Evvoia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1347, 87, N'Florina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1348, 87, N'Fokis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1349, 87, N'Fthiotis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1350, 87, N'Grevena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1351, 87, N'Ilia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1352, 87, N'Imathia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1353, 87, N'Ioannina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1354, 87, N'Irakleion', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1355, 87, N'Kardhitsa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1356, 87, N'Kastoria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1357, 87, N'Kavala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1358, 87, N'Kefallinia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1359, 87, N'Kerkyra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1360, 87, N'Khalkidhiki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1361, 87, N'Khania', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1362, 87, N'Khios', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1363, 87, N'Kikladhes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1364, 87, N'Kilkis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1365, 87, N'Korinthia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1366, 87, N'Kozani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1367, 87, N'Lakonia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1368, 87, N'Larisa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1369, 87, N'Lasithi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1370, 87, N'Lesvos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1371, 87, N'Levkas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1372, 87, N'Magnisia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1373, 87, N'Messinia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1374, 87, N'Pella', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1375, 87, N'Pieria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1376, 87, N'Preveza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1377, 87, N'Rethimni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1378, 87, N'Rodhopi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1379, 87, N'Samos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1380, 87, N'Serrai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1381, 87, N'Thesprotia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1382, 87, N'Thessaloniki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1383, 87, N'Trikala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1384, 87, N'Voiotia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1385, 87, N'Xanthi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1386, 87, N'Zakinthos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1387, 88, N'Avannaa (Nordgronland)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1388, 88, N'Kitaa (Vestgronland)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1389, 88, N'Tunu (Ostgronland)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1390, 89, N'Carriacou and Petit Martinique', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1391, 89, N'Saint Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1392, 89, N'Saint David', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1393, 89, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1394, 89, N'Saint John', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1395, 89, N'Saint Mark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1396, 89, N'Saint Patrick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1397, 90, N'Basse-Terre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1398, 90, N'Grande-Terre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1399, 90, N'Iles de la Petite Terre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1400, 90, N'Iles des Saintes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1401, 90, N'Marie-Galante', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1402, 91, N'Guam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1403, 92, N'Alta Verapaz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1404, 92, N'Baja Verapaz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1405, 92, N'Chimaltenango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1406, 92, N'Chiquimula', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1407, 92, N'El Progreso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1408, 92, N'Escuintla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1409, 92, N'Guatemala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1410, 92, N'Huehuetenango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1411, 92, N'Izabal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1412, 92, N'Jalapa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1413, 92, N'Jutiapa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1414, 92, N'Peten', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1415, 92, N'Quetzaltenango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1416, 92, N'Quiche', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1417, 92, N'Retalhuleu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1418, 92, N'Sacatepequez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1419, 92, N'San Marcos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1420, 92, N'Santa Rosa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1421, 92, N'Solola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1422, 92, N'Suchitepequez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1423, 92, N'Totonicapan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1424, 92, N'Zacapa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1425, 93, N'Castel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1426, 93, N'Forest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1427, 93, N'St. Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1428, 93, N'St. Martin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1429, 93, N'St. Peter Port', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1430, 93, N'St. Pierre du Bois', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1431, 93, N'St. Sampson', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1432, 93, N'St. Saviour', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1433, 93, N'Torteval', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1434, 93, N'Vale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1435, 94, N'Beyla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1436, 94, N'Boffa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1437, 94, N'Boke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1438, 94, N'Conakry', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1439, 94, N'Coyah', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1440, 94, N'Dabola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1441, 94, N'Dalaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1442, 94, N'Dinguiraye', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1443, 94, N'Dubreka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1444, 94, N'Faranah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1445, 94, N'Forecariah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1446, 94, N'Fria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1447, 94, N'Gaoual', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1448, 94, N'Gueckedou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1449, 94, N'Kankan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1450, 94, N'Kerouane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1451, 94, N'Kindia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1452, 94, N'Kissidougou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1453, 94, N'Koubia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1454, 94, N'Koundara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1455, 94, N'Kouroussa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1456, 94, N'Labe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1457, 94, N'Lelouma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1458, 94, N'Lola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1459, 94, N'Macenta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1460, 94, N'Mali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1461, 94, N'Mamou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1462, 94, N'Mandiana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1463, 94, N'Nzerekore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1464, 94, N'Pita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1465, 94, N'Siguiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1466, 94, N'Telimele', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1467, 94, N'Tougue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1468, 94, N'Yomou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1469, 95, N'Bafata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1470, 95, N'Biombo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1471, 95, N'Bissau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1472, 95, N'Bolama-Bijagos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1473, 95, N'Cacheu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1474, 95, N'Gabu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1475, 95, N'Oio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1476, 95, N'Quinara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1477, 95, N'Tombali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1538, 96, N'Barima-Waini', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1539, 96, N'Cuyuni-Mazaruni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1540, 96, N'Demerara-Mahaica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1541, 96, N'East Berbice-Corentyne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1542, 96, N'Essequibo Islands-West Demerara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1543, 96, N'Mahaica-Berbice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1544, 96, N'Pomeroon-Supenaam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1545, 96, N'Potaro-Siparuni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1546, 96, N'Upper Demerara-Berbice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1547, 96, N'Upper Takutu-Upper Essequibo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1548, 97, N'Artibonite', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1549, 97, N'Centre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1550, 97, N'Grand''Anse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1551, 97, N'Nord', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1552, 97, N'Nord-Est', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1553, 97, N'Nord-Ouest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1554, 97, N'Ouest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1555, 97, N'Sud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1556, 97, N'Sud-Est', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1557, 98, N'Heard Island and McDonald Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1558, 99, N'Holy See (Vatican City)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1559, 100, N'Atlantida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1560, 100, N'Choluteca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1561, 100, N'Colon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1562, 100, N'Comayagua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1563, 100, N'Copan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1564, 100, N'Cortes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1565, 100, N'El Paraiso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1566, 100, N'Francisco Morazan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1567, 100, N'Gracias a Dios', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1568, 100, N'Intibuca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1569, 100, N'Islas de la Bahia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1570, 100, N'La Paz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1571, 100, N'Lempira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1572, 100, N'Ocotepeque', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1573, 100, N'Olancho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1574, 100, N'Santa Barbara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1575, 100, N'Valle', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1576, 100, N'Yoro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1577, 101, N'Hong Kong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1578, 102, N'Howland Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1579, 103, N'Bacs-Kiskun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1580, 103, N'Baranya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1581, 103, N'Bekes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1582, 103, N'Bekescsaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1583, 103, N'Borsod-Abauj-Zemplen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1584, 103, N'Budapest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1585, 103, N'Csongrad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1586, 103, N'Debrecen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1587, 103, N'Dunaujvaros', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1588, 103, N'Eger', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1589, 103, N'Fejer', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1590, 103, N'Gyor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1591, 103, N'Gyor-Moson-Sopron', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1592, 103, N'Hajdu-Bihar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1593, 103, N'Heves', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1594, 103, N'Hodmezovasarhely', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1595, 103, N'Jasz-Nagykun-Szolnok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1596, 103, N'Kaposvar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1597, 103, N'Kecskemet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1598, 103, N'Komarom-Esztergom', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1599, 103, N'Miskolc', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1600, 103, N'Nagykanizsa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1601, 103, N'Nograd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1602, 103, N'Nyiregyhaza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1603, 103, N'Pecs', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1604, 103, N'Pest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1605, 103, N'Somogy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1606, 103, N'Sopron', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1607, 103, N'Szabolcs-Szatmar-Bereg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1608, 103, N'Szeged', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1609, 103, N'Szekesfehervar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1610, 103, N'Szolnok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1611, 103, N'Szombathely', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1612, 103, N'Tatabanya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1613, 103, N'Tolna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1614, 103, N'Vas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1615, 103, N'Veszprem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1616, 103, N'Veszprem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1617, 103, N'Zala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1618, 103, N'Zalaegerszeg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1619, 104, N'Akranes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1620, 104, N'Akureyri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1621, 104, N'Arnessysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1622, 104, N'Austur-Bardhastrandarsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1623, 104, N'Austur-Hunavatnssysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1624, 104, N'Austur-Skaftafellssysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1625, 104, N'Borgarfjardharsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1626, 104, N'Dalasysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1627, 104, N'Eyjafjardharsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1628, 104, N'Gullbringusysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1629, 104, N'Hafnarfjordhur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1630, 104, N'Husavik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1631, 104, N'Isafjordhur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1632, 104, N'Keflavik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1633, 104, N'Kjosarsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1634, 104, N'Kopavogur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1635, 104, N'Myrasysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1636, 104, N'Neskaupstadhur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1637, 104, N'Nordhur-Isafjardharsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1638, 104, N'Nordhur-Mulasys-la', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1639, 104, N'Nordhur-Thingeyjarsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1640, 104, N'Olafsfjordhur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1641, 104, N'Rangarvallasysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1642, 104, N'Reykjavik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1643, 104, N'Saudharkrokur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1644, 104, N'Seydhisfjordhur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1645, 104, N'Siglufjordhur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1646, 104, N'Skagafjardharsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1647, 104, N'Snaefellsnes-og Hnappadalssysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1648, 104, N'Strandasysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1649, 104, N'Sudhur-Mulasysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1650, 104, N'Sudhur-Thingeyjarsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1651, 104, N'Vesttmannaeyjar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1652, 104, N'Vestur-Bardhastrandarsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1653, 104, N'Vestur-Hunavatnssysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1654, 104, N'Vestur-Isafjardharsysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1655, 104, N'Vestur-Skaftafellssysla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1656, 105, N'Andaman and Nicobar Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1657, 105, N'Andhra Pradesh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1658, 105, N'Arunachal Pradesh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1659, 105, N'Assam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1660, 105, N'Bihar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1661, 105, N'Chandigarh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1662, 105, N'Chhattisgarh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1663, 105, N'Dadra and Nagar Haveli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1664, 105, N'Daman and Diu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1665, 105, N'Delhi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1666, 105, N'Goa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1667, 105, N'Gujarat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1668, 105, N'Haryana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1669, 105, N'Himachal Pradesh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1670, 105, N'Jammu and Kashmir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1671, 105, N'Jharkhand', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1672, 105, N'Karnataka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1673, 105, N'Kerala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1674, 105, N'Lakshadweep', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1675, 105, N'Madhya Pradesh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1676, 105, N'Maharashtra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1677, 105, N'Manipur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1678, 105, N'Meghalaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1679, 105, N'Mizoram', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1680, 105, N'Nagaland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1681, 105, N'Orissa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1682, 105, N'Pondicherry', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1683, 105, N'Punjab', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1684, 105, N'Rajasthan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1685, 105, N'Sikkim', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1686, 105, N'Tamil Nadu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1687, 105, N'Tripura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1688, 105, N'Uttar Pradesh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1689, 105, N'Uttaranchal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1690, 105, N'West Bengal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1691, 106, N'Aceh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1692, 106, N'Bali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1693, 106, N'Banten', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1694, 106, N'Bengkulu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1695, 106, N'East Timor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1696, 106, N'Gorontalo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1697, 106, N'Irian Jaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1698, 106, N'Jakarta Raya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1699, 106, N'Jambi', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1700, 106, N'Jawa Barat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1701, 106, N'Jawa Tengah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1702, 106, N'Jawa Timur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1703, 106, N'Kalimantan Barat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1704, 106, N'Kalimantan Selatan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1705, 106, N'Kalimantan Tengah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1706, 106, N'Kalimantan Timur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1707, 106, N'Kepulauan Bangka Belitung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1708, 106, N'Lampung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1709, 106, N'Maluku', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1710, 106, N'Maluku Utara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1711, 106, N'Nusa Tenggara Barat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1712, 106, N'Nusa Tenggara Timur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1713, 106, N'Riau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1714, 106, N'Sulawesi Selatan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1715, 106, N'Sulawesi Tengah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1716, 106, N'Sulawesi Tenggara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1717, 106, N'Sulawesi Utara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1718, 106, N'Sumatera Barat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1719, 106, N'Sumatera Selatan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1720, 106, N'Sumatera Utara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1721, 106, N'Yogyakarta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1722, 107, N'Ardabil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1723, 107, N'Azarbayjan-e Gharbi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1724, 107, N'Azarbayjan-e Sharqi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1725, 107, N'Bushehr', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1726, 107, N'Chahar Mahall va Bakhtiari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1727, 107, N'Esfahan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1728, 107, N'Fars', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1729, 107, N'Gilan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1730, 107, N'Golestan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1731, 107, N'Hamadan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1732, 107, N'Hormozgan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1733, 107, N'Ilam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1734, 107, N'Kerman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1735, 107, N'Kermanshah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1736, 107, N'Khorasan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1737, 107, N'Khuzestan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1738, 107, N'Kohgiluyeh va Buyer Ahmad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1739, 107, N'Kordestan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1740, 107, N'Lorestan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1741, 107, N'Markazi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1742, 107, N'Mazandaran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1743, 107, N'Qazvin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1744, 107, N'Qom', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1745, 107, N'Semnan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1746, 107, N'Sistan va Baluchestan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1747, 107, N'Tehran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1748, 107, N'Yazd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1749, 107, N'Zanjan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1750, 108, N'Al Anbar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1751, 108, N'Al Basrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1752, 108, N'Al Muthanna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1753, 108, N'Al Qadisiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1754, 108, N'An Najaf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1755, 108, N'Arbil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1756, 108, N'As Sulaymaniyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1757, 108, N'At Ta''mim', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1758, 108, N'Babil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1759, 108, N'Baghdad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1760, 108, N'Dahuk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1761, 108, N'Dhi Qar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1762, 108, N'Diyala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1763, 108, N'Karbala''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1764, 108, N'Maysan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1765, 108, N'Ninawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1766, 108, N'Salah ad Din', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1767, 108, N'Wasit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1768, 109, N'Carlow', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1769, 109, N'Cavan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1770, 109, N'Clare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1771, 109, N'Cork', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1772, 109, N'Donegal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1773, 109, N'Dublin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1774, 109, N'Galway', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1775, 109, N'Kerry', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1776, 109, N'Kildare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1777, 109, N'Kilkenny', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1778, 109, N'Laois', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1779, 109, N'Leitrim', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1780, 109, N'Limerick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1781, 109, N'Longford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1782, 109, N'Louth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1783, 109, N'Mayo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1784, 109, N'Meath', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1785, 109, N'Monaghan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1786, 109, N'Offaly', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1787, 109, N'Roscommon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1788, 109, N'Sligo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1789, 109, N'Tipperary', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1790, 109, N'Waterford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1791, 109, N'Westmeath', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1792, 109, N'Wexford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1793, 109, N'Wicklow', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1794, 110, N'Antrim', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1795, 110, N'Ards', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1796, 110, N'Armagh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1797, 110, N'Ballymena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1798, 110, N'Ballymoney', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1799, 110, N'Banbridge', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1800, 110, N'Belfast', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1801, 110, N'Carrickfergus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1802, 110, N'Castlereagh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1803, 110, N'Coleraine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1804, 110, N'Cookstown', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1805, 110, N'Craigavon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1806, 110, N'Derry', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1807, 110, N'Down', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1808, 110, N'Dungannon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1809, 110, N'Fermanagh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1810, 110, N'Larne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1811, 110, N'Limavady', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1812, 110, N'Lisburn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1813, 110, N'Magherafelt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1814, 110, N'Moyle', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1815, 110, N'Newry and Mourne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1816, 110, N'Newtownabbey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1817, 110, N'North Down', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1818, 110, N'Omagh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1819, 110, N'Strabane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1820, 111, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1821, 111, N'Haifa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1822, 111, N'Jerusalem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1823, 111, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1824, 111, N'Southern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1825, 111, N'Tel Aviv', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1826, 112, N'Abruzzo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1827, 112, N'Basilicata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1828, 112, N'Calabria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1829, 112, N'Campania', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1830, 112, N'Emilia-Romagna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1831, 112, N'Friuli-Venezia Giulia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1832, 112, N'Lazio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1833, 112, N'Liguria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1834, 112, N'Lombardia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1835, 112, N'Marche', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1836, 112, N'Molise', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1837, 112, N'Piemonte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1838, 112, N'Puglia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1839, 112, N'Sardegna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1840, 112, N'Sicilia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1841, 112, N'Toscana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1842, 112, N'Trentino-Alto Adige', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1843, 112, N'Umbria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1844, 112, N'Valle d''Aosta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1845, 112, N'Veneto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1846, 113, N'Clarendon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1847, 113, N'Hanover', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1848, 113, N'Kingston', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1849, 113, N'Manchester', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1850, 113, N'Portland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1851, 113, N'Saint Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1852, 113, N'Saint Ann', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1853, 113, N'Saint Catherine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1854, 113, N'Saint Elizabeth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1855, 113, N'Saint James', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1856, 113, N'Saint Mary', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1857, 113, N'Saint Thomas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1858, 113, N'Trelawny', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1859, 113, N'Westmoreland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1860, 114, N'Jan Mayen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1861, 115, N'Aichi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1862, 115, N'Akita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1863, 115, N'Aomori', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1864, 115, N'Chiba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1865, 115, N'Ehime', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1866, 115, N'Fukui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1867, 115, N'Fukuoka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1868, 115, N'Fukushima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1869, 115, N'Gifu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1870, 115, N'Gumma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1871, 115, N'Hiroshima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1872, 115, N'Hokkaido', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1873, 115, N'Hyogo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1874, 115, N'Ibaraki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1875, 115, N'Ishikawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1876, 115, N'Iwate', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1877, 115, N'Kagawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1878, 115, N'Kagoshima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1879, 115, N'Kanagawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1880, 115, N'Kochi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1881, 115, N'Kumamoto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1882, 115, N'Kyoto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1883, 115, N'Mie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1884, 115, N'Miyagi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1885, 115, N'Miyazaki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1886, 115, N'Nagano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1887, 115, N'Nagasaki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1888, 115, N'Nara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1889, 115, N'Niigata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1890, 115, N'Oita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1891, 115, N'Okayama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1892, 115, N'Okinawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1893, 115, N'Osaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1894, 115, N'Saga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1895, 115, N'Saitama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1896, 115, N'Shiga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1897, 115, N'Shimane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1898, 115, N'Shizuoka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1899, 115, N'Tochigi', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1900, 115, N'Tokushima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1901, 115, N'Tokyo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1902, 115, N'Tottori', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1903, 115, N'Toyama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1904, 115, N'Wakayama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1905, 115, N'Yamagata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1906, 115, N'Yamaguchi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1907, 115, N'Yamanashi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1908, 116, N'Jarvis Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1909, 117, N'Jersey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1910, 118, N'Johnston Atoll', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1912, 119, N'Amman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1913, 119, N'Ajlun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1914, 119, N'Al ''Aqabah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1915, 119, N'Al Balqa''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1916, 119, N'Al Karak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1917, 119, N'Al Mafraq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1918, 119, N'At Tafilah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1919, 119, N'Az Zarqa''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1920, 119, N'Irbid', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1921, 119, N'Jarash', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1922, 119, N'Ma''an', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1923, 119, N'Madaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1924, 121, N'Almaty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1925, 121, N'Aqmola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1926, 121, N'Aqtobe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1927, 121, N'Astana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1928, 121, N'Atyrau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1929, 121, N'Batys Qazaqstan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1930, 121, N'Bayqongyr', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1931, 121, N'Mangghystau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1932, 121, N'Ongtustik Qazaqstan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1933, 121, N'Pavlodar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1934, 121, N'Qaraghandy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1935, 121, N'Qostanay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1936, 121, N'Qyzylorda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1937, 121, N'Shyghys Qazaqstan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1938, 121, N'Soltustik Qazaqstan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1939, 121, N'Zhambyl', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1940, 122, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1941, 122, N'Coast', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1942, 122, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1943, 122, N'Nairobi Area', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1944, 122, N'North Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1945, 122, N'Nyanza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1946, 122, N'Rift Valley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1947, 122, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1948, 123, N'Abaiang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1949, 123, N'Abemama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1950, 123, N'Aranuka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1951, 123, N'Arorae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1952, 123, N'Banaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1953, 123, N'Banaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1955, 123, N'Beru', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1956, 123, N'Butaritari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1957, 123, N'Central Gilberts', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1958, 123, N'Gilbert Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1959, 123, N'Kanton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1960, 123, N'Kiritimati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1961, 123, N'Kuria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1962, 123, N'Line Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1963, 123, N'Line Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1964, 123, N'Maiana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1965, 123, N'Makin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1966, 123, N'Marakei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1967, 123, N'Nikunau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1968, 123, N'Nonouti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1969, 123, N'Northern Gilberts', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1970, 123, N'Onotoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1971, 123, N'Phoenix Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1972, 123, N'Southern Gilberts', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1973, 123, N'Tabiteuea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1974, 123, N'Tabuaeran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1975, 123, N'Tamana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1976, 123, N'Tarawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1977, 123, N'Tarawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1978, 123, N'Teraina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1979, 124, N'Chagang-do (Chagang Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1980, 124, N'Hamgyong-bukto (North Hamgyong Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1981, 124, N'Hamgyong-namdo (South Hamgyong Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1982, 124, N'Hwanghae-bukto (North Hwanghae Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1983, 124, N'Hwanghae-namdo (South Hwanghae Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1984, 124, N'Kaesong-si (Kaesong City)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1985, 124, N'Kangwon-do (Kangwon Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1986, 124, N'Namp''o-si (Namp''o City)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1987, 124, N'P''yongan-bukto (North P''yongan Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1988, 124, N'P''yongan-namdo (South P''yongan Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1989, 124, N'P''yongyang-si (P''yongyang City)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1990, 124, N'Yanggang-do (Yanggang Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1991, 120, N'Juan de Nova Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1992, 125, N'Ch''ungch''ong-bukto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1993, 125, N'Ch''ungch''ong-namdo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1994, 125, N'Cheju-do', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1995, 125, N'Cholla-bukto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1996, 125, N'Cholla-namdo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1997, 125, N'Inch''on-gwangyoksi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1998, 125, N'Kangwon-do', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (1999, 125, N'Kwangju-gwangyoksi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2000, 125, N'Kyonggi-do', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2001, 125, N'Kyongsang-bukto', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2002, 125, N'Kyongsang-namdo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2003, 125, N'Pusan-gwangyoksi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2004, 125, N'Soul-t''ukpyolsi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2005, 125, N'Taegu-gwangyoksi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2006, 125, N'Taejon-gwangyoksi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2007, 125, N'Ulsan-gwangyoksi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2008, 126, N'Al ''Asimah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2009, 126, N'Al Ahmadi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2010, 126, N'Al Farwaniyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2011, 126, N'Al Jahra''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2012, 126, N'Hawalli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2013, 127, N'Batken Oblasty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2014, 127, N'Bishkek Shaary', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2015, 127, N'Chuy Oblasty (Bishkek)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2016, 127, N'Jalal-Abad Oblasty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2017, 127, N'Naryn Oblasty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2018, 127, N'Osh Oblasty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2019, 127, N'Talas Oblasty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2020, 127, N'Ysyk-Kol Oblasty (Karakol)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2021, 128, N'Attapu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2022, 128, N'Bokeo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2023, 128, N'Bolikhamxai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2024, 128, N'Champasak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2025, 128, N'Houaphan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2026, 128, N'Khammouan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2027, 128, N'Louangnamtha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2028, 128, N'Louangphabang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2029, 128, N'Oudomxai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2030, 128, N'Phongsali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2031, 128, N'Salavan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2032, 128, N'Savannakhet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2033, 128, N'Viangchan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2034, 128, N'Viangchan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2035, 128, N'Xaignabouli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2036, 128, N'Xaisomboun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2037, 128, N'Xekong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2038, 128, N'Xiangkhoang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2039, 129, N'Aizkraukles Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2040, 129, N'Aluksnes Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2041, 129, N'Balvu Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2042, 129, N'Bauskas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2043, 129, N'Cesu Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2044, 129, N'Daugavpils', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2045, 129, N'Daugavpils Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2046, 129, N'Dobeles Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2047, 129, N'Gulbenes Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2048, 129, N'Jekabpils Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2049, 129, N'Jelgava', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2050, 129, N'Jelgavas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2051, 129, N'Jurmala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2052, 129, N'Kraslavas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2053, 129, N'Kuldigas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2054, 129, N'Leipaja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2055, 129, N'Liepajas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2056, 129, N'Limbazu Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2057, 129, N'Ludzas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2058, 129, N'Madonas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2059, 129, N'Ogres Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2060, 129, N'Preilu Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2061, 129, N'Rezekne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2062, 129, N'Rezeknes Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2063, 129, N'Riga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2064, 129, N'Rigas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2065, 129, N'Saldus Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2066, 129, N'Talsu Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2067, 129, N'Tukuma Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2068, 129, N'Valkas Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2069, 129, N'Valmieras Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2070, 129, N'Ventspils', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2071, 129, N'Ventspils Rajons', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2072, 130, N'Beyrouth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2073, 130, N'Ech Chimal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2074, 130, N'Ej Jnoub', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2075, 130, N'El Bekaa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2076, 130, N'Jabal Loubnane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2077, 131, N'Berea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2078, 131, N'Butha-Buthe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2079, 131, N'Leribe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2080, 131, N'Mafeteng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2081, 131, N'Maseru', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2082, 131, N'Mohales Hoek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2083, 131, N'Mokhotlong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2084, 131, N'Qacha''s Nek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2085, 131, N'Quthing', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2086, 131, N'Thaba-Tseka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2087, 132, N'Bomi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2088, 132, N'Bong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2089, 132, N'Grand Bassa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2090, 132, N'Grand Cape Mount', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2091, 132, N'Grand Gedeh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2092, 132, N'Grand Kru', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2093, 132, N'Lofa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2094, 132, N'Margibi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2095, 132, N'Maryland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2096, 132, N'Montserrado', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2097, 132, N'Nimba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2098, 132, N'River Cess', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2099, 132, N'Sinoe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2100, 133, N'Ajdabiya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2101, 133, N'Al ''Aziziyah', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2102, 133, N'Al Fatih', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2103, 133, N'Al Jabal al Akhdar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2104, 133, N'Al Jufrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2105, 133, N'Al Khums', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2106, 133, N'Al Kufrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2107, 133, N'An Nuqat al Khams', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2108, 133, N'Ash Shati''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2109, 133, N'Awbari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2110, 133, N'Az Zawiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2111, 133, N'Banghazi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2112, 133, N'Darnah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2113, 133, N'Ghadamis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2114, 133, N'Gharyan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2115, 133, N'Misratah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2116, 133, N'Murzuq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2117, 133, N'Sabha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2118, 133, N'Sawfajjin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2119, 133, N'Surt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2120, 133, N'Tarabulus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2121, 133, N'Tarhunah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2122, 133, N'Tubruq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2123, 133, N'Yafran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2124, 133, N'Zlitan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2125, 134, N'Balzers', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2126, 134, N'Eschen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2127, 134, N'Gamprin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2128, 134, N'Mauren', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2129, 134, N'Planken', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2130, 134, N'Ruggell', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2131, 134, N'Schaan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2132, 134, N'Schellenberg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2133, 134, N'Triesen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2134, 134, N'Triesenberg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2135, 134, N'Vaduz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2136, 137, N'Macau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2137, 135, N'Akmenes Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2138, 135, N'Alytaus Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2139, 135, N'Alytus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2140, 135, N'Anyksciu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2141, 135, N'Birstonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2142, 135, N'Birzu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2143, 135, N'Druskininkai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2144, 135, N'Ignalinos Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2145, 135, N'Jonavos Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2146, 135, N'Joniskio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2147, 135, N'Jurbarko Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2148, 135, N'Kaisiadoriu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2149, 135, N'Kaunas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2150, 135, N'Kauno Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2151, 135, N'Kedainiu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2152, 135, N'Kelmes Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2153, 135, N'Klaipeda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2154, 135, N'Klaipedos Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2155, 135, N'Kretingos Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2156, 135, N'Kupiskio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2157, 135, N'Lazdiju Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2158, 135, N'Marijampole', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2159, 135, N'Marijampoles Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2160, 135, N'Mazeikiu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2161, 135, N'Moletu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2162, 135, N'Neringa Pakruojo Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2163, 135, N'Palanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2164, 135, N'Panevezio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2165, 135, N'Panevezys', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2166, 135, N'Pasvalio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2167, 135, N'Plunges Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2168, 135, N'Prienu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2169, 135, N'Radviliskio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2170, 135, N'Raseiniu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2171, 135, N'Rokiskio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2172, 135, N'Sakiu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2173, 135, N'Salcininku Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2174, 135, N'Siauliai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2175, 135, N'Siauliu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2176, 135, N'Silales Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2177, 135, N'Silutes Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2178, 135, N'Sirvintu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2179, 135, N'Skuodo Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2180, 135, N'Svencioniu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2181, 135, N'Taurages Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2182, 135, N'Telsiu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2183, 135, N'Traku Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2184, 135, N'Ukmerges Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2185, 135, N'Utenos Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2186, 135, N'Varenos Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2187, 135, N'Vilkaviskio Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2188, 135, N'Vilniaus Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2189, 135, N'Vilnius', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2190, 135, N'Zarasu Rajonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2191, 136, N'Diekirch', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2192, 136, N'Grevenmacher', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2193, 136, N'Luxembourg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2194, 138, N'Aracinovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2195, 138, N'Bac', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2196, 138, N'Belcista', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2197, 138, N'Berovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2198, 138, N'Bistrica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2199, 138, N'Bitola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2200, 138, N'Blatec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2201, 138, N'Bogdanci', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2202, 138, N'Bogomila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2203, 138, N'Bogovinje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2204, 138, N'Bosilovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2205, 138, N'Brvenica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2206, 138, N'Cair (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2207, 138, N'Capari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2208, 138, N'Caska', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2209, 138, N'Cegrane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2210, 138, N'Centar (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2211, 138, N'Centar Zupa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2212, 138, N'Cesinovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2213, 138, N'Cucer-Sandevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2214, 138, N'Debar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2215, 138, N'Delcevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2216, 138, N'Delogozdi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2217, 138, N'Demir Hisar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2218, 138, N'Demir Kapija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2219, 138, N'Dobrusevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2220, 138, N'Dolna Banjica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2221, 138, N'Dolneni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2222, 138, N'Dorce Petrov (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2223, 138, N'Drugovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2224, 138, N'Dzepciste', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2225, 138, N'Gazi Baba (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2226, 138, N'Gevgelija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2227, 138, N'Gostivar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2228, 138, N'Gradsko', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2229, 138, N'Ilinden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2230, 138, N'Izvor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2231, 138, N'Jegunovce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2232, 138, N'Kamenjane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2233, 138, N'Karbinci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2234, 138, N'Karpos (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2235, 138, N'Kavadarci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2236, 138, N'Kicevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2237, 138, N'Kisela Voda (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2238, 138, N'Klecevce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2239, 138, N'Kocani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2240, 138, N'Konce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2241, 138, N'Kondovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2242, 138, N'Konopiste', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2243, 138, N'Kosel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2244, 138, N'Kratovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2245, 138, N'Kriva Palanka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2246, 138, N'Krivogastani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2247, 138, N'Krusevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2248, 138, N'Kuklis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2249, 138, N'Kukurecani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2250, 138, N'Kumanovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2251, 138, N'Labunista', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2252, 138, N'Lipkovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2253, 138, N'Lozovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2254, 138, N'Lukovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2255, 138, N'Makedonska Kamenica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2256, 138, N'Makedonski Brod', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2257, 138, N'Mavrovi Anovi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2258, 138, N'Meseista', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2259, 138, N'Miravci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2260, 138, N'Mogila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2261, 138, N'Murtino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2262, 138, N'Negotino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2263, 138, N'Negotino-Poloska', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2264, 138, N'Novaci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2265, 138, N'Novo Selo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2266, 138, N'Oblesevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2267, 138, N'Ohrid', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2268, 138, N'Orasac', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2269, 138, N'Orizari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2270, 138, N'Oslomej', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2271, 138, N'Pehcevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2272, 138, N'Petrovec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2273, 138, N'Plasnia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2274, 138, N'Podares', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2275, 138, N'Prilep', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2276, 138, N'Probistip', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2277, 138, N'Radovis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2278, 138, N'Rankovce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2279, 138, N'Resen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2280, 138, N'Rosoman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2281, 138, N'Rostusa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2282, 138, N'Samokov', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2283, 138, N'Saraj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2284, 138, N'Sipkovica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2285, 138, N'Sopiste', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2286, 138, N'Sopotnika', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2287, 138, N'Srbinovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2288, 138, N'Star Dojran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2289, 138, N'Staravina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2290, 138, N'Staro Nagoricane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2291, 138, N'Stip', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2292, 138, N'Struga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2293, 138, N'Strumica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2294, 138, N'Studenicani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2295, 138, N'Suto Orizari (Skopje)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2296, 138, N'Sveti Nikole', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2297, 138, N'Tearce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2298, 138, N'Tetovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2299, 138, N'Topolcani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2300, 138, N'Valandovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2301, 138, N'Vasilevo', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2302, 138, N'Veles', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2303, 138, N'Velesta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2304, 138, N'Vevcani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2305, 138, N'Vinica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2306, 138, N'Vitoliste', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2307, 138, N'Vranestica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2308, 138, N'Vrapciste', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2309, 138, N'Vratnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2310, 138, N'Vrutok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2311, 138, N'Zajas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2312, 138, N'Zelenikovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2313, 138, N'Zileno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2314, 138, N'Zitose', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2315, 138, N'Zletovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2316, 138, N'Zrnovci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2317, 139, N'Antananarivo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2318, 139, N'Antsiranana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2319, 139, N'Fianarantsoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2320, 139, N'Mahajanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2321, 139, N'Toamasina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2322, 139, N'Toliara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2323, 140, N'Balaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2324, 140, N'Blantyre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2325, 140, N'Chikwawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2326, 140, N'Chiradzulu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2327, 140, N'Chitipa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2328, 140, N'Dedza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2329, 140, N'Dowa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2330, 140, N'Karonga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2331, 140, N'Kasungu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2332, 140, N'Likoma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2333, 140, N'Lilongwe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2334, 140, N'Machinga (Kasupe)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2335, 140, N'Mangochi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2336, 140, N'Mchinji', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2337, 140, N'Mulanje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2338, 140, N'Mwanza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2339, 140, N'Mzimba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2340, 140, N'Nkhata Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2341, 140, N'Nkhotakota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2342, 140, N'Nsanje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2343, 140, N'Ntcheu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2344, 140, N'Ntchisi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2345, 140, N'Phalombe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2346, 140, N'Rumphi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2347, 140, N'Salima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2348, 140, N'Thyolo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2349, 140, N'Zomba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2350, 144, N'Valletta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2351, 145, N'Man, Isle of', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2352, 147, N'Martinique', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2353, 141, N'Johor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2354, 141, N'Kedah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2355, 141, N'Kelantan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2356, 141, N'Labuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2357, 141, N'Melaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2358, 141, N'Negeri Sembilan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2359, 141, N'Pahang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2360, 141, N'Perak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2361, 141, N'Perlis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2362, 141, N'Pulau Pinang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2363, 141, N'Sabah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2364, 141, N'Sarawak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2365, 141, N'Selangor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2366, 141, N'Terengganu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2367, 141, N'Wilayah Persekutuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2368, 142, N'Alifu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2369, 142, N'Baa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2370, 142, N'Dhaalu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2371, 142, N'Faafu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2372, 142, N'Gaafu Alifu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2373, 142, N'Gaafu Dhaalu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2374, 142, N'Gnaviyani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2375, 142, N'Haa Alifu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2376, 142, N'Haa Dhaalu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2377, 142, N'Kaafu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2378, 142, N'Laamu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2379, 142, N'Lhaviyani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2380, 142, N'Maale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2381, 142, N'Meemu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2382, 142, N'Noonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2383, 142, N'Raa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2384, 142, N'Seenu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2385, 142, N'Shaviyani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2386, 142, N'Thaa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2387, 142, N'Vaavu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2388, 143, N'Gao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2389, 143, N'Kayes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2390, 143, N'Kidal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2391, 143, N'Koulikoro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2392, 143, N'Mopti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2393, 143, N'Segou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2394, 143, N'Sikasso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2395, 143, N'Tombouctou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2396, 146, N'Ailinginae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2397, 146, N'Ailinglaplap', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2398, 146, N'Ailuk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2399, 146, N'Arno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2400, 146, N'Aur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2401, 146, N'Bikar', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2402, 146, N'Bikini', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2403, 146, N'Bokak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2404, 146, N'Ebon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2405, 146, N'Enewetak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2406, 146, N'Erikub', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2407, 146, N'Jabat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2408, 146, N'Jaluit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2409, 146, N'Jemo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2410, 146, N'Kili', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2411, 146, N'Kwajalein', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2412, 146, N'Lae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2413, 146, N'Lib', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2414, 146, N'Likiep', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2415, 146, N'Majuro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2416, 146, N'Maloelap', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2417, 146, N'Mejit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2418, 146, N'Mili', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2419, 146, N'Namorik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2420, 146, N'Namu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2421, 146, N'Rongelap', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2422, 146, N'Rongrik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2423, 146, N'Toke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2424, 146, N'Ujae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2425, 146, N'Ujelang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2426, 146, N'Utirik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2427, 146, N'Wotho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2428, 146, N'Wotje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2429, 148, N'Adrar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2430, 148, N'Assaba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2431, 148, N'Brakna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2432, 148, N'Dakhlet Nouadhibou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2433, 148, N'Gorgol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2434, 148, N'Guidimaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2435, 148, N'Hodh Ech Chargui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2436, 148, N'Hodh El Gharbi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2437, 148, N'Inchiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2438, 148, N'Nouakchott', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2439, 148, N'Tagant', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2440, 148, N'Tiris Zemmour', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2441, 148, N'Trarza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2442, 150, N'Mayotte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2443, 153, N'Midway Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2444, 149, N'Agalega Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2445, 149, N'Black River', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2446, 149, N'Cargados Carajos Shoals', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2447, 149, N'Flacq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2448, 149, N'Grand Port', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2449, 149, N'Moka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2450, 149, N'Pamplemousses', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2451, 149, N'Plaines Wilhems', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2452, 149, N'Port Louis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2453, 149, N'Riviere du Rempart', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2454, 149, N'Rodrigues', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2455, 149, N'Savanne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2456, 151, N'Aguascalientes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2457, 151, N'Baja California', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2458, 151, N'Baja California Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2459, 151, N'Campeche', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2460, 151, N'Chiapas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2461, 151, N'Chihuahua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2462, 151, N'Coahuila de Zaragoza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2463, 151, N'Colima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2464, 151, N'Distrito Federal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2465, 151, N'Durango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2466, 151, N'Guanajuato', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2467, 151, N'Guerrero', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2468, 151, N'Hidalgo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2469, 151, N'Jalisco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2470, 151, N'Mexico', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2471, 151, N'Michoacan de Ocampo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2472, 151, N'Morelos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2473, 151, N'Nayarit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2474, 151, N'Nuevo Leon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2475, 151, N'Oaxaca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2476, 151, N'Puebla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2477, 151, N'Queretaro de Arteaga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2478, 151, N'Quintana Roo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2479, 151, N'San Luis Potosi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2480, 151, N'Sinaloa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2481, 151, N'Sonora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2482, 151, N'Tabasco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2483, 151, N'Tamaulipas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2484, 151, N'Tlaxcala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2485, 151, N'Veracruz-Llave', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2486, 151, N'Yucatan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2487, 151, N'Zacatecas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2488, 152, N'Chuuk (Truk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2489, 152, N'Kosrae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2490, 152, N'Pohnpei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2491, 152, N'Yap', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2492, 154, N'Balti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2493, 154, N'Cahul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2494, 154, N'Chisinau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2495, 154, N'Chisinau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2496, 154, N'Dubasari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2497, 154, N'Edinet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2498, 154, N'Gagauzia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2499, 154, N'Lapusna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2500, 154, N'Orhei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2501, 154, N'Soroca', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2502, 154, N'Tighina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2503, 154, N'Ungheni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2504, 155, N'Fontvieille', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2505, 155, N'La Condamine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2506, 155, N'Monaco-Ville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2507, 155, N'Monte-Carlo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2508, 156, N'Arhangay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2509, 156, N'Bayan-Olgiy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2510, 156, N'Bayanhongor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2511, 156, N'Bulgan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2512, 156, N'Darhan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2513, 156, N'Dornod', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2514, 156, N'Dornogovi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2515, 156, N'Dundgovi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2516, 156, N'Dzavhan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2517, 156, N'Erdenet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2518, 156, N'Govi-Altay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2519, 156, N'Hentiy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2520, 156, N'Hovd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2521, 156, N'Hovsgol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2522, 156, N'Omnogovi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2523, 156, N'Ovorhangay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2524, 156, N'Selenge', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2525, 156, N'Suhbaatar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2526, 156, N'Tov', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2527, 156, N'Ulaanbaatar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2528, 156, N'Uvs', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2529, 157, N'Saint Anthony', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2530, 157, N'Saint Georges', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2531, 157, N'Saint Peter''s', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2532, 158, N'Agadir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2533, 158, N'Al Hoceima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2534, 158, N'Azilal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2535, 158, N'Ben Slimane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2536, 158, N'Beni Mellal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2537, 158, N'Boulemane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2538, 158, N'Casablanca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2539, 158, N'Chaouen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2540, 158, N'El Jadida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2541, 158, N'El Kelaa des Srarhna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2542, 158, N'Er Rachidia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2543, 158, N'Essaouira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2544, 158, N'Fes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2545, 158, N'Figuig', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2546, 158, N'Guelmim', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2547, 158, N'Ifrane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2548, 158, N'Kenitra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2549, 158, N'Khemisset', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2550, 158, N'Khenifra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2551, 158, N'Khouribga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2552, 158, N'Laayoune', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2553, 158, N'Larache', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2554, 158, N'Marrakech', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2555, 158, N'Meknes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2556, 158, N'Nador', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2557, 158, N'Ouarzazate', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2558, 158, N'Oujda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2559, 158, N'Rabat-Sale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2560, 158, N'Safi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2561, 158, N'Settat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2562, 158, N'Sidi Kacem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2563, 158, N'Tan-Tan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2564, 158, N'Tanger', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2565, 158, N'Taounate', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2566, 158, N'Taroudannt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2567, 158, N'Tata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2568, 158, N'Taza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2569, 158, N'Tetouan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2570, 158, N'Tiznit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2571, 159, N'Cabo Delgado', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2572, 159, N'Gaza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2573, 159, N'Inhambane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2574, 159, N'Manica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2575, 159, N'Maputo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2576, 159, N'Nampula', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2577, 159, N'Niassa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2578, 159, N'Sofala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2579, 159, N'Tete', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2580, 159, N'Zambezia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2581, 160, N'Caprivi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2582, 160, N'Erongo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2583, 160, N'Hardap', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2584, 160, N'Karas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2585, 160, N'Khomas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2586, 160, N'Kunene', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2587, 160, N'Ohangwena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2588, 160, N'Okavango', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2589, 160, N'Omaheke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2590, 160, N'Omusati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2591, 160, N'Oshana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2592, 160, N'Oshikoto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2593, 160, N'Otjozondjupa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2594, 164, N'Netherlands Antilles', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2595, 161, N'Aiwo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2596, 161, N'Anabar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2597, 161, N'Anetan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2598, 161, N'Anibare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2599, 161, N'Baiti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2600, 161, N'Boe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2601, 161, N'Buada', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2602, 161, N'Denigomodu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2603, 161, N'Ewa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2604, 161, N'Ijuw', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2605, 161, N'Meneng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2606, 161, N'Nibok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2607, 161, N'Uaboe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2608, 161, N'Yaren', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2609, 162, N'Bagmati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2610, 162, N'Bheri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2611, 162, N'Dhawalagiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2612, 162, N'Gandaki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2613, 162, N'Janakpur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2614, 162, N'Karnali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2615, 162, N'Kosi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2616, 162, N'Lumbini', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2617, 162, N'Mahakali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2618, 162, N'Mechi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2619, 162, N'Narayani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2620, 162, N'Rapti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2621, 162, N'Sagarmatha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2622, 162, N'Seti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2623, 163, N'Drenthe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2624, 163, N'Flevoland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2625, 163, N'Friesland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2626, 163, N'Gelderland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2627, 163, N'Groningen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2628, 163, N'Limburg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2629, 163, N'Noord-Brabant', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2630, 163, N'Noord-Holland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2631, 163, N'Overijssel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2632, 163, N'Utrecht', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2633, 163, N'Zeeland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2634, 163, N'Zuid-Holland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2635, 165, N'Iles Loyaute', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2636, 165, N'Nord', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2637, 165, N'Sud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2638, 166, N'Akaroa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2639, 166, N'Amuri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2640, 166, N'Ashburton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2641, 166, N'Bay of Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2642, 166, N'Bruce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2643, 166, N'Buller', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2644, 166, N'Chatham Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2645, 166, N'Cheviot', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2646, 166, N'Clifton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2647, 166, N'Clutha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2648, 166, N'Cook', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2649, 166, N'Dannevirke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2650, 166, N'Egmont', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2651, 166, N'Eketahuna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2652, 166, N'Ellesmere', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2653, 166, N'Eltham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2654, 166, N'Eyre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2655, 166, N'Featherston', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2656, 166, N'Franklin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2657, 166, N'Golden Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2658, 166, N'Great Barrier Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2659, 166, N'Grey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2660, 166, N'Hauraki Plains', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2661, 166, N'Hawera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2662, 166, N'Hawke''s Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2663, 166, N'Heathcote', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2664, 166, N'Hikurangi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2665, 166, N'Hobson', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2666, 166, N'Hokianga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2667, 166, N'Horowhenua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2668, 166, N'Hurunui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2669, 166, N'Hutt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2670, 166, N'Inangahua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2671, 166, N'Inglewood', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2672, 166, N'Kaikoura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2673, 166, N'Kairanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2674, 166, N'Kiwitea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2675, 166, N'Lake', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2676, 166, N'Mackenzie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2677, 166, N'Malvern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2678, 166, N'Manaia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2679, 166, N'Manawatu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2680, 166, N'Mangonui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2681, 166, N'Maniototo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2682, 166, N'Marlborough', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2683, 166, N'Masterton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2684, 166, N'Matamata', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2685, 166, N'Mount Herbert', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2686, 166, N'Ohinemuri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2687, 166, N'Opotiki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2688, 166, N'Oroua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2689, 166, N'Otamatea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2690, 166, N'Otorohanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2691, 166, N'Oxford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2692, 166, N'Pahiatua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2693, 166, N'Paparua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2694, 166, N'Patea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2695, 166, N'Piako', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2696, 166, N'Pohangina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2697, 166, N'Raglan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2698, 166, N'Rangiora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2699, 166, N'Rangitikei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2700, 166, N'Rodney', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2701, 166, N'Rotorua', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2702, 166, N'Runanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2703, 166, N'Saint Kilda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2704, 166, N'Silverpeaks', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2705, 166, N'Southland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2706, 166, N'Stewart Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2707, 166, N'Stratford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2708, 166, N'Strathallan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2709, 166, N'Taranaki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2710, 166, N'Taumarunui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2711, 166, N'Taupo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2712, 166, N'Tauranga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2713, 166, N'Thames-Coromandel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2714, 166, N'Tuapeka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2715, 166, N'Vincent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2716, 166, N'Waiapu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2717, 166, N'Waiheke', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2718, 166, N'Waihemo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2719, 166, N'Waikato', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2720, 166, N'Waikohu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2721, 166, N'Waimairi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2722, 166, N'Waimarino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2723, 166, N'Waimate', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2724, 166, N'Waimate West', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2725, 166, N'Waimea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2726, 166, N'Waipa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2727, 166, N'Waipawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2728, 166, N'Waipukurau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2729, 166, N'Wairarapa South', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2730, 166, N'Wairewa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2731, 166, N'Wairoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2732, 166, N'Waitaki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2733, 166, N'Waitomo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2734, 166, N'Waitotara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2735, 166, N'Wallace', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2736, 166, N'Wanganui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2737, 166, N'Waverley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2738, 166, N'Westland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2739, 166, N'Whakatane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2740, 166, N'Whangarei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2741, 166, N'Whangaroa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2742, 166, N'Woodville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2743, 170, N'Niue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2744, 171, N'Norfolk Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2745, 167, N'Atlantico Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2746, 167, N'Atlantico Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2747, 167, N'Boaco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2748, 167, N'Carazo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2749, 167, N'Chinandega', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2750, 167, N'Chontales', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2751, 167, N'Esteli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2752, 167, N'Granada', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2753, 167, N'Jinotega', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2754, 167, N'Leon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2755, 167, N'Madriz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2756, 167, N'Managua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2757, 167, N'Masaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2758, 167, N'Matagalpa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2759, 167, N'Nueva Segovia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2760, 167, N'Rio San Juan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2761, 167, N'Rivas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2762, 168, N'Agadez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2763, 168, N'Diffa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2764, 168, N'Dosso', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2765, 168, N'Maradi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2766, 168, N'Niamey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2767, 168, N'Tahoua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2768, 168, N'Tillaberi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2769, 168, N'Zinder', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2770, 169, N'Abia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2771, 169, N'Abuja Federal Capital Territory', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2772, 169, N'Adamawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2773, 169, N'Akwa Ibom', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2774, 169, N'Anambra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2775, 169, N'Bauchi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2776, 169, N'Bayelsa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2777, 169, N'Benue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2778, 169, N'Borno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2779, 169, N'Cross River', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2780, 169, N'Delta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2781, 169, N'Ebonyi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2782, 169, N'Edo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2783, 169, N'Ekiti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2784, 169, N'Enugu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2785, 169, N'Gombe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2786, 169, N'Imo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2787, 169, N'Jigawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2788, 169, N'Kaduna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2789, 169, N'Kano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2790, 169, N'Katsina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2791, 169, N'Kebbi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2792, 169, N'Kogi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2793, 169, N'Kwara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2794, 169, N'Lagos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2795, 169, N'Nassarawa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2796, 169, N'Niger', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2797, 169, N'Ogun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2798, 169, N'Ondo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2799, 169, N'Osun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2800, 169, N'Oyo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2801, 169, N'Plateau', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2802, 169, N'Rivers', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2803, 169, N'Sokoto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2804, 169, N'Taraba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2805, 169, N'Yobe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2806, 169, N'Zamfara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2807, 172, N'Northern Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2808, 172, N'Rota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2809, 172, N'Saipan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2810, 172, N'Tinian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2811, 173, N'Akershus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2812, 173, N'Aust-Agder', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2813, 173, N'Buskerud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2814, 173, N'Finnmark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2815, 173, N'Hedmark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2816, 173, N'Hordaland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2817, 173, N'More og Romsdal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2818, 173, N'Nord-Trondelag', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2819, 173, N'Nordland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2820, 173, N'Oppland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2821, 173, N'Oslo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2822, 173, N'Ostfold', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2823, 173, N'Rogaland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2824, 173, N'Sogn og Fjordane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2825, 173, N'Sor-Trondelag', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2826, 173, N'Telemark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2827, 173, N'Troms', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2828, 173, N'Vest-Agder', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2829, 173, N'Vestfold', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2830, 174, N'Ad Dakhiliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2831, 174, N'Al Batinah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2832, 174, N'Al Wusta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2833, 174, N'Ash Sharqiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2834, 174, N'Az Zahirah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2835, 174, N'Masqat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2836, 174, N'Musandam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2837, 174, N'Zufar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2838, 175, N'Balochistan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2839, 175, N'Federally Administered Tribal Areas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2840, 175, N'Islamabad Capital Territory', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2841, 175, N'North-West Frontier Province', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2842, 175, N'Punjab', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2843, 175, N'Sindh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2844, 176, N'Aimeliik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2845, 176, N'Airai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2846, 176, N'Angaur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2847, 176, N'Hatobohei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2848, 176, N'Kayangel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2849, 176, N'Koror', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2850, 176, N'Melekeok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2851, 176, N'Ngaraard', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2852, 176, N'Ngarchelong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2853, 176, N'Ngardmau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2854, 176, N'Ngatpang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2855, 176, N'Ngchesar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2856, 176, N'Ngeremlengui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2857, 176, N'Ngiwal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2858, 176, N'Palau Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2859, 176, N'Peleliu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2860, 176, N'Sonsoral', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2861, 176, N'Tobi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2862, 177, N'Bocas del Toro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2863, 177, N'Chiriqui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2864, 177, N'Cocle', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2865, 177, N'Colon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2866, 177, N'Darien', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2867, 177, N'Herrera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2868, 177, N'Los Santos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2869, 177, N'Panama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2870, 177, N'San Blas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2871, 177, N'Veraguas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2872, 178, N'Bougainville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2873, 178, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2874, 178, N'Chimbu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2875, 178, N'East New Britain', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2876, 178, N'East Sepik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2877, 178, N'Eastern Highlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2878, 178, N'Enga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2879, 178, N'Gulf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2880, 178, N'Madang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2881, 178, N'Manus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2882, 178, N'Milne Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2883, 178, N'Morobe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2884, 178, N'National Capital', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2885, 178, N'New Ireland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2886, 178, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2887, 178, N'Sandaun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2888, 178, N'Southern Highlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2889, 178, N'West New Britain', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2890, 178, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2891, 178, N'Western Highlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2892, 179, N'Alto Paraguay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2893, 179, N'Alto Parana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2894, 179, N'Amambay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2895, 179, N'Asuncion (city)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2896, 179, N'Boqueron', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2897, 179, N'Caaguazu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2898, 179, N'Caazapa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2899, 179, N'Canindeyu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2900, 179, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2901, 179, N'Concepcion', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2902, 179, N'Cordillera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2903, 179, N'Guaira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2904, 179, N'Itapua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2905, 179, N'Misiones', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2906, 179, N'Neembucu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2907, 179, N'Paraguari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2908, 179, N'Presidente Hayes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (2909, 179, N'San Pedro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3280, 180, N'Amazonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3281, 180, N'Ancash', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3282, 180, N'Apurimac', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3283, 180, N'Arequipa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3284, 180, N'Ayacucho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3285, 180, N'Cajamarca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3286, 180, N'Callao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3287, 180, N'Cusco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3288, 180, N'Huancavelica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3289, 180, N'Huanuco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3290, 180, N'Ica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3291, 180, N'Junin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3292, 180, N'La Libertad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3293, 180, N'Lambayeque', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3294, 180, N'Lima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3295, 180, N'Loreto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3296, 180, N'Madre de Dios', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3297, 180, N'Moquegua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3298, 180, N'Pasco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3299, 180, N'Piura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3300, 180, N'Puno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3301, 180, N'San Martin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3302, 180, N'Tacna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3303, 180, N'Tumbes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3304, 180, N'Ucayali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3305, 181, N'Abra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3306, 181, N'Agusan del Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3307, 181, N'Agusan del Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3308, 181, N'Aklan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3309, 181, N'Albay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3310, 181, N'Angeles', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3311, 181, N'Antique', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3312, 181, N'Aurora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3313, 181, N'Bacolod', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3314, 181, N'Bago', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3315, 181, N'Baguio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3316, 181, N'Bais', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3317, 181, N'Basilan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3318, 181, N'Basilan City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3319, 181, N'Bataan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3320, 181, N'Batanes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3321, 181, N'Batangas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3322, 181, N'Batangas City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3323, 181, N'Benguet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3324, 181, N'Bohol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3325, 181, N'Bukidnon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3326, 181, N'Bulacan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3327, 181, N'Butuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3328, 181, N'Cabanatuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3329, 181, N'Cadiz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3330, 181, N'Cagayan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3331, 181, N'Cagayan de Oro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3332, 181, N'Calbayog', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3333, 181, N'Caloocan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3334, 181, N'Camarines Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3335, 181, N'Camarines Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3336, 181, N'Camiguin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3337, 181, N'Canlaon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3338, 181, N'Capiz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3339, 181, N'Catanduanes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3340, 181, N'Cavite', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3341, 181, N'Cavite City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3342, 181, N'Cebu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3343, 181, N'Cebu City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3344, 181, N'Cotabato', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3345, 181, N'Dagupan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3346, 181, N'Danao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3347, 181, N'Dapitan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3348, 181, N'Davao City Davao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3349, 181, N'Davao del Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3350, 181, N'Davao Oriental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3351, 181, N'Dipolog', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3352, 181, N'Dumaguete', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3353, 181, N'Eastern Samar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3354, 181, N'General Santos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3355, 181, N'Gingoog', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3356, 181, N'Ifugao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3357, 181, N'Iligan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3358, 181, N'Ilocos Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3359, 181, N'Ilocos Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3360, 181, N'Iloilo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3361, 181, N'Iloilo City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3362, 181, N'Iriga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3363, 181, N'Isabela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3364, 181, N'Kalinga-Apayao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3365, 181, N'La Carlota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3366, 181, N'La Union', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3367, 181, N'Laguna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3368, 181, N'Lanao del Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3369, 181, N'Lanao del Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3370, 181, N'Laoag', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3371, 181, N'Lapu-Lapu', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3372, 181, N'Legaspi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3373, 181, N'Leyte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3374, 181, N'Lipa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3375, 181, N'Lucena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3376, 181, N'Maguindanao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3377, 181, N'Mandaue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3378, 181, N'Manila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3379, 181, N'Marawi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3380, 181, N'Marinduque', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3381, 181, N'Masbate', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3382, 181, N'Mindoro Occidental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3383, 181, N'Mindoro Oriental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3384, 181, N'Misamis Occidental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3385, 181, N'Misamis Oriental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3386, 181, N'Mountain', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3387, 181, N'Naga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3388, 181, N'Negros Occidental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3389, 181, N'Negros Oriental', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3390, 181, N'North Cotabato', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3391, 181, N'Northern Samar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3392, 181, N'Nueva Ecija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3393, 181, N'Nueva Vizcaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3394, 181, N'Olongapo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3395, 181, N'Ormoc', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3396, 181, N'Oroquieta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3397, 181, N'Ozamis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3398, 181, N'Pagadian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3399, 181, N'Palawan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3400, 181, N'Palayan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3401, 181, N'Pampanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3402, 181, N'Pangasinan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3403, 181, N'Pasay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3404, 181, N'Puerto Princesa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3405, 181, N'Quezon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3406, 181, N'Quezon City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3407, 181, N'Quirino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3408, 181, N'Rizal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3409, 181, N'Romblon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3410, 181, N'Roxas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3411, 181, N'Samar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3412, 181, N'San Carlos (in Negros Occidental)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3413, 181, N'San Carlos (in Pangasinan)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3414, 181, N'San Jose', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3415, 181, N'San Pablo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3416, 181, N'Silay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3417, 181, N'Siquijor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3418, 181, N'Sorsogon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3419, 181, N'South Cotabato', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3420, 181, N'Southern Leyte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3421, 181, N'Sultan Kudarat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3422, 181, N'Sulu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3423, 181, N'Surigao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3424, 181, N'Surigao del Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3425, 181, N'Surigao del Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3426, 181, N'Tacloban', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3427, 181, N'Tagaytay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3428, 181, N'Tagbilaran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3429, 181, N'Tangub', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3430, 181, N'Tarlac', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3431, 181, N'Tawitawi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3432, 181, N'Toledo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3433, 181, N'Trece Martires', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3434, 181, N'Zambales', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3435, 181, N'Zamboanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3436, 181, N'Zamboanga del Norte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3437, 181, N'Zamboanga del Sur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3439, 183, N'Dolnoslaskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3440, 183, N'Kujawsko-Pomorskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3441, 183, N'Lodzkie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3442, 183, N'Lubelskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3443, 183, N'Lubuskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3444, 183, N'Malopolskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3445, 183, N'Mazowieckie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3446, 183, N'Opolskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3447, 183, N'Podkarpackie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3448, 183, N'Podlaskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3449, 183, N'Pomorskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3450, 183, N'Slaskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3451, 183, N'Swietokrzyskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3452, 183, N'Warminsko-Mazurskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3453, 183, N'Wielkopolskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3454, 183, N'Zachodniopomorskie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3455, 184, N'Acores (Azores)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3456, 184, N'Aveiro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3457, 184, N'Beja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3458, 184, N'Braga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3459, 184, N'Braganca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3460, 184, N'Castelo Branco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3461, 184, N'Coimbra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3462, 184, N'Evora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3463, 184, N'Faro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3464, 184, N'Guarda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3465, 184, N'Leiria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3466, 184, N'Lisboa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3467, 184, N'Madeira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3468, 184, N'Portalegre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3469, 184, N'Porto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3470, 184, N'Santarem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3471, 184, N'Setubal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3472, 184, N'Viana do Castelo', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3473, 184, N'Vila Real', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3474, 184, N'Viseu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3475, 185, N'Adjuntas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3476, 185, N'Aguada', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3477, 185, N'Aguadilla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3478, 185, N'Aguas Buenas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3479, 185, N'Aibonito', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3480, 185, N'Anasco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3481, 185, N'Arecibo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3482, 185, N'Arroyo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3483, 185, N'Barceloneta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3484, 185, N'Barranquitas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3485, 185, N'Bayamon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3486, 185, N'Cabo Rojo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3487, 185, N'Caguas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3488, 185, N'Camuy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3489, 185, N'Canovanas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3490, 185, N'Carolina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3491, 185, N'Catano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3492, 185, N'Cayey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3493, 185, N'Ceiba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3494, 185, N'Ciales', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3495, 185, N'Cidra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3496, 185, N'Coamo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3497, 185, N'Comerio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3498, 185, N'Corozal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3499, 185, N'Culebra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3500, 185, N'Dorado', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3501, 185, N'Fajardo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3502, 185, N'Florida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3503, 185, N'Guanica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3504, 185, N'Guayama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3505, 185, N'Guayanilla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3506, 185, N'Guaynabo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3507, 185, N'Gurabo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3508, 185, N'Hatillo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3509, 185, N'Hormigueros', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3510, 185, N'Humacao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3511, 185, N'Isabela', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3512, 185, N'Jayuya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3513, 185, N'Juana Diaz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3514, 185, N'Juncos', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3515, 185, N'Lajas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3516, 185, N'Lares', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3517, 185, N'Las Marias', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3518, 185, N'Las Piedras', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3519, 185, N'Loiza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3520, 185, N'Luquillo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3521, 185, N'Manati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3522, 185, N'Maricao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3523, 185, N'Maunabo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3524, 185, N'Mayaguez', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3525, 185, N'Moca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3526, 185, N'Morovis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3527, 185, N'Naguabo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3528, 185, N'Naranjito', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3529, 185, N'Orocovis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3530, 185, N'Patillas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3531, 185, N'Penuelas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3532, 185, N'Ponce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3533, 185, N'Quebradillas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3534, 185, N'Rincon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3535, 185, N'Rio Grande', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3536, 185, N'Sabana Grande', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3537, 185, N'Salinas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3538, 185, N'San German', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3539, 185, N'San Juan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3540, 185, N'San Lorenzo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3541, 185, N'San Sebastian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3542, 185, N'Santa Isabel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3543, 185, N'Toa Alta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3544, 185, N'Toa Baja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3545, 185, N'Trujillo Alto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3546, 185, N'Utuado', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3547, 185, N'Vega Alta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3548, 185, N'Vega Baja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3549, 185, N'Vieques', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3550, 185, N'Villalba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3551, 185, N'Yabucoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3552, 185, N'Yauco', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3553, 186, N'Ad Dawhah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3554, 186, N'Al Ghuwayriyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3555, 186, N'Al Jumayliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3556, 186, N'Al Khawr', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3557, 186, N'Al Wakrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3558, 186, N'Ar Rayyan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3559, 186, N'Jarayan al Batinah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3560, 186, N'Madinat ash Shamal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3561, 186, N'Umm Salal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3562, 187, N'Reunion', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3563, 188, N'Alba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3564, 188, N'Arad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3565, 188, N'Arges', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3566, 188, N'Bacau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3567, 188, N'Bihor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3568, 188, N'Bistrita-Nasaud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3569, 188, N'Botosani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3570, 188, N'Braila', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3571, 188, N'Brasov', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3572, 188, N'Bucuresti', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3573, 188, N'Buzau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3574, 188, N'Calarasi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3575, 188, N'Caras-Severin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3576, 188, N'Cluj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3577, 188, N'Constanta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3578, 188, N'Covasna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3579, 188, N'Dimbovita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3580, 188, N'Dolj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3581, 188, N'Galati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3582, 188, N'Giurgiu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3583, 188, N'Gorj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3584, 188, N'Harghita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3585, 188, N'Hunedoara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3586, 188, N'Ialomita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3587, 188, N'Iasi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3588, 188, N'Maramures', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3589, 188, N'Mehedinti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3590, 188, N'Mures', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3591, 188, N'Neamt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3592, 188, N'Olt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3593, 188, N'Prahova', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3594, 188, N'Salaj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3595, 188, N'Satu Mare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3596, 188, N'Sibiu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3597, 188, N'Suceava', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3598, 188, N'Teleorman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3599, 188, N'Timis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3600, 188, N'Tulcea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3601, 188, N'Vaslui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3602, 188, N'Vilcea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3603, 188, N'Vrancea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3604, 189, N'Adygeya (Maykop)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3605, 189, N'Aginskiy Buryatskiy (Aginskoye)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3606, 189, N'Altay (Gorno-Altaysk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3607, 189, N'Altayskiy (Barnaul)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3608, 189, N'Amurskaya (Blagoveshchensk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3609, 189, N'Arkhangel''skaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3610, 189, N'Astrakhanskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3611, 189, N'Bashkortostan (Ufa)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3612, 189, N'Belgorodskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3613, 189, N'Bryanskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3614, 189, N'Buryatiya (Ulan-Ude)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3615, 189, N'Chechnya (Groznyy)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3616, 189, N'Chelyabinskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3617, 189, N'Chitinskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3618, 189, N'Chukotskiy (Anadyr'')', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3619, 189, N'Chuvashiya (Cheboksary)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3620, 189, N'Dagestan (Makhachkala)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3621, 189, N'Evenkiyskiy (Tura)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3622, 189, N'Ingushetiya (Nazran'')', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3623, 189, N'Irkutskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3624, 189, N'Ivanovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3625, 189, N'Kabardino-Balkariya (Nal''chik)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3626, 189, N'Kaliningradskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3627, 189, N'Kalmykiya (Elista)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3628, 189, N'Kaluzhskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3629, 189, N'Kamchatskaya (Petropavlovsk-Kamchatskiy)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3630, 189, N'Karachayevo-Cherkesiya (Cherkessk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3631, 189, N'Kareliya (Petrozavodsk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3632, 189, N'Kemerovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3633, 189, N'Khabarovskiy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3634, 189, N'Khakasiya (Abakan)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3635, 189, N'Khanty-Mansiyskiy (Khanty-Mansiysk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3636, 189, N'Kirovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3637, 189, N'Komi (Syktyvkar)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3638, 189, N'Komi-Permyatskiy (Kudymkar)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3639, 189, N'Koryakskiy (Palana)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3640, 189, N'Kostromskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3641, 189, N'Krasnodarskiy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3642, 189, N'Krasnoyarskiy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3643, 189, N'Kurganskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3644, 189, N'Kurskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3645, 189, N'Leningradskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3646, 189, N'Lipetskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3647, 189, N'Magadanskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3648, 189, N'Mariy-El (Yoshkar-Ola)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3649, 189, N'Mordoviya (Saransk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3650, 189, N'Moskovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3651, 189, N'Moskva (Moscow)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3652, 189, N'Murmanskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3653, 189, N'Nenetskiy (Nar''yan-Mar)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3654, 189, N'Nizhegorodskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3655, 189, N'Novgorodskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3656, 189, N'Novosibirskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3657, 189, N'Omskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3658, 189, N'Orenburgskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3659, 189, N'Orlovskaya (Orel)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3660, 189, N'Penzenskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3661, 189, N'Permskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3662, 189, N'Primorskiy (Vladivostok)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3663, 189, N'Pskovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3664, 189, N'Rostovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3665, 189, N'Ryazanskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3666, 189, N'Sakha (Yakutsk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3667, 189, N'Sakhalinskaya (Yuzhno-Sakhalinsk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3668, 189, N'Samarskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3669, 189, N'Sankt-Peterburg (Saint Petersburg)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3670, 189, N'Saratovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3671, 189, N'Severnaya Osetiya-Alaniya [North Ossetia] (Vladikavkaz)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3672, 189, N'Smolenskaya', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3673, 189, N'Stavropol''skiy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3674, 189, N'Sverdlovskaya (Yekaterinburg)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3675, 189, N'Tambovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3676, 189, N'Tatarstan (Kazan'')', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3677, 189, N'Taymyrskiy (Dudinka)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3678, 189, N'Tomskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3679, 189, N'Tul''skaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3680, 189, N'Tverskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3681, 189, N'Tyumenskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3682, 189, N'Tyva (Kyzyl)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3683, 189, N'Udmurtiya (Izhevsk)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3684, 189, N'Ul''yanovskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3685, 189, N'Ust''-Ordynskiy Buryatskiy (Ust''-Ordynskiy)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3686, 189, N'Vladimirskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3687, 189, N'Volgogradskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3688, 189, N'Vologodskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3689, 189, N'Voronezhskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3690, 189, N'Yamalo-Nenetskiy (Salekhard)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3691, 189, N'Yaroslavskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3692, 189, N'Yevreyskaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3693, 190, N'Butare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3694, 190, N'Byumba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3695, 190, N'Cyangugu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3696, 190, N'Gikongoro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3697, 190, N'Gisenyi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3698, 190, N'Gitarama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3699, 190, N'Kibungo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3700, 190, N'Kibuye', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3701, 190, N'Kigali Rurale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3702, 190, N'Kigali-ville', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3703, 190, N'Ruhengeri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3704, 190, N'Umutara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3705, 191, N'Ascension', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3706, 191, N'Saint Helena', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3707, 191, N'Tristan da Cunha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3708, 192, N'Christ Church Nichola Town', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3709, 192, N'Saint Anne Sandy Point', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3710, 192, N'Saint George Basseterre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3711, 192, N'Saint George Gingerland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3712, 192, N'Saint James Windward', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3713, 192, N'Saint John Capisterre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3714, 192, N'Saint John Figtree', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3715, 192, N'Saint Mary Cayon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3716, 192, N'Saint Paul Capisterre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3717, 192, N'Saint Paul Charlestown', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3718, 192, N'Saint Peter Basseterre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3719, 192, N'Saint Thomas Lowland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3720, 192, N'Saint Thomas Middle Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3721, 192, N'Trinity Palmetto Point', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3722, 193, N'Anse-la-Raye', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3723, 193, N'Castries', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3724, 193, N'Choiseul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3725, 193, N'Dauphin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3726, 193, N'Dennery', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3727, 193, N'Gros Islet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3728, 193, N'Laborie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3729, 193, N'Micoud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3730, 193, N'Praslin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3731, 193, N'Soufriere', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3732, 193, N'Vieux Fort', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3733, 194, N'Miquelon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3734, 194, N'Saint Pierre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3735, 195, N'Charlotte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3736, 195, N'Grenadines', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3737, 195, N'Saint Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3738, 195, N'Saint David', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3739, 195, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3740, 195, N'Saint Patrick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3741, 196, N'A''ana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3742, 196, N'Aiga-i-le-Tai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3743, 196, N'Atua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3744, 196, N'Fa''asaleleaga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3745, 196, N'Gaga''emauga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3746, 196, N'Gagaifomauga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3747, 196, N'Palauli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3748, 196, N'Satupa''itea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3749, 196, N'Tuamasaga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3750, 196, N'Va''a-o-Fonoti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3751, 196, N'Vaisigano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3752, 197, N'Acquaviva', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3753, 197, N'Borgo Maggiore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3754, 197, N'Chiesanuova', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3755, 197, N'Domagnano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3756, 197, N'Faetano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3757, 197, N'Fiorentino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3758, 197, N'Monte Giardino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3759, 197, N'San Marino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3760, 197, N'Serravalle', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3761, 198, N'Principe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3762, 198, N'Sao Tome', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3763, 199, N'''Asir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3764, 199, N'Al Bahah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3765, 199, N'Al Hudud ash Shamaliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3766, 199, N'Al Jawf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3767, 199, N'Al Madinah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3768, 199, N'Al Qasim', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3769, 199, N'Ar Riyad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3770, 199, N'Ash Sharqiyah (Eastern Province)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3771, 199, N'Ha''il', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3772, 199, N'Jizan', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3773, 199, N'Makkah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3774, 199, N'Najran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3775, 199, N'Tabuk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3776, 200, N'Aberdeen City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3777, 200, N'Aberdeenshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3778, 200, N'Angus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3779, 200, N'Argyll and Bute', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3780, 200, N'City of Edinburgh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3781, 200, N'Clackmannanshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3782, 200, N'Dumfries and Galloway', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3783, 200, N'Dundee City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3784, 200, N'East Ayrshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3785, 200, N'East Dunbartonshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3786, 200, N'East Lothian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3787, 200, N'East Renfrewshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3788, 200, N'Eilean Siar (Western Isles)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3789, 200, N'Falkirk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3790, 200, N'Fife', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3791, 200, N'Glasgow City', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3792, 200, N'Highland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3793, 200, N'Inverclyde', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3794, 200, N'Midlothian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3795, 200, N'Moray', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3796, 200, N'North Ayrshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3797, 200, N'North Lanarkshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3798, 200, N'Orkney Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3799, 200, N'Perth and Kinross', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3800, 200, N'Renfrewshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3801, 200, N'Shetland Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3802, 200, N'South Ayrshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3803, 200, N'South Lanarkshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3804, 200, N'Stirling', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3805, 200, N'The Scottish Borders', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3806, 200, N'West Dunbartonshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3807, 200, N'West Lothian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3808, 201, N'Dakar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3809, 201, N'Diourbel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3810, 201, N'Fatick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3811, 201, N'Kaolack', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3812, 201, N'Kolda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3813, 201, N'Louga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3814, 201, N'Saint-Louis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3815, 201, N'Tambacounda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3816, 201, N'Thies', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3817, 201, N'Ziguinchor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3818, 202, N'Anse aux Pins', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3819, 202, N'Anse Boileau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3820, 202, N'Anse Etoile', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3821, 202, N'Anse Louis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3822, 202, N'Anse Royale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3823, 202, N'Baie Lazare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3824, 202, N'Baie Sainte Anne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3825, 202, N'Beau Vallon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3826, 202, N'Bel Air', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3827, 202, N'Bel Ombre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3828, 202, N'Cascade', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3829, 202, N'Glacis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3830, 202, N'Grand'' Anse (on Mahe)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3831, 202, N'Grand'' Anse (on Praslin)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3832, 202, N'La Digue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3833, 202, N'La Riviere Anglaise', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3834, 202, N'Mont Buxton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3835, 202, N'Mont Fleuri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3836, 202, N'Plaisance', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3837, 202, N'Pointe La Rue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3838, 202, N'Port Glaud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3839, 202, N'Saint Louis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3840, 202, N'Takamaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3841, 203, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3842, 203, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3843, 203, N'Southern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3844, 203, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (3845, 204, N'Singapore', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4127, 205, N'Banskobystricky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4128, 205, N'Bratislavsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4129, 205, N'Kosicky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4130, 205, N'Nitriansky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4131, 205, N'Presovsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4132, 205, N'Trenciansky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4133, 205, N'Trnavsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4134, 205, N'Zilinsky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4135, 207, N'Bellona', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4136, 207, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4137, 207, N'Choiseul (Lauru)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4138, 207, N'Guadalcanal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4139, 207, N'Honiara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4140, 207, N'Isabel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4141, 207, N'Makira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4142, 207, N'Malaita', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4143, 207, N'Rennell', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4144, 207, N'Temotu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4145, 207, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4146, 208, N'Awdal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4147, 208, N'Bakool', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4148, 208, N'Banaadir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4149, 208, N'Bari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4150, 208, N'Bay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4151, 208, N'Galguduud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4152, 208, N'Gedo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4153, 208, N'Hiiraan', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4154, 208, N'Jubbada Dhexe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4155, 208, N'Jubbada Hoose', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4156, 208, N'Mudug', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4157, 208, N'Nugaal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4158, 208, N'Sanaag', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4159, 208, N'Shabeellaha Dhexe', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4160, 208, N'Shabeellaha Hoose', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4161, 208, N'Sool', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4162, 208, N'Togdheer', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4163, 208, N'Woqooyi Galbeed', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4164, 209, N'Eastern Cape', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4165, 209, N'Free State', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4166, 209, N'Gauteng', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4167, 209, N'KwaZulu-Natal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4168, 209, N'Mpumalanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4169, 209, N'North-West', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4170, 209, N'Northern Cape', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4171, 209, N'Northern Province', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4172, 209, N'Western Cape', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4173, 210, N'Bird Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4174, 210, N'Bristol Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4175, 210, N'Clerke Rocks', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4176, 210, N'Montagu Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4177, 210, N'Saunders Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4178, 210, N'South Georgia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4179, 210, N'Southern Thule', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4180, 210, N'Traversay Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4203, 212, N'Spratly Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4214, 214, N'A''ali an Nil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4215, 214, N'Al Bahr al Ahmar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4216, 214, N'Al Buhayrat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4217, 214, N'Al Jazirah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4218, 214, N'Al Khartum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4219, 214, N'Al Qadarif', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4220, 214, N'Al Wahdah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4221, 214, N'An Nil al Abyad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4222, 214, N'An Nil al Azraq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4223, 214, N'Ash Shamaliyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4224, 214, N'Bahr al Jabal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4225, 214, N'Gharb al Istiwa''iyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4226, 214, N'Gharb Bahr al Ghazal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4227, 214, N'Gharb Darfur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4228, 214, N'Gharb Kurdufan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4229, 214, N'Janub Darfur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4230, 214, N'Janub Kurdufan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4231, 214, N'Junqali', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4232, 214, N'Kassala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4233, 214, N'Nahr an Nil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4234, 214, N'Shamal Bahr al Ghazal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4235, 214, N'Shamal Darfur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4236, 214, N'Shamal Kurdufan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4237, 214, N'Sharq al Istiwa''iyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4238, 214, N'Sinnar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4239, 214, N'Warab', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4240, 215, N'Brokopondo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4241, 215, N'Commewijne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4242, 215, N'Coronie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4243, 215, N'Marowijne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4244, 215, N'Nickerie', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4245, 215, N'Para', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4246, 215, N'Paramaribo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4247, 215, N'Saramacca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4248, 215, N'Sipaliwini', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4249, 215, N'Wanica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4258, 211, N'Andalucia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4259, 211, N'Aragon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4260, 211, N'Asturias', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4261, 211, N'Baleares (Balearic Islands)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4262, 211, N'Canarias (Canary Islands)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4263, 211, N'Cantabria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4264, 211, N'Castilla y Leon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4265, 211, N'Castilla-La Mancha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4266, 211, N'Cataluna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4267, 211, N'Ceuta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4268, 211, N'Communidad Valencian', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4269, 211, N'Extremadura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4270, 211, N'Galicia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4271, 211, N'Islas Chafarinas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4272, 211, N'La Rioja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4273, 211, N'Madrid', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4274, 211, N'Melilla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4275, 211, N'Murcia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4276, 211, N'Navarra', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4277, 211, N'Pais Vasco (Basque Country)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4278, 211, N'Penon de Alhucemas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4279, 211, N'Penon de Velez de la Gomera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4281, 213, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4282, 213, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4283, 213, N'North Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4284, 213, N'North Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4285, 213, N'North Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4286, 213, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4287, 213, N'Sabaragamuwa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4288, 213, N'Southern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4289, 213, N'Uva', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4290, 213, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4327, 216, N'Barentsoya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4328, 216, N'Bjornoya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4329, 216, N'Edgeoya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4330, 216, N'Hopen', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4331, 216, N'Kvitoya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4332, 216, N'Nordaustandet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4333, 216, N'Prins Karls Forland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4334, 216, N'Spitsbergen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4335, 217, N'Hhohho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4336, 217, N'Lubombo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4337, 217, N'Manzini', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4338, 217, N'Shiselweni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4339, 218, N'Blekinge', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4340, 218, N'Dalarnas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4341, 218, N'Gavleborgs', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4342, 218, N'Gotlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4343, 218, N'Hallands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4344, 218, N'Jamtlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4345, 218, N'Jonkopings', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4346, 218, N'Kalmar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4347, 218, N'Kronobergs', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4348, 218, N'Norrbottens', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4349, 218, N'Orebro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4350, 218, N'Ostergotlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4351, 218, N'Skane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4352, 218, N'Sodermanlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4353, 218, N'Stockholms', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4354, 218, N'Uppsala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4355, 218, N'Varmlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4356, 218, N'Vasterbottens', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4357, 218, N'Vasternorrlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4358, 218, N'Vastmanlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4359, 218, N'Vastra Gotalands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4360, 219, N'Aargau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4361, 219, N'Ausser-Rhoden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4362, 219, N'Basel-Landschaft', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4363, 219, N'Basel-Stadt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4364, 219, N'Bern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4365, 219, N'Fribourg', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4366, 219, N'Geneve', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4367, 219, N'Glarus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4368, 219, N'Graubunden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4369, 219, N'Inner-Rhoden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4370, 219, N'Jura', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4371, 219, N'Luzern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4372, 219, N'Neuchatel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4373, 219, N'Nidwalden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4374, 219, N'Obwalden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4375, 219, N'Sankt Gallen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4376, 219, N'Schaffhausen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4377, 219, N'Schwyz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4378, 219, N'Solothurn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4379, 219, N'Thurgau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4380, 219, N'Ticino', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4381, 219, N'Uri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4382, 219, N'Valais', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4383, 219, N'Vaud', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4384, 219, N'Zug', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4385, 219, N'Zurich', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4386, 220, N'Al Hasakah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4387, 220, N'Al Ladhiqiyah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4388, 220, N'Al Qunaytirah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4389, 220, N'Ar Raqqah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4390, 220, N'As Suwayda''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4391, 220, N'Dar''a', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4392, 220, N'Dayr az Zawr', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4393, 220, N'Dimashq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4394, 220, N'Halab', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4395, 220, N'Hamah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4396, 220, N'Hims', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4397, 220, N'Idlib', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4398, 220, N'Rif Dimashq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4399, 220, N'Tartus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4400, 221, N'Chang-hua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4401, 221, N'Chi-lung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4402, 221, N'Chia-i', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4403, 221, N'Chia-i', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4404, 221, N'Chung-hsing-hsin-ts''un', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4405, 221, N'Hsin-chu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4406, 221, N'Hsin-chu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4407, 221, N'Hua-lien', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4408, 221, N'I-lan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4409, 221, N'Kao-hsiung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4410, 221, N'Kao-hsiung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4411, 221, N'Miao-li', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4412, 221, N'Nan-t''ou', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4413, 221, N'P''eng-hu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4414, 221, N'P''ing-tung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4415, 221, N'T''ai-chung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4416, 221, N'T''ai-chung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4417, 221, N'T''ai-nan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4418, 221, N'T''ai-nan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4419, 221, N'T''ai-pei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4420, 221, N'T''ai-pei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4421, 221, N'T''ai-tung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4422, 221, N'T''ao-yuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4423, 221, N'Yun-lin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4424, 222, N'Viloyati Khatlon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4425, 222, N'Viloyati Leninobod', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4426, 222, N'Viloyati Mukhtori Kuhistoni Badakhshon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4427, 223, N'Arusha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4428, 223, N'Dar es Salaam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4429, 223, N'Dodoma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4430, 223, N'Iringa', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4431, 223, N'Kagera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4432, 223, N'Kigoma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4433, 223, N'Kilimanjaro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4434, 223, N'Lindi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4435, 223, N'Mara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4436, 223, N'Mbeya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4437, 223, N'Morogoro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4438, 223, N'Mtwara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4439, 223, N'Mwanza', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4440, 223, N'Pemba North', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4441, 223, N'Pemba South', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4442, 223, N'Pwani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4443, 223, N'Rukwa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4444, 223, N'Ruvuma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4445, 223, N'Shinyanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4446, 223, N'Singida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4447, 223, N'Tabora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4448, 223, N'Tanga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4449, 223, N'Zanzibar Central/South', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4450, 223, N'Zanzibar North', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4451, 223, N'Zanzibar Urban/West', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4452, 224, N'Amnat Charoen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4453, 224, N'Ang Thong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4454, 224, N'Buriram', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4455, 224, N'Chachoengsao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4456, 224, N'Chai Nat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4457, 224, N'Chaiyaphum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4458, 224, N'Chanthaburi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4459, 224, N'Chiang Mai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4460, 224, N'Chiang Rai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4461, 224, N'Chon Buri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4462, 224, N'Chumphon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4463, 224, N'Kalasin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4464, 224, N'Kamphaeng Phet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4465, 224, N'Kanchanaburi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4466, 224, N'Khon Kaen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4467, 224, N'Krabi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4468, 224, N'Krung Thep Mahanakhon (Bangkok)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4469, 224, N'Lampang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4470, 224, N'Lamphun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4471, 224, N'Loei', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4472, 224, N'Lop Buri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4473, 224, N'Mae Hong Son', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4474, 224, N'Maha Sarakham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4475, 224, N'Mukdahan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4476, 224, N'Nakhon Nayok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4477, 224, N'Nakhon Pathom', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4478, 224, N'Nakhon Phanom', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4479, 224, N'Nakhon Ratchasima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4480, 224, N'Nakhon Sawan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4481, 224, N'Nakhon Si Thammarat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4482, 224, N'Nan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4483, 224, N'Narathiwat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4484, 224, N'Nong Bua Lamphu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4485, 224, N'Nong Khai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4486, 224, N'Nonthaburi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4487, 224, N'Pathum Thani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4488, 224, N'Pattani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4489, 224, N'Phangnga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4490, 224, N'Phatthalung', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4491, 224, N'Phayao', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4492, 224, N'Phetchabun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4493, 224, N'Phetchaburi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4494, 224, N'Phichit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4495, 224, N'Phitsanulok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4496, 224, N'Phra Nakhon Si Ayutthaya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4497, 224, N'Phrae', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4498, 224, N'Phuket', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4499, 224, N'Prachin Buri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4500, 224, N'Prachuap Khiri Khan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4501, 224, N'Ranong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4502, 224, N'Ratchaburi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4503, 224, N'Rayong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4504, 224, N'Roi Et', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4505, 224, N'Sa Kaeo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4506, 224, N'Sakon Nakhon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4507, 224, N'Samut Prakan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4508, 224, N'Samut Sakhon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4509, 224, N'Samut Songkhram', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4510, 224, N'Sara Buri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4511, 224, N'Satun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4512, 224, N'Sing Buri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4513, 224, N'Sisaket', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4514, 224, N'Songkhla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4515, 224, N'Sukhothai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4516, 224, N'Suphan Buri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4517, 224, N'Surat Thani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4518, 224, N'Surin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4519, 224, N'Tak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4520, 224, N'Trang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4521, 224, N'Trat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4522, 224, N'Ubon Ratchathani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4523, 224, N'Udon Thani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4524, 224, N'Uthai Thani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4525, 224, N'Uttaradit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4526, 224, N'Yala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4527, 224, N'Yasothon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4528, 225, N'Tobago', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4529, 226, N'De La Kara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4530, 226, N'Des Plateaux', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4531, 226, N'Des Savanes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4532, 226, N'Du Centre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4533, 226, N'Maritime', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4534, 227, N'Atafu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4535, 227, N'Fakaofo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4536, 227, N'Nukunonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4537, 228, N'Ha''apai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4538, 228, N'Tongatapu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4539, 228, N'Vava''u', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4540, 229, N'Arima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4541, 229, N'Caroni', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4542, 229, N'Mayaro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4543, 229, N'Nariva', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4544, 229, N'Port-of-Spain', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4545, 229, N'Saint Andrew', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4546, 229, N'Saint David', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4547, 229, N'Saint George', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4548, 229, N'Saint Patrick', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4549, 229, N'San Fernando', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4550, 229, N'Victoria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4551, 230, N'Ariana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4552, 230, N'Beja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4553, 230, N'Ben Arous', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4554, 230, N'Bizerte', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4555, 230, N'El Kef', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4556, 230, N'Gabes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4557, 230, N'Gafsa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4558, 230, N'Jendouba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4559, 230, N'Kairouan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4560, 230, N'Kasserine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4561, 230, N'Kebili', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4562, 230, N'Mahdia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4563, 230, N'Medenine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4564, 230, N'Monastir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4565, 230, N'Nabeul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4566, 230, N'Sfax', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4567, 230, N'Sidi Bou Zid', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4568, 230, N'Siliana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4569, 230, N'Sousse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4570, 230, N'Tataouine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4571, 230, N'Tozeur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4572, 230, N'Tunis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4573, 230, N'Zaghouan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4574, 231, N'Adana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4575, 231, N'Adiyaman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4576, 231, N'Afyon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4577, 231, N'Agri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4578, 231, N'Aksaray', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4579, 231, N'Amasya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4580, 231, N'Ankara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4581, 231, N'Antalya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4582, 231, N'Ardahan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4583, 231, N'Artvin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4584, 231, N'Aydin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4585, 231, N'Balikesir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4586, 231, N'Bartin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4587, 231, N'Batman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4588, 231, N'Bayburt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4589, 231, N'Bilecik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4590, 231, N'Bingol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4591, 231, N'Bitlis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4592, 231, N'Bolu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4593, 231, N'Burdur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4594, 231, N'Bursa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4595, 231, N'Canakkale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4596, 231, N'Cankiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4597, 231, N'Corum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4598, 231, N'Denizli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4599, 231, N'Diyarbakir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4600, 231, N'Duzce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4601, 231, N'Edirne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4602, 231, N'Elazig', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4603, 231, N'Erzincan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4604, 231, N'Erzurum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4605, 231, N'Eskisehir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4606, 231, N'Gaziantep', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4607, 231, N'Giresun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4608, 231, N'Gumushane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4609, 231, N'Hakkari', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4610, 231, N'Hatay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4611, 231, N'Icel', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4612, 231, N'Igdir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4613, 231, N'Isparta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4614, 231, N'Istanbul', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4615, 231, N'Izmir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4616, 231, N'Kahramanmaras', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4617, 231, N'Karabuk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4618, 231, N'Karaman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4619, 231, N'Kars', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4620, 231, N'Kastamonu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4621, 231, N'Kayseri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4622, 231, N'Kilis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4623, 231, N'Kirikkale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4624, 231, N'Kirklareli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4625, 231, N'Kirsehir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4626, 231, N'Kocaeli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4627, 231, N'Konya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4628, 231, N'Kutahya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4629, 231, N'Malatya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4630, 231, N'Manisa', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4631, 231, N'Mardin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4632, 231, N'Mugla', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4633, 231, N'Mus', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4634, 231, N'Nevsehir', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4635, 231, N'Nigde', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4636, 231, N'Ordu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4637, 231, N'Osmaniye', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4638, 231, N'Rize', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4639, 231, N'Sakarya', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4640, 231, N'Samsun', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4641, 231, N'Sanliurfa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4642, 231, N'Siirt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4643, 231, N'Sinop', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4644, 231, N'Sirnak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4645, 231, N'Sivas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4646, 231, N'Tekirdag', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4647, 231, N'Tokat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4648, 231, N'Trabzon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4649, 231, N'Tunceli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4650, 231, N'Usak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4651, 231, N'Van', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4652, 231, N'Yalova', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4653, 231, N'Yozgat', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4654, 231, N'Zonguldak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4655, 232, N'Ahal Welayaty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4656, 232, N'Balkan Welayaty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4657, 232, N'Dashhowuz Welayaty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4658, 232, N'Lebap Welayaty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4659, 232, N'Mary Welayaty', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4660, 233, N'Tuvalu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4661, 234, N'Adjumani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4662, 234, N'Apac', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4663, 234, N'Arua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4664, 234, N'Bugiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4665, 234, N'Bundibugyo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4666, 234, N'Bushenyi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4667, 234, N'Busia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4668, 234, N'Gulu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4669, 234, N'Hoima', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4670, 234, N'Iganga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4671, 234, N'Jinja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4672, 234, N'Kabale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4673, 234, N'Kabarole', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4674, 234, N'Kalangala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4675, 234, N'Kampala', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4676, 234, N'Kamuli', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4677, 234, N'Kapchorwa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4678, 234, N'Kasese', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4679, 234, N'Katakwi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4680, 234, N'Kibale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4681, 234, N'Kiboga', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4682, 234, N'Kisoro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4683, 234, N'Kitgum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4684, 234, N'Kotido', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4685, 234, N'Kumi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4686, 234, N'Lira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4687, 234, N'Luwero', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4688, 234, N'Masaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4689, 234, N'Masindi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4690, 234, N'Mbale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4691, 234, N'Mbarara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4692, 234, N'Moroto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4693, 234, N'Moyo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4694, 234, N'Mpigi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4695, 234, N'Mubende', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4696, 234, N'Mukono', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4697, 234, N'Nakasongola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4698, 234, N'Nebbi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4699, 234, N'Ntungamo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4700, 234, N'Pallisa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4701, 234, N'Rakai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4702, 234, N'Rukungiri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4703, 234, N'Sembabule', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4704, 234, N'Soroti', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4705, 234, N'Tororo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4706, 235, N'Avtonomna Respublika Krym (Simferopol'')', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4707, 235, N'Cherkas''ka (Cherkasy)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4708, 235, N'Chernihivs''ka (Chernihiv)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4709, 235, N'Chernivets''ka (Chernivtsi)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4710, 235, N'Dnipropetrovs''ka (Dnipropetrovs''k)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4711, 235, N'Donets''ka (Donets''k)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4712, 235, N'Ivano-Frankivs''ka (Ivano-Frankivs''k)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4713, 235, N'Kharkivs''ka (Kharkiv)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4714, 235, N'Khersons''ka (Kherson)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4715, 235, N'Khmel''nyts''ka (Khmel''nyts''kyy)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4716, 235, N'Kirovohrads''ka (Kirovohrad)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4717, 235, N'Kyyiv', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4718, 235, N'Kyyivs''ka (Kiev)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4719, 235, N'L''vivs''ka (L''viv)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4720, 235, N'Luhans''ka (Luhans''k)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4721, 235, N'Mykolayivs''ka (Mykolayiv)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4722, 235, N'Odes''ka (Odesa)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4723, 235, N'Poltavs''ka (Poltava)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4724, 235, N'Rivnens''ka (Rivne)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4725, 235, N'Sevastopol''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4726, 235, N'Sums''ka (Sumy)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4727, 235, N'Ternopil''s''ka (Ternopil'')', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4728, 235, N'Vinnyts''ka (Vinnytsya)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4729, 235, N'Volyns''ka (Luts''k)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4730, 235, N'Zakarpats''ka (Uzhhorod)', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4731, 235, N'Zaporiz''ka (Zaporizhzhya)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4732, 235, N'Zhytomyrs''ka (Zhytomyr)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4733, 236, N'''Ajman', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4734, 236, N'Abu Zaby (Abu Dhabi)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4735, 236, N'Al Fujayrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4736, 236, N'Ash Shariqah (Sharjah)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4737, 236, N'Dubayy (Dubai)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4738, 236, N'Ra''s al Khaymah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4739, 236, N'Umm al Qaywayn', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4740, 237, N'Barking and Dagenham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4741, 237, N'Barnet', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4742, 237, N'Barnsley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4743, 237, N'Bath and North East Somerset', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4744, 237, N'Bedfordshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4745, 237, N'Bexley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4746, 237, N'Birmingham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4747, 237, N'Blackburn with Darwen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4748, 237, N'Blackpool', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4749, 237, N'Bolton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4750, 237, N'Bournemouth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4751, 237, N'Bracknell Forest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4752, 237, N'Bradford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4753, 237, N'Brent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4754, 237, N'Brighton and Hove', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4755, 237, N'Bromley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4756, 237, N'Buckinghamshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4757, 237, N'Bury', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4758, 237, N'Calderdale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4759, 237, N'Cambridgeshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4760, 237, N'Camden', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4761, 237, N'Cheshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4762, 237, N'City of Bristol', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4763, 237, N'City of Kingston upon Hull', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4764, 237, N'City of London', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4765, 237, N'Cornwall', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4766, 237, N'Coventry', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4767, 237, N'Croydon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4768, 237, N'Cumbria', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4769, 237, N'Darlington', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4770, 237, N'Derby', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4771, 237, N'Derbyshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4772, 237, N'Devon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4773, 237, N'Doncaster', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4774, 237, N'Dorset', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4775, 237, N'Dudley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4776, 237, N'Durham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4777, 237, N'Ealing', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4778, 237, N'East Riding of Yorkshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4779, 237, N'East Sussex', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4780, 237, N'Enfield', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4781, 237, N'Essex', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4782, 237, N'Gateshead', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4783, 237, N'Gloucestershire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4784, 237, N'Greenwich', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4785, 237, N'Hackney', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4786, 237, N'Halton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4787, 237, N'Hammersmith and Fulham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4788, 237, N'Hampshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4789, 237, N'Haringey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4790, 237, N'Harrow', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4791, 237, N'Hartlepool', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4792, 237, N'Havering', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4793, 237, N'Herefordshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4794, 237, N'Hertfordshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4795, 237, N'Hillingdon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4796, 237, N'Hounslow', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4797, 237, N'Isle of Wight', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4798, 237, N'Islington', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4799, 237, N'Kensington and Chelsea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4800, 237, N'Kent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4801, 237, N'Kingston upon Thames', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4802, 237, N'Kirklees', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4803, 237, N'Knowsley', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4804, 237, N'Lambeth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4805, 237, N'Lancashire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4806, 237, N'Leeds', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4807, 237, N'Leicester', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4808, 237, N'Leicestershire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4809, 237, N'Lewisham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4810, 237, N'Lincolnshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4811, 237, N'Liverpool', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4812, 237, N'Luton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4813, 237, N'Manchester', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4814, 237, N'Medway', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4815, 237, N'Merton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4816, 237, N'Middlesbrough', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4817, 237, N'Milton Keynes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4818, 237, N'Newcastle upon Tyne', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4819, 237, N'Newham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4820, 237, N'Norfolk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4821, 237, N'North East Lincolnshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4822, 237, N'North Lincolnshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4823, 237, N'North Somerset', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4824, 237, N'North Tyneside', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4825, 237, N'North Yorkshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4826, 237, N'Northamptonshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4827, 237, N'Northumberland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4828, 237, N'Nottingham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4829, 237, N'Nottinghamshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4830, 237, N'Oldham', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4831, 237, N'Oxfordshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4832, 237, N'Peterborough', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4833, 237, N'Plymouth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4834, 237, N'Poole', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4835, 237, N'Portsmouth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4836, 237, N'Reading', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4837, 237, N'Redbridge', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4838, 237, N'Redcar and Cleveland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4839, 237, N'Richmond upon Thames', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4840, 237, N'Rochdale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4841, 237, N'Rotherham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4842, 237, N'Rutland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4843, 237, N'Salford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4844, 237, N'Sandwell', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4845, 237, N'Sefton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4846, 237, N'Sheffield', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4847, 237, N'Shropshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4848, 237, N'Slough', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4849, 237, N'Solihull', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4850, 237, N'Somerset', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4851, 237, N'South Gloucestershire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4852, 237, N'South Tyneside', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4853, 237, N'Southampton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4854, 237, N'Southend-on-Sea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4855, 237, N'Southwark', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4856, 237, N'St. Helens', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4857, 237, N'Staffordshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4858, 237, N'Stockport', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4859, 237, N'Stockton-on-Tees', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4860, 237, N'Stoke-on-Trent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4861, 237, N'Suffolk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4862, 237, N'Sunderland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4863, 237, N'Surrey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4864, 237, N'Sutton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4865, 237, N'Swindon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4866, 237, N'Tameside', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4867, 237, N'Telford and Wrekin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4868, 237, N'Thurrock', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4869, 237, N'Torbay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4870, 237, N'Tower Hamlets', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4871, 237, N'Trafford', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4872, 237, N'Wakefield', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4873, 237, N'Walsall', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4874, 237, N'Waltham Forest', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4875, 237, N'Wandsworth', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4876, 237, N'Warrington', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4877, 237, N'Warwickshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4878, 237, N'West Berkshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4879, 237, N'West Sussex', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4880, 237, N'Westminster', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4881, 237, N'Wigan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4882, 237, N'Wiltshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4883, 237, N'Windsor and Maidenhead', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4884, 237, N'Wirral', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4885, 237, N'Wokingham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4886, 237, N'Wolverhampton', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4887, 237, N'Worcestershire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4888, 237, N'York', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4889, 238, N'Artigas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4890, 238, N'Canelones', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4891, 238, N'Cerro Largo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4892, 238, N'Colonia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4893, 238, N'Durazno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4894, 238, N'Flores', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4895, 238, N'Florida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4896, 238, N'Lavalleja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4897, 238, N'Maldonado', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4898, 238, N'Montevideo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4899, 238, N'Paysandu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4900, 238, N'Rio Negro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4901, 238, N'Rivera', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4902, 238, N'Rocha', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4903, 238, N'Salto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4904, 238, N'San Jose', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4905, 238, N'Soriano', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4906, 238, N'Tacuarembo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4907, 238, N'Treinta y Tres', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4908, 239, N'Alabama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4909, 239, N'Alaska', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4910, 239, N'Arizona', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4911, 239, N'Arkansas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4912, 239, N'California', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4913, 239, N'Colorado', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4914, 239, N'Connecticut', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4915, 239, N'Delaware', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4916, 239, N'District of Columbia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4917, 239, N'Florida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4918, 239, N'Georgia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4919, 239, N'Hawaii', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4920, 239, N'Idaho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4921, 239, N'Illinois', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4922, 239, N'Indiana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4923, 239, N'Iowa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4924, 239, N'Kansas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4925, 239, N'Kentucky', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4926, 239, N'Louisiana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4927, 239, N'Maine', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4928, 239, N'Maryland', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4929, 239, N'Massachusetts', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4930, 239, N'Michigan', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4931, 239, N'Minnesota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4932, 239, N'Mississippi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4933, 239, N'Missouri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4934, 239, N'Montana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4935, 239, N'Nebraska', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4936, 239, N'Nevada', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4937, 239, N'New Hampshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4938, 239, N'New Jersey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4939, 239, N'New Mexico', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4940, 239, N'New York', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4941, 239, N'North Carolina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4942, 239, N'North Dakota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4943, 239, N'Ohio', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4944, 239, N'Oklahoma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4945, 239, N'Oregon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4946, 239, N'Pennsylvania', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4947, 239, N'Rhode Island', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4948, 239, N'South Carolina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4949, 239, N'South Dakota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4950, 239, N'Tennessee', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4951, 239, N'Texas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4952, 239, N'Utah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4953, 239, N'Vermont', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4954, 239, N'Virginia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4955, 239, N'Washington', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4956, 239, N'West Virginia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4957, 239, N'Wisconsin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4958, 239, N'Wyoming', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4959, 240, N'Andijon Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4960, 240, N'Bukhoro Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4961, 240, N'Farghona Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4962, 240, N'Jizzakh Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4963, 240, N'Khorazm Wiloyati (Urganch)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4964, 240, N'Namangan Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4965, 240, N'Nawoiy Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4966, 240, N'Qashqadaryo Wiloyati (Qarshi)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4967, 240, N'Qoraqalpoghiston (Nukus)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4968, 240, N'Samarqand Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4969, 240, N'Sirdaryo Wiloyati (Guliston)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4970, 240, N'Surkhondaryo Wiloyati (Termiz)', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4971, 240, N'Toshkent Shahri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4972, 240, N'Toshkent Wiloyati', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4973, 241, N'Malampa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4974, 241, N'Penama', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4975, 241, N'Sanma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4976, 241, N'Shefa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4977, 241, N'Tafea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4978, 241, N'Torba', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4979, 242, N'Amazonas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4980, 242, N'Anzoategui', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4981, 242, N'Apure', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4982, 242, N'Aragua', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4983, 242, N'Barinas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4984, 242, N'Bolivar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4985, 242, N'Carabobo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4986, 242, N'Cojedes', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4987, 242, N'Delta Amacuro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4988, 242, N'Dependencias Federales', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4989, 242, N'Distrito Federal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4990, 242, N'Falcon', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4991, 242, N'Guarico', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4992, 242, N'Lara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4993, 242, N'Merida', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4994, 242, N'Miranda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4995, 242, N'Monagas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4996, 242, N'Nueva Esparta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4997, 242, N'Portuguesa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4998, 242, N'Sucre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (4999, 242, N'Tachira', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5000, 242, N'Trujillo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5001, 242, N'Vargas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5002, 242, N'Yaracuy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5003, 242, N'Zulia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5004, 243, N'An Giang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5005, 243, N'Ba Ria-Vung Tau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5006, 243, N'Bac Giang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5007, 243, N'Bac Kan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5008, 243, N'Bac Lieu', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5009, 243, N'Bac Ninh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5010, 243, N'Ben Tre', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5011, 243, N'Binh Dinh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5012, 243, N'Binh Duong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5013, 243, N'Binh Phuoc', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5014, 243, N'Binh Thuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5015, 243, N'Ca Mau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5016, 243, N'Can Tho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5017, 243, N'Cao Bang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5018, 243, N'Da Nang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5019, 243, N'Dac Lak', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5020, 243, N'Dong Nai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5021, 243, N'Dong Thap', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5022, 243, N'Gia Lai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5023, 243, N'Ha Giang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5024, 243, N'Ha Nam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5025, 243, N'Ha Noi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5026, 243, N'Ha Tay', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5027, 243, N'Ha Tinh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5028, 243, N'Hai Duong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5029, 243, N'Hai Phong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5030, 243, N'Ho Chi Minh', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5031, 243, N'Hoa Binh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5032, 243, N'Hung Yen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5033, 243, N'Khanh Hoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5034, 243, N'Kien Giang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5035, 243, N'Kon Tum', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5036, 243, N'Lai Chau', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5037, 243, N'Lam Dong', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5038, 243, N'Lang Son', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5039, 243, N'Lao Cai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5040, 243, N'Long An', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5041, 243, N'Nam Dinh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5042, 243, N'Nghe An', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5043, 243, N'Ninh Binh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5044, 243, N'Ninh Thuan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5045, 243, N'Phu Tho', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5046, 243, N'Phu Yen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5047, 243, N'Quang Binh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5048, 243, N'Quang Nam', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5049, 243, N'Quang Ngai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5050, 243, N'Quang Ninh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5051, 243, N'Quang Tri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5052, 243, N'Soc Trang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5053, 243, N'Son La', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5054, 243, N'Tay Ninh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5055, 243, N'Thai Binh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5056, 243, N'Thai Nguyen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5057, 243, N'Thanh Hoa', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5058, 243, N'Thua Thien-Hue', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5059, 243, N'Tien Giang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5060, 243, N'Tra Vinh', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5061, 243, N'Tuyen Quang', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5062, 243, N'Vinh Long', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5063, 243, N'Vinh Phuc', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5064, 243, N'Yen Bai', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5065, 244, N'Saint Croix', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5066, 244, N'Saint John', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5067, 244, N'Saint Thomas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5068, 245, N'Blaenau Gwent', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5069, 245, N'Bridgend', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5070, 245, N'Caerphilly', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5071, 245, N'Cardiff', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5072, 245, N'Carmarthenshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5073, 245, N'Ceredigion', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5074, 245, N'Conwy', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5075, 245, N'Denbighshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5076, 245, N'Flintshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5077, 245, N'Gwynedd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5078, 245, N'Isle of Anglesey', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5079, 245, N'Merthyr Tydfil', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5080, 245, N'Monmouthshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5081, 245, N'Neath Port Talbot', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5082, 245, N'Newport', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5083, 245, N'Pembrokeshire', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5084, 245, N'Powys', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5085, 245, N'Rhondda Cynon Taff', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5086, 245, N'Swansea', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5087, 245, N'The Vale of Glamorgan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5088, 245, N'Torfaen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5089, 245, N'Wrexham', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5090, 246, N'Alo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5091, 246, N'Sigave', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5092, 246, N'Wallis', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5093, 247, N'West Bank', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5094, 248, N'Western Sahara', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5095, 249, N'''Adan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5096, 249, N'''Ataq', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5097, 249, N'Abyan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5098, 249, N'Al Bayda''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5099, 249, N'Al Hudaydah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5100, 249, N'Al Jawf', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5101, 249, N'Al Mahrah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5102, 249, N'Al Mahwit', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5103, 249, N'Dhamar', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5104, 249, N'Hadhramawt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5105, 249, N'Hajjah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5106, 249, N'Ibb', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5107, 249, N'Lahij', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5108, 249, N'Ma''rib', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5109, 249, N'Sa''dah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5110, 249, N'San''a''', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5111, 249, N'Ta''izz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5112, 250, N'Kosovo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5113, 250, N'Montenegro', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5114, 250, N'Serbia', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5115, 250, N'Vojvodina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5116, 251, N'Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5117, 251, N'Copperbelt', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5118, 251, N'Eastern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5119, 251, N'Luapula', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5120, 251, N'Lusaka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5121, 251, N'North-Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5122, 251, N'Northern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5123, 251, N'Southern', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5124, 251, N'Western', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5125, 252, N'Bulawayo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5126, 252, N'Harare', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5127, 252, N'ManicalandMashonaland Central', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5128, 252, N'Mashonaland East', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5129, 252, N'Mashonaland West', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5130, 252, N'Masvingo', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5131, 252, N'Matabeleland North', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5132, 252, N'Matabeleland South', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5133, 252, N'Midlands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5136, 182, N'Pitcaim Islands', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5137, 206, N'Ajdovscina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5138, 206, N'Beltinci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5139, 206, N'Bled', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5140, 206, N'Bohinj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5141, 206, N'Borovnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5142, 206, N'Bovec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5143, 206, N'Brda', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5144, 206, N'Brezice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5145, 206, N'Brezovica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5146, 206, N'Cankova-Tisina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5147, 206, N'Celje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5148, 206, N'Cerklje na Gorenjskem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5149, 206, N'Cerknica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5150, 206, N'Cerkno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5151, 206, N'Crensovci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5152, 206, N'Crna na Koroskem', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5153, 206, N'Crnomelj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5154, 206, N'Destrnik-Trnovska Vas', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5155, 206, N'Divaca', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5156, 206, N'Dobrepolje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5157, 206, N'Dobrova-Horjul-Polhov Gradec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5158, 206, N'Dol pri Ljubljani', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5159, 206, N'Domzale', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5160, 206, N'Dornava', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5161, 206, N'Dravograd', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5162, 206, N'Duplek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5163, 206, N'Gorenja Vas-Poljane', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5164, 206, N'Gorisnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5165, 206, N'Gornja Radgona', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5166, 206, N'Gornji Grad', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5167, 206, N'Gornji Petrovci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5168, 206, N'Grosuplje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5169, 206, N'Hodos Salovci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5170, 206, N'Hrastnik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5171, 206, N'Hrpelje-Kozina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5172, 206, N'Idrija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5173, 206, N'Ig', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5174, 206, N'Ilirska Bistrica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5175, 206, N'Ivancna Gorica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5176, 206, N'Izola', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5177, 206, N'Jesenice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5178, 206, N'Jursinci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5179, 206, N'Kamnik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5180, 206, N'Kanal', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5181, 206, N'Kidricevo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5182, 206, N'Kobarid', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5183, 206, N'Kobilje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5184, 206, N'Kocevje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5185, 206, N'Komen', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5186, 206, N'Koper', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5187, 206, N'Kozje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5188, 206, N'Kranj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5189, 206, N'Kranjska Gora', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5190, 206, N'Krsko', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5191, 206, N'Kungota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5192, 206, N'Kuzma', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5193, 206, N'Lasko', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5194, 206, N'Lenart', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5195, 206, N'Lendava', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5196, 206, N'Litija', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5197, 206, N'Ljubljana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5198, 206, N'Ljubno', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5199, 206, N'Ljutomer', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5200, 206, N'Logatec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5201, 206, N'Loska Dolina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5202, 206, N'Loski Potok', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5203, 206, N'Luce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5204, 206, N'Lukovica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5205, 206, N'Majsperk', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5206, 206, N'Maribor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5207, 206, N'Medvode', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5208, 206, N'Menges', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5209, 206, N'Metlika', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5210, 206, N'Mezica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5211, 206, N'Miren-Kostanjevica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5212, 206, N'Mislinja', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5213, 206, N'Moravce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5214, 206, N'Moravske Toplice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5215, 206, N'Mozirje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5216, 206, N'Murska Sobota', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5217, 206, N'Muta', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5218, 206, N'Naklo', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5219, 206, N'Nazarje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5220, 206, N'Nova Gorica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5221, 206, N'Novo Mesto', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5222, 206, N'Odranci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5223, 206, N'Ormoz', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5224, 206, N'Osilnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5225, 206, N'Pesnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5226, 206, N'Piran', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5227, 206, N'Pivka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5228, 206, N'Podcetrtek', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5229, 206, N'Podvelka-Ribnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5230, 206, N'Postojna', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5231, 206, N'Preddvor', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5232, 206, N'Ptuj', 1)
GO
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5233, 206, N'Puconci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5234, 206, N'Race-Fram', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5235, 206, N'Radece', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5236, 206, N'Radenci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5237, 206, N'Radlje ob Dravi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5238, 206, N'Radovljica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5239, 206, N'Ravne-Prevalje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5240, 206, N'Ribnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5241, 206, N'Rogasevci', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5242, 206, N'Rogaska Slatina', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5243, 206, N'Rogatec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5244, 206, N'Ruse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5245, 206, N'Semic', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5246, 206, N'Sencur', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5247, 206, N'Sentilj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5248, 206, N'Sentjernej', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5249, 206, N'Sentjur pri Celju', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5250, 206, N'Sevnica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5251, 206, N'Sezana', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5252, 206, N'Skocjan', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5253, 206, N'Skofja Loka', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5254, 206, N'Skofljica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5255, 206, N'Slovenj Gradec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5256, 206, N'Slovenska Bistrica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5257, 206, N'Slovenske Konjice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5258, 206, N'Smarje pri Jelsah', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5259, 206, N'Smartno ob Paki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5260, 206, N'Sostanj', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5261, 206, N'Starse', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5262, 206, N'Store', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5263, 206, N'Sveti Jurij', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5264, 206, N'Tolmin', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5265, 206, N'Trbovlje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5266, 206, N'Trebnje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5267, 206, N'Trzic', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5268, 206, N'Turnisce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5269, 206, N'Velenje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5270, 206, N'Velike Lasce', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5271, 206, N'Videm', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5272, 206, N'Vipava', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5273, 206, N'Vitanje', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5274, 206, N'Vodice', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5275, 206, N'Vojnik', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5276, 206, N'Vrhnika', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5277, 206, N'Vuzenica', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5278, 206, N'Zagorje ob Savi', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5279, 206, N'Zalec', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5280, 206, N'Zavrc', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5281, 206, N'Zelezniki', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5282, 206, N'Ziri', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5283, 206, N'Zrece', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5284, 86, N'Ile du Lys', 1)
INSERT [dbo].[State_Master] ([PK_State_Id], [FK_Country_Id], [State_Name], [Active_Status]) VALUES (5285, 86, N'Ile Glorieuse', 1)
SET IDENTITY_INSERT [dbo].[State_Master] OFF
SET IDENTITY_INSERT [dbo].[Trending_Comment_Details] ON 

INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (156, 85, 2, 3, N'                Testing', 2, N'//www.youtube.com/embed/0NfGPWu3qAQ', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A6730098483A AS DateTime), CAST(0x0000A67301069E98 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (157, 85, 2, 3, N'
                testing', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67301162356 AS DateTime), CAST(0x0000A67301162356 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (158, 83, 2, 3, N'Testing Purpose
                ', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A673011CDA70 AS DateTime), CAST(0x0000A673011CDA70 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (159, 91, 2, 3, N'testing
                ', NULL, N'#', N'#', N'a1d0e6a7-67fd-4ca5-9e1e-ca77c87b519d', 1, CAST(0x0000A673012E8A55 AS DateTime), CAST(0x0000A673012E8A55 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (160, 10095, 2, 3, N'
Testing', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A674009C2FD0 AS DateTime), CAST(0x0000A674009C2FD0 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (161, 10095, 2, 3, N'
                test', NULL, N'#', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A674009D8D40 AS DateTime), CAST(0x0000A674009D8D40 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (162, 91, 2, 3, N'
                test', NULL, N'#', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A67400B06E37 AS DateTime), CAST(0x0000A67400B06E37 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (163, 83, 2, 3, N'
testing', NULL, N'#', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A67400B20770 AS DateTime), CAST(0x0000A67400B20770 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (164, 10095, 2, 3, N'
                test', NULL, N'#', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A67400B27AB1 AS DateTime), CAST(0x0000A67400B27AB1 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (165, 10095, 2, 3, N'
testing', NULL, N'#', N'#', N'081e0060-cad1-47f6-9ac7-567062fc5081', 1, CAST(0x0000A67400D50FC2 AS DateTime), CAST(0x0000A67400D50FC2 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (166, 10095, 2, 3, N'test
                ', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800ECF231 AS DateTime), CAST(0x0000A67800ECF231 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (167, 10095, 2, 3, N'
TESTING', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800ED1E3D AS DateTime), CAST(0x0000A67800ED1E3D AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (168, 10095, 2, 3, N'Testing Purpose', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800F54E82 AS DateTime), CAST(0x0000A67800F54E82 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (169, 10095, 2, 3, N'Testing Purpose', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800F55531 AS DateTime), CAST(0x0000A67800F55531 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (170, 10095, 2, 3, N'Testing Purpose', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800F55917 AS DateTime), CAST(0x0000A67800F55917 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (171, 10095, 2, 3, N'Testing Purpose', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800F56147 AS DateTime), CAST(0x0000A67800F56147 AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (172, 10095, 2, 3, N'Testing Purpose', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67800F564BD AS DateTime), CAST(0x0000A67800F564BD AS DateTime))
INSERT [dbo].[Trending_Comment_Details] ([PK_Trending_Comment_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Comment], [Video_Type], [Video_Link], [Image_Path], [Guest_User_Id], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (173, 10095, 2, 3, N'
                https://translate.google.co.in', NULL, N'#', N'#', N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, CAST(0x0000A67900C38E15 AS DateTime), CAST(0x0000A67900C38E15 AS DateTime))
SET IDENTITY_INSERT [dbo].[Trending_Comment_Details] OFF
SET IDENTITY_INSERT [dbo].[Trending_Master] ON 

INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (83, 7, 2, 3, N'uhklihgf', N'hjjjvgffdgjjjhjukk', N'/ImageCollection/TrendingStory/story_img_556863890_45_30.jpg', 0, N'#', 1, N'04502393-c867-4e25-99d1-a14b8c4b96f6', 46, 1, CAST(0x0000A606001CFAD8 AS DateTime), CAST(0x0000A67300D8C1C6 AS DateTime))
INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (85, 7, 2, 3, N'ujhjhhkkkkkk', N'kiiulkkkhjjnmmkll', N'/ImageCollection/TrendingStory/story_img_590710808_52_32.jpg', 0, N'', 1, N'04502393-c867-4e25-99d1-a14b8c4b96f6', 19, 1, CAST(0x0000A606001EE930 AS DateTime), CAST(0x0000A64200AD2C68 AS DateTime))
INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (90, 6, 2, 3, N'9/11 first responders bill', N'Why should it take "The people" to chase down their representatives in congress to perform the jobs we elected them to?

Does this make any logical sense?', N'/ImageCollection/TrendingStory/story_img_681204576_18_39.jpg', 0, N'', 1, N'c572743c-83a1-4654-adf9-541309a4d1a1', 20, 1, CAST(0x0000A63500997129 AS DateTime), CAST(0x0000A64200AD30F7 AS DateTime))
INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (91, 6, 35, 2, N'When do we start holding people running for public office accountable?', N'Trump Doctor Wrote Health Letter in Just 5 Minutes as Limo Waited', N'/ImageCollection/TrendingStory/story_img_612734219_44_59.jpg', 2, N'https://www.youtube.com/watch?v=PtNrWG02IIE', 1, NULL, 20, 1, CAST(0x0000A66F0155F2DC AS DateTime), CAST(0x0000A671009332D4 AS DateTime))
INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (10095, 7, 10042, 2, N'Testing Trending Story', N'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/TrendingStory/story_img_1466997653_49_37.jpg', 2, N'//www.youtube.com/embed/embed/embed/Z6LcUVh7-18', 0, NULL, 126, 2, CAST(0x0000A6730099CB58 AS DateTime), CAST(0x0000A6810100C467 AS DateTime))
INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (10098, 7, 10042, 2, N'Testing Trending Story', N'Lorem1 Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', N'/ImageCollection/TrendingStory/story_img_1787820442_4_19.jpg', 2, N'//www.youtube.com/embed/embed/embed/wFAhCYSiVvY', 0, NULL, 7, 10042, CAST(0x0000A67B00EE5DEB AS DateTime), CAST(0x0000A681010147B6 AS DateTime))
INSERT [dbo].[Trending_Master] ([PK_Trending_Id], [FK_Category_Id], [FK_User_Id], [FK_Role_Id], [Trending_Title], [Description], [Image_Path], [Video_Type], [Video_Link], [Active_Status], [Guest_User_Id], [View_Count], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (10101, 7, 10042, 2, N'Test1', N'Testing Purpose', N'/ImageCollection/TrendingStory/story_img_1572080818_40_18.jpg', 0, N'#', 1, NULL, 4, 10042, CAST(0x0000A68200EDFC3A AS DateTime), CAST(0x0000A68E00AE02FD AS DateTime))
SET IDENTITY_INSERT [dbo].[Trending_Master] OFF
SET IDENTITY_INSERT [dbo].[Trending_Status_Details] ON 

INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (41, 91, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 0, NULL, NULL, NULL, NULL, 1, CAST(0x0000A67100F8BCE2 AS DateTime), CAST(0x0000A67100F8C4FE AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (42, 83, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, NULL, 1, CAST(0x0000A67200B265D1 AS DateTime), CAST(0x0000A67A00E26CBD AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (43, 85, 2, 3, N'081e0060-cad1-47f6-9ac7-567062fc5081', 0, NULL, NULL, NULL, NULL, 1, CAST(0x0000A67200BCC1DD AS DateTime), CAST(0x0000A67200BCC43E AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (44, 85, 2, 3, N'18d3271e-8def-4fb6-a1c5-58ca9ed4460d', 1, NULL, NULL, NULL, NULL, 1, CAST(0x0000A6730117B894 AS DateTime), CAST(0x0000A6730117B894 AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (45, 10095, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, NULL, 1, CAST(0x0000A67800ED9612 AS DateTime), CAST(0x0000A67900C380EA AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (46, 83, 0, 0, NULL, 1, NULL, NULL, NULL, NULL, 1, CAST(0x0000A67900FBA0B5 AS DateTime), CAST(0x0000A67900FBA0B5 AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (47, 10098, 2, 3, N'2cdcb0eb-5bd7-4162-8205-c59ca717f4a2', 1, NULL, NULL, NULL, NULL, 1, CAST(0x0000A67B00F07B15 AS DateTime), CAST(0x0000A67B00F07CDC AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (48, 83, 2, 3, N'7a5462d5-4c5a-4fc7-bb52-4fe7115f551a', 1, NULL, NULL, NULL, NULL, 1, CAST(0x0000A68200DEF913 AS DateTime), CAST(0x0000A68200DEFB88 AS DateTime))
INSERT [dbo].[Trending_Status_Details] ([PK_Trending_Status_Details], [FK_Trending_Id], [FK_User_Id], [FK_Role_Id], [Guest_User_Id], [Like_Status], [Dislike_Status], [Twiter_Status], [Facebook_Status], [Instagram_Status], [Active_Status], [Created_DateTime], [Modified_DateTime]) VALUES (49, 10101, 2, 3, N'0005f7a8-884b-4aaf-a860-fe1f08bae2c9', 1, NULL, NULL, NULL, NULL, 1, CAST(0x0000A686012E4026 AS DateTime), CAST(0x0000A686012E4DFD AS DateTime))
SET IDENTITY_INSERT [dbo].[Trending_Status_Details] OFF
SET IDENTITY_INSERT [dbo].[User_Master] ON 

INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (1, 2, N'Mr', N'Kaushik Gohel ', NULL, NULL, N'a2F1c2hpa2dvaGVsMUBhbGlhbnNvZnR3YXJlLm5ldA==', N'7EFF1BC3571559658CA3D79030A35307', 1, CAST(0x0000818200000000 AS DateTime), N'Married', 1, 17, N'Anand', N'/ImageCollection/UserProfilePic/User_Profile_img_560583556_34_22.png', 1, NULL, CAST(0x0000A59100000000 AS DateTime), CAST(0x0000A680011635A4 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (2, 3, NULL, N'Guest', NULL, N'User', N'ZGlwYW5raS5qYWRhdkBhbGlhbnNvZnR3YXJlLm5ldA==', N'7EFF1BC3571559658CA3D79030A35307', 0, CAST(0x0000818200000000 AS DateTime), NULL, 1, 17, N'8', N'/ImageCollection/AdminProfilePic/Admin_Profile_img_173864954_13_50.png', 1, 0, CAST(0x0000A59100000000 AS DateTime), CAST(0x0000A67200EAAD3B AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (13, 2, NULL, N'Kirtan Desai', NULL, NULL, N'a2lydGFuLmRlc2FpQGFsaWFuc29mdHdhcmUuY29t', N'7EFF1BC3571559658CA3D79030A35307', 1, CAST(0x0000885100000000 AS DateTime), NULL, 1, 17, N'8', N'/ImageCollection/UserProfilePic/User_Profile_img_1821316926_52_34.png', 0, NULL, CAST(0x0000A5D2011891B7 AS DateTime), CAST(0x0000A6730126978B AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (15, 2, NULL, N'Nilesh', NULL, NULL, N'bmlsZXNoLnByYWphcGF0aUBhbGlhbnNvZnR3YXJlLmNvbQ==', N'7EFF1BC3571559658CA3D79030A35307', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(0x0000A5D40114C964 AS DateTime), CAST(0x0000A5DA00B632D3 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (26, 2, NULL, N'Kaushik Gohel1', NULL, NULL, N'a2F1c2hpay5nb2hlbEBhbGlhbnNvZnR3YXJlLmNvbQ==', N'7EFF1BC3571559658CA3D79030A35307', 1, CAST(0x0000A5E700000000 AS DateTime), NULL, 2, 16, N'11', N'/ImageCollection/UserProfilePic/User_Profile_img_1362906439_35_11.png', 1, NULL, CAST(0x0000A5D700AD6BFB AS DateTime), CAST(0x0000A5E70121D198 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (27, 2, NULL, N'Dipanki Vala', NULL, NULL, N'ZGlwYW5raS52YWxhQGdtYWlsLmNvbQ==', N'7EFF1BC3571559658CA3D79030A35307', 2, CAST(0x00009F0B00000000 AS DateTime), NULL, 2, 1, N'13', N'/ImageCollection/UserProfilePic/User_Profile_img_1536330986_2_5.jpg', 1, NULL, CAST(0x0000A5DA011DF811 AS DateTime), CAST(0x0000A5F30097DEC3 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (28, 2, NULL, N'Dipanki Jadav', NULL, NULL, N'ZGlwYW5raS5qYWRhdkBhbGlhbnNvZnR3YXJlLm5ldA==', N'7EFF1BC3571559658CA3D79030A35307', 2, CAST(0x0000A5F800000000 AS DateTime), NULL, 2, 16, N'11', N'/ImageCollection/UserProfilePic/User_Master_img_1346358625_3_15.png', 1, 0, CAST(0x0000A5DA0129868A AS DateTime), CAST(0x0000A5E70121FEF6 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (32, 2, NULL, N'Mehul Parmar', NULL, NULL, N'bWVodWwucGFybWFyQGFsaWFuc29mdHdhcmUubmV0', N'43AE5D3CC8679AF87798DB2B4BE66EE3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(0x0000A5E700EFBE9B AS DateTime), CAST(0x0000A5F30097DBAA AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (34, 2, NULL, N'AB1', NULL, NULL, N'MTIzNDU2N0BnbWFpbC5jb20=', N'482C811DA5D5B4BC6D497FFA98491E38', 1, CAST(0x0000A5EC00000000 AS DateTime), NULL, 2, 1, N'13', N'/ImageCollection/UserProfilePic/User_Master_img_315589353_10_40.jpg', 1, NULL, CAST(0x0000A5F300973EC1 AS DateTime), CAST(0x0000A5F300973EC1 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (35, 2, NULL, N'abasiodu', NULL, NULL, N'YWJhc2lvZHUyMDAxQGdtYWlsLmNvbQ==', N'A12852099B73D7294E749E7ECEAAD169', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, CAST(0x0000A6010134267B AS DateTime), CAST(0x0000A6010134267B AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (37, 2, NULL, N'Wole', NULL, NULL, N'YWJhc2lvZHUyMDAxQHlhaG9vLmNvbQ==', N'827CCB0EEA8A706C4C34A16891F84E7B', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(0x0000A634008020BF AS DateTime), CAST(0x0000A634008020BF AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (38, 2, NULL, N'Hardik Patel', NULL, NULL, N'aGFyZGlrLnBhdGVsQGFsaWFuc29mdHdhcmUubmV0', N'43AE5D3CC8679AF87798DB2B4BE66EE3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, CAST(0x0000A64200AE2D1E AS DateTime), CAST(0x0000A64200AE2D1E AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10038, 2, NULL, N'reema', NULL, NULL, N'cmVlbWEucGFsYWprYXJAYWxpYW5zb2Z0d2FyZS5jb20=', N'7EFF1BC3571559658CA3D79030A35307', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(0x0000A65600AC10A0 AS DateTime), CAST(0x0000A65600AC10A0 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10041, 2, NULL, N'ravina.vala', NULL, NULL, N'cmF2aW5hLnZhbGFAYWxpYW5zb2Z0d2FyZS5jb20=', N'16883178317CBE0262DBF903D62C1DCA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, CAST(0x0000A6600116674D AS DateTime), CAST(0x0000A66001166788 AS DateTime))
INSERT [dbo].[User_Master] ([PK_User_Id], [FK_Role_Id], [Prefix], [First_Name], [Middle_Name], [Last_Name], [Email], [Password], [Gender], [Birth_Date], [Marital_Status], [FK_Country_Id], [FK_State_Id], [FK_City_Id], [Profile_Image], [Active_Status], [Forget_Pswd_Status], [Created_DateTime], [Modified_DateTime]) VALUES (10042, 2, NULL, N'Dipanki K Jadav', NULL, NULL, N'ZGlwYW5raS5qLmFsaWFuQGFsaWFuc29mdHdhcmUuY29t', N'7EFF1BC3571559658CA3D79030A35307', 2, CAST(0x0000A67400000000 AS DateTime), NULL, 105, 1667, N'Anand', N'', 1, NULL, CAST(0x0000A67900EBFB56 AS DateTime), CAST(0x0000A6810101A3B6 AS DateTime))
SET IDENTITY_INSERT [dbo].[User_Master] OFF
SET IDENTITY_INSERT [dbo].[Video_Adv_Master] ON 

INSERT [dbo].[Video_Adv_Master] ([PK_Video_Adv_Id], [FK_User_Id], [FK_Role_Id], [Video_Link], [Video_Type], [Title], [Description], [Active_Status], [Modified_By_Id], [Created_DateTime], [Modified_DateTime]) VALUES (1, 1, 1, N'//www.youtube.com/embed/tP0awqth0XI', 2, NULL, NULL, 1, 1, CAST(0x0000A603009A6087 AS DateTime), CAST(0x0000A67301194C02 AS DateTime))
SET IDENTITY_INSERT [dbo].[Video_Adv_Master] OFF
ALTER TABLE [dbo].[Feed_Comment_Details]  WITH CHECK ADD  CONSTRAINT [FK_FeedComm_Id_Master] FOREIGN KEY([FK_Feed_Id])
REFERENCES [dbo].[Feed_Master] ([PK_Feed_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Feed_Comment_Details] CHECK CONSTRAINT [FK_FeedComm_Id_Master]
GO
ALTER TABLE [dbo].[Feed_Comment_Status_Details]  WITH CHECK ADD  CONSTRAINT [FK_FeedCommStatus_Id_Master] FOREIGN KEY([FK_Feed_Id])
REFERENCES [dbo].[Feed_Master] ([PK_Feed_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Feed_Comment_Status_Details] CHECK CONSTRAINT [FK_FeedCommStatus_Id_Master]
GO
ALTER TABLE [dbo].[Feed_Master]  WITH CHECK ADD  CONSTRAINT [FK_Feed_Category_Master] FOREIGN KEY([FK_Category_Id])
REFERENCES [dbo].[Category_Master] ([PK_Category_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Feed_Master] CHECK CONSTRAINT [FK_Feed_Category_Master]
GO
ALTER TABLE [dbo].[Feed_Status_Details]  WITH CHECK ADD  CONSTRAINT [FK_FeedStatus_Id_Master] FOREIGN KEY([FK_Feed_Id])
REFERENCES [dbo].[Feed_Master] ([PK_Feed_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Feed_Status_Details] CHECK CONSTRAINT [FK_FeedStatus_Id_Master]
GO
ALTER TABLE [dbo].[Global_Topic_Comment_Details]  WITH CHECK ADD  CONSTRAINT [FK_GlobalComm_Id_Master] FOREIGN KEY([FK_Global_Topics_Id])
REFERENCES [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Global_Topic_Comment_Details] CHECK CONSTRAINT [FK_GlobalComm_Id_Master]
GO
ALTER TABLE [dbo].[Global_Topic_Comment_Status_Details]  WITH CHECK ADD  CONSTRAINT [FK_GlobalCommStatus_Id_Master] FOREIGN KEY([FK_Global_Topics_Id])
REFERENCES [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Global_Topic_Comment_Status_Details] CHECK CONSTRAINT [FK_GlobalCommStatus_Id_Master]
GO
ALTER TABLE [dbo].[Global_Topics_Master]  WITH CHECK ADD  CONSTRAINT [FK_Global_Category_Master] FOREIGN KEY([FK_Category_Id])
REFERENCES [dbo].[Category_Master] ([PK_Category_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Global_Topics_Master] CHECK CONSTRAINT [FK_Global_Category_Master]
GO
ALTER TABLE [dbo].[Global_Topics_Status_Details]  WITH CHECK ADD  CONSTRAINT [FK_GlobalStatus_Id_Master] FOREIGN KEY([FK_Global_Topics_Id])
REFERENCES [dbo].[Global_Topics_Master] ([PK_Global_Topics_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Global_Topics_Status_Details] CHECK CONSTRAINT [FK_GlobalStatus_Id_Master]
GO
ALTER TABLE [dbo].[Trending_Comment_Details]  WITH CHECK ADD  CONSTRAINT [FK_TrendingComm_Id_Master] FOREIGN KEY([FK_Trending_Id])
REFERENCES [dbo].[Trending_Master] ([PK_Trending_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Trending_Comment_Details] CHECK CONSTRAINT [FK_TrendingComm_Id_Master]
GO
ALTER TABLE [dbo].[Trending_Comment_Status_Details]  WITH CHECK ADD  CONSTRAINT [FK_TrendingCommStatus_Id_Master] FOREIGN KEY([FK_Trending_Id])
REFERENCES [dbo].[Trending_Master] ([PK_Trending_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Trending_Comment_Status_Details] CHECK CONSTRAINT [FK_TrendingCommStatus_Id_Master]
GO
ALTER TABLE [dbo].[Trending_Master]  WITH CHECK ADD  CONSTRAINT [FK_Trending_Category_Master] FOREIGN KEY([FK_Category_Id])
REFERENCES [dbo].[Category_Master] ([PK_Category_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Trending_Master] CHECK CONSTRAINT [FK_Trending_Category_Master]
GO
ALTER TABLE [dbo].[Trending_Status_Details]  WITH CHECK ADD  CONSTRAINT [FK_TrendingStatus_Id_Master] FOREIGN KEY([FK_Trending_Id])
REFERENCES [dbo].[Trending_Master] ([PK_Trending_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Trending_Status_Details] CHECK CONSTRAINT [FK_TrendingStatus_Id_Master]
GO
USE [master]
GO
ALTER DATABASE [ntsb] SET  READ_WRITE 
GO
