USE [master]
GO
/****** Object:  Database [Monster_Builder]    Script Date: 1/24/2018 7:11:03 AM ******/
CREATE DATABASE [Monster_Builder]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Monster_Builder', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Monster_Builder.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Monster_Builder_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Monster_Builder_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Monster_Builder] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Monster_Builder].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Monster_Builder] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Monster_Builder] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Monster_Builder] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Monster_Builder] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Monster_Builder] SET ARITHABORT OFF 
GO
ALTER DATABASE [Monster_Builder] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Monster_Builder] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Monster_Builder] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Monster_Builder] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Monster_Builder] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Monster_Builder] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Monster_Builder] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Monster_Builder] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Monster_Builder] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Monster_Builder] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Monster_Builder] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Monster_Builder] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Monster_Builder] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Monster_Builder] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Monster_Builder] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Monster_Builder] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Monster_Builder] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Monster_Builder] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Monster_Builder] SET  MULTI_USER 
GO
ALTER DATABASE [Monster_Builder] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Monster_Builder] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Monster_Builder] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Monster_Builder] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Monster_Builder] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Monster_Builder] SET QUERY_STORE = OFF
GO
USE [Monster_Builder]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Monster_Builder]
GO
/****** Object:  Table [dbo].[com_rl_Monster_AbilityScore]    Script Date: 1/24/2018 7:11:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_rl_Monster_AbilityScore](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_AbilityScore] [uniqueidentifier] NOT NULL,
	[value_AbilityScore] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC,
	[guid_AbilityScore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_Weapon]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_Weapon](
	[guid_Weapon] [uniqueidentifier] NOT NULL,
	[guid_Die] [uniqueidentifier] NULL,
	[guid_DamageType] [uniqueidentifier] NULL,
	[guid_WeaponType] [uniqueidentifier] NOT NULL,
	[number_DamageDice] [int] NOT NULL,
	[name_weapon] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__weap_Wea__EDC313E3A6EF0B17] PRIMARY KEY CLUSTERED 
(
	[guid_Weapon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Monster_Weapon]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Monster_Weapon](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_Weapon] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC,
	[guid_Weapon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_Monster]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_Monster](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[name_Monster] [nvarchar](50) NULL,
	[description_Monster] [nvarchar](max) NULL,
	[guid_Size] [uniqueidentifier] NULL,
	[guid_Alignment] [uniqueidentifier] NULL,
	[guid_Type] [uniqueidentifier] NULL,
	[guid_CR] [uniqueidentifier] NULL,
 CONSTRAINT [PK__mon_Mons__3C3D085FED6554FE] PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dice_Dice]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dice_Dice](
	[guid_Die] [uniqueidentifier] NOT NULL,
	[min_Roll] [int] NOT NULL,
	[max_Roll] [int] NOT NULL,
	[average_Roll] [float] NOT NULL,
	[name_Die] [varchar](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Die] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_rl_AbilityScore_Modifier]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_rl_AbilityScore_Modifier](
	[value_AbilityScore] [int] NOT NULL,
	[value_AbilityScore_Modifier] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[value_AbilityScore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_lu_DamageType]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_lu_DamageType](
	[guid_DamageType] [uniqueidentifier] NOT NULL,
	[name_DamageType] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_DamageType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEMP_Monster_CR]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_Monster_CR](
	[guid_monster] [uniqueidentifier] NOT NULL,
	[offensive_CR] [uniqueidentifier] NULL,
	[defensive_CR] [uniqueidentifier] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_AbilityScore]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_AbilityScore](
	[guid_AbilityScore] [uniqueidentifier] NOT NULL,
	[name_AbilityScore] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__com_Abil__83EC500F6E24C5D9] PRIMARY KEY CLUSTERED 
(
	[guid_AbilityScore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[core_lu_CR_Proficiency]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_lu_CR_Proficiency](
	[proficiency_bonus] [int] NOT NULL,
	[guid_CR] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_CR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_lu_Size_WeaponDice]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_lu_Size_WeaponDice](
	[guid_Size] [uniqueidentifier] NOT NULL,
	[size_die_Multiplier] [int] NOT NULL,
 CONSTRAINT [PK__weap_lu___68976992B7F9F1C4] PRIMARY KEY CLUSTERED 
(
	[guid_Size] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_Size]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_Size](
	[guid_Size] [uniqueidentifier] NOT NULL,
	[name_Size] [varchar](15) NOT NULL,
	[guid_Die] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Size] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[core_lu_Offensive_Values]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_lu_Offensive_Values](
	[guid_CR] [uniqueidentifier] NOT NULL,
	[attack_bonus] [int] NOT NULL,
	[save_DC] [int] NOT NULL,
	[minimum_damage] [int] NOT NULL,
	[maximum_damage] [int] NOT NULL,
 CONSTRAINT [PK__core_lu___A73FE9A7FFDD80E9] PRIMARY KEY CLUSTERED 
(
	[guid_CR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_rl_Weapon_AbilityScore]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_rl_Weapon_AbilityScore](
	[guid_AbilityScore] [uniqueidentifier] NOT NULL,
	[guid_Weapon] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_AbilityScore] ASC,
	[guid_Weapon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[get_Basic_Attack_Routine]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[get_Basic_Attack_Routine]
AS
SELECT TOP (1) mon.guid_Monster, mon.name_Monster AS [Monster Name], CASE WHEN floor(ov.maximum_damage / ((average_Roll * size_die_Multiplier * number_DamageDice) + value_AbilityScore_Modifier)) 
                  > 1 THEN 'Multi-Attack' ELSE 'Single Attack' END AS [Attack Routine], FLOOR(ov.maximum_damage / (d.average_Roll * swd.size_die_Multiplier * w.number_DamageDice + sc_m.value_AbilityScore_Modifier)) AS [Number of Attacks], 
                  '+' + CAST(sc_m.value_AbilityScore_Modifier AS nvarchar(2)) AS [Ability Score Modifier], w.name_weapon AS Weapon, '+' + CAST(prof.proficiency_bonus + sc_m.value_AbilityScore_Modifier AS nvarchar(2)) AS [Hit Modifier], 
                  '(' + CAST(swd.size_die_Multiplier * w.number_DamageDice AS nvarchar(2)) + d.name_Die + ' + ' + CAST(sc_m.value_AbilityScore_Modifier AS nvarchar(2)) + ')' AS Damage, dt.name_DamageType AS [Damage Type], 
                  d.average_Roll * swd.size_die_Multiplier * w.number_DamageDice + sc_m.value_AbilityScore_Modifier AS [Damage per Attack], 
                  FLOOR(ov.maximum_damage / (d.average_Roll * swd.size_die_Multiplier * w.number_DamageDice + sc_m.value_AbilityScore_Modifier)) 
                  * sc_m.value_AbilityScore_Modifier + FLOOR(ov.maximum_damage / (d.average_Roll * swd.size_die_Multiplier * w.number_DamageDice + sc_m.value_AbilityScore_Modifier)) 
                  * d.average_Roll * swd.size_die_Multiplier * w.number_DamageDice AS [Average Damage per Action]
FROM     dbo.mon_Monster AS mon INNER JOIN
                  dbo.TEMP_Monster_CR AS t_cr ON t_cr.guid_monster = mon.guid_Monster INNER JOIN
                  dbo.core_lu_Offensive_Values AS ov ON ov.guid_CR = t_cr.offensive_CR INNER JOIN
                  dbo.core_lu_CR_Proficiency AS prof ON prof.guid_CR = ov.guid_CR INNER JOIN
                  dbo.com_Size AS s ON s.guid_Size = mon.guid_Size INNER JOIN
                  dbo.mon_rl_Monster_Weapon AS mw ON mon.guid_Monster = mw.guid_Monster INNER JOIN
                  dbo.weap_Weapon AS w ON w.guid_Weapon = mw.guid_Weapon INNER JOIN
                  dbo.weap_lu_DamageType AS dt ON dt.guid_DamageType = w.guid_DamageType INNER JOIN
                  dbo.dice_Dice AS d ON d.guid_Die = w.guid_Die INNER JOIN
                  dbo.weap_lu_Size_WeaponDice AS swd ON swd.guid_Size = mon.guid_Size INNER JOIN
                  dbo.weap_rl_Weapon_AbilityScore AS was ON was.guid_Weapon = w.guid_Weapon INNER JOIN
                  dbo.com_AbilityScore AS score ON score.guid_AbilityScore = was.guid_AbilityScore INNER JOIN
                  dbo.com_rl_Monster_AbilityScore AS mas ON mas.guid_AbilityScore = score.guid_AbilityScore AND mas.guid_Monster = mw.guid_Monster INNER JOIN
                  dbo.com_rl_AbilityScore_Modifier AS sc_m ON sc_m.value_AbilityScore = mas.value_AbilityScore
ORDER BY sc_m.value_AbilityScore_Modifier DESC, mas.value_AbilityScore DESC

GO
/****** Object:  Table [dbo].[arm_Shield]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[arm_Shield](
	[guid_Shield] [uniqueidentifier] NOT NULL,
	[name_Shield] [varchar](20) NOT NULL,
	[armor_Class] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Shield] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[arm_rl_ACModifier]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[arm_rl_ACModifier](
	[guid_Armor] [uniqueidentifier] NOT NULL,
	[max_Modifier] [int] NOT NULL,
	[guid_AbilityScore] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Armor] ASC,
	[guid_AbilityScore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[arm_Armor]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[arm_Armor](
	[guid_Armor] [uniqueidentifier] NOT NULL,
	[guid_ArmorType] [uniqueidentifier] NOT NULL,
	[name_Armor] [varchar](40) NOT NULL,
	[armor_Class] [int] NOT NULL,
	[has_StealthDisadvantage] [bit] NOT NULL,
 CONSTRAINT [PK__arm_Armo__34A2D127F5BABA27] PRIMARY KEY CLUSTERED 
(
	[guid_Armor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Monster_Armor]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Monster_Armor](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_Armor] [uniqueidentifier] NOT NULL,
	[guid_Shield] [uniqueidentifier] NULL,
 CONSTRAINT [PK_mon_rl_Monster_Armor] PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC,
	[guid_Armor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[get_Basic_Armor_Stats]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[get_Basic_Armor_Stats] as

SELECT 
	m.guid_Monster, 
	m.name_Monster, 
	a.name_Armor, 
	s.name_Shield, 
	isnull(a.armor_Class, 0) + isnull(s.armor_Class, 0) + isnull(iif(acm.max_Modifier = 0, asm.value_AbilityScore_Modifier, iif(asm.value_abilityScore_modifier > acm.max_modifier, 
	acm.max_modifier, asm.value_abilityScore_modifier)), 0) AS [Armor Class], 

	isnull('+' + cast(iif(acm.max_Modifier = 0, asm.value_AbilityScore_Modifier, 
		iif(asm.value_abilityScore_modifier > acm.max_modifier, acm.max_modifier, 
			asm.value_abilityScore_modifier)) AS nvarchar(2)),0) AS [AC Modifier], 

	isnull(a.armor_Class, 0) + isnull(s.armor_Class, 0) AS [Base Armor Class]
FROM     mon_rl_Monster_Armor ma JOIN
mon_Monster m ON m.guid_Monster = ma.guid_Monster LEFT JOIN
arm_Shield s ON s.guid_Shield = ma.guid_Shield LEFT JOIN
arm_Armor a ON a.guid_Armor = ma.guid_Armor LEFT JOIN
arm_rl_ACModifier acm ON acm.guid_Armor = ma.guid_Armor LEFT JOIN
com_AbilityScore score ON score.guid_AbilityScore = acm.guid_AbilityScore LEFT JOIN
com_rl_Monster_AbilityScore mas ON mas.guid_Monster = ma.guid_Monster AND mas.guid_AbilityScore = score.guid_AbilityScore LEFT JOIN
com_rl_AbilityScore_Modifier asm ON asm.value_AbilityScore = mas.value_AbilityScore;
GO
/****** Object:  Table [dbo].[arm_lu_ArmorType]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[arm_lu_ArmorType](
	[guid_ArmorType] [uniqueidentifier] NOT NULL,
	[name_ArmorType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_arm_lu_ArmorType] PRIMARY KEY CLUSTERED 
(
	[guid_ArmorType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_CR]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_CR](
	[guid_CR] [uniqueidentifier] NOT NULL,
	[rank_CR] [int] NOT NULL,
	[name_CR] [varchar](3) NOT NULL,
	[experience_Points] [int] NOT NULL,
 CONSTRAINT [PK__com_CR__A73FE9A72590B126] PRIMARY KEY CLUSTERED 
(
	[guid_CR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_Language]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_Language](
	[guid_Language] [uniqueidentifier] NOT NULL,
	[name_Language] [varchar](30) NOT NULL,
	[name_Script] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_lu_ArmorClass]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_lu_ArmorClass](
	[armor_class] [int] NOT NULL,
	[guid_CR] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_CR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_lu_Movement]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_lu_Movement](
	[guid_Movement] [uniqueidentifier] NOT NULL,
	[name_Movement] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Movement] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_lu_Senses]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_lu_Senses](
	[guid_Sense] [uniqueidentifier] NOT NULL,
	[name_Sense] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Sense] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_lu_Skill]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_lu_Skill](
	[guid_skill] [uniqueidentifier] NOT NULL,
	[name_Skill] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_skill] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_ProtectionFromDamage]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_ProtectionFromDamage](
	[guid_Protection] [uniqueidentifier] NOT NULL,
	[name_Protection] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Protection] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_rl_AbilityScore_Skill]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_rl_AbilityScore_Skill](
	[guid_AbilityScore] [uniqueidentifier] NOT NULL,
	[guid_skill] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_AbilityScore] ASC,
	[guid_skill] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[com_rl_Monster_Language]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[com_rl_Monster_Language](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_Language] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC,
	[guid_Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[core_lu_Defensive_Values]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_lu_Defensive_Values](
	[guid_CR] [uniqueidentifier] NOT NULL,
	[AC] [int] NOT NULL,
	[minimum_HP] [int] NOT NULL,
	[maximum_HP] [int] NOT NULL,
 CONSTRAINT [PK__core_lu___A73FE9A76C95E6E3] PRIMARY KEY CLUSTERED 
(
	[guid_CR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[custom_Attack_Dice]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[custom_Attack_Dice](
	[number_Dice] [int] NOT NULL,
	[guid_Die] [uniqueidentifier] NOT NULL,
	[guid_Custom_Attack] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Die] ASC,
	[guid_Custom_Attack] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[custom_Weapon_Attack]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[custom_Weapon_Attack](
	[guid_Custom_Attack] [uniqueidentifier] NOT NULL,
	[name_Custom_Attack] [varchar](50) NOT NULL,
	[guid_DamageType] [uniqueidentifier] NOT NULL,
	[guid_AbilityScore] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Custom_Attack] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[feature_lu_Feature]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feature_lu_Feature](
	[guid_feature] [uniqueidentifier] NOT NULL,
	[name_Feature] [varchar](30) NOT NULL,
	[stat_modifier] [varchar](max) NULL,
	[description_Feature] [varchar](max) NULL,
 CONSTRAINT [PK__feature___3BCC02F9BA89BB70] PRIMARY KEY CLUSTERED 
(
	[guid_feature] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[feature_rl_Monster_Feature]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feature_rl_Monster_Feature](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_Feature] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC,
	[guid_Feature] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[hp_Protection_CR_Modifier]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hp_Protection_CR_Modifier](
	[effective_HPModifier] [float] NOT NULL,
	[guid_CR] [uniqueidentifier] NOT NULL,
	[guid_Protection] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_CR] ASC,
	[guid_Protection] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_lu_Goodness]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_lu_Goodness](
	[guid_Goodness] [uniqueidentifier] NOT NULL,
	[name_Morality] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Goodness] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_lu_Lawfulness]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_lu_Lawfulness](
	[guid_Lawfulness] [uniqueidentifier] NOT NULL,
	[name_Lawfulness] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Lawfulness] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_lu_Type]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_lu_Type](
	[guid_Type] [uniqueidentifier] NOT NULL,
	[name_Type] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Alignment]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Alignment](
	[guid_Alignment] [uniqueidentifier] NOT NULL,
	[name_alignment] [varchar](50) NOT NULL,
	[guid_Lawfulness] [uniqueidentifier] NOT NULL,
	[guid_Goodness] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Alignment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Monster_Movement]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Monster_Movement](
	[guid_monster] [uniqueidentifier] NOT NULL,
	[guid_Movement] [uniqueidentifier] NOT NULL,
	[speed_Movement] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_monster] ASC,
	[guid_Movement] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Monster_Senses]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Monster_Senses](
	[guid_monster] [uniqueidentifier] NOT NULL,
	[guid_Sense] [uniqueidentifier] NOT NULL,
	[distance_sense] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_monster] ASC,
	[guid_Sense] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Monster_Skill]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Monster_Skill](
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_skill] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Monster] ASC,
	[guid_skill] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mon_rl_Protection]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mon_rl_Protection](
	[guid_DamageType] [uniqueidentifier] NOT NULL,
	[guid_Monster] [uniqueidentifier] NOT NULL,
	[guid_Protection] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_DamageType] ASC,
	[guid_Monster] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_lu_SkillRequired]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_lu_SkillRequired](
	[guid_Skill] [uniqueidentifier] NOT NULL,
	[name_SkillLevel] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Skill] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_lu_WeaponReach]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_lu_WeaponReach](
	[guid_Reach] [uniqueidentifier] NOT NULL,
	[name_Reach] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Reach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_lu_WeaponTrait]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_lu_WeaponTrait](
	[guid_Trait] [uniqueidentifier] NOT NULL,
	[name_Trait] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Trait] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_lu_WeaponType]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_lu_WeaponType](
	[guid_WeaponType] [uniqueidentifier] NOT NULL,
	[guid_Skill] [uniqueidentifier] NULL,
	[guid_Reach] [uniqueidentifier] NULL,
	[name_weaponType] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK__weap_lu___16C9DC1B61B3AA5B] PRIMARY KEY CLUSTERED 
(
	[guid_WeaponType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[weap_rl_Weapon_WeaponTrait]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[weap_rl_Weapon_WeaponTrait](
	[guid_Trait] [uniqueidentifier] NOT NULL,
	[guid_Weapon] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[guid_Trait] ASC,
	[guid_Weapon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'bc22c77c-47ce-4545-8e01-0dc50b181863', N'017f6724-b3bb-47a9-866f-aa0f6b5ea615', N'Natural Armor', 0, 0)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'5671fbac-4ca1-40f7-a2ba-2ca169cfda74', N'f79ac52b-9051-4150-bd72-04685bafb2ec', N'Splint', 17, 1)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'28c85887-22a6-48fd-af47-3672826ca38b', N'56932a77-ee68-4be6-a38d-3310856d9c40', N'Studded leather', 12, 0)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'473b5e7e-8aa8-47c3-a277-40afaf1b8663', N'56932a77-ee68-4be6-a38d-3310856d9c40', N'Leather', 11, 0)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'4691e07a-52e1-4a67-8c76-5ce7be7e3c6e', N'91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', N'Hide', 12, 0)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'aec7ec59-d514-47be-868f-66d6d11dd8fa', N'56932a77-ee68-4be6-a38d-3310856d9c40', N'Padded', 11, 1)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'709e9bd1-33dd-40c3-a768-73278de345a6', N'91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', N'Scale Mail', 14, 1)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'e3380772-677d-47e0-8b12-84f4e131b787', N'91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', N'Half Plate', 15, 1)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'3163b20f-aeae-48db-b63d-a72e4c956e9c', N'91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', N'Breastplate', 14, 0)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'f747896e-2497-4ac6-9fe9-afbc7647bcd8', N'f79ac52b-9051-4150-bd72-04685bafb2ec', N'Ring Mail', 14, 1)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'ca6d4488-781d-4be6-8ce8-bc65496b4450', N'f79ac52b-9051-4150-bd72-04685bafb2ec', N'Chain Mail', 16, 1)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'088f622d-e6c3-4ff4-af2a-cb002f8e1405', N'91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', N'Chain Shirt', 13, 0)
INSERT [dbo].[arm_Armor] ([guid_Armor], [guid_ArmorType], [name_Armor], [armor_Class], [has_StealthDisadvantage]) VALUES (N'c9f77dd7-34f5-4292-9452-ef60a59413c3', N'f79ac52b-9051-4150-bd72-04685bafb2ec', N'Plate', 18, 1)
INSERT [dbo].[arm_lu_ArmorType] ([guid_ArmorType], [name_ArmorType]) VALUES (N'f79ac52b-9051-4150-bd72-04685bafb2ec', N'Heavy')
INSERT [dbo].[arm_lu_ArmorType] ([guid_ArmorType], [name_ArmorType]) VALUES (N'56932a77-ee68-4be6-a38d-3310856d9c40', N'Light')
INSERT [dbo].[arm_lu_ArmorType] ([guid_ArmorType], [name_ArmorType]) VALUES (N'91aa2a71-adc6-4dd5-8bd7-50e97c29ec45', N'Medium')
INSERT [dbo].[arm_lu_ArmorType] ([guid_ArmorType], [name_ArmorType]) VALUES (N'017f6724-b3bb-47a9-866f-aa0f6b5ea615', N'Natural')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'28c85887-22a6-48fd-af47-3672826ca38b', 0, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'473b5e7e-8aa8-47c3-a277-40afaf1b8663', 0, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'4691e07a-52e1-4a67-8c76-5ce7be7e3c6e', 2, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'aec7ec59-d514-47be-868f-66d6d11dd8fa', 0, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'709e9bd1-33dd-40c3-a768-73278de345a6', 2, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'e3380772-677d-47e0-8b12-84f4e131b787', 2, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'3163b20f-aeae-48db-b63d-a72e4c956e9c', 2, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_rl_ACModifier] ([guid_Armor], [max_Modifier], [guid_AbilityScore]) VALUES (N'088f622d-e6c3-4ff4-af2a-cb002f8e1405', 2, N'6c49abc6-06f1-436a-a046-f50e9cc93808')
INSERT [dbo].[arm_Shield] ([guid_Shield], [name_Shield], [armor_Class]) VALUES (N'1adc4be5-872e-40d2-91cf-e3c7a2757281', N'Shield', 2)
INSERT [dbo].[com_AbilityScore] ([guid_AbilityScore], [name_AbilityScore]) VALUES (N'2d98bb55-6f0f-4d35-bcdc-01a405ce770f', N'Wisdom')
INSERT [dbo].[com_AbilityScore] ([guid_AbilityScore], [name_AbilityScore]) VALUES (N'74ee66a4-deda-4660-9f4a-2d40becc0e77', N'Constitution')
INSERT [dbo].[com_AbilityScore] ([guid_AbilityScore], [name_AbilityScore]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'Strength')
INSERT [dbo].[com_AbilityScore] ([guid_AbilityScore], [name_AbilityScore]) VALUES (N'a8a91281-619e-43af-b32d-8ef14cc41151', N'Intelligence')
INSERT [dbo].[com_AbilityScore] ([guid_AbilityScore], [name_AbilityScore]) VALUES (N'd38c4a57-4c05-4eff-872f-d9c886ca558f', N'Charisma')
INSERT [dbo].[com_AbilityScore] ([guid_AbilityScore], [name_AbilityScore]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'Dexterity')
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'6798d7f1-d779-437c-9c99-000031c5d30c', 6, N'2', 450)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'f6d26cd6-f212-452b-a6f4-033cd3525d49', 28, N'24', 62000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'8bb60024-59fa-46e0-921e-05f60dd26cdb', 34, N'30', 155000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'b5f9abae-8b6e-43d0-b3c1-08b23907121a', 8, N'4', 1100)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', 20, N'16', 15000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'b997bbc4-0aed-4a32-acab-166134369f47', 31, N'27', 105000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'ac3179be-938e-4819-9098-2106abdbb429', 22, N'18', 20000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'e45b322e-a694-43a0-a42d-210b2fcf05f7', 1, N'0', 0)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'7faff7cc-8691-4b27-ae01-2606bafba93f', 15, N'11', 7200)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'e58ab5bd-f7be-4989-bfd0-26840cf218f7', 24, N'20', 25000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', 14, N'10', 5900)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'a0e4ee68-87f0-433c-bfa6-2c834b382119', 30, N'26', 90000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'9c3c55bc-5044-46e4-9bc4-3d2ebe317430', 21, N'17', 18000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'6558423c-eb07-48dc-a694-3efdc36be41d', 32, N'28', 120000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'32a77e7d-ade9-4461-8941-421809e379fc', 2, N'1/8', 25)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', 12, N'8', 3900)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'584e036f-f640-4e76-937a-57fb7c9aad41', 5, N'1', 200)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'4fbabffc-b152-43cc-b361-5b03cb53c60d', 29, N'25', 75000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'902e442e-5ac7-411a-9f77-6b8a12e58cdf', 23, N'19', 22000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'7a06f521-598d-4736-9c7f-6e4d87c77a05', 4, N'1/2', 100)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'8caf6098-94d8-4d25-a19f-6edc5131d168', 18, N'14', 11500)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'27de4a7f-8762-41d8-b6b9-6f1f1902de74', 25, N'21', 33000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'9bc8da1e-a396-46ae-8884-758b0676c05a', 19, N'15', 13000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', 13, N'9', 5000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', 33, N'29', 135000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'2bd93716-3342-4160-891f-8cdbebdf885e', 27, N'23', 50000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', 10, N'6', 2300)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'22e2f0ce-c357-4d4f-8668-bf4d85b3369c', 26, N'22', 41000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'641fa88c-f7b3-4822-9136-d174b155e193', 9, N'5', 1800)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'12a0ccf5-11c7-44f4-a44f-e7729ee11bba', 11, N'7', 2900)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'54d4a58f-d22d-4c49-b16c-f40979f55207', 17, N'13', 10000)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'7205de9d-e02b-4c83-bbc0-f6ede21434f6', 7, N'3', 700)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'864ed2cf-5aea-45a7-add2-f7228ea1e3f3', 16, N'12', 8400)
INSERT [dbo].[com_CR] ([guid_CR], [rank_CR], [name_CR], [experience_Points]) VALUES (N'2a7b6a97-4784-452f-936e-ff44d2cbc3ba', 3, N'1/4', 50)
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'bbca4bf6-f2aa-425d-b31e-2719a5a11ecb', N'Elvish', N'Elvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'24de5d90-3314-40d2-b725-27388161d9c5', N'Halfling', N'Common')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'3d904bac-cccf-42fd-8ca2-35813066a96e', N'Undercommon', N'Underscript')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'ffa8126e-f845-4a56-b950-56a2fc2231f9', N'Orc', N'Dwarvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'68336ea4-c5a6-478d-9a3b-717cbec7273c', N'Sylvan', N'Elvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'e957ed0f-78b2-4428-8a51-78f72c40d702', N'Draconic', N'Draconic')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'cdc039b0-38b1-4578-a081-7960b9b09f49', N'Dwarvish', N'Dwarvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'd57871f8-2905-4d98-aa5a-8544f8cc1d14', N'Giant', N'Dwarvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'74dd4172-d496-48b0-878e-92856964dae1', N'Goblin', N'Dwarvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'cf3aa67b-ac66-4fbd-a83d-93881ec3113f', N'Primordial', N'Dwarvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'9b578587-711a-4ab9-a09c-95a77bf28342', N'Common', N'Common')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'3b7fcac8-79c3-4e32-a5ec-c427e1518c74', N'Celestial', N'Celestial')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'56a41403-9e73-4174-908d-c9e03d49d4b8', N'Infernal', N'Infernal')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'9cace042-ced7-4fac-b71b-cc3fe2e30890', N'Gnomish', N'Dwarvish')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'6ae5c857-6faa-4a6b-83de-d2e4fce8305a', N'Deep Speech', N'None')
INSERT [dbo].[com_Language] ([guid_Language], [name_Language], [name_Script]) VALUES (N'f0804fe8-00f8-4d94-a21a-e09974a19afc', N'Abyssal', N'Infernal')
INSERT [dbo].[com_lu_Movement] ([guid_Movement], [name_Movement]) VALUES (N'66ad7c4f-8a55-4256-99a9-48152b0f4fcb', N'Walking')
INSERT [dbo].[com_lu_Movement] ([guid_Movement], [name_Movement]) VALUES (N'474b0d21-87bf-4a7b-bd77-625293f1497a', N'Climbing')
INSERT [dbo].[com_lu_Movement] ([guid_Movement], [name_Movement]) VALUES (N'84fe9cca-37e3-45b7-bda9-903c268a8a28', N'Swimming')
INSERT [dbo].[com_lu_Movement] ([guid_Movement], [name_Movement]) VALUES (N'd4d08461-7a02-466e-9988-b68f44c06906', N'Burrowing')
INSERT [dbo].[com_lu_Movement] ([guid_Movement], [name_Movement]) VALUES (N'f5420c6c-29be-4178-afaa-dab2710a67bd', N'Flying')
INSERT [dbo].[com_lu_Senses] ([guid_Sense], [name_Sense]) VALUES (N'373dc787-a970-465e-86f5-05ea95c53689', N'Darkvision')
INSERT [dbo].[com_lu_Senses] ([guid_Sense], [name_Sense]) VALUES (N'17b2ad71-e65a-4ef3-aabc-09e5d943153b', N'Blindsight')
INSERT [dbo].[com_lu_Senses] ([guid_Sense], [name_Sense]) VALUES (N'9b13aada-c519-4a0f-aaab-43002f8fd2d9', N'Truesight')
INSERT [dbo].[com_lu_Senses] ([guid_Sense], [name_Sense]) VALUES (N'3c3890cb-3e8f-4ec4-88f5-f908c2259f12', N'Tremorsense')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'0994ad2c-3c16-4a28-9099-00e800b8a18e', N'Investigation')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'591a52a7-a577-4fa7-915a-077cb6434b97', N'History')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'c55ffa93-4ec6-465d-a607-3ca1a6e5c8dc', N'Medicine')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'98afd2f4-dcb0-4ef9-9c22-4183e652de8a', N'Persuasion')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'605fb05b-0adc-4d7d-ba63-46fb95bf3b7c', N'Perception')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'9f2451a2-35ef-433e-9f2f-63e6c5154004', N'Athletics')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'af549fb6-6972-4fe1-b063-9743d82ce9e5', N'Nature')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'bf93e1a0-4445-4f0c-a2d2-9ab7bbfb395c', N'Stealth')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'ef3db14f-370a-42ef-9515-acbc78fc657d', N'Survival')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'c6769c24-53df-43ae-a696-b901493ccb5e', N'Religion')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'340307f6-63c6-4f02-9417-d2a34677446d', N'Intimidation')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'c7714643-aa68-4fc3-8ae5-dcf0307fdf47', N'Insight')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'ea6b363d-4d3e-4883-8b29-dcf9c71db876', N'Performance')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'2e6c43f3-ddef-4dd8-9ab6-ef985e7018fb', N'Animal Handling')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'e9d9e738-38f5-44ef-b3fd-f4edc8b82d3c', N'Deception')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'd675676c-2312-4f81-97d1-f4fe6ced7ac3', N'Sleight of Hand')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'1084a24e-7746-4775-8f70-f7980c3514f4', N'Arcana')
INSERT [dbo].[com_lu_Skill] ([guid_skill], [name_Skill]) VALUES (N'dae0c6b2-9a75-42b1-abe9-f7bca37d7a65', N'Acrobatics')
INSERT [dbo].[com_ProtectionFromDamage] ([guid_Protection], [name_Protection]) VALUES (N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6', N'Resistance')
INSERT [dbo].[com_ProtectionFromDamage] ([guid_Protection], [name_Protection]) VALUES (N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8', N'Immunity')
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (1, -5)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (2, -4)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (3, -4)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (4, -3)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (5, -3)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (6, -2)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (7, -2)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (8, -1)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (9, -1)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (10, 0)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (11, 0)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (12, 1)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (13, 1)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (14, 2)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (15, 2)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (16, 3)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (17, 3)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (18, 4)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (19, 4)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (20, 5)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (21, 5)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (22, 6)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (23, 6)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (24, 7)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (25, 7)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (26, 8)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (27, 8)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (28, 9)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (29, 9)
INSERT [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore], [value_AbilityScore_Modifier]) VALUES (30, 10)
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'2d98bb55-6f0f-4d35-bcdc-01a405ce770f', N'c55ffa93-4ec6-465d-a607-3ca1a6e5c8dc')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'2d98bb55-6f0f-4d35-bcdc-01a405ce770f', N'605fb05b-0adc-4d7d-ba63-46fb95bf3b7c')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'2d98bb55-6f0f-4d35-bcdc-01a405ce770f', N'ef3db14f-370a-42ef-9515-acbc78fc657d')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'2d98bb55-6f0f-4d35-bcdc-01a405ce770f', N'c7714643-aa68-4fc3-8ae5-dcf0307fdf47')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'2d98bb55-6f0f-4d35-bcdc-01a405ce770f', N'2e6c43f3-ddef-4dd8-9ab6-ef985e7018fb')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'9f2451a2-35ef-433e-9f2f-63e6c5154004')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'a8a91281-619e-43af-b32d-8ef14cc41151', N'0994ad2c-3c16-4a28-9099-00e800b8a18e')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'a8a91281-619e-43af-b32d-8ef14cc41151', N'591a52a7-a577-4fa7-915a-077cb6434b97')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'a8a91281-619e-43af-b32d-8ef14cc41151', N'af549fb6-6972-4fe1-b063-9743d82ce9e5')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'a8a91281-619e-43af-b32d-8ef14cc41151', N'c6769c24-53df-43ae-a696-b901493ccb5e')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'a8a91281-619e-43af-b32d-8ef14cc41151', N'1084a24e-7746-4775-8f70-f7980c3514f4')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'd38c4a57-4c05-4eff-872f-d9c886ca558f', N'98afd2f4-dcb0-4ef9-9c22-4183e652de8a')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'd38c4a57-4c05-4eff-872f-d9c886ca558f', N'340307f6-63c6-4f02-9417-d2a34677446d')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'd38c4a57-4c05-4eff-872f-d9c886ca558f', N'ea6b363d-4d3e-4883-8b29-dcf9c71db876')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'd38c4a57-4c05-4eff-872f-d9c886ca558f', N'e9d9e738-38f5-44ef-b3fd-f4edc8b82d3c')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'bf93e1a0-4445-4f0c-a2d2-9ab7bbfb395c')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'd675676c-2312-4f81-97d1-f4fe6ced7ac3')
INSERT [dbo].[com_rl_AbilityScore_Skill] ([guid_AbilityScore], [guid_skill]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'dae0c6b2-9a75-42b1-abe9-f7bca37d7a65')
INSERT [dbo].[com_Size] ([guid_Size], [name_Size], [guid_Die]) VALUES (N'a4d28780-e894-4d7a-b065-1cb00ee01d80', N'Small', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307')
INSERT [dbo].[com_Size] ([guid_Size], [name_Size], [guid_Die]) VALUES (N'5e6048f6-e0ec-4bb1-9065-2116230246ff', N'Gargantuan', N'61cb0fcd-7038-43e5-894f-a1a7a2cccce1')
INSERT [dbo].[com_Size] ([guid_Size], [name_Size], [guid_Die]) VALUES (N'2ef6d926-9d94-46d6-9f4d-6b14321d7d2e', N'Tiny', N'1ff5257c-1568-49c1-a656-088b4884efc0')
INSERT [dbo].[com_Size] ([guid_Size], [name_Size], [guid_Die]) VALUES (N'c64a7d4b-30cd-4eee-a276-dbbde28daa21', N'Medium', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8')
INSERT [dbo].[com_Size] ([guid_Size], [name_Size], [guid_Die]) VALUES (N'5d0ff0c0-6053-476e-a423-df63946be45e', N'Large', N'e01bf86f-0ff3-4cf7-897f-a185afb33c54')
INSERT [dbo].[com_Size] ([guid_Size], [name_Size], [guid_Die]) VALUES (N'a9404107-c146-4e4f-ac83-f1b5df09bed7', N'Huge', N'c4d1ecfa-f454-45cf-be70-cf784baf834f')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'6798d7f1-d779-437c-9c99-000031c5d30c')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (7, N'f6d26cd6-f212-452b-a6f4-033cd3525d49')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (9, N'8bb60024-59fa-46e0-921e-05f60dd26cdb')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'b5f9abae-8b6e-43d0-b3c1-08b23907121a')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (5, N'd8e93c9d-4553-4ce1-b30b-14c5822e4b22')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (8, N'b997bbc4-0aed-4a32-acab-166134369f47')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (6, N'ac3179be-938e-4819-9098-2106abdbb429')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'e45b322e-a694-43a0-a42d-210b2fcf05f7')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (4, N'7faff7cc-8691-4b27-ae01-2606bafba93f')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (6, N'e58ab5bd-f7be-4989-bfd0-26840cf218f7')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (4, N'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (8, N'a0e4ee68-87f0-433c-bfa6-2c834b382119')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (6, N'9c3c55bc-5044-46e4-9bc4-3d2ebe317430')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (8, N'6558423c-eb07-48dc-a694-3efdc36be41d')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'32a77e7d-ade9-4461-8941-421809e379fc')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (3, N'fa7e2c4d-5fc6-41c1-83f6-442c7282950b')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'584e036f-f640-4e76-937a-57fb7c9aad41')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (8, N'4fbabffc-b152-43cc-b361-5b03cb53c60d')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (6, N'902e442e-5ac7-411a-9f77-6b8a12e58cdf')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'7a06f521-598d-4736-9c7f-6e4d87c77a05')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (5, N'8caf6098-94d8-4d25-a19f-6edc5131d168')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (7, N'27de4a7f-8762-41d8-b6b9-6f1f1902de74')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (5, N'9bc8da1e-a396-46ae-8884-758b0676c05a')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (4, N'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (9, N'5c50c90f-1fc0-4c89-85b6-7e5890c42d2a')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (7, N'2bd93716-3342-4160-891f-8cdbebdf885e')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (3, N'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (7, N'22e2f0ce-c357-4d4f-8668-bf4d85b3369c')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (3, N'641fa88c-f7b3-4822-9136-d174b155e193')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (3, N'12a0ccf5-11c7-44f4-a44f-e7729ee11bba')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (5, N'54d4a58f-d22d-4c49-b16c-f40979f55207')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'7205de9d-e02b-4c83-bbc0-f6ede21434f6')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (4, N'864ed2cf-5aea-45a7-add2-f7228ea1e3f3')
INSERT [dbo].[core_lu_CR_Proficiency] ([proficiency_bonus], [guid_CR]) VALUES (2, N'2a7b6a97-4784-452f-936e-ff44d2cbc3ba')
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'6798d7f1-d779-437c-9c99-000031c5d30c', 13, 86, 100)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'f6d26cd6-f212-452b-a6f4-033cd3525d49', 19, 536, 580)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'8bb60024-59fa-46e0-921e-05f60dd26cdb', 19, 806, 860)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'b5f9abae-8b6e-43d0-b3c1-08b23907121a', 14, 116, 130)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', 18, 296, 310)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'b997bbc4-0aed-4a32-acab-166134369f47', 19, 671, 715)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'ac3179be-938e-4819-9098-2106abdbb429', 19, 326, 340)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'e45b322e-a694-43a0-a42d-210b2fcf05f7', 13, 1, 6)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'7faff7cc-8691-4b27-ae01-2606bafba93f', 17, 221, 235)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'e58ab5bd-f7be-4989-bfd0-26840cf218f7', 19, 356, 400)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', 17, 206, 220)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'a0e4ee68-87f0-433c-bfa6-2c834b382119', 19, 626, 670)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'9c3c55bc-5044-46e4-9bc4-3d2ebe317430', 19, 311, 325)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'6558423c-eb07-48dc-a694-3efdc36be41d', 19, 716, 760)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'32a77e7d-ade9-4461-8941-421809e379fc', 13, 7, 36)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', 16, 176, 190)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'584e036f-f640-4e76-937a-57fb7c9aad41', 13, 71, 85)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'4fbabffc-b152-43cc-b361-5b03cb53c60d', 19, 581, 625)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'902e442e-5ac7-411a-9f77-6b8a12e58cdf', 19, 341, 355)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'7a06f521-598d-4736-9c7f-6e4d87c77a05', 13, 50, 70)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'8caf6098-94d8-4d25-a19f-6edc5131d168', 18, 266, 280)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'27de4a7f-8762-41d8-b6b9-6f1f1902de74', 19, 401, 445)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'9bc8da1e-a396-46ae-8884-758b0676c05a', 18, 281, 295)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', 16, 191, 205)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', 19, 761, 805)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'2bd93716-3342-4160-891f-8cdbebdf885e', 19, 491, 535)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', 15, 146, 160)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'22e2f0ce-c357-4d4f-8668-bf4d85b3369c', 19, 446, 490)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'641fa88c-f7b3-4822-9136-d174b155e193', 15, 131, 145)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'12a0ccf5-11c7-44f4-a44f-e7729ee11bba', 15, 161, 175)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'54d4a58f-d22d-4c49-b16c-f40979f55207', 18, 251, 265)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'7205de9d-e02b-4c83-bbc0-f6ede21434f6', 13, 101, 115)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'864ed2cf-5aea-45a7-add2-f7228ea1e3f3', 17, 236, 250)
INSERT [dbo].[core_lu_Defensive_Values] ([guid_CR], [AC], [minimum_HP], [maximum_HP]) VALUES (N'2a7b6a97-4784-452f-936e-ff44d2cbc3ba', 13, 36, 49)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'6798d7f1-d779-437c-9c99-000031c5d30c', 3, 13, 15, 20)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'f6d26cd6-f212-452b-a6f4-033cd3525d49', 12, 21, 195, 212)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'8bb60024-59fa-46e0-921e-05f60dd26cdb', 14, 23, 303, 320)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'b5f9abae-8b6e-43d0-b3c1-08b23907121a', 5, 14, 27, 32)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', 9, 18, 99, 4)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'b997bbc4-0aed-4a32-acab-166134369f47', 13, 22, 249, 266)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'ac3179be-938e-4819-9098-2106abdbb429', 10, 19, 111, 116)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'e45b322e-a694-43a0-a42d-210b2fcf05f7', 3, 13, 0, 1)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'7faff7cc-8691-4b27-ae01-2606bafba93f', 8, 17, 69, 74)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'e58ab5bd-f7be-4989-bfd0-26840cf218f7', 10, 19, 123, 140)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', 7, 17, 63, 68)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'a0e4ee68-87f0-433c-bfa6-2c834b382119', 12, 21, 231, 248)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'9c3c55bc-5044-46e4-9bc4-3d2ebe317430', 10, 19, 105, 110)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'6558423c-eb07-48dc-a694-3efdc36be41d', 13, 22, 267, 284)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'32a77e7d-ade9-4461-8941-421809e379fc', 3, 13, 2, 3)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', 7, 16, 51, 56)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'584e036f-f640-4e76-937a-57fb7c9aad41', 3, 13, 9, 14)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'4fbabffc-b152-43cc-b361-5b03cb53c60d', 12, 21, 213, 230)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'902e442e-5ac7-411a-9f77-6b8a12e58cdf', 10, 19, 117, 122)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'7a06f521-598d-4736-9c7f-6e4d87c77a05', 3, 13, 6, 8)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'8caf6098-94d8-4d25-a19f-6edc5131d168', 8, 18, 87, 92)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'27de4a7f-8762-41d8-b6b9-6f1f1902de74', 11, 20, 141, 158)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'9bc8da1e-a396-46ae-8884-758b0676c05a', 8, 18, 93, 98)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', 7, 16, 57, 62)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', 13, 22, 285, 302)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'2bd93716-3342-4160-891f-8cdbebdf885e', 11, 20, 177, 194)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', 6, 15, 39, 44)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'22e2f0ce-c357-4d4f-8668-bf4d85b3369c', 11, 20, 159, 176)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'641fa88c-f7b3-4822-9136-d174b155e193', 6, 15, 33, 38)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'12a0ccf5-11c7-44f4-a44f-e7729ee11bba', 6, 15, 45, 50)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'54d4a58f-d22d-4c49-b16c-f40979f55207', 8, 18, 81, 86)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'7205de9d-e02b-4c83-bbc0-f6ede21434f6', 4, 13, 21, 26)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'864ed2cf-5aea-45a7-add2-f7228ea1e3f3', 8, 17, 75, 80)
INSERT [dbo].[core_lu_Offensive_Values] ([guid_CR], [attack_bonus], [save_DC], [minimum_damage], [maximum_damage]) VALUES (N'2a7b6a97-4784-452f-936e-ff44d2cbc3ba', 3, 13, 4, 5)
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'1ff5257c-1568-49c1-a656-088b4884efc0', 1, 4, 2.5, N'd4')
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', 1, 8, 4.5, N'd8')
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', 1, 6, 3.5, N'd6')
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'e01bf86f-0ff3-4cf7-897f-a185afb33c54', 1, 10, 5.5, N'd10')
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'61cb0fcd-7038-43e5-894f-a1a7a2cccce1', 1, 20, 10.5, N'd20')
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'c4d1ecfa-f454-45cf-be70-cf784baf834f', 1, 12, 6.5, N'd12')
INSERT [dbo].[dice_Dice] ([guid_Die], [min_Roll], [max_Roll], [average_Roll], [name_Die]) VALUES (N'bd31d66d-3731-45bb-88b2-dbf1acfa6e98', 1, 1, 1, N'd1')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'30f9a521-8284-4c02-b841-0317e53061f3', N'Spellcasting', N'It''s complicated', N'Varies')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'9afb16b6-9cdf-4153-909b-077ac8190d2f', N'Elemental Body', N'Increase the monster''s effective per-round damage by the amount noted in the trait', N'A creature that touchers the monster or hits it with a melee attack while within 5 feet of it takes damage.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'9f48748c-5e52-4c41-875e-0a2f635f6e94', N'Standing Leap', N'', N'The monster''s long jump is up to 20 feet and its high jump is up to 10 feet, with or without a running start.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'05be75ff-2ca1-4985-a6a2-14499ff3fa8f', N'Change Shape ', N'', N'The monster magically polymorphs into a humanoid or beast that has a challenge rating no higher than its own, or back into its true form. It reverts to its true form if it dies. Any equipment it is wearing or carrying is absorbed or borne by the new form (the monster''s choice). In a new form, the monster retains its alignment, hit points, Hit Dice, ability to speak, proficiencies, Legendary Resistance (if any), lair actions (if any), and Intelligence, Wisdom, and Charisma scores, as well as this action. Its statistics and capabilities are otherwise replaced by those of the new form, except any class features or legendary actions of that form.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'2e0c7794-4152-4fb3-a26b-1ea70114fdf9', N'Innate Spellcasting', N'It''s complicated', N'Varies')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'e9acc141-9a59-40db-b2f8-1fab7334e1e0', N'Otherworldly Perception', N'', N'The monster can sense the presence of any creature within 30 feet of it that is invisible or on the Ethereal Plane. It can pinpoint such a creature that is moving. ')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'a829c160-0287-4853-9734-22831a64fe05', N'Web Sense', N'', N'While in contact with a web, the monster knows the exact location of any other creature in contact with the same web.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'0915b940-766a-4a50-a1d6-23e1e09e71de', N'Tunneler', N'', N'The monster can burrow through solid rock at half its burrowing speed and leaves a tunnel in its wake.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'53fb9601-75cc-4736-bf3a-28db6d0fc8cc', N'Rejuvenation', N'', N'If it has a phylactery, the destroyed monster gains a new body in 1d10 days, regaining all its hit points and becoming active again . The new body appears within 5 feet of the phylactery.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'95867524-4693-4a21-a40b-29016278ba47', N'Devil Sight', N'', N'Magical darkness doesn''t impede the darkvision .')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'b1a47bb5-28e9-4445-af10-2905afd563b1', N'Avoidance', N'Increase the monster''s effective AC by 1', N'If the monster is subjected to an effect that allows it to make a saving throw to take only half damage, it instead takes no damage if it succeeds on the saving throw, and only half damage if it fails.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'8d8df994-c416-46ed-b379-2d37bec7692a', N'Shadow Stealth', N'Incrase the monster''s effective AC by 4', N'While in dim light or darkness, the monster can take the Hide action as a bonus action.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'dd08fff3-a64f-4275-9dd4-2de7ddc12032', N'Incorporeal Movement', N'', N'The monster can move through other creatures and objects as if they were difficult terrain. It takes 5 (1d10) force damage if it ends its turn inside an object.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'3d225974-3a90-4886-bf48-2e1b77c6279b', N'Parry', N'Increase the monster''s effective AC by 1', N'The monster adds 6 to its AC against one melee attack that would hit it. To do so, the monster must see the attacker and be wield ing a melee weapon.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'dee3c8aa-ebc5-4c1e-90f5-32997fab4a3e', N'Magic Resistance', N'Increase the monster''s effective AC by 2', N'The monster has advantage on saving throws against spells and other magical effects.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'a9e63834-7fd5-4f30-aee5-3630971b32c2', N'Grappler', N'', N'The monster has advantage on attack rolls against any creature grappled by it.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'ef601ddf-5f61-4ca6-9f0e-379d62e6e34f', N'Illusory Appearance', N'', N'The monster covers itself and anything it is wearing or carrying with a magical illusion that makes her look like another creature of its general size and humanoid shape. The illusion ends if the hag takes a bonus action to end it or if it dies. The changes wrought by this effect fail to hold up to physical inspection. For example, the monster could appear to have smooth skin, but someone touching it would feel its rough flesh. Otherwise, a creature must take an action to visually inspect the illusion and succeed on a DC 20 Intelligence (Investigation) check to discern that the monster is disguised.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'dac1b195-5610-4dd0-90b9-3bfcc211dfb5', N'Charge', N'Increase the monster''s damage on one attack by the amount noted in the trait', N'If the monster moves at least 30 feet straight toward a target and then hits it with a weapon attack on the same turn, the target takes an extra amount of damage.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'aa11d1bb-5086-4d27-90da-3ce6080249e8', N'Keen Senses', N'', N'The monster has advantage on Wisdom (Perception) checks that rely on the chosen sense.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'8fe76edc-d704-4d65-aaf5-3d1138505a1d', N'Blood Frenzy', N'Increase the monster''s effective attack bonus by 4', N'The monster has advantage on melee attack rolls against any creature that doesn''t have all its hit points.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'77b29aac-f4e4-49d1-8d61-3e7ee20e052f', N'Terrain Camouflage', N'', N'The monster has advantage on Dexterity (Stealth) checks made to hide in native terrain.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'e4da0ca8-31fd-4279-8436-3ea5442a5a14', N'Antimagic Susceptibility', N'', N'The monster is incapacitated while in the area of an anti-magic field. If targeted by dispel magic, the monster must succeed on a Constitution saving throw against the caster''s spell save DC or fall unconscious for 1 minute.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'53c75262-a6ea-4071-8e4f-3efe7c92c750', N'Web', N'Increase the monster''s effective AC by 1', N'Recharge 5-6. Ranged Weapon Attack: +5 to hit, range 30 ft. to 60 ft., one creature. Hit: The target is restrained by webbing. As an action, the restrained target can make a Strength check, bursting the webbing on a success. The webbing can also be attacked and destroyed (AC 10; hp 5; vulnerability to fire damage; immunity to bludgeoning, poison, and psychic damage).')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'cfff9e9d-4816-4edc-a2d2-3f3cec7d4196', N'Reactive ', N'', N'The monster can take one reaction on every turn in a combat.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'41670e84-80eb-46c7-864a-44da8b87cc24', N'Constrict', N'Increase the monster''s effective AC by 1', N'Melee weapon attack, reach 5 ft., one creature the same size or smaller as the monster. The target is grappled if the monster isn''t already constricting a creature, and the target is restrained until this grapple ends.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'0a29f9dc-4b01-4902-8735-45701246a2d5', N'Life Drain', N'', N'The target must succeed on a Constitution saving throw or its hit point maximum is reduced by an amount equal to the damage taken. This reduction lasts until the target finishes a long rest. The target dies if this effect reduces its hit point maximum to 0. A humanoid slain by this attack rises 24 hours later as a zombie under the monster''s control, unless the humanoid is restored to life or its body is destroyed. The monster can have no more than twelve zombies under its control at one time.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'8e767ae1-2d4c-496b-b34d-465957ad2d16', N'Relentless', N'Increase the monster''s effective hit points based on the expected challenge rating: 1-4, 7 hp; 5-10, 14 hp; 11-16, 21 hp; 17 or higher, 28 hp', N'If the monster takes 14 damage or less that would reduce it to 0 hit points, it is reduced to 1 hit point instead.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'05752c2d-a1b4-4fa5-a8b5-47331efcaaff', N'Siege Monster', N'', N'The monster deals double damage to objects and structures.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'692e456a-ea87-4e32-abd9-4872580dcc7f', N'Legendary Resistance', N'Each per-day use of this trait increases the monster''s effective hit points based on the expected challenge rating: 1-4, 10 hp; 5-10, 20 hp; 11 or higher, 30 hp', N'If the monster fails a saving throw, it can choose to succeed instead.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'7735f1e6-cadd-480b-909d-4a5efab4fc73', N'Breath Weapon', N'For the purpose of determining effective damage output, assume the breath weapon hits two targets and that each target fails its saving throw', N'Varies')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'ab344948-f5f7-45cd-aefc-4b52a50e74e4', N'Martial Advantage', N'Increase the effective damage of one attack per round by the amount gained from this trait', N'Once per turn, the monster can deal an extra 10 (3d6) damage to a creature it hits with a weapon attack if that creature is with in 5 feet of an ally of the monster that isn''t incapacitated.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'4d877060-ef5c-489c-b8bc-4d9cce46672a', N'Charm', N'', N'The monster targets one humanoid it can see within 30 feet of it. If the target can see the monster, the target must succeed on a Wisdom saving throw against this magic or be charmed by the monster. The charmed target regards the monster as a trusted friend to be heeded and protected. Although the target isn''t under the monster''s control, it takes the monster''s requests or actions in the most favorable way it can, and it is a willing target for some attacks. Each time the monster or the monster''s companions do anything harmful to the target, it can repeat the saving throw, ending the effect on itself on a success. Otherwise, the effect lasts 24 hours or until the monster is destroyed , is on a different plane of existence than the target, or takes a bonus action to end the effect.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'd647388b-3ea2-43df-a3f8-50a4083475a5', N'Reckless', N'', N'At the start of its turn, the monster can gain advantage on all melee weapon attack rolls it makes during that turn, but attack rolls against it have advantage until the start of its next turn.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'6551d320-d66c-4518-aadb-522ee9ae5b05', N'Pounce', N'Increase the monster''s effective damage for 1 round by the amount it deals with the bonus action gained from this trait', N'If the monster moves at least 30 feet straight toward a creature and then hits it with a hand attack on the same turn, that target must succeed on a Strength saving throw or be knocked prone. If the target is prone, the monster can make one bite attack against it as a bonus action.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'a03e4d67-cd3e-4dc7-874c-5660894161b7', N'Superior Invisibility', N'Increase the monster''s effective AC by 2', N'As a bonus action, the monster can magically turn invisible until its concentration ends (as if concentrating on a spell). Any equipment the monster wears or carries is invisible with it.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'14bc11f9-12e6-4766-8d97-56adabf29264', N'Damage Transfer', N'Double the monster''s effective hit points. Add one-third of the monster''s hit points to its per-round damage', N'While attached to a creature, the monster takes only half the damage dealt to it (rounded down) and that creature takes the other half.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'bd26b280-292e-45fa-b510-5805b737a09b', N'Fey Ancestry', N'', N'The monster has advantage on saving throws against being charmed, and magic can''t put the monster to sleep')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'df21a834-ae4d-4417-89d4-5998cbd5b02f', N'Turn Resistance', N'', N'The monster has advantage on saving throws against any effect that turns undead.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'7a4f4298-a4da-4800-8c58-65d712a0476b', N'Slippery', N'', N'The monster has advantage on ability checks and saving throws made to escape a grapple.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'60e16183-52be-4174-85c3-6d28ac271e17', N'Damage Absorption', N'', N'Whenever the monster is subjected to elemental or other damage, it takes no damage and instead regains a number of hit poin ts equal to the damage damage dealt')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'4b03c5c0-fc6e-4dde-a57d-6d8bd1111a1b', N'Flyby', N'', N'The monster doesn''t provoke an opportunity attack when it flies out of an enemy''s reach.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'2ef2cca7-7570-4091-9538-70519a13a7c9', N'Two Heads', N'', N'The monster has advantage on Wisdom (Perception) checks and on saving throws against being blinded, charmed, deafened, frightened, stunned, and knocked unconscious.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'ca21462d-5e3e-4e21-be3c-71812ff616c4', N'Death Burst', N'Increase the monster''s effective damage output for 1 round by the amount noted in the trait and assume it affects two creatures', N'When the monster dies, it explodes in a burst. Each creature within 10 feet of it must make a DC 11 Dexterity saving throw, taking damage on a failed save, or half as much damage on a successful one. ')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'b16f22d1-2de4-4b02-860a-727540411fd2', N'Regeneration', N'Increase the monster''s effective hit points by 3x the number of hit points the monster regenerates each round', N'The monster regains 10 hit points at the start of its turn if it has at least 1 hit point')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'52196e12-ae94-4629-be26-7305665a8e5d', N'Surprise Attack', N'Increase the monster''s effective damage for 1 round by the amount noted in the trait', N'If the monster surprises a creature and hits it with an attack during the first round of combat, the target takes extra damage from the attack.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'45014478-4fff-4894-b31a-74c6b75d1f1a', N'Reel', N'', N'The monster pulls each creature grappled by it up to 25 feet straight toward it.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'59c09360-9d7e-4efb-9d38-775d78dbbeca', N'Blind Senses', N'', N'The monster can sense without the usual equipment to do so.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'7d8b1451-3dcc-4e70-b62c-7fa2939ec6af', N'Steadfast', N'', N'The monster can''t be frightened while it can see an allied creature within 30 feet of it.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'f8b2232e-a35e-40d3-8b74-866e0548a78d', N'Illumination', N'', N'The monster emits either dim light in a 15-foot radius, or bright light in a 15-foot radius and dim light for an additionnal 15 feet. It can switch between the options as an action')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'f339534d-a4eb-4cc6-822a-87cd84940df8', N'Brute', N'Increase the monster''s effective per-round damage by the amount noted in the trait', N'A melee weapon deals one extra die of its damage when the monster hits with it.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'a4183c7a-9266-4272-a796-89c20091f71e', N'Ambusher', N'Increase the monster''s effective attack bonus by 1', N'The monster has advantage on attack rolls against any creature it has surprised.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'4d68fb24-bcb5-4835-9e9a-8d64edee4f28', N'Echolocation', N'', N'Counts as blindsight, but the monster can''t use its blindsight while deafened.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'a8d05a66-3ccb-46b2-8951-8f6514de2c59', N'Leadership', N'', N'For 1 minute, the monster can utter a special command or warning whenever a nonhostile creature that it can see within 30 feet of it makes an attack roll or a saving throw. The creature can add a d4 to its roll provided it can hear and understand the monster. A creature can benefit from only one Leadership die at a time. This effect ends if the monster is incapacitated')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'cc9de9f3-7fab-4c5a-bbec-94022879c507', N'Redirect Attack', N'', N'When a creature the monster can see targets it with an attack, the monster chooses an ally within 5 feet of it. The two monster swap places, and the chosen monster becomes the target instead.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'67d0180f-d0fa-473b-83dc-96584cc1b787', N'Mimicry', N'', N'The monster has advantage on attack rolls against any creature it has surprised.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'b36420e4-5472-4f84-9502-98b87d7061c1', N'Undead Fortitude', N'Increase the monster''s effective hit points based on the expected challenge rating: 1-4, 7 hp; 5-10, 14 hp; 11-16, 21 hp; 17 or higher, 28 hp', N'If damage reduces the monster to 0 hit points, it must make a Constitution saving throw with a DC of 5 +the damage taken, unless the damage is radiant or from a critical hit. On a success, the monster drops to 1 hit point instead.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'4ef3df01-0ea5-4486-9d6a-99e74f9632e2', N'Turn Immunity', N'', N'The monster is immune to effects that turn undead.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'dd3e8563-1977-4611-9609-9bc417a1d229', N'Wounded Fury', N'Increase the monster''s damager for 1 round by the amount noted in the trait', N'While it has 10 hit points or fewer, the monster has advantage on attack rolls. In addition, it deals extra damage to any target it hits with a melee attack.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'3a2f0349-68ce-4a71-b9df-9c6298685156', N'Labyrinthine Recall', N'', N'The monster can perfectly recall any path it has traveled.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'b0687cb4-c034-4aa3-be07-9c6f677cb800', N'Chameleon Skin', N'', N'The monster has advantage on Dexterity (Stealth) checks made to hide')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'2ec5fccc-7b7e-482a-9d82-9cc1bd165a19', N'Inscrutable', N'', N'The monster is immune to any effect that would sense its emotions or read its thoughts, as well as any divination spell that it refuses. Wisdom (Insight) checks made to ascertain the monster''s intentions or sincerity have disadvantage.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'75caca80-712a-4236-9ed8-9e8a7bd149d1', N'Rampage', N'Incrase the monster effective per-round damage by 2', N'When the monster reduces a creature to 0 hit points with a melee attack on its turn , the monster can take a bonus action to move up to half its speed and make a bite attack.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'44694480-c564-41cc-8b5c-a135d0ead9dc', N'Horrifying Visage', N'Increase the monster''s effective hit points by 25% if the monster is meant to face characters of 10th level or higher', N'Each non-undead creature within 60 feet of the monster that can see her must succeed on a DC 13 Wisdom saving throw or be frightened for 1 minute. A frightened target can repeat the saving throw at the end of each of its turns, with disadvantage if the monster is within line of sight, ending the effect on itself on a success. If a target''s saving throw is successful or the effect ends for it, the target is immune to the monster''s Horrifying Visage for the next 24 hours.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'e2a75718-ccfd-4977-9aa6-a13a844523f2', N'Nimble Escape', N'Increase the monster''s effective AC and effective attack bonus by 4 ( assuming the monster hits every round)', N'The monster can take the Disengage or Hide action as a bonus action on each of its turns.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'd437df8b-c4f0-4e8f-a26d-a921643c8382', N'Sure-Footed', N'', N'The monster has advantage on Strength and Dexterity saving throws made against effects that would knock it prone.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'f4e738d8-1d85-4990-909b-ac68dbb4d3dd', N'Frightful Presence', N'Increase the monster''s effective hit points by 25% if the monster is meant to face characters of 10th level or higher', N'Each creature of the monster''s choice that is within 120 feet of the monster and aware of it must succeed on a DC 18 Wisdom saving throw or become frightened for 1 minute. A creature can repeat the saving throw at the end of each of its turns, ending the effect on itself on a success. If a creature''s saving throw is successful or the effect ends for it, the creature is immune to the monster''s Frightful Presence for the next 24 hours.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'0ffb37a5-fcab-4c7c-a055-b2b000baa96e', N'Invisibility', N'', N'The monster magically turns invisible until it attacks or uses offensive abilities or until its concentration ends (as if concentrating on a spell) . Any equipment the monster wears or carries is invisible with it')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'9d6b0cee-6b35-4c12-81cd-b2ca7a924c49', N'Psychic Defense', N'Apply the monster''s Wisdom modifier to its actual AC if the monsterits wearing armor or wielding a shield', N'While the monster is wearing no armor and wielding no shield , its AC includes its Wisdom modifier.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'fd5efee9-f5f4-47be-a8f3-b781fefcc65b', N'False Appearance', N'', N'While the monster remains motion less, it is indistinguishable from an inanimate statue.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'2bcbcaaa-1fb1-466c-9105-ba55d4d35da3', N'Etherealness', N'', N'The monster enters the Ethereal Plane from the Material Plane, or vice versa. It is visible on the Material Plane while it is in the Border Ethereal, and viae versa, yet it can''t affect or be affected by anything on the other plane.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'd11940bb-c202-4625-95a8-bd37ca4b17d8', N'Possession', N'Double the monster''s effective hit points.', N'Recharge 6. One humanoid that the monster can see within 5 feet of it must succeed on a Charisma saving throw or be possessed by the monster; the monster then disappears, and the target is incapacitated and loses control of its body. The monster now controls the body but doesn''t deprive the target of awareness. The monster can''t be targeted by any attack, spell, or other effect, except ones that turn undead, and it retains its alignment, Intelligence, Wisdom, Charisma, and immunities and resistances. It otherwise uses the possessed target''s statistics, but doesn''t gain access to the target''s knowledge, class features, or proficiencies. The possession lasts until the body drops to 0 hit points, the monster ends it as a bonus action, or the monster is turned or forced out by an effect like the dispel evil and good spell. When the possession ends, the monster reappears in an unoccupied space within 5 feet of the body. The target is immune to this monster''s Possession for 24 hours after succeeding on the saving throw or after the possession ends.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'9976567f-01c1-4a16-ae3a-c0fbe7c180de', N'Swallow ', N'Assume the monster swallows one creature and deals 2 rounds of acid damage to it', N'The monster makes one bite attack against a Medium or smaller target it is grappling. If the attack hits, the target is also swallowed, and the grapple ends. While swallowed, the target is blinded and restrained, it has total cover against attacks and other effects outside the behir, and it takes acid damage at the start of each of the monster''s turns. A monster can have only one creature swallowed at a time. If the monster takes 30 damage or more on a single turn from the swallowed creature, the monster must succeed on a Constitution saving throw at the end of that turn or regurgitate the creature, which falls prone in a space within 10 feet of the monster. If the monster dies, a swallowed creature is no longer restrained by it and can escape from the corpse by using 15 feet of movement, exiting prone.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'adf9c94b-d914-4a8f-807d-c10cb584ad21', N'Hold Breath ', N'', N'The monster can hold its breath for 15 minutes')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'bc70adbb-f678-4a5c-8a19-c31b749f84bd', N'Shapechanger', N'', N'The monster can use its action to polymorph into a beast form that resembles a bat (speed 10ft. fly 40ft.), a centipede (40ft., climb 40ft.), or a toad (40ft., swi m 40ft.), or back into its true form. Its statistics are the same in each form, except for the speed changes noted. Any equipment it is wearing or carrying transforms along with it.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'149fb57a-07a6-43bd-bd23-c77245c1a7f8', N'Read Thoughts', N'', N'The monster magically reads the surface thoughts of one creature within 60 feet of it. The effect can penetrate barriers, but 3 feet of wood or dirt, 2 feet of stone, 2 inches of metal, or a thin layer of lead blocks it. While the target is in range, the monster can continue reading its thoughts, as long as the monster''s concentration isn''t broken (as if concentrating on a spell). While reading the target''s mind, the monster has advantage on Wisdom (Insight) and Charisma (Deception, Intimidation, and Persuasion) checks against the target.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'5d87e207-2f3a-49f4-b995-ca3dd00193cf', N'Amorphous', N'', N'The monster can move through a space as narrow as 1 inch wide without squeezing.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'04889176-5ade-4562-82e2-cb65c31857fa', N'Sunlight Sensitivity', N'', N'While in sunlight, the monster has disadvantage on attack rolls, as well as on Wisdom (Perception) checks that rely on sight.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'b8c9215f-835e-40d9-8fd2-d0c829c0b8c6', N'Pack Tactics', N'Increase the monster''s effective attack bonus by 1', N'The monster has advantage on an attack roll against a creature if at least one of the monster''s allies is within 5 feet of the creature and the ally isn''t incapacitated.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'6d3a40c1-020a-4a18-bb9a-d4afe7450e2c', N'Fiendish Blessing', N'Apply the monster''s Charisma modifier to its actual AC', N'The AC of the monster includes its Charisma bonus')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'6fc90019-918f-40da-a35d-dbb820fe10c8', N'Stench', N'Increase the monster''s effective AC by 1', N'Any creature that starts its turn within 10 feet of the monster must succeed on a Constitution saving throw or be poisoned until the start of its next turn. On a successful saving throw, the creature is immune to the monster''s stench for 24 hours')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'd68056ce-3ce5-420d-8b4c-de862e865522', N'Light Sensitivity', N'', N'While in bright light, the monster has disadvantage on attack rolls, as well as on Wisdom (Perception) checks that rely on sight.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'e60a08c9-e1ca-4bbc-9660-dee6757a8e7f', N'Web Walker', N'', N'The monster ignores movement restrictions caused by webbing.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'4951cd97-c003-4bec-9624-df41a051ad82', N'Magic Weapons', N'', N'The monster''s weapons are magical')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'95810ae3-50ab-4b32-abd0-e8f5447143b7', N'Aggressive', N'Increase the monster''s effective per-round damage output by 2', N'As a bonus action, the monster can move up to its speed toward a hostile creature that it can see.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'd95de4d6-0343-4502-aae2-e94d9c5846d3', N'Enlarge', N'Increase the monster''s effective per-round damage by the amount noted in the trait', N'Recharges after a Short or Long Rest. For 1 minute, the monster magically increases in size, along with anything it is wearing or carrying. While enlarged, the monster is Large, doubles its damage dice on Strength-based weapon attacks, and makes Strength checks and Strength saving throws with advantage. If the monster lacks the room to become Large, it attains the maximum size possible in the space available .')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'599f94ac-6f75-454e-9a66-ea8f5385825d', N'Teleport', N'', N'The monster magically teleports, along with any equipment it is wearing or carrying, up to 120 feet to an unoccupied space it can see.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'de814fa5-9616-40b8-8e1f-eb3e503aff0a', N'Immutable Form', N'', N'The monster is immune to any spell or effect that would alter its form.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'770dd8f1-e33e-4700-ad8a-ebbf0494dd6c', N'Angelic Weapons', N'Increase the monster''s effective per-round damage by the amount noted in the trait', N'The monster''s weapon attacks are magical. When the monster hits with any weapon, the weapon deals an extra amount of damage.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'98bb740b-c6cf-4de0-9213-f45f6aff247a', N'Dive', N'Increase the monster''s effective per-round damage by the amount noted in the trait', N'If the monster is flying and dives at least 30 feet straight toward a target and then hits it with a melee weapon attack, the attack deals extra damage to the target.')
INSERT [dbo].[feature_lu_Feature] ([guid_feature], [name_Feature], [stat_modifier], [description_Feature]) VALUES (N'2b6271d3-fbaa-45bf-9838-fa138e9097f5', N'Spider Climb', N'', N'The monster can climb difficult surfaces, including upside down on ceilings, without needing to make an ability check.')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'6798d7f1-d779-437c-9c99-000031c5d30c', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'6798d7f1-d779-437c-9c99-000031c5d30c', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'f6d26cd6-f212-452b-a6f4-033cd3525d49', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'f6d26cd6-f212-452b-a6f4-033cd3525d49', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'8bb60024-59fa-46e0-921e-05f60dd26cdb', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'8bb60024-59fa-46e0-921e-05f60dd26cdb', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'b5f9abae-8b6e-43d0-b3c1-08b23907121a', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'b5f9abae-8b6e-43d0-b3c1-08b23907121a', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'd8e93c9d-4553-4ce1-b30b-14c5822e4b22', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'b997bbc4-0aed-4a32-acab-166134369f47', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'b997bbc4-0aed-4a32-acab-166134369f47', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'ac3179be-938e-4819-9098-2106abdbb429', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'ac3179be-938e-4819-9098-2106abdbb429', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'7faff7cc-8691-4b27-ae01-2606bafba93f', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'7faff7cc-8691-4b27-ae01-2606bafba93f', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'e58ab5bd-f7be-4989-bfd0-26840cf218f7', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'e58ab5bd-f7be-4989-bfd0-26840cf218f7', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'c5a8e3ba-b773-4ed2-ae74-27bdb5b3e0c0', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'a0e4ee68-87f0-433c-bfa6-2c834b382119', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'a0e4ee68-87f0-433c-bfa6-2c834b382119', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'9c3c55bc-5044-46e4-9bc4-3d2ebe317430', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'9c3c55bc-5044-46e4-9bc4-3d2ebe317430', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'6558423c-eb07-48dc-a694-3efdc36be41d', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'6558423c-eb07-48dc-a694-3efdc36be41d', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'32a77e7d-ade9-4461-8941-421809e379fc', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'32a77e7d-ade9-4461-8941-421809e379fc', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'fa7e2c4d-5fc6-41c1-83f6-442c7282950b', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'584e036f-f640-4e76-937a-57fb7c9aad41', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'584e036f-f640-4e76-937a-57fb7c9aad41', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'4fbabffc-b152-43cc-b361-5b03cb53c60d', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'4fbabffc-b152-43cc-b361-5b03cb53c60d', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'902e442e-5ac7-411a-9f77-6b8a12e58cdf', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'902e442e-5ac7-411a-9f77-6b8a12e58cdf', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'7a06f521-598d-4736-9c7f-6e4d87c77a05', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'7a06f521-598d-4736-9c7f-6e4d87c77a05', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'8caf6098-94d8-4d25-a19f-6edc5131d168', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'8caf6098-94d8-4d25-a19f-6edc5131d168', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'27de4a7f-8762-41d8-b6b9-6f1f1902de74', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'27de4a7f-8762-41d8-b6b9-6f1f1902de74', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'9bc8da1e-a396-46ae-8884-758b0676c05a', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'9bc8da1e-a396-46ae-8884-758b0676c05a', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'ce7a5f69-a0fa-4bc0-9568-7aee7cfa0cc4', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'5c50c90f-1fc0-4c89-85b6-7e5890c42d2a', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'2bd93716-3342-4160-891f-8cdbebdf885e', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'2bd93716-3342-4160-891f-8cdbebdf885e', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'c1926a33-4e10-4eee-b4f5-9e186e9b6cc8', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1, N'22e2f0ce-c357-4d4f-8668-bf4d85b3369c', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'22e2f0ce-c357-4d4f-8668-bf4d85b3369c', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'641fa88c-f7b3-4822-9136-d174b155e193', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'641fa88c-f7b3-4822-9136-d174b155e193', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'12a0ccf5-11c7-44f4-a44f-e7729ee11bba', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'12a0ccf5-11c7-44f4-a44f-e7729ee11bba', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'54d4a58f-d22d-4c49-b16c-f40979f55207', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'54d4a58f-d22d-4c49-b16c-f40979f55207', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'7205de9d-e02b-4c83-bbc0-f6ede21434f6', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'7205de9d-e02b-4c83-bbc0-f6ede21434f6', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.25, N'864ed2cf-5aea-45a7-add2-f7228ea1e3f3', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (1.5, N'864ed2cf-5aea-45a7-add2-f7228ea1e3f3', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'2a7b6a97-4784-452f-936e-ff44d2cbc3ba', N'2197b8e4-d5a4-462d-bbd1-33b29e4f9bf6')
INSERT [dbo].[hp_Protection_CR_Modifier] ([effective_HPModifier], [guid_CR], [guid_Protection]) VALUES (2, N'2a7b6a97-4784-452f-936e-ff44d2cbc3ba', N'78bc70a4-f0c3-4c6a-8745-b2b054099ce8')
INSERT [dbo].[mon_lu_Goodness] ([guid_Goodness], [name_Morality]) VALUES (N'50cc979c-1442-4938-8e35-2ec30adde6b4', N'Neutral')
INSERT [dbo].[mon_lu_Goodness] ([guid_Goodness], [name_Morality]) VALUES (N'800eb61f-dde0-495f-bc95-d334328d1a82', N'Evil')
INSERT [dbo].[mon_lu_Goodness] ([guid_Goodness], [name_Morality]) VALUES (N'8c71e0af-ba6a-4cd2-8769-f9288233252a', N'Good')
INSERT [dbo].[mon_lu_Lawfulness] ([guid_Lawfulness], [name_Lawfulness]) VALUES (N'464e7a1f-f891-4816-9924-0eba5980e544', N'Lawful')
INSERT [dbo].[mon_lu_Lawfulness] ([guid_Lawfulness], [name_Lawfulness]) VALUES (N'b55bfef1-aa91-42a1-86fe-6ede3a698a85', N'Neutral')
INSERT [dbo].[mon_lu_Lawfulness] ([guid_Lawfulness], [name_Lawfulness]) VALUES (N'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', N'Chaotic')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'68b1298e-1aab-43ec-aeb9-0ca086735378', N'Humanoid')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'c35a5d91-705e-4454-a4a1-1cd9d2fc49e2', N'Elemental')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'0f2028ab-892e-42c4-b1e6-232ce584ac88', N'Aberration')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'edb50140-b3f7-4ee9-9219-43b23e027b38', N'Giant')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'102e0311-6789-44b5-9540-682c3fe23f7e', N'Celestial')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'a18d12fa-ac21-4a2a-b263-71b5d24d13a2', N'Beast')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'75b43273-854c-47e0-b0ab-746ad75ba08e', N'Undead')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'ccb2668c-28d4-4692-b8d2-8324a0e2f60b', N'Fiend')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'f77010b5-9608-46e8-bdb6-83b84829e80f', N'Plant')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'6f4567af-dafc-44f3-b6e0-86669a5303f5', N'Dragon')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'29b80bad-aef0-43f1-baae-8e76849f42c9', N'Fey')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'e9bfa601-598d-4fcf-b502-91f0b284a994', N'Ooze')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'fcba4d7b-bc4f-4f59-950d-a06868362f64', N'Monstrosity')
INSERT [dbo].[mon_lu_Type] ([guid_Type], [name_Type]) VALUES (N'706b76b8-a5f8-44d4-a93d-fcf92d1ded7d', N'Construct')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'a2be9be6-b848-4981-b3ee-12ba0ed18baf', N'Lawful Evil', N'464e7a1f-f891-4816-9924-0eba5980e544', N'800eb61f-dde0-495f-bc95-d334328d1a82')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'5a88c224-a341-470a-a14c-29be5b0b086b', N'Neutral Good', N'b55bfef1-aa91-42a1-86fe-6ede3a698a85', N'8c71e0af-ba6a-4cd2-8769-f9288233252a')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'd7cf6701-c4aa-4317-b22e-2a15657f4617', N'Lawful Good', N'464e7a1f-f891-4816-9924-0eba5980e544', N'8c71e0af-ba6a-4cd2-8769-f9288233252a')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'3220825c-09a1-42b7-baed-3157392c5248', N'True Neutral', N'b55bfef1-aa91-42a1-86fe-6ede3a698a85', N'50cc979c-1442-4938-8e35-2ec30adde6b4')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'4ce16b80-7f50-4385-af3a-6433fbcee5bc', N'Chaotic Evil', N'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', N'800eb61f-dde0-495f-bc95-d334328d1a82')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'3f25ee9f-9cb3-4f1b-a8fc-a315ebda648b', N'Chaotic Good', N'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', N'8c71e0af-ba6a-4cd2-8769-f9288233252a')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'892edc67-d60d-4906-ae68-cbd01d293cae', N'Chaotic Neutral', N'd0f4ae17-7ae8-4ca7-9226-7096b3f63110', N'50cc979c-1442-4938-8e35-2ec30adde6b4')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'cff1fee0-17fc-4826-92ef-d3a1553287a8', N'Lawful Neutral', N'464e7a1f-f891-4816-9924-0eba5980e544', N'50cc979c-1442-4938-8e35-2ec30adde6b4')
INSERT [dbo].[mon_rl_Alignment] ([guid_Alignment], [name_alignment], [guid_Lawfulness], [guid_Goodness]) VALUES (N'c57508b3-8ef1-4d70-b85f-d96367874094', N'Neutral Evil', N'b55bfef1-aa91-42a1-86fe-6ede3a698a85', N'800eb61f-dde0-495f-bc95-d334328d1a82')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'2709fd0a-c030-4290-ba76-3d73e5477726', N'Radiant')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'99a54ee7-bd10-437c-b09a-468f9c98f301', N'Necrotic')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'Bludgeoning')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'92e7e998-feb1-4152-b744-6f0b416c3493', N'Slashing')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'3d7578c1-d5a9-433d-bbd8-76ab6166e6ea', N'Lightning')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'c265c3b8-b1b8-4cba-ab6d-8844fea83e9c', N'Cold')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'9620adc9-c1f8-43e3-900f-9a83c881291d', N'Fire')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'c89d508f-9557-46e2-b037-9c99d954e2cc', N'Poison')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'6e7cb455-5e2f-4419-a525-9f9f1fa7bf5c', N'Force')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'175fbca2-0919-47b6-88b7-ba1a22880a6d', N'Thunder')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'88018808-853f-41df-872a-c37df135a51d', N'Acid')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'Piercing')
INSERT [dbo].[weap_lu_DamageType] ([guid_DamageType], [name_DamageType]) VALUES (N'39500d27-976d-487d-baa0-eff64dcc7fbd', N'Psychic')
INSERT [dbo].[weap_lu_Size_WeaponDice] ([guid_Size], [size_die_Multiplier]) VALUES (N'a4d28780-e894-4d7a-b065-1cb00ee01d80', 1)
INSERT [dbo].[weap_lu_Size_WeaponDice] ([guid_Size], [size_die_Multiplier]) VALUES (N'5e6048f6-e0ec-4bb1-9065-2116230246ff', 4)
INSERT [dbo].[weap_lu_Size_WeaponDice] ([guid_Size], [size_die_Multiplier]) VALUES (N'2ef6d926-9d94-46d6-9f4d-6b14321d7d2e', 1)
INSERT [dbo].[weap_lu_Size_WeaponDice] ([guid_Size], [size_die_Multiplier]) VALUES (N'c64a7d4b-30cd-4eee-a276-dbbde28daa21', 1)
INSERT [dbo].[weap_lu_Size_WeaponDice] ([guid_Size], [size_die_Multiplier]) VALUES (N'5d0ff0c0-6053-476e-a423-df63946be45e', 2)
INSERT [dbo].[weap_lu_Size_WeaponDice] ([guid_Size], [size_die_Multiplier]) VALUES (N'a9404107-c146-4e4f-ac83-f1b5df09bed7', 3)
INSERT [dbo].[weap_lu_SkillRequired] ([guid_Skill], [name_SkillLevel]) VALUES (N'4c205a9f-503e-416a-92f0-9f598bbf7f15', N'Simple')
INSERT [dbo].[weap_lu_SkillRequired] ([guid_Skill], [name_SkillLevel]) VALUES (N'7104d202-4ca3-45d2-9c30-eb31894d3a52', N'Martial')
INSERT [dbo].[weap_lu_WeaponReach] ([guid_Reach], [name_Reach]) VALUES (N'2bd15ddb-2765-4433-8002-0fb80f1289bc', N'Ranged')
INSERT [dbo].[weap_lu_WeaponReach] ([guid_Reach], [name_Reach]) VALUES (N'434fb0a8-b9b7-4dda-acbc-984b12f2c9fd', N'Melee')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'e915bf4a-0b59-45e3-8086-074c874c4f7a', N'Reach')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'7359aa0d-2e9f-4f97-9ea5-126b09dd82b8', N'Ammunition (range 25/100)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'7a8be51f-f543-4942-9585-14fdec3fb04c', N'Ammunition (range 80/320)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'Heavy')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', N'Loading')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'2b40ddae-84e2-4e8a-b935-52384d3e82fd', N'Versitile (1d10)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'Thrown (range 20/60)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'ee72411c-44b2-49f0-94ce-7fa89bcd018f', N'Thrown (range 5/15)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'c44fd3ff-53ac-4317-87cc-8f260d95362d', N'Ammunition (range 100/400)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'Finesse')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'74dc2e9c-618f-4fbb-8ce7-98e1aff82989', N'Thrown (range 30/120)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'Light')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'fa6c7360-1928-4f89-a03f-c45641b26861', N'Ammunition (range 150/600)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'33104808-7332-49d7-8484-d22cc3c5f6bc', N'Special')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'Two-handed')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'ae941ebd-4a84-44ef-8909-d84351a125c9', N'Versitile (1d8)')
INSERT [dbo].[weap_lu_WeaponTrait] ([guid_Trait], [name_Trait]) VALUES (N'd68eaf40-d77b-43a1-94aa-f9583ce3b47c', N'Ammunition (range 30/120)')
INSERT [dbo].[weap_lu_WeaponType] ([guid_WeaponType], [guid_Skill], [guid_Reach], [name_weaponType]) VALUES (N'a1d546e2-6fef-4ea0-bee8-2e0b86931559', N'4c205a9f-503e-416a-92f0-9f598bbf7f15', N'2bd15ddb-2765-4433-8002-0fb80f1289bc', N'Simple Ranged')
INSERT [dbo].[weap_lu_WeaponType] ([guid_WeaponType], [guid_Skill], [guid_Reach], [name_weaponType]) VALUES (N'95a8beda-1efc-4b5f-aa66-346c93c5023d', N'4c205a9f-503e-416a-92f0-9f598bbf7f15', N'434fb0a8-b9b7-4dda-acbc-984b12f2c9fd', N'Simple Melee')
INSERT [dbo].[weap_lu_WeaponType] ([guid_WeaponType], [guid_Skill], [guid_Reach], [name_weaponType]) VALUES (N'93f486b6-c2a0-40d1-9da4-63cad316b763', N'7104d202-4ca3-45d2-9c30-eb31894d3a52', N'2bd15ddb-2765-4433-8002-0fb80f1289bc', N'Martial Ranged')
INSERT [dbo].[weap_lu_WeaponType] ([guid_WeaponType], [guid_Skill], [guid_Reach], [name_weaponType]) VALUES (N'fab735a6-8c18-486a-a058-c6bf42884512', N'7104d202-4ca3-45d2-9c30-eb31894d3a52', N'434fb0a8-b9b7-4dda-acbc-984b12f2c9fd', N'Martial Melee')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'fd25a437-79b3-47ce-b7a0-04b7aa40c061')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'1cfcd5a0-60df-43c5-99c8-152caeb08a6c')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'6e439074-d840-4ef7-a61b-1bb8402f3a9d')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'15e826d7-591d-4550-979b-25df20fec7a7')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'cbcdb66c-2985-40a7-a4f2-317d3b10e224')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'1af9dba1-261f-47a0-ae91-349766bb5846')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'd900f107-d4f5-48cb-b23f-3ea977f4502b')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'9f49f128-f692-4f76-84de-53a32db82b3c')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'f6953406-2767-4c4d-9c6b-597344b8162f')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'80e1e0f5-70e3-4eb6-897d-59ae929539a1')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'3a1accd9-9305-4501-ae82-6211b36f96d8')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'349c6055-11fb-4100-9fef-68328cb14d2a')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'c6fa2adf-1887-433b-9ee9-71a296a4fc1e')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'a9b8343d-ae8f-4bc7-baf5-74c36fe5cfa3')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'7dab5339-bc4c-4141-b5e6-7d3f420d6396')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'ebf21478-2150-4d74-a547-a1bd7001106f')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'a30ecf65-6cdc-4133-a9d5-a29feb674d9b')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'8786c3e4-1169-4132-8389-a9471318003c')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'82a08381-8847-4362-a221-ae01fb9a5f3e')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'61978a5d-c69e-4466-9048-be0c50abf97f')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'5a2fb915-4d8c-4a25-b3dd-d029d9266219')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'6569316a-fc7a-40e6-b93e-d72d28d92aa0')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'02de9c62-da40-499b-9a76-da49ad8eeb0d')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'30039481-56bb-4ec4-a578-de7289d634ae')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'33eb22b3-67e6-42f4-954b-e473840826b2')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'5c6241a0-716a-430a-8854-f7b5c8ce74e8')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'd27ab717-2f71-4b66-b67d-f86822b630db')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'fa1e2ba9-e0b0-4cef-bfda-4b2fac5caee9', N'be84879a-bc83-4746-90fe-fe4c413fdb76')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'4c82364c-f6e6-492d-8f59-22579051aa8c')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'613297ea-ac74-40ef-bd79-2c3ad858a9f2')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'f3496bec-3de1-453b-b0e6-317f99401ecd')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'4d49c0b3-53ba-47f5-9c61-5d3da6c6f375')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'349c6055-11fb-4100-9fef-68328cb14d2a')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'6c318ddd-2dc2-4e5d-87d1-9621afdadf02')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'5a2fb915-4d8c-4a25-b3dd-d029d9266219')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'02de9c62-da40-499b-9a76-da49ad8eeb0d')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'8c558f4c-f4a9-4cd5-a52a-de21a9009154')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'0e337194-078c-4f99-a339-e7e311a2bdc4')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'd27ab717-2f71-4b66-b67d-f86822b630db')
INSERT [dbo].[weap_rl_Weapon_AbilityScore] ([guid_AbilityScore], [guid_Weapon]) VALUES (N'6c49abc6-06f1-436a-a046-f50e9cc93808', N'be84879a-bc83-4746-90fe-fe4c413fdb76')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'e915bf4a-0b59-45e3-8086-074c874c4f7a', N'58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'e915bf4a-0b59-45e3-8086-074c874c4f7a', N'7dab5339-bc4c-4141-b5e6-7d3f420d6396')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'e915bf4a-0b59-45e3-8086-074c874c4f7a', N'a30ecf65-6cdc-4133-a9d5-a29feb674d9b')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'e915bf4a-0b59-45e3-8086-074c874c4f7a', N'61978a5d-c69e-4466-9048-be0c50abf97f')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'e915bf4a-0b59-45e3-8086-074c874c4f7a', N'5a2fb915-4d8c-4a25-b3dd-d029d9266219')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7359aa0d-2e9f-4f97-9ea5-126b09dd82b8', N'8c558f4c-f4a9-4cd5-a52a-de21a9009154')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7a8be51f-f543-4942-9585-14fdec3fb04c', N'4c82364c-f6e6-492d-8f59-22579051aa8c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7a8be51f-f543-4942-9585-14fdec3fb04c', N'f3496bec-3de1-453b-b0e6-317f99401ecd')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'9f49f128-f692-4f76-84de-53a32db82b3c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'80e1e0f5-70e3-4eb6-897d-59ae929539a1')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'4d49c0b3-53ba-47f5-9c61-5d3da6c6f375')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'7dab5339-bc4c-4141-b5e6-7d3f420d6396')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'6c318ddd-2dc2-4e5d-87d1-9621afdadf02')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'a30ecf65-6cdc-4133-a9d5-a29feb674d9b')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'8ced51fc-d785-40f7-8d88-2cbd93939634', N'8786c3e4-1169-4132-8389-a9471318003c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', N'f3496bec-3de1-453b-b0e6-317f99401ecd')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', N'6c318ddd-2dc2-4e5d-87d1-9621afdadf02')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', N'8c558f4c-f4a9-4cd5-a52a-de21a9009154')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'b7d7d12b-4a5a-47bb-97ca-46d9d415ef85', N'0e337194-078c-4f99-a339-e7e311a2bdc4')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'2b40ddae-84e2-4e8a-b935-52384d3e82fd', N'15e826d7-591d-4550-979b-25df20fec7a7')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'2b40ddae-84e2-4e8a-b935-52384d3e82fd', N'1af9dba1-261f-47a0-ae91-349766bb5846')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'2b40ddae-84e2-4e8a-b935-52384d3e82fd', N'f6953406-2767-4c4d-9c6b-597344b8162f')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'fd25a437-79b3-47ce-b7a0-04b7aa40c061')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'3a1accd9-9305-4501-ae82-6211b36f96d8')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'82a08381-8847-4362-a221-ae01fb9a5f3e')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'02de9c62-da40-499b-9a76-da49ad8eeb0d')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd9e00792-a5cc-4136-b9ba-650c19b4af67', N'5c6241a0-716a-430a-8854-f7b5c8ce74e8')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'ee72411c-44b2-49f0-94ce-7fa89bcd018f', N'1cfcd5a0-60df-43c5-99c8-152caeb08a6c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'c44fd3ff-53ac-4317-87cc-8f260d95362d', N'6c318ddd-2dc2-4e5d-87d1-9621afdadf02')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'349c6055-11fb-4100-9fef-68328cb14d2a')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'5a2fb915-4d8c-4a25-b3dd-d029d9266219')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'02de9c62-da40-499b-9a76-da49ad8eeb0d')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'd27ab717-2f71-4b66-b67d-f86822b630db')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'a8075fec-9f18-4f66-bf36-962eedee2fb6', N'be84879a-bc83-4746-90fe-fe4c413fdb76')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'74dc2e9c-618f-4fbb-8ce7-98e1aff82989', N'6e439074-d840-4ef7-a61b-1bb8402f3a9d')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'd900f107-d4f5-48cb-b23f-3ea977f4502b')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'3a1accd9-9305-4501-ae82-6211b36f96d8')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'349c6055-11fb-4100-9fef-68328cb14d2a')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'33eb22b3-67e6-42f4-954b-e473840826b2')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'0e337194-078c-4f99-a339-e7e311a2bdc4')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'5c6241a0-716a-430a-8854-f7b5c8ce74e8')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7e3888e5-4326-4c30-be4f-9c6e631b350a', N'd27ab717-2f71-4b66-b67d-f86822b630db')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'fa6c7360-1928-4f89-a03f-c45641b26861', N'4d49c0b3-53ba-47f5-9c61-5d3da6c6f375')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'33104808-7332-49d7-8484-d22cc3c5f6bc', N'1cfcd5a0-60df-43c5-99c8-152caeb08a6c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'33104808-7332-49d7-8484-d22cc3c5f6bc', N'61978a5d-c69e-4466-9048-be0c50abf97f')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'4c82364c-f6e6-492d-8f59-22579051aa8c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'f3496bec-3de1-453b-b0e6-317f99401ecd')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'9f49f128-f692-4f76-84de-53a32db82b3c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'80e1e0f5-70e3-4eb6-897d-59ae929539a1')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'4d49c0b3-53ba-47f5-9c61-5d3da6c6f375')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'7dab5339-bc4c-4141-b5e6-7d3f420d6396')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'6c318ddd-2dc2-4e5d-87d1-9621afdadf02')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'ebf21478-2150-4d74-a547-a1bd7001106f')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'a30ecf65-6cdc-4133-a9d5-a29feb674d9b')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'7ad0cb0d-b422-45a2-9d9d-d60ac66bf5b5', N'8786c3e4-1169-4132-8389-a9471318003c')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'ae941ebd-4a84-44ef-8909-d84351a125c9', N'fd25a437-79b3-47ce-b7a0-04b7aa40c061')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'ae941ebd-4a84-44ef-8909-d84351a125c9', N'c6fa2adf-1887-433b-9ee9-71a296a4fc1e')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'ae941ebd-4a84-44ef-8909-d84351a125c9', N'82a08381-8847-4362-a221-ae01fb9a5f3e')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd68eaf40-d77b-43a1-94aa-f9583ce3b47c', N'613297ea-ac74-40ef-bd79-2c3ad858a9f2')
INSERT [dbo].[weap_rl_Weapon_WeaponTrait] ([guid_Trait], [guid_Weapon]) VALUES (N'd68eaf40-d77b-43a1-94aa-f9583ce3b47c', N'0e337194-078c-4f99-a339-e7e311a2bdc4')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'fd25a437-79b3-47ce-b7a0-04b7aa40c061', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Spear')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'1cfcd5a0-60df-43c5-99c8-152caeb08a6c', NULL, NULL, N'93f486b6-c2a0-40d1-9da4-63cad316b763', 0, N'Net')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'58c31b7b-c0d9-41ba-8e9e-187c8fbf76c0', N'e01bf86f-0ff3-4cf7-897f-a185afb33c54', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Pike')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'6e439074-d840-4ef7-a61b-1bb8402f3a9d', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Javelin')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'4c82364c-f6e6-492d-8f59-22579051aa8c', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, N'Shortbow')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'15e826d7-591d-4550-979b-25df20fec7a7', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Warhammer')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'613297ea-ac74-40ef-bd79-2c3ad858a9f2', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, N'Sling')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'6dfc7b00-5ca9-45d7-8ca9-2cc6cd7ebecb', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Dagger')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'cbcdb66c-2985-40a7-a4f2-317d3b10e224', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Mace')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'f3496bec-3de1-453b-b0e6-317f99401ecd', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, N'Crossbow, Light')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'1af9dba1-261f-47a0-ae91-349766bb5846', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Longsword')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'd900f107-d4f5-48cb-b23f-3ea977f4502b', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Club')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'9f49f128-f692-4f76-84de-53a32db82b3c', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'fab735a6-8c18-486a-a058-c6bf42884512', 2, N'Maul')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'f6953406-2767-4c4d-9c6b-597344b8162f', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Battleaxe')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'80e1e0f5-70e3-4eb6-897d-59ae929539a1', N'c4d1ecfa-f454-45cf-be70-cf784baf834f', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Greataxe')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'4d49c0b3-53ba-47f5-9c61-5d3da6c6f375', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'93f486b6-c2a0-40d1-9da4-63cad316b763', 1, N'Longbow')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'3a1accd9-9305-4501-ae82-6211b36f96d8', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Light Hammer')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'349c6055-11fb-4100-9fef-68328cb14d2a', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Shortsword')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'c6fa2adf-1887-433b-9ee9-71a296a4fc1e', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Quarterstaff')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'a9b8343d-ae8f-4bc7-baf5-74c36fe5cfa3', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Flail')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'7dab5339-bc4c-4141-b5e6-7d3f420d6396', N'e01bf86f-0ff3-4cf7-897f-a185afb33c54', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Halberd')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'6c318ddd-2dc2-4e5d-87d1-9621afdadf02', N'e01bf86f-0ff3-4cf7-897f-a185afb33c54', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'93f486b6-c2a0-40d1-9da4-63cad316b763', 1, N'Crossbow, heavy')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'ebf21478-2150-4d74-a547-a1bd7001106f', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'3a1a49f6-88dc-4d72-98ad-50a513efccec', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Greatclub')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'a30ecf65-6cdc-4133-a9d5-a29feb674d9b', N'e01bf86f-0ff3-4cf7-897f-a185afb33c54', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Glaive')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'8786c3e4-1169-4132-8389-a9471318003c', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 2, N'Greatsword')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'82a08381-8847-4362-a221-ae01fb9a5f3e', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Trident')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'61978a5d-c69e-4466-9048-be0c50abf97f', N'c4d1ecfa-f454-45cf-be70-cf784baf834f', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Lance')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'5a2fb915-4d8c-4a25-b3dd-d029d9266219', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Whip')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'6569316a-fc7a-40e6-b93e-d72d28d92aa0', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Morningstar')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'02de9c62-da40-499b-9a76-da49ad8eeb0d', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'a1d546e2-6fef-4ea0-bee8-2e0b86931559', 1, N'Dart')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'8c558f4c-f4a9-4cd5-a52a-de21a9009154', N'bd31d66d-3731-45bb-88b2-dbf1acfa6e98', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'93f486b6-c2a0-40d1-9da4-63cad316b763', 1, N'Blowgun')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'30039481-56bb-4ec4-a578-de7289d634ae', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'War Pick')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'33eb22b3-67e6-42f4-954b-e473840826b2', N'1ff5257c-1568-49c1-a656-088b4884efc0', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Sickle')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'0e337194-078c-4f99-a339-e7e311a2bdc4', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'93f486b6-c2a0-40d1-9da4-63cad316b763', 1, N'Crossbow, hand')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'5c6241a0-716a-430a-8854-f7b5c8ce74e8', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'95a8beda-1efc-4b5f-aa66-346c93c5023d', 1, N'Handaxe')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'd27ab717-2f71-4b66-b67d-f86822b630db', N'04c5e5d5-fe76-4dfe-b4bb-a0c26e914307', N'92e7e998-feb1-4152-b744-6f0b416c3493', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Scimitar')
INSERT [dbo].[weap_Weapon] ([guid_Weapon], [guid_Die], [guid_DamageType], [guid_WeaponType], [number_DamageDice], [name_weapon]) VALUES (N'be84879a-bc83-4746-90fe-fe4c413fdb76', N'32fb76a6-a39a-4bb7-b761-48b96bf0f3a8', N'fb41f73b-deef-4cf8-b0ad-dc952284c234', N'fab735a6-8c18-486a-a058-c6bf42884512', 1, N'Rapier')
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__dice_Dic__0957E246B853EAD1]    Script Date: 1/24/2018 7:11:04 AM ******/
ALTER TABLE [dbo].[dice_Dice] ADD UNIQUE NONCLUSTERED 
(
	[name_Die] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[arm_Armor]  WITH NOCHECK ADD  CONSTRAINT [FK_arm_Armor_arm_lu_ArmorType] FOREIGN KEY([guid_ArmorType])
REFERENCES [dbo].[arm_lu_ArmorType] ([guid_ArmorType])
GO
ALTER TABLE [dbo].[arm_Armor] CHECK CONSTRAINT [FK_arm_Armor_arm_lu_ArmorType]
GO
ALTER TABLE [dbo].[arm_rl_ACModifier]  WITH NOCHECK ADD  CONSTRAINT [FK__arm_rl_AC__guid___54CB950F] FOREIGN KEY([guid_AbilityScore])
REFERENCES [dbo].[com_AbilityScore] ([guid_AbilityScore])
GO
ALTER TABLE [dbo].[arm_rl_ACModifier] CHECK CONSTRAINT [FK__arm_rl_AC__guid___54CB950F]
GO
ALTER TABLE [dbo].[arm_rl_ACModifier]  WITH NOCHECK ADD  CONSTRAINT [FK__arm_rl_AC__guid___55BFB948] FOREIGN KEY([guid_Armor])
REFERENCES [dbo].[arm_Armor] ([guid_Armor])
GO
ALTER TABLE [dbo].[arm_rl_ACModifier] CHECK CONSTRAINT [FK__arm_rl_AC__guid___55BFB948]
GO
ALTER TABLE [dbo].[com_lu_ArmorClass]  WITH NOCHECK ADD  CONSTRAINT [FK__com_lu_Ar__guid___56E8E7AB] FOREIGN KEY([guid_CR])
REFERENCES [dbo].[com_CR] ([guid_CR])
GO
ALTER TABLE [dbo].[com_lu_ArmorClass] CHECK CONSTRAINT [FK__com_lu_Ar__guid___56E8E7AB]
GO
ALTER TABLE [dbo].[com_rl_AbilityScore_Skill]  WITH NOCHECK ADD  CONSTRAINT [FK__com_rl_Ab__guid___6CD828CA] FOREIGN KEY([guid_AbilityScore])
REFERENCES [dbo].[com_AbilityScore] ([guid_AbilityScore])
GO
ALTER TABLE [dbo].[com_rl_AbilityScore_Skill] CHECK CONSTRAINT [FK__com_rl_Ab__guid___6CD828CA]
GO
ALTER TABLE [dbo].[com_rl_AbilityScore_Skill]  WITH NOCHECK ADD FOREIGN KEY([guid_skill])
REFERENCES [dbo].[com_lu_Skill] ([guid_skill])
GO
ALTER TABLE [dbo].[com_rl_Monster_AbilityScore]  WITH NOCHECK ADD  CONSTRAINT [FK__com_rl_Mo__guid___05A3D694] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[com_rl_Monster_AbilityScore] CHECK CONSTRAINT [FK__com_rl_Mo__guid___05A3D694]
GO
ALTER TABLE [dbo].[com_rl_Monster_AbilityScore]  WITH NOCHECK ADD  CONSTRAINT [FK__com_rl_Mo__guid___0697FACD] FOREIGN KEY([guid_AbilityScore])
REFERENCES [dbo].[com_AbilityScore] ([guid_AbilityScore])
GO
ALTER TABLE [dbo].[com_rl_Monster_AbilityScore] CHECK CONSTRAINT [FK__com_rl_Mo__guid___0697FACD]
GO
ALTER TABLE [dbo].[com_rl_Monster_AbilityScore]  WITH NOCHECK ADD FOREIGN KEY([value_AbilityScore])
REFERENCES [dbo].[com_rl_AbilityScore_Modifier] ([value_AbilityScore])
GO
ALTER TABLE [dbo].[com_rl_Monster_Language]  WITH NOCHECK ADD  CONSTRAINT [FK__com_rl_Mo__guid___0E391C95] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[com_rl_Monster_Language] CHECK CONSTRAINT [FK__com_rl_Mo__guid___0E391C95]
GO
ALTER TABLE [dbo].[com_rl_Monster_Language]  WITH NOCHECK ADD FOREIGN KEY([guid_Language])
REFERENCES [dbo].[com_Language] ([guid_Language])
GO
ALTER TABLE [dbo].[com_Size]  WITH NOCHECK ADD FOREIGN KEY([guid_Die])
REFERENCES [dbo].[dice_Dice] ([guid_Die])
GO
ALTER TABLE [dbo].[core_lu_CR_Proficiency]  WITH NOCHECK ADD  CONSTRAINT [FK__core_lu_C__guid___5F7E2DAC] FOREIGN KEY([guid_CR])
REFERENCES [dbo].[com_CR] ([guid_CR])
GO
ALTER TABLE [dbo].[core_lu_CR_Proficiency] CHECK CONSTRAINT [FK__core_lu_C__guid___5F7E2DAC]
GO
ALTER TABLE [dbo].[core_lu_Defensive_Values]  WITH NOCHECK ADD  CONSTRAINT [FK__core_lu_D__guid___59C55456] FOREIGN KEY([guid_CR])
REFERENCES [dbo].[com_CR] ([guid_CR])
GO
ALTER TABLE [dbo].[core_lu_Defensive_Values] CHECK CONSTRAINT [FK__core_lu_D__guid___59C55456]
GO
ALTER TABLE [dbo].[core_lu_Offensive_Values]  WITH NOCHECK ADD  CONSTRAINT [FK__core_lu_O__guid___5CA1C101] FOREIGN KEY([guid_CR])
REFERENCES [dbo].[com_CR] ([guid_CR])
GO
ALTER TABLE [dbo].[core_lu_Offensive_Values] CHECK CONSTRAINT [FK__core_lu_O__guid___5CA1C101]
GO
ALTER TABLE [dbo].[custom_Attack_Dice]  WITH NOCHECK ADD FOREIGN KEY([guid_Die])
REFERENCES [dbo].[dice_Dice] ([guid_Die])
GO
ALTER TABLE [dbo].[custom_Attack_Dice]  WITH NOCHECK ADD FOREIGN KEY([guid_Custom_Attack])
REFERENCES [dbo].[custom_Weapon_Attack] ([guid_Custom_Attack])
GO
ALTER TABLE [dbo].[custom_Weapon_Attack]  WITH NOCHECK ADD FOREIGN KEY([guid_DamageType])
REFERENCES [dbo].[weap_lu_DamageType] ([guid_DamageType])
GO
ALTER TABLE [dbo].[custom_Weapon_Attack]  WITH NOCHECK ADD  CONSTRAINT [FK__custom_We__guid___634EBE90] FOREIGN KEY([guid_AbilityScore])
REFERENCES [dbo].[com_AbilityScore] ([guid_AbilityScore])
GO
ALTER TABLE [dbo].[custom_Weapon_Attack] CHECK CONSTRAINT [FK__custom_We__guid___634EBE90]
GO
ALTER TABLE [dbo].[feature_rl_Monster_Feature]  WITH NOCHECK ADD  CONSTRAINT [FK__feature_r__guid___0A688BB1] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[feature_rl_Monster_Feature] CHECK CONSTRAINT [FK__feature_r__guid___0A688BB1]
GO
ALTER TABLE [dbo].[feature_rl_Monster_Feature]  WITH NOCHECK ADD  CONSTRAINT [FK__feature_r__guid___0B5CAFEA] FOREIGN KEY([guid_Feature])
REFERENCES [dbo].[feature_lu_Feature] ([guid_feature])
GO
ALTER TABLE [dbo].[feature_rl_Monster_Feature] CHECK CONSTRAINT [FK__feature_r__guid___0B5CAFEA]
GO
ALTER TABLE [dbo].[hp_Protection_CR_Modifier]  WITH NOCHECK ADD  CONSTRAINT [FK__hp_Protec__guid___498EEC8D] FOREIGN KEY([guid_CR])
REFERENCES [dbo].[com_CR] ([guid_CR])
GO
ALTER TABLE [dbo].[hp_Protection_CR_Modifier] CHECK CONSTRAINT [FK__hp_Protec__guid___498EEC8D]
GO
ALTER TABLE [dbo].[hp_Protection_CR_Modifier]  WITH NOCHECK ADD FOREIGN KEY([guid_Protection])
REFERENCES [dbo].[com_ProtectionFromDamage] ([guid_Protection])
GO
ALTER TABLE [dbo].[mon_Monster]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_Monst__guid___00DF2177] FOREIGN KEY([guid_Alignment])
REFERENCES [dbo].[mon_rl_Alignment] ([guid_Alignment])
GO
ALTER TABLE [dbo].[mon_Monster] CHECK CONSTRAINT [FK__mon_Monst__guid___00DF2177]
GO
ALTER TABLE [dbo].[mon_Monster]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_Monst__guid___01D345B0] FOREIGN KEY([guid_Type])
REFERENCES [dbo].[mon_lu_Type] ([guid_Type])
GO
ALTER TABLE [dbo].[mon_Monster] CHECK CONSTRAINT [FK__mon_Monst__guid___01D345B0]
GO
ALTER TABLE [dbo].[mon_Monster]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_Monst__guid___02C769E9] FOREIGN KEY([guid_CR])
REFERENCES [dbo].[com_CR] ([guid_CR])
GO
ALTER TABLE [dbo].[mon_Monster] CHECK CONSTRAINT [FK__mon_Monst__guid___02C769E9]
GO
ALTER TABLE [dbo].[mon_Monster]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_Monst__guid___7FEAFD3E] FOREIGN KEY([guid_Size])
REFERENCES [dbo].[com_Size] ([guid_Size])
GO
ALTER TABLE [dbo].[mon_Monster] CHECK CONSTRAINT [FK__mon_Monst__guid___7FEAFD3E]
GO
ALTER TABLE [dbo].[mon_rl_Alignment]  WITH NOCHECK ADD FOREIGN KEY([guid_Lawfulness])
REFERENCES [dbo].[mon_lu_Lawfulness] ([guid_Lawfulness])
GO
ALTER TABLE [dbo].[mon_rl_Alignment]  WITH NOCHECK ADD FOREIGN KEY([guid_Goodness])
REFERENCES [dbo].[mon_lu_Goodness] ([guid_Goodness])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Armor]  WITH NOCHECK ADD  CONSTRAINT [FK__arm_rl_Mo__guid___1209AD79] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Armor] CHECK CONSTRAINT [FK__arm_rl_Mo__guid___1209AD79]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Armor]  WITH NOCHECK ADD  CONSTRAINT [FK__arm_rl_Mo__guid___12FDD1B2] FOREIGN KEY([guid_Shield])
REFERENCES [dbo].[arm_Shield] ([guid_Shield])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Armor] CHECK CONSTRAINT [FK__arm_rl_Mo__guid___12FDD1B2]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Armor]  WITH NOCHECK ADD  CONSTRAINT [FK__arm_rl_Mo__guid___13F1F5EB] FOREIGN KEY([guid_Armor])
REFERENCES [dbo].[arm_Armor] ([guid_Armor])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Armor] CHECK CONSTRAINT [FK__arm_rl_Mo__guid___13F1F5EB]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Movement]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_rl_Mo__guid___1975C517] FOREIGN KEY([guid_monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Movement] CHECK CONSTRAINT [FK__mon_rl_Mo__guid___1975C517]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Movement]  WITH NOCHECK ADD FOREIGN KEY([guid_Movement])
REFERENCES [dbo].[com_lu_Movement] ([guid_Movement])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Senses]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_rl_Mo__guid___15A53433] FOREIGN KEY([guid_monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Senses] CHECK CONSTRAINT [FK__mon_rl_Mo__guid___15A53433]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Senses]  WITH NOCHECK ADD FOREIGN KEY([guid_Sense])
REFERENCES [dbo].[com_lu_Senses] ([guid_Sense])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Skill]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_rl_Mo__guid___1F63A897] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Skill] CHECK CONSTRAINT [FK__mon_rl_Mo__guid___1F63A897]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Skill]  WITH NOCHECK ADD FOREIGN KEY([guid_skill])
REFERENCES [dbo].[com_lu_Skill] ([guid_skill])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Weapon]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_rl_Mo__guid___1B9317B3] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Weapon] CHECK CONSTRAINT [FK__mon_rl_Mo__guid___1B9317B3]
GO
ALTER TABLE [dbo].[mon_rl_Monster_Weapon]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_rl_Mo__guid___1C873BEC] FOREIGN KEY([guid_Weapon])
REFERENCES [dbo].[weap_Weapon] ([guid_Weapon])
GO
ALTER TABLE [dbo].[mon_rl_Monster_Weapon] CHECK CONSTRAINT [FK__mon_rl_Mo__guid___1C873BEC]
GO
ALTER TABLE [dbo].[mon_rl_Protection]  WITH NOCHECK ADD FOREIGN KEY([guid_DamageType])
REFERENCES [dbo].[weap_lu_DamageType] ([guid_DamageType])
GO
ALTER TABLE [dbo].[mon_rl_Protection]  WITH NOCHECK ADD  CONSTRAINT [FK__mon_rl_Pr__guid___17C286CF] FOREIGN KEY([guid_Monster])
REFERENCES [dbo].[mon_Monster] ([guid_Monster])
GO
ALTER TABLE [dbo].[mon_rl_Protection] CHECK CONSTRAINT [FK__mon_rl_Pr__guid___17C286CF]
GO
ALTER TABLE [dbo].[mon_rl_Protection]  WITH NOCHECK ADD FOREIGN KEY([guid_Protection])
REFERENCES [dbo].[com_ProtectionFromDamage] ([guid_Protection])
GO
ALTER TABLE [dbo].[weap_lu_Size_WeaponDice]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_lu_S__guid___7D0E9093] FOREIGN KEY([guid_Size])
REFERENCES [dbo].[com_Size] ([guid_Size])
GO
ALTER TABLE [dbo].[weap_lu_Size_WeaponDice] CHECK CONSTRAINT [FK__weap_lu_S__guid___7D0E9093]
GO
ALTER TABLE [dbo].[weap_lu_WeaponType]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_lu_W__guid___51300E55] FOREIGN KEY([guid_Skill])
REFERENCES [dbo].[weap_lu_SkillRequired] ([guid_Skill])
GO
ALTER TABLE [dbo].[weap_lu_WeaponType] CHECK CONSTRAINT [FK__weap_lu_W__guid___51300E55]
GO
ALTER TABLE [dbo].[weap_lu_WeaponType]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_lu_W__guid___5224328E] FOREIGN KEY([guid_Reach])
REFERENCES [dbo].[weap_lu_WeaponReach] ([guid_Reach])
GO
ALTER TABLE [dbo].[weap_lu_WeaponType] CHECK CONSTRAINT [FK__weap_lu_W__guid___5224328E]
GO
ALTER TABLE [dbo].[weap_rl_Weapon_AbilityScore]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_rl_W__guid___793DFFAF] FOREIGN KEY([guid_AbilityScore])
REFERENCES [dbo].[com_AbilityScore] ([guid_AbilityScore])
GO
ALTER TABLE [dbo].[weap_rl_Weapon_AbilityScore] CHECK CONSTRAINT [FK__weap_rl_W__guid___793DFFAF]
GO
ALTER TABLE [dbo].[weap_rl_Weapon_AbilityScore]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_rl_W__guid___7A3223E8] FOREIGN KEY([guid_Weapon])
REFERENCES [dbo].[weap_Weapon] ([guid_Weapon])
GO
ALTER TABLE [dbo].[weap_rl_Weapon_AbilityScore] CHECK CONSTRAINT [FK__weap_rl_W__guid___7A3223E8]
GO
ALTER TABLE [dbo].[weap_rl_Weapon_WeaponTrait]  WITH NOCHECK ADD FOREIGN KEY([guid_Trait])
REFERENCES [dbo].[weap_lu_WeaponTrait] ([guid_Trait])
GO
ALTER TABLE [dbo].[weap_rl_Weapon_WeaponTrait]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_rl_W__guid___76619304] FOREIGN KEY([guid_Weapon])
REFERENCES [dbo].[weap_Weapon] ([guid_Weapon])
GO
ALTER TABLE [dbo].[weap_rl_Weapon_WeaponTrait] CHECK CONSTRAINT [FK__weap_rl_W__guid___76619304]
GO
ALTER TABLE [dbo].[weap_Weapon]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_Weap__guid___70A8B9AE] FOREIGN KEY([guid_Die])
REFERENCES [dbo].[dice_Dice] ([guid_Die])
GO
ALTER TABLE [dbo].[weap_Weapon] CHECK CONSTRAINT [FK__weap_Weap__guid___70A8B9AE]
GO
ALTER TABLE [dbo].[weap_Weapon]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_Weap__guid___719CDDE7] FOREIGN KEY([guid_DamageType])
REFERENCES [dbo].[weap_lu_DamageType] ([guid_DamageType])
GO
ALTER TABLE [dbo].[weap_Weapon] CHECK CONSTRAINT [FK__weap_Weap__guid___719CDDE7]
GO
ALTER TABLE [dbo].[weap_Weapon]  WITH NOCHECK ADD  CONSTRAINT [FK__weap_Weap__guid___72910220] FOREIGN KEY([guid_WeaponType])
REFERENCES [dbo].[weap_lu_WeaponType] ([guid_WeaponType])
GO
ALTER TABLE [dbo].[weap_Weapon] CHECK CONSTRAINT [FK__weap_Weap__guid___72910220]
GO
/****** Object:  StoredProcedure [dbo].[calculate_Basic_Attack_Routine]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Calculate attack routine for basic weapon attack
-- =============================================
CREATE PROCEDURE [dbo].[calculate_Basic_Attack_Routine]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    print 'let''s do it'


END

GO
/****** Object:  StoredProcedure [dbo].[create_New_Monster]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azgara Shathur
-- Create date: 20170901
-- Description:	Create new monster
-- =============================================
CREATE PROCEDURE [dbo].[create_New_Monster]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --declare @sid_member table (sid_member uniqueidentifier)

	insert into mon_Monster (
		guid_Monster
	)
	output inserted.guid_Monster
	select 
		newid()
		

END

GO
/****** Object:  StoredProcedure [dbo].[delete_Monster_Feature]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170911
-- Description:	Remove a monster's feature
-- =============================================
CREATE PROCEDURE [dbo].[delete_Monster_Feature]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier,
	@guid_feature uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete rmf
	from feature_rl_Monster_Feature rmf
	where guid_Monster = @guid_monster
		and guid_Feature = @guid_feature

	select 
		name_Feature,
		description_Feature,
		stat_modifier
	from feature_lu_Feature f
	join feature_rl_Monster_Feature rmf
		on f.guid_feature = rmf.guid_Feature
		and rmf.guid_Feature = @guid_feature
	where guid_Monster = @guid_monster
		
END

GO
/****** Object:  StoredProcedure [dbo].[get_All_Features]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Gets all features for display
-- =============================================
CREATE PROCEDURE [dbo].[get_All_Features]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select *
	from feature_lu_Feature
	order by name_Feature

END

GO
/****** Object:  StoredProcedure [dbo].[get_Basic_CR_data]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Gets CR data to populate drop-down menu
-- =============================================
CREATE PROCEDURE [dbo].[get_Basic_CR_data]
	-- None
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
		guid_CR,
		name_CR,
		experience_Points
	from com_CR
	order by rank_CR

END

GO
/****** Object:  StoredProcedure [dbo].[get_Best_AbilityScore_By_Weapon]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Gets the best ability score for a chosen weapon, used to build up the attack routine
--				for a standard weapon attack
-- =============================================
CREATE PROCEDURE [dbo].[get_Best_AbilityScore_By_Weapon]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier, 
	@guid_weapon uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
		score.guid_AbilityScore,
		score.name_AbilityScore,
		mas.value_AbilityScore,
		asm.value_AbilityScore_Modifier
	from com_rl_Monster_AbilityScore mas
	join com_rl_AbilityScore_Modifier asm
		on mas.value_AbilityScore = asm.value_AbilityScore
	join com_AbilityScore score
		on score.guid_AbilityScore = mas.guid_AbilityScore
	join weap_rl_Weapon_AbilityScore was
		on was.guid_AbilityScore = score.guid_AbilityScore
	where was.guid_Weapon = @guid_weapon

END

GO
/****** Object:  StoredProcedure [dbo].[get_Monster_Features]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Get all features for a monster
-- =============================================
CREATE PROCEDURE [dbo].[get_Monster_Features]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
		f.*
	from feature_rl_Monster_Feature mf
	join feature_lu_Feature f
		on mf.guid_Feature = f.guid_feature
	where mf.guid_Monster = @guid_monster

END

GO
/****** Object:  StoredProcedure [dbo].[get_Stats_By_CR]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson	
-- Create date: 20170913
-- Description:	Return all CR data for levels above and below given CR
-- =============================================
CREATE PROCEDURE [dbo].[get_Stats_By_CR]
	-- Add the parameters for the stored procedure here
	@guid_CR uniqueidentifier,
	@number_adjacent_CR int = 5
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @rank_cr int = (
		select 
			rank_cr
		from com_CR
		where guid_CR = @guid_cr
	)

	select 
		cr.guid_CR,
		cr.name_CR,
		prof.proficiency_bonus,
		offen.attack_bonus,
		cast(offen.minimum_damage as nvarchar(4)) + '-' + cast(offen.maximum_damage as nvarchar(4)) as damage_range,
		offen.save_DC,
		def.ac,
		cast(def.minimum_HP as nvarchar(4)) + '-' + cast(def.maximum_HP as nvarchar(4)) as HP_range
	from com_CR cr
	join core_lu_CR_Proficiency prof
		on prof.guid_CR = cr.guid_CR
	join core_lu_Defensive_Values def
		on def.guid_CR = cr.guid_CR
	join core_lu_Offensive_Values offen
		on offen.guid_CR = cr.guid_CR
	where cr.rank_CR >= @rank_cr - @number_adjacent_CR
		and cr.rank_cr <= @rank_cr + @number_adjacent_CR
	order by rank_cr

END

GO
/****** Object:  StoredProcedure [dbo].[update_mon_Monster_Table]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170908
-- Description:	Update monster information
-- =============================================
CREATE PROCEDURE [dbo].[update_mon_Monster_Table]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier,

	@name_monster nvarchar(max) = null,
	@description_monster nvarchar(max) = null,
	@guid_alignment uniqueidentifier = null,
	@guid_type uniqueidentifier = null,
	@guid_CR uniqueidentifier = null,
	@guid_size uniqueidentifier = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update mm
		set name_monster = @name_monster,
			description_monster = @description_monster,
			guid_alignment = @guid_alignment,
			guid_type = @guid_type,
			guid_CR = @guid_CR,
			guid_size = @guid_size
	from mon_Monster mm
	where guid_monster = @guid_monster

	select @guid_monster

END


GO
/****** Object:  StoredProcedure [dbo].[update_Monster_Ability_Scores]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170911
-- Description:	Update ability scores, return ability score modifiers
-- =============================================
CREATE PROCEDURE [dbo].[update_Monster_Ability_Scores]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier,
	@guid_AbilityScore uniqueidentifier,
	@value_abilityScore int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if exists (
			select top 1 
				*
			from com_rl_Monster_AbilityScore
			where guid_Monster = @guid_monster
				and guid_AbilityScore = @guid_AbilityScore
		)
		begin

			update com_rl_Monster_AbilityScore
				set value_AbilityScore = @value_abilityScore
			where guid_Monster = @guid_monster
					and guid_AbilityScore = @guid_AbilityScore

		end


	else
		begin

			insert into com_rl_Monster_AbilityScore (
				guid_Monster,
				guid_AbilityScore,
				value_AbilityScore
			)
			select 
				@guid_monster,
				@guid_AbilityScore,
				@value_abilityScore

		end

	select top 1
		abl.name_AbilityScore,
		asm.value_AbilityScore_Modifier
	from com_rl_Monster_AbilityScore mas
	join com_rl_AbilityScore_Modifier asm
		on mas.value_AbilityScore = asm.value_AbilityScore
	join com_AbilityScore abl
		on abl.guid_AbilityScore = mas.guid_AbilityScore
	where mas.guid_Monster = @guid_monster
		and mas.guid_AbilityScore = @guid_AbilityScore

END

GO
/****** Object:  StoredProcedure [dbo].[update_Monster_Armor]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170914
-- Description:	Updates monster with chosen armour
-- =============================================
CREATE PROCEDURE [dbo].[update_Monster_Armor]
	-- Add the parameters for the stored procedure here
	@guid_Monster uniqueidentifier,
	@guid_Armor uniqueidentifier = null,
	@guid_shield uniqueidentifier = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if not exists (
		select top 1
			guid_Armor
		from mon_rl_Monster_Armor
		where guid_monster = @guid_monster

		union all

		select top 1
			guid_Shield
		from mon_rl_Monster_Armor
		where guid_monster = @guid_monster

	)
	begin
		
		insert into mon_rl_Monster_Armor (
			guid_monster, 
			guid_Armor,
			guid_Shield
		)
		select 
			@guid_monster,
			@guid_Armor,
			@guid_shield
	end

	else
	begin
		
		update mon_rl_Monster_Armor
			set guid_Armor = @guid_Armor,
				guid_Shield = @guid_shield
		where guid_Monster = @guid_monster

	end

	select *
	from [dbo].[get_Basic_Armor_Stats]
	where guid_Monster = @guid_Monster

END

GO
/****** Object:  StoredProcedure [dbo].[update_Monster_Feature]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Add new monster features, return the feature details
-- =============================================
CREATE PROCEDURE [dbo].[update_Monster_Feature]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier,
	@guid_feature uniqueidentifier

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @new_feature table
	(
		guid_monster uniqueidentifier,
		guid_feature uniqueidentifier
	)
	
	insert into @new_feature (
		guid_monster,
		guid_feature
	)
	select	
		@guid_monster,
		@guid_feature

	insert into feature_rl_Monster_Feature (
		guid_monster,
		guid_Feature
	)
	select 
		nf.guid_monster,
		nf.guid_feature
	from @new_feature nf
	left join feature_rl_Monster_Feature rmf
		on nf.guid_monster = rmf.guid_Monster
		and nf.guid_feature = rmf.guid_Feature
	where rmf.guid_Monster is null
		and rmf.guid_Feature is null

	select *
	from feature_rl_Monster_Feature mf
	join feature_lu_Feature f
		on mf.guid_Feature = f.guid_feature
	where mf.guid_Monster = @guid_monster
		and mf.guid_Feature = @guid_feature

END

GO
/****** Object:  StoredProcedure [dbo].[update_Monster_Weapon]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Adds/Updates a monster weapon entry
-- =============================================
CREATE PROCEDURE [dbo].[update_Monster_Weapon]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier, 
	@guid_weapon uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if not exists (
		select top 1
			guid_monster
		from mon_rl_Monster_Weapon
		where guid_monster = @guid_monster
	)
	begin
		
		insert into mon_rl_Monster_Weapon (
			guid_monster, 
			guid_Weapon
		)
		select 
			@guid_monster,
			@guid_weapon

	end

	else
	begin
		
		update mon_rl_Monster_Weapon
			set guid_Weapon = @guid_weapon
		where guid_Monster = @guid_monster

	end

	declare @monster_weapon_abilityScore table
	(
		guid_abilityScore uniqueidentifier,
		name_weapon nvarchar(70),
		name_abilityScore nvarchar(30),
		abilityScore_modifier int
	)

	insert into @monster_weapon_abilityScore
	exec [dbo].[get_Best_AbilityScore_By_Weapon]
		@guid_monster = @guid_monster,
		@guid_weapon = @guid_weapon

	select *
	from get_Basic_Attack_Routine 
	where guid_Monster = @guid_monster		

END

GO
/****** Object:  StoredProcedure [dbo].[update_Temp_Monster_CR]    Script Date: 1/24/2018 7:11:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170913
-- Description:	Updates temp CR table, used to calculate attacks etc while determining final CR for mon_Monster table
-- =============================================
CREATE PROCEDURE [dbo].[update_Temp_Monster_CR]
	-- Add the parameters for the stored procedure here
	@guid_monster uniqueidentifier,
	@offensive_CR uniqueidentifier = null,
	@defensive_CR uniqueidentifier = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if not exists (
		select top 1
			guid_monster
		from TEMP_Monster_CR
		where guid_monster = @guid_monster
	)
	begin
		
		insert into TEMP_Monster_CR (
			guid_monster, 
			offensive_CR,
			defensive_CR
		)
		select 
			@guid_monster,
			@offensive_CR,
			@defensive_CR

	end

	else
	begin

		update t_mcr
			set offensive_CR = case
							       when @offensive_CR is null then t_mcr.offensive_CR
								   else @offensive_CR
							   end,
				defensive_CR = case
							       when @defensive_CR  is null then t_mcr.defensive_CR 
								   else @defensive_CR 
							   end
		from TEMP_Monster_CR t_mcr
		where t_mcr.guid_monster = @guid_monster

	end

	select 
		cr_o.name_CR,
		ov.attack_bonus,
		cast(ov.minimum_damage as nvarchar(4)) + '-' + cast(ov.maximum_damage as nvarchar(4)) as damage_range,
		ov.save_DC,
		cr_d.name_CR,
		dv.ac,
		cast(dv.minimum_HP as nvarchar(4)) + '-' + cast(dv.maximum_HP as nvarchar(4)) as HP_range
	from TEMP_Monster_CR t_mcr
	left join core_lu_Offensive_Values ov
		on t_mcr.offensive_CR = ov.guid_CR
	left join com_CR cr_o
		on cr_o.guid_CR = ov.guid_CR
	left join core_lu_Defensive_Values dv
		on t_mcr.defensive_CR = dv.guid_CR
	left join com_CR cr_d
		on cr_d.guid_CR = dv.guid_CR
	where t_mcr.guid_monster = @guid_monster

END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[9] 2[31] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -1673
         Left = 0
      End
      Begin Tables = 
         Begin Table = "mon"
            Begin Extent = 
               Top = 88
               Left = 555
               Bottom = 251
               Right = 784
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t_cr"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 316
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ov"
            Begin Extent = 
               Top = 322
               Left = 48
               Bottom = 485
               Right = 270
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "prof"
            Begin Extent = 
               Top = 490
               Left = 48
               Bottom = 609
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 609
               Left = 48
               Bottom = 750
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mw"
            Begin Extent = 
               Top = 756
               Left = 48
               Bottom = 875
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "w"
            Begin Extent = 
               Top = 875
               Left = 48
               Bottom = 1038
               Right = 287
            End
            DisplayFlags = 280
            TopColumn = 0
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'get_Basic_Attack_Routine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         End
         Begin Table = "dt"
            Begin Extent = 
               Top = 1043
               Left = 48
               Bottom = 1162
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 1162
               Left = 48
               Bottom = 1325
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "swd"
            Begin Extent = 
               Top = 1330
               Left = 48
               Bottom = 1449
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "was"
            Begin Extent = 
               Top = 1449
               Left = 48
               Bottom = 1568
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "score"
            Begin Extent = 
               Top = 1568
               Left = 48
               Bottom = 1687
               Right = 266
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "mas"
            Begin Extent = 
               Top = 1687
               Left = 48
               Bottom = 1828
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sc_m"
            Begin Extent = 
               Top = 1834
               Left = 48
               Bottom = 1953
               Right = 327
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'get_Basic_Attack_Routine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'get_Basic_Attack_Routine'
GO
USE [master]
GO
ALTER DATABASE [Monster_Builder] SET  READ_WRITE 
GO
