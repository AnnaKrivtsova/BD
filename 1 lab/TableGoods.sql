USE [Кривцова_ПРОДАЖИ]
GO

/****** Object:  Table [dbo].[ТОВАРЫ]    Script Date: 01.02.2021 20:14:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ТОВАРЫ](
	[Наименование] [nvarchar](20) NOT NULL,
	[Цена] [real] NULL,
	[Количество] [int] NULL,
 CONSTRAINT [PK_ТОВАРЫ] PRIMARY KEY CLUSTERED 
(
	[Наименование] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


