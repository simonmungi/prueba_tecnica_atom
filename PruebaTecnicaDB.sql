USE [PruebaTecnicaDB]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articulos]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articulos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](max) NOT NULL,
	[Stock] [int] NOT NULL,
	[Precio] [decimal](18, 2) NOT NULL,
	[Fecha_alta] [datetime2](7) NOT NULL,
	[Fecha_modificacion] [datetime2](7) NULL,
	[Fecha_baja] [datetime2](7) NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Articulos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articulos] ADD  DEFAULT (N'') FOR [Descripcion]
GO
/****** Object:  StoredProcedure [dbo].[PRC_ACTUALIZAR_ARTICULO]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRC_ACTUALIZAR_ARTICULO]
    @Id INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @Precio DECIMAL(18, 2),
	@Stock INT
AS
BEGIN
    UPDATE Articulos
    SET 
        Nombre = @Nombre, 
        Descripcion = @Descripcion, 
        Precio = @Precio, 
        Fecha_modificacion = SYSDATETIME(),
		Stock = @Stock
    WHERE 
        Id = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[PRC_AGREGAR_ARTICULO]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PRC_AGREGAR_ARTICULO]
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(255),
    @Precio DECIMAL(18, 2),
	@Stock INT
AS
BEGIN
    INSERT INTO Articulos (Nombre, Descripcion, Precio, Fecha_alta, Stock)
    VALUES (@Nombre, @Descripcion, @Precio, SYSDATETIME(), @Stock);
END
GO
/****** Object:  StoredProcedure [dbo].[PRC_ELIMINAR_ARTICULO]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRC_ELIMINAR_ARTICULO]
    @Id INT
AS
BEGIN
    UPDATE Articulos 
    SET Fecha_baja = SYSDATETIME()
    WHERE Id = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[PRC_OBTENER_ARTICULO_ID]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRC_OBTENER_ARTICULO_ID]
    @Id INT
AS
BEGIN
    SELECT * FROM Articulos
    where Id = @Id
    and Fecha_baja is null;
END
GO
/****** Object:  StoredProcedure [dbo].[PRC_OBTENER_ARTICULOS]    Script Date: 29/06/2024 13:29:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PRC_OBTENER_ARTICULOS]
AS
BEGIN
    SELECT * FROM Articulos
    where Fecha_baja is null;
END
GO
