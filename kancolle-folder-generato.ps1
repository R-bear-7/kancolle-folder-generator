# ===== 基本フォルダ =====
$baseFolderPath = "$env:USERPROFILE\Documents\艦これ\イベント"

# ===== 日付取得 =====
$currentDate = Get-Date
$currentYear = $currentDate.Year
$month = $currentDate.Month

# ===== 季節判定 =====
if ($month -ge 3 -and $month -le 5) {
    $season = "春"
} elseif ($month -ge 6 -and $month -le 8) {
    $season = "夏"
} elseif ($month -ge 9 -and $month -le 11) {
    $season = "秋"
} else {
    $season = "冬"
}

# ===== フォルダ名 =====
$mainFolderName = "$currentYear$season"
$fullFolderPath = Join-Path $baseFolderPath $mainFolderName

# ===== メインフォルダ作成 =====
if (!(Test-Path $fullFolderPath)) {
    New-Item -ItemType Directory -Path $fullFolderPath | Out-Null
}

# ===== 入力（フォルダ数）=====
Add-Type -AssemblyName Microsoft.VisualBasic
$input = [Microsoft.VisualBasic.Interaction]::InputBox(
    "いくつの海域フォルダを作成しますか？",
    "フォルダ数入力",
    "7"
)

# ===== 入力チェック =====
if (-not ($input -match '^\d+$')) {
    Write-Host "数値を入力してください"
    pause
    exit
}

$maxCount = [int]$input

if ($maxCount -le 0) {
    Write-Host "1以上の数値を入力してください"
    pause
    exit
}

# ===== ループ処理 =====
for ($i = 1; $i -le $maxCount; $i++) {

    $subFolderName = "E$i"
    $subFolderPath = Join-Path $fullFolderPath $subFolderName
    $textFilePath = Join-Path $subFolderPath "dummy.txt"

    # フォルダ作成
    if (!(Test-Path $subFolderPath)) {
        New-Item -ItemType Directory -Path $subFolderPath | Out-Null
    }

    # ファイル作成
    if (!(Test-Path $textFilePath)) {
        New-Item -ItemType File -Path $textFilePath | Out-Null
    }
}

Write-Host "作成完了: $fullFolderPath"
pause