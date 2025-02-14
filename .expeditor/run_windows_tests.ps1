# Stop script execution when a non-terminating error occurs
$ErrorActionPreference = "Stop"

## temp fix for docker container ##
choco install vcredist140 -y 

# This will run ruby test on windows platform

Write-Output "--- Bundle install"
ruby --version
bundler --version
gem update --system
If ($lastexitcode -ne 0) { Exit $lastexitcode }

bundle config --local path vendor/bundle
If ($lastexitcode -ne 0) { Exit $lastexitcode }

bundle install --jobs=7 --retry=3
If ($lastexitcode -ne 0) { Exit $lastexitcode }

Write-Output "--- Bundle Execute rake"

bundle exec rake 
If ($lastexitcode -ne 0) { Exit $lastexitcode }