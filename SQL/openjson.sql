declare @json varchar(max) = '[
    {
        "Name": "Alien",
        "Value": "663",
        "Experinces": [
            {
                "Year Old": "10",
                "Event": "Arrive Earth"
            },
            {
                "Year Old": "15",
                "Event": "Arrive LV-426"
            },
            {
                "Year Old": "20",
                "Event": "Be killed by Facehugger"
            }
        ]
    },
    {
        "Name": "Xenomorph",
        "Value": "426",
        "Experinces":[
            {
                "Year Old": "5",
                "Event": "Kill Alien No.663"
            }
        ]
    }
]'
select * from openjson(@json)

select * from openjson(@json)
with(
	[NickName] varchar(20) '$.Name',
	[No] varchar(20) '$.Value',
	[FirstEventYearOld] varchar(100) '$.Experinces[0].Event'
)

create table #temp(
	TID int identity(1, 1),
	Origin_Content varchar(max)
)

insert into #temp(Origin_Content)
	select value from openjson(@json)

alter table #temp add J_Name as JSON_VALUE(Origin_Content, '$.Name')
select * from #temp
