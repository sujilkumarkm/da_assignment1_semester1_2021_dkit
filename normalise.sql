-- Begining of the file

begin;

-- Correcting the column valus with null
UPDATE pollster SET participants = NULL WHERE participants = 'NA';

UPDATE pollster SET popul_type = 'AD' WHERE popul_type = 'A';


-- Removing unwanted columns for cleaning of data
ALTER table pollster DROP COLUMN charlie,DROP meltdown;


create table poll_date as (select id,mid_date,days,split_part(poll_date, '-', 1) as from_date,split_part(poll_date, '-', 2) as to_date from pollster);

-- Creating foreign key for the table poll_date
alter table poll_date add foreign key (id) references pollster(id);



create table month_map as select id,LEFT(mid_date,2) FROM poll_date;



-- Again dropping unwamted columns
ALTER table pollster DROP COLUMN poll_date;

ALTER table pollster DROP COLUMN mid_date;

ALTER table pollster DROP COLUMN days;

-- Creating tables to store votes for 2 major parties from pollster
drop table if exists votes;

create table votes as select id as vote_id,macain,obama,margin from pollster;

-- Assigning foreign key for main table reference
alter table votes add foreign key (vote_id) references pollster(id);


ALTER table pollster DROP COLUMN macain;
ALTER table pollster DROP COLUMN obama;
ALTER table pollster DROP COLUMN margin;


-- Removed column days which is not relavant for the study considering expected outputs
ALTER table poll_date DROP COLUMN days;

-- Making from date into full date
update poll_date set from_date = from_date || '/2008';

UPDATE poll_date SET to_date = REPLACE(to_date,'9/','') WHERE length(to_date)>=6;

UPDATE poll_date SET to_date = REPLACE(to_date,'10/','') WHERE length(to_date)>6;

UPDATE poll_date SET to_date = REPLACE(to_date,'/08','/2008');

UPDATE poll_date set mid_date = mid_date || '/2008';

-- UPDATE poll_dates SET to_date = REPLACE(to_date,'9/1/2008','10/1/2008');

drop table if exists poll_dates;

create table poll_dates as (select a.id,a.mid_date,a.from_date,concat(month_map.left,a.to_date) as to_date from poll_date a inner join month_map on a.id=month_map.id);



--Concerting to date datatype
ALTER TABLE poll_dates ALTER COLUMN from_date TYPE DATE USING to_date(from_date, 'MM-DD-YYYY');

ALTER TABLE poll_dates ALTER COLUMN to_date TYPE DATE USING to_date(to_date, 'MM-DD-YYYY');

ALTER TABLE poll_dates ALTER COLUMN mid_date TYPE DATE USING to_date(mid_date, 'MM-DD-YYYY');


ALTER TABLE poll_dates ADD CONSTRAINT id FOREIGN KEY (id) REFERENCES pollster (id);



-- Setting Nullable constrains for more good practice and precision in data management

ALTER TABLE poll_dates ALTER column id SET NOT NULL;

ALTER TABLE poll_dates ALTER column mid_date SET NOT NULL;

ALTER TABLE poll_dates ALTER column from_date SET NOT NULL;

ALTER TABLE poll_dates ALTER column to_date SET NOT NULL;

ALTER TABLE pollster ALTER column popul_type SET NOT NULL;

ALTER TABLE pollster ALTER column poll_taker SET NOT NULL;

ALTER TABLE pollster ALTER column participants DROP NOT NULL;

ALTER TABLE votes ALTER column vote_id SET NOT NULL;

ALTER TABLE votes ALTER column macain SET NOT NULL;

ALTER TABLE votes ALTER column obama SET NOT NULL;

ALTER TABLE votes ALTER column margin SET NOT NULL;





-- Setting default value for columns
alter table pollster alter column poll_taker set default 'unknown';

alter table pollster alter column participants set default 'unknown';


-- Votes made by default zero to make the process easier if no vote added
alter table votes alter column obama set default '0';

alter table votes alter column macain set default '0';



-- drop table poll_date;
drop table if exists poll_date;
drop table if exists month_map;

commit;






