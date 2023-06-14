insert into mart.f_sales (date_id, item_id, customer_id, city_id, status, quantity, payment_amount)
select 
    dc.date_id, 
    item_id, 
    customer_id, 
    city_id, 
    'shipped' as status,
    quantity, 
    if(uol.status = 'refunded', -1 * payment_amount, payment_amount) as payment_amount
from staging.user_order_log uol
left join mart.d_calendar as dc 
    on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = '{{ds}}';
