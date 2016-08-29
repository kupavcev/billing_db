drop procedure  aws.rep_noinstance_volumes_cost;
go
create procedure aws.rep_noinstance_volumes_cost(@ddate datetime)
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


select ResourceId as volumeId,ItemDescription as rDescription,username as volumeTag,sum(BlendedCost) as Cost 
from aws.aws_billing_reports_detailed
	where LinkedAccountId='470567614800' and billing_date=@ddate 
	--and ResourceId is null 
	and (ResourceId like 'vol%' or ResourceId like 'i%') 
	and ItemDescription <> 'Total for linked account# 470567614800'
	and (ResourceId not in(select volumeId from aws.aws_volumes) and 
	ResourceId not in(select instanceId from aws.aws_instances))
	group by ResourceId, userName, 	ItemDescription, username
	having sum(BlendedCost)>0
	order by sum(BlendedCost) desc
end;
