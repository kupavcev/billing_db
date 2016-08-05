drop table #aws_billing_reports_detailed_n_tmp;
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
	[userName] varchar(max) NULL
)

BULK INSERT #aws_billing_reports_detailed_n_tmp
    FROM 'C:\AWS_Billing_Reports\Data\aws_billing_reports_detailed_2016-07.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = '","',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    ERRORFILE = 'C:\AWS_Billing_Reports\Data\aws_billing_reports_detailed.csv.err'--,
  --  TABLOCK
    );

	update  #aws_billing_reports_detailed_n_tmp set InvoiceID=replace(InvoiceId,'"',''), userName=replace(userName,'"','')



	insert into aws.aws_billing_reports_detailed(billing_date, InvoiceID, PayerAccountId, LinkedAccountId, RecordType, RecordId, 
		ProductName, RateId, SubscriptionId, PricingPlanId, UsageType, Operation, AvailabilityZone, ReservedInstance, ItemDescription, 
		UsageStartDate, UsageEndDate, UsageQuantity, BlendedRate, BlendedCost, UnBlendedRate, UnBlendedCost, ResourceId, userName)
	select cast('2016-07-01'as datetime),* from #aws_billing_reports_detailed_n_tmp;


	/*select '2016-07-01',* from #aws_billing_reports_detailed_n_tmp where ResourceId='i-1ea48d5f'
	and UsageStartDate='2016-07-02 02:00:00' and UsageEndDate='2016-07-02 03:00:00'*/
	
	
	--truncate table #aws_billing_reports_detailed_n_tmp;
		select distinct LinkedAccountId  from aws.aws_billing_reports_detailed


	select ResourceId, userName, ItemDescription, sum(BlendedCost) from aws.aws_billing_reports_detailed
	where LinkedAccountId='470567614800'
	group by ResourceId, userName, ItemDescription
	having sum(BlendedCost)>10
	order by sum(BlendedCost) desc;
