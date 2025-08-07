objective 15

with cte as 
(
Select doctor_name, count(*) as total_patients, 
sum(total_bill) as revenuea
from doctor_patient_data
group by doctor_name
),
ranked as 
( 
Select doctor_name, total_patients, revenue ,
rank() over( order by total_patients asc, revenue desc) as rnk 
from cte )

Select doctor_name, total_patients , revenue from ranked 
where rnk<=5;

objective 16
with cte as 
(
Select department_referral as department ,
date_format(date,'%Y-%m') as month ,
round(avg(patient_waittime),2) as avg_waittime 
from patient_visits 
group by department_referral, date_format(date,'%Y-%m')
),

lags as 
(
Select department,
month,
avg_waittime,
LAG(avg_waittime,1) over( partition by department order by month ) as prev_month,
LAG(avg_waittime,2) over( partition by department order by month ) as prev_prev_month
from cte )
Select department,month,avg_waittime,prev_month,prev_prev_month
from lags where avg_waittime < prev_month and prev_month < prev_prev_month;

objective 17
with cte as 
( Select d.doctor_name,
ifnull(round(sum( case when p.patient_gender = "Male" then 1 else 0 end) / sum( case when p.patient_gender = "Female" then 1 else 0 end),2),0) as gender_ratio
from doctor_patient_data d join patient_visits p 
on d.patient_id = p.patient_id
group by d.doctor_name )

Select doctor_name, gender_ratio , 
dense_rank() over( order by gender_ratio desc) as rnk 
from cte ;

objective 18
Select d.doctor_name,
round(avg(p.patient_sat_score),2) as SAT_Score 
from doctor_patient_data d 
join patient_visits p on d.patient_id = p.patient_id
group by d.doctor_name 
order by SAT_Score desc;

objective 19

Select d.doctor_name,
count(distinct(p.patient_race)) as diversity_count
from doctor_patient_data d 
join patient_visits p on d.patient_id = p.patient_id
group by d.doctor_name 
order by diversity_count desc, doctor_name asc;

objective 20

Select d.department_referral as department ,
round(sum(case when p.patient_gender = "Male" then d.total_bill else 0 end)/
sum(case when p.patient_gender = "Female" then d.total_bill else 0 end),2) as gender_revenue_ratio
from doctor_patient_data d 
join patient_visits p on d.patient_id = p.patient_id
group by d.department_referral 
order by gender_revenue_ratio desc , department asc;

objective 21

UPDATE patient_visits
SET patient_sat_score = LEAST(patient_sat_score + 2, 10)
WHERE department_referral = 'General Practice'
AND patient_waittime > 30;



