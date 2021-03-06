param(
     [switch]$GetDropboxUrlFromDoc = $false
    ,[switch]$ConfirmDownload = $false
    ,[switch]$NoChangelog = $false
    ,[string]$DocUrl = "https://staxrip.readthedocs.io/introduction.html"
    ,[string]$DropboxUrl = "https://www.dropbox.com/sh/4ctl2y928xkak4f/AAADEZj_hFpGQaNOdd3yqcAHa?dl=0&lst="
    ,[string]$ChangelogUrl = "https://github.com/staxrip/staxrip/blob/master/Changelog.md"
    ,[string]$DownloadDirectory = (Get-Location | Select -exp Path)
)

# Constants
$ScriptVersion    = "v1.3"

$COLORLINE             = [ConsoleColor]::Green
$COLORHEADER           = [ConsoleColor]::Green
$COLORFOOTER           = [ConsoleColor]::Green
$COLORDROPBOX          = [ConsoleColor]::Yellow
$COLORQUESTION         = [ConsoleColor]::Gray
$COLORCHANGELOG        = [ConsoleColor]::White
$COLORCHANGELOGENTRY   = [ConsoleColor]::Cyan
$COLORSKIP             = [ConsoleColor]::DarkCyan


function Main{
    try
    {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        if( $GetDropboxUrlFromDoc )
        {
            $WR = Invoke-WebRequest -Uri $DocUrl
            $DB = $WR.content | Select-String "(https://www.dropbox.com[^""]*)""" -AllMatches

            if( $DB.Matches.Count -gt 0 )
            {
                $DropboxUrl = $DB.Matches[0].Groups[1].Value
            }
        }

        $out = "Using Dropbox URL: {0}" -f $DropboxUrl
        Write-Host -ForegroundColor $COLORDROPBOX $out

        $WR = Invoke-WebRequest -Uri $DropboxUrl
        $SR = $WR.content | Select-String  "(https://[^""]*/([^""/]*StaxRip[^""/?]*x64[^""?]*)[^""]*)\\""" -AllMatches

        if( $SR.Matches.Count -gt 0 )
        {
            $matches   = $SR.Matches
            $matches   = $matches | Sort-Object -Unique -Property @{ Expression={[Regex]::replace( $_.Groups[2].Value, "\d+", "$&".PadLeft(11,'0') )}; Descending=$false; }
            $lastMatch = $matches | Select -Last 1

            $url = $lastMatch.Groups[1].Value -replace "\?dl=0","\?dl=1"
            $filename = $lastMatch.Groups[2].Value
            $downloadPath = [System.IO.Path]::Combine($DownloadDirectory, $filename)
            $version = ($filename | Select-String ".*(\d+\.\d+\.\d+\.\d+).*" -AllMatches).Matches.Groups[1]

            Write-Host
            $out = "Latest version: {0}" -f $version
            Write-Host -ForegroundColor $COLORDROPBOX $out
            $out = "           URL: {0}" -f $url
            Write-Host -ForegroundColor $COLORDROPBOX $out
            $out = "      Filename: {0}" -f $filename
            Write-Host -ForegroundColor $COLORDROPBOX $out
            $out = "       Save as: {0}" -f $downloadPath
            Write-Host -ForegroundColor $COLORDROPBOX $out
            Write-Host
            
            if( [System.IO.File]::Exists($downloadPath) )
            {
                $out = "The lastest version already exists. Skipping download..."
                Write-Host -ForegroundColor $COLORSKIP $out
            }
            else
            {
                $proceedDownload = $true
                if( $ConfirmDownload )
                {
                    $out = "Do you want to download '{0}'? (y)es or any key to abort: " -f $filename
                    Write-Host -ForegroundColor $COLORQUESTION -NoNewline $out
                    $readKey = $Host.UI.RawUI.ReadKey()
                    Write-Host

                    if( $readKey.Key -ne 'y' )
                    {
                        $proceedDownload = $false
                    }
                }

                if( $proceedDownload )
                {
                    if( -not (Test-Path -LiteralPath $DownloadDirectory -PathType Container) )
                    {
                        $out = "Creating directory '{0}'..." -f $DownloadDirectory
                        Write-Host -ForegroundColor $COLORDROPBOX $out

                        New-Item -ItemType Directory -Path $DownloadDirectory | Out-Null
                    }

                    if( -not ($NoChangelog) )
                    {
                        $out = "Changes in this version:"
                        Write-Host -ForegroundColor $COLORCHANGELOG $out

                        $WR = Invoke-WebRequest -Uri $ChangelogUrl

                        $split = $WR.content -split "<h1>" | Where{ $_ -match $version }
                        $split = $split -replace "<a[^>]*>",""
                        $split = $split -replace "</a>",""
                        $split = $split -replace "`r",""
                        $split = $split -replace "`n"," "

                        $matches = $split | Select-String '<li>((?!</li>).)*</li>' -AllMatches

                        foreach( $match in $matches.Matches )
                        {
                            $value = $match.Groups[0].Value
                            $m = $value | Select-String '<li>(.*)</li>' -AllMatches
                            $content = $m.Matches.Groups[1].Value

                            if( -not ($content.StartsWith("     ") ) )
                            {
                                $out = "· " + $content
                                Write-Host -ForegroundColor $COLORCHANGELOGENTRY $out
                            }
                        }

                        Write-Host
                    }


                    $out = "Downloading, please be patient..."
                    Write-Host -ForegroundColor $COLORDROPBOX $out

                    #Invoke-WebRequest -Uri $url -OutFile $downloadPath
                    (New-Object System.Net.WebClient).DownloadFile( $url, $downloadPath )
                }
                else
                {
                    $out = "Aborting..."
                    Write-Host -ForegroundColor $COLORSKIP $out
                }
            }

            $out = "Done."
            Write-Host -ForegroundColor $COLORFOOTER $out
        }
    }
    catch 
    {
        Write-Host -ForegroundColor ([ConsoleColor]::DarkRed) $_
    }
    finally
    {

    }

    Write-Host
    $out = "-----"
    #Write-Host -ForegroundColor $COLORFOOTER ("  " + $out)
    $out = "¯" * $out.Length
    #Write-Host -ForegroundColor $COLORFOOTER ("  " + $out)
}



Write-Host -ForegroundColor $COLORLINE ("·" * 80)
Write-Host -ForegroundColor $COLORHEADER ("  " + "StaxripBetaDownload " + $ScriptVersion)
Write-Host -ForegroundColor $COLORLINE ("·" * 80)
Main
