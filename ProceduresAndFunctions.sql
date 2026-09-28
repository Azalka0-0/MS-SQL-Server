-- UniversityDB: функция и процедура

USE UniversityDB;
GO

-- 1. ФУНКЦИЯ: демонстрация встроенных функций SQL Server
IF OBJECT_ID(N'dbo.ShowBuiltInFunctions', N'IF') IS NOT NULL
    DROP FUNCTION dbo.ShowBuiltInFunctions;
GO

CREATE FUNCTION dbo.ShowBuiltInFunctions()
RETURNS TABLE
AS
RETURN
(
    SELECT
        LEN(N'University') AS StringLength,
        UPPER(N'university') AS UpperCase,
        LOWER(N'UNIVERSITY') AS LowerCase,
        ROUND(123.4567, 2) AS RoundedNumber,
        ABS(-25) AS AbsoluteValue,
        CEILING(12.3) AS CeilingValue,
        FLOOR(12.9) AS FloorValue,
        GETDATE() AS CurrentDateTime,
        YEAR(GETDATE()) AS CurrentYear,
        MONTH(GETDATE()) AS CurrentMonth,
        DAY(GETDATE()) AS CurrentDay,
        (SELECT COUNT(*) FROM dbo.Students) AS StudentCount,
        (SELECT MIN(BirthDate) FROM dbo.Students) AS EarliestBirthDate,
        (SELECT MAX(BirthDate) FROM dbo.Students) AS LatestBirthDate,
        IIF(
            (SELECT COUNT(*) FROM dbo.Students) > 0,
            N'Студенты есть',
            N'Студентов нет'
        ) AS StudentStatus
);
GO

-- Вызов функции
SELECT *
FROM dbo.ShowBuiltInFunctions();
GO


-- 2. ПРОЦЕДУРА: разница между поступившими и выпускающимися
IF OBJECT_ID(N'dbo.GetStudentDifference', N'P') IS NOT NULL
    DROP PROCEDURE dbo.GetStudentDifference;
GO

CREATE PROCEDURE dbo.GetStudentDifference
    @AdmissionYear INT,
    @GraduationYear INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Admitted INT;
    DECLARE @Graduating INT;

    SELECT @Admitted = COUNT(*)
    FROM dbo.Students
    WHERE AdmissionYear = @AdmissionYear;

    SELECT @Graduating = COUNT(*)
    FROM dbo.Students
    WHERE GraduationYear = @GraduationYear;

    SELECT
        @Admitted AS AdmittedStudents,
        @Graduating AS GraduatingStudents,
        @Admitted - @Graduating AS Difference;
END;
GO

-- Вызов процедуры
EXEC dbo.GetStudentDifference
    @AdmissionYear = 2023,
    @GraduationYear = 2027;
GO
