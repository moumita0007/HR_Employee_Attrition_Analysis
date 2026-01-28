create database Attrition;
use Attrition;

select * from cleand_HR_employee_attrition;

# 1. Overall Attrition Rate 
select Round(100.0* sum(case when Attrition= 'Yes' then 1 else 0 end )/ count(*), 2) as Attrition_rate_percentage
from cleand_HR_employee_attrition;

# 2.Attrition Rate by Department
select Department,Round(100.0* SUM(case when Attrition = 'Yes' then 1 else 0 end)/count(*),2) as Attrition_rate_percentage
From cleand_HR_employee_attrition
Group by Department
Order by Attrition_rate_percentage DESC;

# 3. Attrition by Job Role
select Round(100.0* SUM(case when Attrition='Yes' then 1 else 0 end)/count(*),2) as Attrition_rate_percentage,JobRole
From cleand_HR_employee_attrition
Group by JobRole
Order by Attrition_rate_percentage desc;

# 4. Average Monthly Income by Attrition
select Round(Avg(MonthlyIncome),2) as MonthlyIncome, Attrition from cleand_HR_employee_attrition
Group by Attrition;

# 5. Overtime vs Attrition Rate
select Round(100* SUM(Case when Attrition='Yes' then 1 else 0 end)/count(*),2) as Attrition_rate_percentage, OverTime
From cleand_HR_employee_attrition
Group by OverTime 
Order by Attrition_rate_percentage DESC;

# 6. Tenure Analysis (Early vs Long-Term Employees)
select case when YearsAtCompany <= 2 then 'Early Career'
            when YearsAtCompany between 3 And 5 then 'Mid Career'
            else 'Long Tenure'
            end as Tenure_group, 
		count(*) as Total_employees,
        sum(case when Attrition='Yes' then 1 else 0 end ) as employee_left,
        Round(100* sum(case when attrition='Yes' then 1 else 0 end)/ count(*),2) as Attrition_rate_percentage
            from cleand_HR_employee_attrition
            group by Tenure_group
            order by Attrition_rate_percentage DESC;

# 7. Gender-wise Attrition
select Gender, Round(100* SUM(case when Attrition='Yes' then 1 else 0 end)/ count(*),2) as Attrition_rate_percentage
from cleand_HR_employee_attrition
Group by Gender;

# 8. Top 5 Departments with Highest Attrition (Window Function) 
select * from (
select department, Round(100* sum(case when Attrition='Yes' then 1 else 0 end)/count(*),2) as Attrition_rate_percentage,
Rank() over (order by sum(case when Attrition='Yes' then 1 else 0 end) * 1.0/ count(*) DESC) as Dept_rank
From cleand_HR_employee_attrition
Group by Department
) t 
where dept_rank<=5;




# Key insight:
# 1. Overall attrition rate is 16.12
# 2. The Sales department shows a higher attrition rate compared to other departments.
# 3. Sales Representatives experience the highest attrition among job roles, possibly due 
#    to target pressure and variable incentives.
# 4. Average MonthlyIncome appears similar for employees who stayed and left; however, 
#    distribution analysis shows higher attrition in lower income bands, indicating mean alone hides variability.
# 5. Employees working overtime exhibit a significantly higher attrition rate, suggesting burnout or work-life imbalance.
# 6. Attrition is highest during early career stages, while long-tenured employees show strong retention, 
#    highlighting the importance of early engagement.
# 7. Male employees exhibit a higher attrition rate than female employees.
# 8. sales rank 1st in attrition rate percentage.







