drop procedure  aws.rep_other_cost;
go
create procedure aws.rep_other_cost(@ddate datetime)
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

select ItemDescription as rDescription, sum(BlendedCost) as Cost from aws.aws_billing_reports_detailed
	where LinkedAccountId='470567614800' and billing_date=@ddate and ResourceId is null and ItemDescription <> 'Total for linked account# 470567614800'
	group by ResourceId, userName, ItemDescription
	having sum(BlendedCost)>0
	order by sum(BlendedCost) desc

end;
