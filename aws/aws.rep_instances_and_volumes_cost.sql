drop procedure  aws.rep_instances_and_volumes_cost;
go
create procedure aws.rep_instances_and_volumes_cost(@ddate datetime)
as
begin
-- set dateformat ymd
-- declare @ddate datetime = '2016-07-01';
declare @scale int;
set @ddate='2016-07-01';
set @scale=-1;

create table #aws_instances_volumes_virtual(
	id int  primary key IDENTITY(1,1),
	insId int,
	volId int);

create table #aws_costs(
	ResourceId varchar(255),
	userName varchar(512),
	sum_BlendedCost numeric(18,4));

insert into #aws_instances_volumes_virtual(insId,volId)
select distinct insId, null from aws.aws_instances_volumes where ddate=@ddate;

insert into #aws_instances_volumes_virtual(insId,volId)
select insId, volId from aws.aws_instances_volumes where ddate=@ddate;


insert into #aws_costs(ResourceId, userName, sum_BlendedCost)
select ResourceId, userName, sum(BlendedCost) from aws.aws_billing_reports_detailed
	where LinkedAccountId='470567614800' and billing_date=@ddate
	group by ResourceId, userName
	having sum(BlendedCost)>@scale;

select 
	(select instanceId from aws.aws_instances where id=insId),
	(select volumeId from aws.aws_volumes where id=volId),
	(select sum_BlendedCost from #aws_costs 
	where #aws_costs.ResourceId = isnull((select volumeId from aws.aws_volumes where id=volId),
										(select instanceId from aws.aws_instances where id=insId)))

from #aws_instances_volumes_virtual order by insId,volId;

drop table #aws_instances_volumes_virtual;
drop table #aws_costs;
end;
