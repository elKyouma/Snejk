function DrawMap
{
    process {
        Write-Host "`n`n" -BackgroundColor black -NoNewline
        $map = ""
        for($y=1; $y -le 10; $y++)
        {
            for($x=1; $x -le 10; $x++)
            {
                $snejk = $false;
                foreach ($player in $global:player)
                {
                    if($player.X -eq $x -and $player.Y -eq $y)
                    {    
                        $snejk = $true
                    }
                }
                
                if($snejk -eq $true)
                {
                    Write-Host $map -BackgroundColor black -NoNewline
                    $map = ""
                    Write-Host "  " -BackgroundColor white -NoNewline
                }
                elseif($x -eq $global:appleX -and $y -eq $global:appleY)
                {
                    Write-Host $map -BackgroundColor black -NoNewline
                    $map = "";
                    Write-Host "  " -BackgroundColor red -NoNewline
                }
                else
                {
                    $map += "  "
                }
            }
            Write-Host $map -BackgroundColor black -NoNewline
            $map = "";
            Write-Host "`n" -BackgroundColor black -NoNewline
        }
    }
}

function ReadInputs
{
    process{
        while([Console]::KeyAvailable)
        {
            $keyInfo = [Console]::ReadKey($true)

            if($keyInfo.Key -eq [ConsoleKey]::DownArrow) 
            {
                $global:dy = 1
                $global:dx = 0
            }
            if($keyInfo.Key -eq [ConsoleKey]::UpArrow) 
            {
                $global:dy = -1
                $global:dx = 0
            }
            if($keyInfo.Key -eq [ConsoleKey]::LeftArrow) 
            {
                $global:dy = 0
                $global:dx = -1
            }
            if($keyInfo.Key -eq [ConsoleKey]::RightArrow) 
            {
                $global:dy = 0
                $global:dx = 1
            }
        }
    }
}

function SpawnApple()
{
    $global:appleX = Get-Random -Minimum 1 -Maximum 10
    $global:appleY = Get-Random -Minimum 1 -Maximum 10
    for($I = $global:player.Length - 1; $I -gt -1; $I--)
    {
        if($global:appleX -eq $global:player[$I].X -and $global:appleY -eq $global:player[$I].Y){
            SpawnApple
        }
    }
}

$global:player = @([pscustomobject]@{X=5;Y=5})

$global:dx = 1
$global:dy = 0

SpawnApple

$dontexit = $true
do{
    for($I = $global:player.Length - 1; $I -gt 0; $I--)
    {
        $global:player[$I].X = $global:player[$I-1].X
        $global:player[$I].Y = $global:player[$I-1].Y 
    }
    
    ReadInputs
    $global:player[0].X = ($global:player[0].X + $global:dx - 1 + 10) % 10 + 1
    $global:player[0].Y = ($global:player[0].Y + $global:dy - 1 + 10) % 10 + 1
    
    for($I = $global:player.Length - 1; $I -gt 0; $I--)
    {
        if($global:player[0].X -eq $global:player[$I].X -and $global:player[0].Y -eq $global:player[$I].Y){
            $dontexit = $false;
        }
    }

    if($global:player[0].X -eq $global:appleX -and $global:player[0].Y -eq $global:appleY){
        SpawnApple
        $global:player += New-Object PSObject -Property @{X=$global:player[0].X;Y=$global:player[0].Y}
    }

    cls
    DrawMap

    Start-Sleep -m 200
} while ($dontexit)
$global:player | Format-table | echo
