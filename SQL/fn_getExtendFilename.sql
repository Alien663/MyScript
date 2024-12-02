create or alter function fn_getExtendFilename(@fullpath varchar(512))
returns varchar(10)
as
begin
    declare @filename varchar(512) = reverse(SUBSTRING(reverse(@fullpath), 1, charindex('\', reverse(@fullpath))-1))
    return reverse(SUBSTRING(reverse(@filename), 1, charindex('.', reverse(@filename))))
end
go
