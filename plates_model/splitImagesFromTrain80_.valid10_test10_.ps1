# --- split-dataset.ps1 ---
# Divide aleatoriamente el contenido de la carpeta "train" en "valid" y "test"
# Mueve 10% de las imágenes a cada una

# Configura las rutas
$trainDir = ".\train"
$validDir = ".\valid"
$testDir  = ".\test"

# Crear las carpetas si no existen
if (!(Test-Path $validDir)) { New-Item -ItemType Directory -Path $validDir | Out-Null }
if (!(Test-Path $testDir))  { New-Item -ItemType Directory -Path $testDir  | Out-Null }

# Obtener todas las imágenes (extensiones comunes)
$images = Get-ChildItem -Path $trainDir -Include *.jpg, *.jpeg, *.png, *.bmp, *.gif -Recurse

# Mezclar aleatoriamente
$shuffled = $images | Get-Random -Count $images.Count

# Calcular cantidades
$total = $shuffled.Count
$validCount = [math]::Floor($total * 0.1)
$testCount  = [math]::Floor($total * 0.1)

# Seleccionar subconjuntos
$validSet = $shuffled[0..($validCount - 1)]
$testSet  = $shuffled[$validCount..($validCount + $testCount - 1)]

# Mover imágenes a valid
foreach ($img in $validSet) {
    Move-Item -Path $img.FullName -Destination (Join-Path $validDir $img.Name)
}

# Mover imágenes a test
foreach ($img in $testSet) {
    Move-Item -Path $img.FullName -Destination (Join-Path $testDir $img.Name)
}

Write-Host "✅ División completa:"
Write-Host " - Moved $($validSet.Count) imágenes a VALID"
Write-Host " - Moved $($testSet.Count) imágenes a TEST"
Write-Host " - Quedan $($total - $validSet.Count - $testSet.Count) en TRAIN"
