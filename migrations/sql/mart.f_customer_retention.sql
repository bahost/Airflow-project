create table if not exists mart.f_customer_retention(
    new_customers_count int not null,
    returning_customers_count int not null,
    refunded_customer_count int not null,
    period_name varchar,
    period_id int,
    item_id int,
    new_customers_revenue float,
    returning_customers_revenue float,
    customers_refunded int,
    primary key (period_id,item_id)
);

delete from mart.f_customer_retention
where period_id in (select week_of_year from mart.d_calendar where date_actual = '{{ds}}');

insert into mart.f_customer_retention (period_name,
                                        period_id,
                                        item_id,
                                        new_customers_count,
                                        returning_customers_count,
                                        refunded_customer_count,
                                        new_customers_revenue,
                                        returning_customers_revenue,
                                        customers_refunded)
with t as(
    select 
        s.customer_id as customer_id,
        c.week_of_year as week_of_year,
        s.quantity as quantity,
        s.payment_amount as payment_amount,
        s.item_id as item_id,
        ---
        count(s.id) over(partition by c.week_of_year, s.customer_id) as qty_cnt
    from mart.f_sales as s
    join mart.d_calendar as c
        on s.date_id = c.date_id
    where c.date_actual = '{{ ds }}'
),

t2 as(
    select distinct
        s.customer_id as customer_id,
        c.week_of_year as week_of_year
    from mart.f_sales as s
    join mart.d_calendar as c
        on s.date_id = c.date_id
    where payment_amount < 0
        and c.date_actual = '{{ ds }}'
)

select
    'weekly' as period_name,
    t.week_of_year as period_id, -- week number
    t.item_id as item_id,
    sum(
        case
            when t.qty_cnt = 1 then 1
            else 0 
        end) as new_customers_count,
    sum(
        case
            when t.qty_cnt > 1 then 1
            else 0 
        end) as returning_customers_count,
    sum(
        case
            when t2.customer_id is not null then 1
            else 0
        end) as refunded_customer_count,
    sum(
        case
            when t.qty_cnt = 1 then payment_amount 
            else 0
        end) as new_customers_revenue,
    sum(
        case
            when t2.customer_id is not null then payment_amount
            else 0
        end) as returning_customers_revenue,
    count(distinct t2.customer_id) as customers_refunded
from t
left join t2
on t.customer_id = t2.customer_id
    and t.week_of_year = t2.week_of_year
group by 
    t.week_of_year,
    t.item_id
;

/*
mart.f_customer_retention
1. new_customers_count — кол-во новых клиентов (тех, которые сделали только один 
заказ за рассматриваемый промежуток времени).
2. returning_customers_count — кол-во вернувшихся клиентов (тех,
которые сделали только несколько заказов за рассматриваемый промежуток времени).
3. refunded_customer_count — кол-во клиентов, оформивших возврат за 
рассматриваемый промежуток времени.
4. period_name — weekly.
5. period_id — идентификатор периода (номер недели или номер месяца).
6. item_id — идентификатор категории товара.
7. new_customers_revenue — доход с новых клиентов.
8. returning_customers_revenue — доход с вернувшихся клиентов.
9. customers_refunded — количество возвратов клиентов. 
*/
