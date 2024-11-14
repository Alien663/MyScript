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


# change site credential and application credential
# -------------------------------------------------------------------------------
$olduser = "domain\account"
$newuser = "domain\account"
$password = "password"

# site
foreach($site in (Get-IISSite).Name){
    $site_creddential = ((Get-WebConfiguration -Filter "/system.applicationHost/sites/site[@name='$site']/application[@path='/']/virtualDirectory[@path='/']").Attributes | where Name -eq userName).Value
    if($site_creddential -eq $olduser){
        Set-WebConfiguration -Filter "/system.applicationHost/sites/site[@name='$site']/application[@path='/']/virtualDirectory[@path='/']" -Value @{userName=$newuser; password=$password}
    }
}

# application
foreach($app in (Get-WebApplication).path){
    $app_creddential = ((Get-WebConfiguration -Filter "/system.applicationHost/sites/site/application[@path='$app']/virtualDirectory").Attributes | where Name -eq userName).Value
    if($app_creddential -eq $olduser){
        Set-WebConfiguration -Filter "/system.applicationHost/sites/site/application[@path='$app']/virtualDirectory" -Value @{userName=$newuser; password=$password}
    }
}
# -------------------------------------------------------------------------------
