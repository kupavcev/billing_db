drop procedure aws.load_billing_reports_detailed;
go
create procedure aws.load_billing_reports_detailed(@billing_date datetime)
as
begin
set dateformat dmy;
declare @year varchar(50), @month varchar(50);
declare @fname varchar(2048);
declare @ddate datetime;

set @year=year(@billing_date);
set @month=month(@billing_date);
if month(@billing_date)<10  
	set @month='0'+@month;
set @ddate='01.'+@month+'.'+@year;

set @fname='C:\AWS_Billing_Reports\Data\aws_billing_reports_detailed_'+@year+'-'+@month+'.csv';

--select @ddate;
--select 'C:\AWS_Billing_Reports\Data\aws_billing_reports_detailed_'+@year+'-'+@month+'.csv';


create table #aws_billing_reports_detailed_n_tmp(
	[InvoiceID] [varchar](50) NULL,
	[PayerAccountId] [varchar](50) NULL,
	[LinkedAccountId] [varchar](50) NULL,
	[RecordType] [varchar](50) NULL,
	[RecordId] [varchar](50) NULL,
	[ProductName] [varchar](50) NULL,
	[RateId] [varchar](50) NULL,
	[SubscriptionId] [varchar](50) NULL,
	[PricingPlanId] [varchar](50) NULL,
	[UsageType] [varchar](50) NULL,
	[Operation] [varchar](50) NULL,
	[AvailabilityZone] [varchar](50) NULL,
	[ReservedInstance] [varchar](50) NULL,
	[ItemDescription] varchar(max) NULL,
	[UsageStartDate] [varchar](50) NULL,
	[UsageEndDate] [varchar](50) NULL,
	[UsageQuantity] [varchar](50) NULL,
	[BlendedRate] [varchar](50) NULL,
	[BlendedCost] [varchar](50) NULL,
	[UnBlendedRate] [varchar](50) NULL,
	[UnBlendedCost] [varchar](50) NULL,
	[ResourceId] varchar(max) NULL,
	[userName] varchar(max) NULL);

DECLARE @sql NVARCHAR(4000) = 'BULK INSERT #aws_billing_reports_detailed_n_tmp
    FROM '''+@fname+'''
    WITH
    (FIRSTROW = 2,
    FIELDTERMINATOR = ''","'',
    ROWTERMINATOR = ''0x0a'');';
exec(@sql);

	update  #aws_billing_reports_detailed_n_tmp set InvoiceID=replace(InvoiceId,'"',''), userName=replace(userName,'"','')


	delete from aws.aws_billing_reports_detailed
	where billing_date=@ddate;
	set dateformat ymd;
	
	insert into aws.aws_billing_reports_detailed(billing_date, InvoiceID, PayerAccountId, LinkedAccountId, RecordType, RecordId, 
		ProductName, RateId, SubscriptionId, PricingPlanId, UsageType, Operation, AvailabilityZone, ReservedInstance, ItemDescription, 
		UsageStartDate, UsageEndDate, UsageQuantity, BlendedRate, BlendedCost, UnBlendedRate, UnBlendedCost, ResourceId, userName)
	select @ddate,* from #aws_billing_reports_detailed_n_tmp;

drop table #aws_billing_reports_detailed_n_tmp;
end;
