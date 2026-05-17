# Run the Spring Boot backend with local file paths for image serving.
# Usage (from this directory): .\start-local.ps1

$env:UPLOAD_DIR = "C:/images/"
$env:BASE_URL   = "http://localhost:8080"

Write-Host "Starting EduSuperNova backend (local)..."
Write-Host "  UPLOAD_DIR = $env:UPLOAD_DIR"
Write-Host "  BASE_URL   = $env:BASE_URL"

mvn spring-boot:run
