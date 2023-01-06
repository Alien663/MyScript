# change the account that run the IIS AppPool
# -------------------------------------------------------------------------------
$username = "domain\account"
$password = "password"
Import-Module WebAdministration
foreach($pools in (Get-IISAppPool).Name){
    $iden = Get-ItemProperty ("IIS:\AppPools\" + $pools) -name processModel.identityType
    if($iden -eq $username){
        echo $pools
        #Set-ItemProperty ("IIS:\AppPools\" + $pools) -name processModel.password -Value $password
    }
}
# -------------------------------------------------------------------------------
