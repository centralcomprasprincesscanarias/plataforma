param(
    [string]$RepoPath = "C:\ruta\plataforma",
    [string]$SourceImage = "C:\ruta\logo.png"
)

$ErrorActionPreference = "Stop"

if (!(Test-Path $RepoPath)) { throw "No existe RepoPath: $RepoPath" }
if (!(Test-Path $SourceImage)) { throw "No existe SourceImage: $SourceImage" }

Add-Type -AssemblyName System.Drawing

function New-ResizedPng {
    param(
        [string]$InputPath,
        [string]$OutputPath,
        [int]$Size
    )

    $src = [System.Drawing.Image]::FromFile($InputPath)
    try {
        $bmp = New-Object System.Drawing.Bitmap $Size, $Size
        try {
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            try {
                $g.Clear([System.Drawing.Color]::Transparent)
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

                $ratio = [Math]::Min($Size / $src.Width, $Size / $src.Height)
                $newW = [int]([Math]::Round($src.Width * $ratio))
                $newH = [int]([Math]::Round($src.Height * $ratio))
                $x = [int](($Size - $newW) / 2)
                $y = [int](($Size - $newH) / 2)

                $g.DrawImage($src, $x, $y, $newW, $newH)
                $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
            }
            finally {
                $g.Dispose()
            }
        }
        finally {
            $bmp.Dispose()
        }
    }
    finally {
        $src.Dispose()
    }
}

function New-FaviconIco {
    param(
        [string]$InputPath,
        [string]$OutputPath
    )

    $tmpPng = Join-Path ([System.IO.Path]::GetDirectoryName($OutputPath)) "_favicon_tmp_32.png"
    New-ResizedPng -InputPath $InputPath -OutputPath $tmpPng -Size 32

    $fs = [System.IO.File]::Open($tmpPng, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    try {
        $pngBytes = New-Object byte[] $fs.Length
        [void]$fs.Read($pngBytes, 0, $fs.Length)
    }
    finally {
        $fs.Dispose()
    }

    $ms = New-Object System.IO.MemoryStream
    $bw = New-Object System.IO.BinaryWriter($ms)
    try {
        # ICONDIR
        $bw.Write([UInt16]0)   # reserved
        $bw.Write([UInt16]1)   # type = icon
        $bw.Write([UInt16]1)   # count = 1

        # ICONDIRENTRY
        $bw.Write([Byte]32)    # width
        $bw.Write([Byte]32)    # height
        $bw.Write([Byte]0)     # color count
        $bw.Write([Byte]0)     # reserved
        $bw.Write([UInt16]1)   # planes
        $bw.Write([UInt16]32)  # bitcount
        $bw.Write([UInt32]$pngBytes.Length)  # bytes in resource
        $bw.Write([UInt32]22)  # offset

        # image data (png)
        $bw.Write($pngBytes)
        [System.IO.File]::WriteAllBytes($OutputPath, $ms.ToArray())
    }
    finally {
        $bw.Dispose()
        $ms.Dispose()
    }

    Remove-Item $tmpPng -Force -ErrorAction SilentlyContinue
}

$icon192 = Join-Path $RepoPath "icon-192.png"
$icon512 = Join-Path $RepoPath "icon-512.png"
$favicon = Join-Path $RepoPath "favicon.ico"
$manifest = Join-Path $RepoPath "manifest.json"
$sw = Join-Path $RepoPath "sw.js"
$hub = Join-Path $RepoPath "hub.html"
$index = Join-Path $RepoPath "index.html"

New-ResizedPng -InputPath $SourceImage -OutputPath $icon192 -Size 192
New-ResizedPng -InputPath $SourceImage -OutputPath $icon512 -Size 512
New-FaviconIco -InputPath $SourceImage -OutputPath $favicon

$manifestJson = @'
{
  "name": "PLATAFORMA PRINCESS",
  "short_name": "PLATAFORMA PRINCESS",
  "start_url": "/plataforma/hub.html",
  "scope": "/plataforma/",
  "display": "standalone",
  "background_color": "#1a1510",
  "theme_color": "#1a1510",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
'@
Set-Content -Path $manifest -Value $manifestJson -Encoding UTF8

$swContent = @'
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", event => event.waitUntil(self.clients.claim()));
'@
Set-Content -Path $sw -Value $swContent -Encoding UTF8

function Add-PwaTags {
    param([string]$HtmlPath)

    if (!(Test-Path $HtmlPath)) { return }

    $html = Get-Content $HtmlPath -Raw -Encoding UTF8

    $tags = @'
  <link rel="icon" href="favicon.ico" sizes="any">
  <link rel="icon" type="image/png" sizes="192x192" href="icon-192.png">
  <link rel="apple-touch-icon" href="icon-192.png">
  <link rel="manifest" href="manifest.json">
  <meta name="theme-color" content="#1a1510">
'@

    if ($html -notmatch 'rel="manifest"') {
        $html = $html -replace '(?i)</head>', "$tags`r`n</head>"
    }

    if ($html -notmatch 'serviceWorker\.register') {
        $register = @'
<script>
if ("serviceWorker" in navigator) {
  window.addEventListener("load", function () {
    navigator.serviceWorker.register("sw.js").catch(function (err) {
      console.log("SW no registrado:", err);
    });
  });
}
</script>
'@
        $html = $html -replace '(?i)</body>', "$register`r`n</body>"
    }

    Set-Content $HtmlPath -Value $html -Encoding UTF8
}

Add-PwaTags -HtmlPath $hub
Add-PwaTags -HtmlPath $index

Write-Host ""
Write-Host "OK. Archivos creados/actualizados en:" -ForegroundColor Green
Write-Host $RepoPath
Write-Host " - favicon.ico"
Write-Host " - icon-192.png"
Write-Host " - icon-512.png"
Write-Host " - manifest.json"
Write-Host " - sw.js"
Write-Host " - hub.html"
Write-Host " - index.html"
Write-Host ""
Write-Host "Siguiente paso:" -ForegroundColor Yellow
Write-Host "1) git add ."
Write-Host '2) git commit -m "Icono PWA Princess"'
Write-Host "3) git push"
Write-Host "4) Espera 1-2 minutos y vuelve a instalar la app en Edge"
