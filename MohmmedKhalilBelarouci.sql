select count(*) from City

-- 2

select p.planName,
p.price AS planPrice ,
idp.internetDataPlanName,
idp.dataAllowanceMB , 
idp.price AS internetDataPlanPrice ,
mno.operatorName 
From [Plan] p 
JOIN InternetDataPlan idp 
	ON p.internetDataPlanID = idp.internetDataPlanID 
JOIN MobileNetworkOperator mno 
	ON idp.operatorID = mno.operatorID;


-- 3

SELECT
    [mno].[operatorName],
    [p].[planName],
    [p].[price]
FROM [MobileNetworkOperator] AS [mno]
JOIN [Plan]        AS [p]  ON [p].[operatorID] = [mno].[operatorID]
JOIN [PlanBundle]  AS [pb] ON [pb].[planID]    = [p].[planID]
JOIN [Discount]    AS [d]  ON [d].[bundleID]   = [pb].[bundleID]
WHERE [pb].[serviceID] = 1
GROUP BY [mno].[operatorName], [p].[planName], [p].[price]
HAVING SUM([d].[quantity]) >= 100
ORDER BY [mno].[operatorName], [p].[planName];

--4
SELECT
    [c].[cityName],
    COUNT([pe].[personID]) AS [numberOfUsers]
FROM [City] AS [c]
LEFT JOIN [Person] AS [pe] ON [pe].[cityID] = [c].[cityID]
GROUP BY [c].[cityID], [c].[cityName]
ORDER BY [numberOfUsers] DESC, [c].[cityName];

--5
SELECT
    [c].[cityName]
FROM [City] AS [c]
LEFT JOIN [Person] AS [pe] ON [pe].[cityID] = [c].[cityID]
WHERE [pe].[personID] IS NULL
ORDER BY [c].[cityName];

--6 excluding cities with no users;

SELECT CAST(COUNT([Person].[personID]) AS DECIMAL(10,2)) / COUNT(DISTINCT [Person].[cityID]) AS [avgUsersPerCity]
FROM [Person];


--6 including cities with no users.
SELECT CAST(COUNT([Person].[personID]) AS DECIMAL(10,2)) / (SELECT COUNT([City].[cityID]) FROM [City]) AS [avgUsersPerCity]
FROM [Person];

-- 7 
SELECT TOP 1 WITH TIES [MobileNetworkOperator].[operatorName]
FROM [MobileNetworkOperator]
JOIN [Plan] ON [Plan].[operatorID] = [MobileNetworkOperator].[operatorID]
GROUP BY [MobileNetworkOperator].[operatorName]
ORDER BY COUNT([Plan].[planID]) DESC;
--8 for the question 8 the last year is 2024 and the question wants the one's betwen january 3, 2025 and January 10, 2025 so it filter nothing 

SELECT MIN([contractStartDate]) AS [firstDate], MAX([contractStartDate]) AS [lastDate]
FROM [Subscriber];
-- 8 corrected filtring between 2014 to 2015

SELECT
    [Person].[firstName],
    [Person].[lastName],
    [Plan].[planName],
    [Subscriber].[contractStartDate]
FROM [Subscriber]
JOIN [Person] ON [Person].[personID] = [Subscriber].[personID]
JOIN [Plan]   ON [Plan].[planID]     = [Subscriber].[planID]
WHERE [Subscriber].[contractStartDate] >= '2014-01-01'
  AND [Subscriber].[contractStartDate] <= '2015-01-01'
ORDER BY [Subscriber].[contractStartDate], [Person].[lastName];
-- 9
SELECT
    [MobileNetworkOperator].[operatorName],
    AVG([Plan].[price]) AS [avgPlanPrice]
FROM [MobileNetworkOperator]
JOIN [Plan] ON [Plan].[operatorID] = [MobileNetworkOperator].[operatorID]
GROUP BY [MobileNetworkOperator].[operatorID], [MobileNetworkOperator].[operatorName]
ORDER BY [avgPlanPrice] DESC;



-- 10
SELECT
    [MobileNetworkOperator].[operatorName],
    COUNT([OperatorAdditionalService].[additionalServiceID]) AS [numberOfAdditionalServices]
FROM [MobileNetworkOperator]
LEFT JOIN [OperatorAdditionalService] ON [OperatorAdditionalService].[operatorID] = [MobileNetworkOperator].[operatorID]
GROUP BY [MobileNetworkOperator].[operatorID], [MobileNetworkOperator].[operatorName]
ORDER BY [numberOfAdditionalServices] DESC;