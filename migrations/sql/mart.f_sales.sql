-- Удаляем из факта данные за текущий день
delete from mart.f_sales 
where date_id in (select date_id from mart.d_calendar where date_actual = '{{ds}}');

insert into mart.f_sales (date_id, item_id, customer_id, city_id, status, quantity, payment_amount)
select 
    dc.date_id, 
    item_id, 
    customer_id, 
    city_id, 
    'shipped' as status,
    quantity, 
    case
        when uol.status = 'refunded' then -1 * payment_amount
        else payment_amount
    end as payment_amount
from staging.user_order_log uol
left join mart.d_calendar as dc 
    on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = '{{ds}}';
