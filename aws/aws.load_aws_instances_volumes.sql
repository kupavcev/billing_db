drop procedure aws.load_aws_instances_volumes;
go
create procedure aws.load_aws_instances_volumes(@billing_date datetime)
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

create table #aws_instance_volumes_tmp(
	instanceId varchar(255),
	instanceTag varchar(1024),
	volumeId varchar(255));


BULK INSERT #aws_instance_volumes_tmp
    FROM 'C:\AWS_Billing_Reports\Data\aws_instance_info_nc.txt'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';|;',  --CSV field delimiter
    ROWTERMINATOR = '0x0d0a',   --Use to shift the control to next row
    ERRORFILE = 'C:\AWS_Billing_Reports\Data\aws_instance_info_nc.txt.err'--,
    );	

--truncate table aws.aws_instances;
insert into aws.aws_instances(instanceId,instanceTag)
select distinct instanceId, instanceTag from #aws_instance_volumes_tmp
where instanceId not in(select instanceId from #aws_instance_volumes_tmp);

update aws.aws_instances set aws.aws_instances.instanceTag=#aws_instance_volumes_tmp.instanceTag
from #aws_instance_volumes_tmp
where aws.aws_instances.instanceId=#aws_instance_volumes_tmp.instanceId and aws.aws_instances.instanceTag<>#aws_instance_volumes_tmp.instanceTag;

--truncate table aws.aws_volumes;
insert into aws.aws_volumes(volumeId)
select distinct volumeId from #aws_instance_volumes_tmp
where volumeId not in(select volumeId from #aws_instance_volumes_tmp);

delete from aws.aws_instances_volumes where ddate=@ddate;

insert into aws.aws_instances_volumes(ddate,insId,volId)
select @ddate, aws.aws_instances.id, aws.aws_volumes.id
from #aws_instance_volumes_tmp
join aws.aws_instances on #aws_instance_volumes_tmp.instanceId=aws.aws_instances.instanceId
join aws.aws_volumes on #aws_instance_volumes_tmp.volumeId=aws.aws_volumes.volumeId

drop table #aws_instance_volumes_tmp;
end;
