CREATE TABLE aws.aws_billing_reports_detailed(
	id bigint primary key IDENTITY(1,1),
	billing_date datetime not null,
	InvoiceID varchar(50) NULL,
	PayerAccountId varchar(50) NULL,
	LinkedAccountId varchar(50) NULL,
	RecordType varchar(50) NULL,
	RecordId varchar(50) NULL,
	ProductName varchar(50) NULL,
	RateId varchar(50) NULL,
	SubscriptionId varchar(50) NULL,
	PricingPlanId varchar(50) NULL,
	UsageType varchar(50) NULL,
	Operation varchar(50) NULL,
	AvailabilityZone varchar(50) NULL,
	ReservedInstance varchar(50) NULL,
	ItemDescription varchar(1024) NULL,
	UsageStartDate datetime NULL,
	UsageEndDate datetime NULL,
	UsageQuantity varchar(50) NULL,
	BlendedRate varchar(50) NULL,
	BlendedCost varchar(50) NULL,
	UnBlendedRate varchar(50) NULL,
	UnBlendedCost varchar(50) NULL,
	ResourceId varchar(255) NULL,
	userName varchar(512) NULL
) ON aws

--drop table aws.aws_billing_reports_detailed;

create index aws_billing_reports_detailed_billing_date on aws.aws_billing_reports_detailed(billing_date);
create index aws_billing_reports_detailed_ResourceId on aws.aws_billing_reports_detailed(ResourceId);
create index aws_billing_reports_detailed_UsageStartDate  on aws.aws_billing_reports_detailed(UsageStartDate);
create index aws_billing_reports_detailed_UsageEndDate  on aws.aws_billing_reports_detailed(UsageEndDate);
create index aws_billing_reports_detailed_userName  on aws.aws_billing_reports_detailed(userName);
--create index aws_billing_reports_detailed_  on aws.aws_billing_reports_detailed( );
