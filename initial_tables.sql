begin;

drop table if exists pollster cascade;

create table pollster (id bigserial primary key, poll_taker varchar, poll_date varchar, mid_date varchar, days int, participants varchar, popul_type varchar, macain int, obama int, margin int, charlie int, meltdown int);

commit;

