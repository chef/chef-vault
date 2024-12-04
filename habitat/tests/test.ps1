param (
    [Parameter()]
    [string]$PackageIdentifier = $(throw "Usage: test.ps1 [test_pkg_ident] e.g. test.ps1 ci/user-windows/1.0.0/20190812103929")
)


Write-Host "--- :fire: Smokish test"
# Pester the Package
$version=hab pkg exec "${pkg_ident}" chef-vault -v
$actual_version=[Regex]::Match($version,"([0-9]+.[0-9]+.[0-9]+)").Value
$package_version=$PackageIdentifier.split("/",4)[2]

Write-Host "package_version  $package_version actual version $actual_version"
if ($package_version -eq $actual_version)
{
    Write "Chef-cli working fine"
}
else {
    Write-Error "chef-cli version not met expected $package_version actual version $actual_version "
    throw "Chef cli windows pipeline not working for hab pkg"
}
