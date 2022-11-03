
--Question1
WITH SourceCTE(TermID, TermName, TermFirstDate, CourseID, InstructorID, StudentCount, PassingStudentCount) AS
(
    SELECT T.TermID, T.TermName, T.FirstDate AS [TermFirstDate], SC.CourseID, SC.InstructorID, 
    COUNT(*) AS StudentCount, 
    SUM(IFF(ES.Finalgrade >= 70, 1, 0)) AS PassingStudentCount
    FROM Term T
        INNER JOIN ScheduledCourse SC ON T.TermID = SC.TermID
        INNER JOIN EnrolledStudent ES ON SC.ScheduledCourse = ES.ScheduledCourse
    WHERE TermFirstDate >= '2014-08-01'
    GROUP BY, T.TermID, T.TermName, TermFirstDate, SC.CourseID, SC.InstructorID
)
SELECT CTE.TermName, CTE.InstructorID,
    I.LastName + N', ' + I.FirstName AS InstructorName,
    C.Name, CTE.StudentCount,
    100.00 * CTE.PassingStudentCount / CTE.StudentCount AS PassingStudentCount,
    100.00 * SUM(CTE.PassingStudentCount) OVER(PARTITION CTE.CourseID, CTE.InstructorID) 
    / SUM(CTE.StudentCount) OVER(PARTITION CTE.CourseID, CTE.InstructorID) AS CourseAndInstructorPassingPercent,
    100.00 * SUM(CTE.PassingStudentCount) OVER(PARTITION CTE.CourseID) 
    / SUM(CTE.StudentCount) OVER(PARTITION CTE.CourseID) AS CoursePassingPercent

FROM SourceCTE CTE
    INNER JOIN Intructor I ON CTE.InstructorID = I.InstructorID
    INNER JOIN Course C ON CTE.CourseID = C.CourseID
ORDER BY CTE.TermFirstDate, C.Name

--Question2
DECLARE @StudentID INT = 1;

SELECT T.Name AS TermName, C.CourseName, 
    LAG(SCC.FinalGrade) OVER(PARTITION BY C.CourseID, ORDER BY T.FirstDate ASC) AS PriorGrade,
    LAG(SCC.FinalLetterGrade) OVER(PARTITION BY C.CourseID, ORDER BY T.FirstDate ASC) AS PriorLetterGrade
FROM (
    SELECT ES.ScheduledCourseID, ES.FinalGrade,
    CASE
        WHEN FinalGrade >= 90 THEN N'A' 
        WHEN FinalGrade >= 80 THEN N'B' 
        WHEN FinalGrade >= 70 THEN N'C' 
        WHEN FinalGrade >= 60 THEN N'D'
        ELSE N'F'
    FROM EnrolledStudent ES
    WHERE ES.StudentID = @StudentID0
) SCC
    INNER JOIN ScheduledCourse SC ON SC.ScheduledCourseID = SCC.ScheduledCourseID
    INNER JOIN Course C ON C.CourseID = SC.CourseID
    INNER JOIN Term T ON T.TermID = C.TermID
ORDER BY T.FirstDate ASC, C.Name ASC