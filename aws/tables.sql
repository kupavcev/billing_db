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
	ReservedInstance varchar(5) NULL,
	ItemDescription varchar(1024) NULL,
	UsageStartDate datetime NULL,
	UsageEndDate datetime NULL,
	UsageQuantity numeric(18,4) NULL,
	BlendedRate numeric(18,4) NULL,
	BlendedCost numeric(18,4) NULL,
	UnBlendedRate numeric(18,4) NULL,
	UnBlendedCost numeric(18,4) NULL,
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

create table aws.aws_instances(
	id int primary key IDENTITY(1,1),
	instanceId varchar(255) not null,
	instanceTag varchar(1024)not null) on aws;
create index aws_instances_instanceId on aws.aws_instances(instanceId);

create table aws.aws_volumes(
	id int primary key IDENTITY(1,1),
	volumeId varchar(255) not null) on aws;
create index aws_volumes_volumeId on aws.aws_volumes(volumeId);
