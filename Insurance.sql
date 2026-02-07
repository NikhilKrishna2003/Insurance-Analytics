 create database insurance; 
 use insurance;

 show tables;
 
 # Cleaning data tables ============================================================================================================================================
 
 # invoice--------------------------------------------------------
ALTER TABLE invoice
RENAME COLUMN `ï»¿invoice_number` TO invoice_number;
 
 Select * from invoice;
 
# meeting ---------------------------------------------------------
ALTER TABLE meeting
RENAME COLUMN `ï»¿Account Executive` TO account_executive;

SET SQL_SAFE_UPDATES = 0;

UPDATE meeting
SET meeting_date = STR_TO_DATE(meeting_date, '%d-%m-%Y')
WHERE meeting_date IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

Select * from meeting ;

#fees---------------------------------------------------------------
ALTER TABLE fees
RENAME COLUMN `ï»¿client_name` TO client_name;

SELECT COUNT(*) FROM fees;
SELECT * FROM fees LIMIT 5;


#brokerage----------------------------------------------------------
SELECT * FROM brokerage;

 #opportunity--------------------------------------------------------
 ALTER TABLE opportunity
RENAME COLUMN `ï»¿opportunity_name` TO opportunity_name;

SELECT * FROM opportunity;
 
 # Main Queries below =========================================================================================================================================
 
 
 #1.No of invoices by account executive--------------------------------
SELECT `Account Executive`,COUNT(invoice_number) AS no_of_invoices
FROM invoice
GROUP BY `Account Executive`
ORDER BY no_of_invoices DESC;
 
 
 #2.Yearly meeting count-----------------------------------------------
SELECT
    YEAR(meeting_date) AS year,
    COUNT(*) AS total_meetings
FROM meeting
GROUP BY YEAR(meeting_date)
ORDER BY year;
 
 
#3.cross-sell target by branch and employee
SELECT
    branch,
    employee,
    SUM(cross_sell_budget) AS cross_sell_target
FROM individual_budgets
GROUP BY branch, employee 
ORDER BY branch, cross_sell_target DESC;



#4  Total placed of fees by type of income like new,renewal and cross ------------------------------------------------------------------------------
SELECT income_type , SUM(placed_achievement) AS total_placed
FROM ( 
    SELECT income_class AS income_type, amount AS placed_achievement FROM fees
) t
GROUP BY income_type;


#5 Total placed of brokerage  by type income like new,renewal and cross ------------------------------------------------------------------------------
SELECT income_type, SUM(placed_achievement) AS total_placed
FROM (
    SELECT income_class AS income_type, amount AS placed_achievement FROM brokerage 
    ) t
GROUP BY income_type;

#6.Achieved Revenue by Type ----------------------------------------------
SELECT revenue_transaction_type,
	   ROUND(SUM(amount),2) AS achieved_revenue
FROM fees 
GROUP BY revenue_transaction_type;


#7.Stage funnel by revenue-----------------------------------------------
SELECT 
    stage,
    SUM(revenue_amount) AS total_revenue
FROM opportunity
GROUP BY stage
ORDER BY total_revenue DESC;

#8.Number of Meeting by account executive---------------------------------------
SELECT
	 Account_Executive ,
    COUNT(*) AS meeting_count
FROM meeting
GROUP BY account_executive
ORDER BY meeting_count DESC;

#9.Top open oppurtunities--------------------------------------------------
SELECT 
    opportunity_name,
    `Account Executive`,
    revenue_amount,
    stage
FROM opportunity
WHERE stage IN ('Propose Solution', 'Qualify Opportunity')
ORDER BY revenue_amount DESC
LIMIT 10;













