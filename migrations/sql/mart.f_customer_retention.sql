drop table if exists mart.f_customer_retention;
create table mart.f_customer_retention(
    new_customers_count int not null,
    returning_customers_count int not null,
    refunded_customer_count int not null,
    period_name varchar,
    period_id int,
    item_id int,
    new_customers_revenue float,
    returning_customers_revenue float,
    customers_refunded int
);

insert into mart.f_customer_retention (new_customers_count,
                                        returning_customers_count,
                                        refunded_customer_count,
                                        period_name,
                                        period_id,
                                        item_id,
                                        new_customers_revenue,
                                        returning_customers_revenue,
                                        customers_refunded)
with(
    
) as t
select
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    period_name,
    period_id,
    item_id,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded
from 

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
