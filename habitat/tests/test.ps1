param (
    [Parameter()]
    [string]$PackageIdentifier = $(throw "Usage: test.ps1 [test_pkg_ident] e.g. test.ps1 ci/user-windows/1.0.0/20190812103929")
)


Write-Host "--- :fire: Smokish test"
# Pester the Package
$help_message=hab pkg exec "${pkg_ident}" -- chef-vault -h
$original_message="Usage: chef-vault"

Write-Host "Checking the help message of the package"
if ($help_message -like $original_message)
{
    Write "Chef-vault is working fine"
}
else {
    Write-Error "chef-vault binary doesn't return the correct usage message "
    throw "Chef-vault windows pipeline not working for hab pkg"
}
