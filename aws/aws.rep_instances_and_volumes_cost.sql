drop procedure  aws.rep_instances_and_volumes_cost;
go
create procedure aws.rep_instances_and_volumes_cost(@ddate datetime)
as
begin
set dateformat dmy;
declare @year varchar(50), @month varchar(50);
declare @fname varchar(2048);
--declare @ddate datetime;

set @year=year(@ddate);
set @month=month(@ddate);
if month(@ddate)<10  
	set @month='0'+@month;
set @ddate='01.'+@month+'.'+@year;

declare @scale int;
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
select ResourceId, userName, sum(unBlendedCost) from aws.aws_billing_reports_detailed
	where LinkedAccountId='470567614800' and billing_date=@ddate
	group by ResourceId, userName
	having sum(unBlendedCost)>@scale;

select 
	(select instanceId from aws.aws_instances where id=insId) as InstanceId,
	(select instanceTag from aws.aws_instances where id=insId) as InstanceTag,
	(select volumeId from aws.aws_volumes where id=volId) as VolumeId,
	(select sum_BlendedCost from #aws_costs 
	where #aws_costs.ResourceId = isnull((select volumeId from aws.aws_volumes where id=volId),
										(select instanceId from aws.aws_instances where id=insId))) as Cost

from #aws_instances_volumes_virtual order by insId,volId;

drop table #aws_instances_volumes_virtual;
drop table #aws_costs;
end;
