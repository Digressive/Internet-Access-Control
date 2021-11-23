<#PSScriptInfo

.VERSION 20.03.18

.GUID 8b5b43ea-f1d3-4fbe-894e-0ce4f5dab51b

.AUTHOR Mike Galvin Contact: mike@gal.vin / twitter.com/mikegalvin_ Based on work by Peter Löfgren syscenramblings.wordpress.com

.COMPANYNAME Mike Galvin

.COPYRIGHT (C) Mike Galvin. All rights reserved.

.TAGS Internet Access Control Windows Firewall

.LICENSEURI

.PROJECTURI https://gal.vin/posts/internet-access-control-utility

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
    .SYNOPSIS
    Internet Access Control Utility - Control internet access with Windows Firewall

    .DESCRIPTION
    Block or allow internet access using Windows Firewall

    .PARAMETER Disable
    Create a Windows Firewall rule to block internet access using ports 80 and 443.

    .PARAMETER Enable
    Remove the Windows Firewall rule to block internet access.

    .PARAMETER NoBanner
    Use this option to hide the ASCII art title in the console.

    .PARAMETER L
    The path to output the log file to.
    The file name will be Inet-Access-Control_YYYY-MM-dd_HH-mm-ss.log
    Do not add a trailing \ backslash.

    .EXAMPLE
    Internet-Access-Control.ps1 -Disable -L C:\scripts\logs

    The above command will disable the internet access using Windows Firewall and the log file will be output to C:\scripts\logs.
#>

## Set up command line switches.
[CmdletBinding()]
Param(
    [alias("L")]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    $LogPath,
    [switch]$Enable,
    [switch]$Disable,
    [switch]$NoBanner)

If ($NoBanner -eq $False)
{
    Write-Host -Object ""
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "     ____     __                   __    ___                      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "    /  _/__  / /____ _______  ___ / /_  / _ |___________ ___ ___  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   _/ // _ \/ __/ -_) __/ _ \/ -_) __/ / __ / __/ __/ -_|_-<(_-<  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  /___/_//_/\__/\__/_/ /_//_/\__/\__/_/_/_|_\__/\__/\__/___/___/  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "   / ___/__  ___  / /________  / / / / / / /_(_) (_) /___ __      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  / /__/ _ \/ _ \/ __/ __/ _ \/ / / /_/ / __/ / / / __/ // /      "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "  \___/\___/_//_/\__/_/  \___/_/  \____/\__/_/_/_/\__/\_, /       "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                     /___/        "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                  "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "    Mike Galvin   https://gal.vin        Version 20.03.18         "
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "                                                                  "
    Write-Host -Object ""
}

## If logging is configured, start logging.
## If the log file already exists, clear it.
If ($LogPath)
{
    $LogFile = ("Inet-Access-Control_{0:yyyy-MM-dd_HH-mm-ss}.log" -f (Get-Date))
    $Log = "$LogPath\$LogFile"

    $LogT = Test-Path -Path $Log

    If ($LogT)
    {
        Clear-Content -Path $Log
    }

    Add-Content -Path $Log -Encoding ASCII -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") [INFO] Log started"
}

## Function to get date in specific format.
Function Get-DateFormat
{
    Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

## Function for logging.
Function Write-Log($Type, $Event)
{
    If ($Type -eq "Info")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [INFO] $Event"
        }

        Write-Host -Object "$(Get-DateFormat) [INFO] $Event"
    }

    If ($Type -eq "Succ")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [SUCCESS] $Event"
        }

        Write-Host -ForegroundColor Green -Object "$(Get-DateFormat) [SUCCESS] $Event"
    }

    If ($Type -eq "Err")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [ERROR] $Event"
        }

        Write-Host -ForegroundColor Red -BackgroundColor Black -Object "$(Get-DateFormat) [ERROR] $Event"
    }

    If ($Type -eq "Conf")
    {
        If ($Null -ne $LogPath)
        {
            Add-Content -Path $Log -Encoding ASCII -Value "$Event"
        }

        Write-Host -ForegroundColor Cyan -Object "$Event"
    }
}

##
## Display the current config and log if configured.
##
Write-Log -Type Conf -Event "************ Running with the following config *************."
Write-Log -Type Conf -Event "Hostname:..............$env:computername."
If ($Disable)
{
   Write-Log -Type Conf -Event "Net access will be:....Blocked."
}

If ($Enable)
{
   Write-Log -Type Conf -Event "Net access will be:....Allowed."
}

If ($Null -ne $LogPath)
{
    Write-Log -Type Conf -Event "Logs directory:........$LogPath."
}

else {
    Write-Log -Type Conf -Event "Logs directory:........No Config"
}

Write-Log -Type Conf -Event "************************************************************"
Write-Log -Type Info -Event "Process started"
##
## Display current config ends here.
##

## Test if the rule already exists
$RuleExist = Get-NetFirewallRule -DisplayName "Internet-Access-Control-Block"

If ($Null -eq $RuleExist)
{
    ## If the -Disable switch is used, the script adds a Firewall Rule to block traffic on ports 80 (http) and 443 (https).
    If ($Disable)
    {
        Write-Log -Type Info -Event "Creating rule Internet-Access-Control-Block"
        New-NetFirewallRule -DisplayName "Internet-Access-Control-Block" -Enabled True -Direction Outbound -Profile Any -Action Block -Protocol TCP -RemotePort 80,443 | Out-Null
    }

    If ($Enable)
    {
        Write-Log -Type Err -Event "The rule Internet-Access-Control-Block does not exist"
    }
}

else {
    If ($Disable)
    {
        Write-Log -Type Err -Event "The rule Internet-Access-Control-Block already exists"
    }

    ## If the -Enable switch is used, the script removes the Firewall Rule created above.
    If ($Enable)
    {
        Write-Log -Type Info -Event "Removing rule Internet-Access-Control-Block"
        Get-NetFirewallRule -DisplayName "Internet-Access-Control-Block" | Remove-NetFirewallRule
    }
}

Write-Log -Type Info -Event "Process finished"

## If logging is configured then finish the log file.
If ($LogPath)
{
    Add-Content -Path $Log -Encoding ASCII -Value "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") [INFO] Log finished"
}

## End