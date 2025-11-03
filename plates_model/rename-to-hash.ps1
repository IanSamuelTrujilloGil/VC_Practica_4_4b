# Cambiar nombres de archivos a su hash + extensión
# Guarda este script como rename-to-hash.ps1 y ejecútalo en la carpeta deseada

# Puedes cambiar SHA256 por MD5 o SHA1 si prefieres
$hashAlgorithm = "SHA256"

# Obtener todos los archivos (sin incluir carpetas)
# Usa -Recurse si quieres hacerlo en subcarpetas
$scriptName = $MyInvocation.MyCommand.Name
$files = Get-ChildItem -File -Path . | Where-Object { $_.Name -ne $scriptName }

foreach ($file in $files) {
    try {
        # Calcular el hash del archivo
        $hash = Get-FileHash -Path $file.FullName -Algorithm $hashAlgorithm
        $hashString = $hash.Hash.ToLower()

        # Mantener la extensión original
        $extension = $file.Extension
        $baseName = "$hashString"
        $newName = "$baseName$extension"
        $counter = 1

        # Si ya existe un archivo con ese nombre, agregar sufijo incremental
        while (Test-Path -Path (Join-Path $file.DirectoryName $newName)) {
            $newName = "{0}_{1}{2}" -f $baseName, $counter, $extension
            $counter++
        }

        # Renombrar el archivo
        Rename-Item -Path $file.FullName -NewName $newName
        Write-Host "✅ Renombrado: $($file.Name) → $newName" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error procesando $($file.FullName): $_" -ForegroundColor Red
    }
}
