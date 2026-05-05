Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===== フォーム作成 =====
$form = New-Object System.Windows.Forms.Form
$form.Text = "イベントフォルダ作成ツール"
$form.Size = New-Object System.Drawing.Size(400,250)
$form.StartPosition = "CenterScreen"

# ===== フォルダ選択ラベル =====
$labelPath = New-Object System.Windows.Forms.Label
$labelPath.Text = "保存先フォルダ:"
$labelPath.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($labelPath)

# ===== パス表示 =====
$textPath = New-Object System.Windows.Forms.TextBox
$textPath.Size = New-Object System.Drawing.Size(260,20)
$textPath.Location = New-Object System.Drawing.Point(10,45)
$form.Controls.Add($textPath)

# ===== 参照ボタン =====
$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "参照"
$btnBrowse.Location = New-Object System.Drawing.Point(280,43)

$btnBrowse.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dialog.ShowDialog() -eq "OK") {
        $textPath.Text = $dialog.SelectedPath
    }
})
$form.Controls.Add($btnBrowse)

# ===== 数値入力 =====
$labelNum = New-Object System.Windows.Forms.Label
$labelNum.Text = "フォルダ数:"
$labelNum.Location = New-Object System.Drawing.Point(10,85)
$form.Controls.Add($labelNum)

$numBox = New-Object System.Windows.Forms.NumericUpDown
$numBox.Minimum = 1
$numBox.Maximum = 20
$numBox.Value = 7
$numBox.Location = New-Object System.Drawing.Point(100,83)
$form.Controls.Add($numBox)

# ===== 実行ボタン =====
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "作成"
$btnRun.Size = New-Object System.Drawing.Size(100,30)
$btnRun.Location = New-Object System.Drawing.Point(140,130)

$btnRun.Add_Click({

    if ([string]::IsNullOrWhiteSpace($textPath.Text)) {
        [System.Windows.Forms.MessageBox]::Show("フォルダを選択してください")
        return
    }

    $baseFolderPath = $textPath.Text
    $maxCount = $numBox.Value

    # ===== 日付取得 =====
    $currentDate = Get-Date
    $year = $currentDate.Year
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

    $mainFolder = Join-Path $baseFolderPath "$year$season"

    if (!(Test-Path $mainFolder)) {
        New-Item -ItemType Directory -Path $mainFolder | Out-Null
    }

    for ($i = 1; $i -le $maxCount; $i++) {
        $subFolder = Join-Path $mainFolder "E$i"
        if (!(Test-Path $subFolder)) {
            New-Item -ItemType Directory -Path $subFolder | Out-Null
        }

        $file = Join-Path $subFolder "dummy.txt"
        if (!(Test-Path $file)) {
            New-Item -ItemType File -Path $file | Out-Null
        }
    }

    [System.Windows.Forms.MessageBox]::Show("作成完了！")
})

$form.Controls.Add($btnRun)

# ===== 表示 =====
$form.Topmost = $true
$form.ShowDialog()