-- =============================================
-- UniversityDB
-- База данных университета
-- 6 таблиц: 5 связанных + 1 независимая
-- =============================================

-- ВНИМАНИЕ:
-- Скрипт ниже пересоздаёт базу UniversityDB с нуля.
-- Не запускайте его в существующей базе, если хотите сохранить данные.

USE master;
GO

IF DB_ID(N'UniversityDB') IS NOT NULL
BEGIN
    ALTER DATABASE UniversityDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE UniversityDB;
END;
GO

CREATE DATABASE UniversityDB;
GO

USE UniversityDB;
GO

-- =============================================
-- 1. Таблица специальностей
-- =============================================

CREATE TABLE dbo.Specialties
(
    SpecialtyID INT IDENTITY(1,1) PRIMARY KEY,
    SpecialtyName NVARCHAR(100) NOT NULL
);
GO

-- =============================================
-- 2. Таблица групп
-- Связана с Specialties
-- =============================================

CREATE TABLE dbo.Groups
(
    GroupID INT IDENTITY(1,1) PRIMARY KEY,
    GroupName NVARCHAR(50) NOT NULL,
    SpecialtyID INT NOT NULL,

    CONSTRAINT FK_Groups_Specialties
        FOREIGN KEY (SpecialtyID)
        REFERENCES dbo.Specialties(SpecialtyID)
);
GO

-- =============================================
-- 3. Таблица студентов
-- Связана с Groups
-- =============================================

CREATE TABLE dbo.Students
(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    GroupID INT NOT NULL,

    CONSTRAINT FK_Students_Groups
        FOREIGN KEY (GroupID)
        REFERENCES dbo.Groups(GroupID)
);
GO

-- =============================================
-- 4. Таблица кафедр
-- =============================================

CREATE TABLE dbo.Departments
(
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL
);
GO

-- =============================================
-- 5. Таблица преподавателей
-- Связана с Departments
-- =============================================

CREATE TABLE dbo.Teachers
(
    TeacherID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DepartmentID INT NOT NULL,

    CONSTRAINT FK_Teachers_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID)
);
GO

-- =============================================
-- 6. Таблица аудиторий
-- Независимая таблица
-- =============================================

CREATE TABLE dbo.Classrooms
(
    ClassroomID INT IDENTITY(1,1) PRIMARY KEY,
    ClassroomNumber NVARCHAR(20) NOT NULL,
    Capacity INT NOT NULL
);
GO

-- =============================================
-- Заполнение таблицы Specialties
-- =============================================

INSERT INTO dbo.Specialties (SpecialtyName)
VALUES
(N'Программная инженерия'),
(N'Информационные системы'),
(N'Компьютерные науки'),
(N'Программная инженерия'),
(N'Информационные системы');
GO

-- =============================================
-- Заполнение таблицы Groups
-- =============================================

INSERT INTO dbo.Groups (GroupName, SpecialtyID)
VALUES
(N'ПИ-101', 1),
(N'ПИ-102', 1),
(N'ИС-201', 2),
(N'КН-301', 3),
(N'ПИ-202', 4);
GO

-- =============================================
-- Заполнение таблицы Students
-- =============================================

INSERT INTO dbo.Students (FirstName, LastName, BirthDate, GroupID)
VALUES
(N'Иван', N'Иванов', '2007-05-15', 1),
(N'Анна', N'Петрова', '2007-08-20', 2),
(N'Максим', N'Сидоров', '2006-11-10', 3),
(N'Екатерина', N'Смирнова', '2007-02-25', 4),
(N'Дмитрий', N'Кузнецов', '2006-12-03', 5);
GO

-- =============================================
-- Заполнение таблицы Departments
-- =============================================

INSERT INTO dbo.Departments (DepartmentName)
VALUES
(N'Кафедра программирования'),
(N'Кафедра информационных технологий'),
(N'Кафедра математики'),
(N'Кафедра компьютерных наук'),
(N'Кафедра информационных систем');
GO

-- =============================================
-- Заполнение таблицы Teachers
-- =============================================

INSERT INTO dbo.Teachers (FirstName, LastName, DepartmentID)
VALUES
(N'Алексей', N'Смирнов', 1),
(N'Елена', N'Кузнецова', 2),
(N'Дмитрий', N'Попов', 3),
(N'Ольга', N'Волкова', 4),
(N'Сергей', N'Морозов', 5);
GO

-- =============================================
-- Заполнение таблицы Classrooms
-- =============================================

INSERT INTO dbo.Classrooms (ClassroomNumber, Capacity)
VALUES
(N'101', 30),
(N'202', 25),
(N'305', 40),
(N'410', 35),
(N'512', 20);
GO

-- =============================================
-- Проверка внешних ключей
-- =============================================

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id;
GO

-- =============================================
-- ЗАДАНИЕ:
-- Достать по 1 строке из каждой таблицы с помощью T-SQL
-- =============================================

SELECT TOP 1 * FROM dbo.Specialties;
SELECT TOP 1 * FROM dbo.Groups;
SELECT TOP 1 * FROM dbo.Students;
SELECT TOP 1 * FROM dbo.Departments;
SELECT TOP 1 * FROM dbo.Teachers;
SELECT TOP 1 * FROM dbo.Classrooms;
GO
