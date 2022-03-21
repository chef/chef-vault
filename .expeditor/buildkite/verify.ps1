echo "--- system details"
$Properties = 'Caption', 'CSName', 'Version', 'BuildType', 'OSArchitecture'
Get-CimInstance Win32_OperatingSystem | Select-Object $Properties | Format-Table -AutoSize
ruby -v
bundle --version

echo "--- bundle install"
bundle config --local path vendor/bundle
bundle config set --local without tools integration
bundle install --jobs=7 --retry=3

echo "+++ bundle exec rake"
bundle exec rake

exit $LASTEXITCODE
