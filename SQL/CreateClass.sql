/*
 *                     _______
 * /           \ -----|       |
 *  Inheritance       | Class |
 * \           / -----|_______|
 */

create table Class
(
    CID int identity(1, 1),
    [Name] nvarchar(64),
    [Description] nvarchar(512),
    IDPath varchar(128),
    NamePath varchar(512),
    nLevel int,
    Since datetime default(getdate()),
    LastUpdate datetime default(getdate()),
    constraint PK_Class primary key(CID)
)

create table Inheritance
(
    PCID int,
    CCID int,
    constraint PK_Inheritance primary key(PCID, CCID),
    constraint FK_Inheritance_PCID foreign key(PCID) references Class(CID),
    constraint FK_Inheritance_CCID foreign key(CCID) references Class(CID)
)
go