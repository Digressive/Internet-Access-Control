<#PSScriptInfo

.VERSION 23.04.28

.GUID 8b5b43ea-f1d3-4fbe-894e-0ce4f5dab51b

.AUTHOR Mike Galvin Contact: mike@gal.vin  Based on work by Peter Löfgren syscenramblings.wordpress.com

.COMPANYNAME Mike Galvin

.COPYRIGHT (C) Mike Galvin. All rights reserved.

.TAGS Internet Access Control Windows Firewall

.LICENSEURI

.PROJECTURI https://gal.vin/utils/internet-access-control-utility/

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
    Run with -help or no arguments for usage.
#>

## Set up command line switches.
[CmdletBinding()]
Param(
    [alias("L")]
    $LogPathUsr,
    [alias("LogRotate")]
    $LogHistory,
    [switch]$Enable,
    [switch]$Disable,
    [switch]$Help,
    [switch]$NoBanner)

If ($NoBanner -eq $False)
{
    Write-Host -ForegroundColor Yellow -BackgroundColor Black -Object "
           ____     __                   __    ___                        
          /  _/__  / /____ _______  ___ / /_  / _ |___________ ___ ___    
         _/ // _ \/ __/ -_) __/ _ \/ -_) __/ / __ / __/ __/ -_|_-<(_-<    
        /___/_//_/\__/\__/_/ /_//_/\__/\__/_/_/_|_\__/\__/\__/___/___/    
         / ___/__  ___  / /________  / / / / / / /_(_) (_) /___ __        
        / /__/ _ \/ _ \/ __/ __/ _ \/ / / /_/ / __/ / / / __/ // /        
        \___/\___/_//_/\__/_/  \___/_/  \____/\__/_/_/_/\__/\_, /         
                                                           /___/          
          Mike Galvin             Version 23.04.28                        
        https://gal.vin          See -help for usage                      
                                                                          
                   Donate: https://www.paypal.me/digressive               
"
}

If ($PSBoundParameters.Values.Count -eq 0 -or $Help)
{
    Write-Host -Object "Usage:
    From an elevated terminal run: [path\]Internet-Access-Control.ps1 -Disable to create a
    Windows Firewall rule to block internet access using ports 80 and 443.

    Use -Enable to remove the Windows Firewall rule and enable internet access.

    To output a log: -L [path\].
    To remove logs produced by the utility older than X days: -LogRotate [number].
    Run with no ASCII banner: -NoBanner"
}

else {
    ## If logging is configured, start logging.
    ## If the log file already exists, clear it.
    If ($LogPathUsr)
    {
        ## Clean User entered string
        $LogPath = $LogPathUsr.trimend('\')

        ## Make sure the log directory exists.
        If ((Test-Path -Path $LogPath) -eq $False)
        {
            New-Item $LogPath -ItemType Directory -Force | Out-Null
        }

        $LogFile = ("Inet-Access-Control_{0:yyyy-MM-dd_HH-mm-ss}.log" -f (Get-Date))
        $Log = "$LogPath\$LogFile"

        If (Test-Path -Path $Log)
        {
            Clear-Content -Path $Log
        }
    }

    ## Function to get date in specific format.
    Function Get-DateFormat
    {
        Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    ## Function for logging.
    Function Write-Log($Type, $Evt)
    {
        If ($Type -eq "Info")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [INFO] $Evt"
            }

            Write-Host -Object "$(Get-DateFormat) [INFO] $Evt"
        }

        If ($Type -eq "Succ")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [SUCCESS] $Evt"
            }

            Write-Host -ForegroundColor Green -Object "$(Get-DateFormat) [SUCCESS] $Evt"
        }

        If ($Type -eq "Err")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$(Get-DateFormat) [ERROR] $Evt"
            }

            Write-Host -ForegroundColor Red -BackgroundColor Black -Object "$(Get-DateFormat) [ERROR] $Evt"
        }

        If ($Type -eq "Conf")
        {
            If ($LogPathUsr)
            {
                Add-Content -Path $Log -Encoding ASCII -Value "$Evt"
            }

            Write-Host -ForegroundColor Cyan -Object "$Evt"
        }
    }

    ## Test if any options are set
    If ($Disable -eq $false -And $Enable -eq $false)
    {
        Write-Log -Type Err -Evt "No options set."
        Exit
    }

    ## Getting Windows Version info
    $OSVMaj = [environment]::OSVersion.Version | Select-Object -expand major
    $OSVMin = [environment]::OSVersion.Version | Select-Object -expand minor
    $OSVBui = [environment]::OSVersion.Version | Select-Object -expand build
    $OSV = "$OSVMaj" + "." + "$OSVMin" + "." + "$OSVBui"

    ##
    ## Display the current config and log if configured.
    ##
    Write-Log -Type Conf -Evt "--- Running with the following config ---"
    Write-Log -Type Conf -Evt "Utility Version: 23.04.28"
    Write-Log -Type Conf -Evt "Hostname: $Env:ComputerName."
    Write-Log -Type Conf -Evt "Windows Version: $OSV."

    If ($Disable)
    {
        Write-Log -Type Conf -Evt "Net access will be: Blocked."
    }

    If ($Enable)
    {
        Write-Log -Type Conf -Evt "Net access will be: Allowed."
    }

    If ($LogPathUsr)
    {
        Write-Log -Type Conf -Evt "Logs directory: $LogPath."
    }

    If ($Null -ne $LogHistory)
    {
        Write-Log -Type Conf -Evt "Logs to keep: $LogHistory days"
    }

    Write-Log -Type Conf -Evt "---"
    Write-Log -Type Info -Evt "Process started"
    ##
    ## Display current config ends here.
    ##

    ## If the -Disable switch is used, the script adds a Firewall Rule to block traffic on ports 80 (http) and 443 (https).
    If ($Disable)
    {
        ## Test if the rule already exists
        try {
            $RuleExist = Get-NetFirewallRule -DisplayName "Internet-Access-Control-Block" -ErrorAction Stop
        }

        catch {
            Write-Log -Type Info -Evt "Creating firewall rule: Internet-Access-Control-Block."
        }

        If ($RuleExist.count -eq 0)
        {
            New-NetFirewallRule -DisplayName "Internet-Access-Control-Block" -Enabled True -Direction Outbound -Profile Any -Action Block -Protocol TCP -RemotePort 80,443 | Out-Null
        }

        else {
            Write-Log -Type Err -Evt "Firewall rule: Internet-Access-Control-Block already exists."
        }
    }

    If ($Enable)
    {
        ## Test if the rule already exists
        try {
            $RuleExist = Get-NetFirewallRule -DisplayName "Internet-Access-Control-Block" -ErrorAction Stop
        }

        catch {
            Write-Log -Type Err -Evt "Firewall rule: Internet-Access-Control-Block doesn't exist."
        }

        If ($RuleExist.count -ne 0)
        {
            Write-Log -Type Info -Evt "Removing firewall rule: Internet-Access-Control-Block"
            Get-NetFirewallRule -DisplayName "Internet-Access-Control-Block" | Remove-NetFirewallRule
        }
    }

    Write-Log -Type Info -Evt "Process finished"

    If ($Null -ne $LogHistory)
    {
        ## Cleanup logs.
        Write-Log -Type Info -Evt "Deleting logs older than: $LogHistory days"
        Get-ChildItem -Path "$LogPath\Inet-Access-Control_*" -File | Where-Object CreationTime -lt (Get-Date).AddDays(-$LogHistory) | Remove-Item -Recurse
    }
}
## End