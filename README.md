# Internet Access Control Utility

## Control internet access with Windows Firewall

For full change log and more information, [visit my site.](https://gal.vin/utils/internet-access-control-utility/)

Internet Access Control Utility is available from:

* [GitHub](https://github.com/Digressive/Internet-Access-Control)
* [The Microsoft PowerShell Gallery](https://www.powershellgallery.com/packages/Internet-Access-Control)

Please consider supporting my work:

* Support with a one-time donation using [PayPal](https://www.paypal.me/digressive).

Please report any problems via the ‘issues’ tab on GitHub.

Thanks
-Mike

## Features and Requirements

* It requires Windows Firewall to be active.
* The utility requires at least PowerShell 5.0.
* Tested on Windows 11 and Windows 10.

## Configuration

Here’s a list of all the command line switches and example configurations.

| Command Line Switch | Description | Example |
| ------------------- | ----------- | ------- |
| -Disable | Block the internet. Create the firewall rule to block ports 80 and 443 | N/A |
| -Enable | Allow the internet. Removes the firewall rule created, allowing the ports 80 and 443 | N/A |
| -L | The path to output the log file to. | [path\] |
| -LogRotate | Remove logs produced by the utility older than X days | [number] |
| -NoBanner | Use this option to hide the ASCII art title in the console. | N/A |
| -Help | Display usage information. No arguments also displays help. | N/A |

## Example

``` txt
[path\]Internet-Access-Control.ps1 -Disable
```

This will create a Windows Firewall rule to block internet access using ports 80 and 443.

## Change Log

### 2023-04-28: Version 23.04.28

* Cleaned up the output.

### 2022-06-14: Version 22.05.30

* Added checks and balances to help with configuration as I'm very aware that the initial configuration can be troublesome. Running the utility manually is a lot more friendly and step-by-step now.
* Added -Help to give usage instructions in the terminal. Running the script with no options will also trigger the -help switch.
* Cleaned user entered paths so that trailing slashes no longer break things or have otherwise unintended results.
* Added -LogRotate [days] to removed old logs created by the utility.
* Streamlined config report so non configured options are not shown.
* Added donation link to the ASCII banner.
* Cleaned up code, removed unneeded log noise.

### 2021-12-08: Version 21.12.08

* Configured logs path now is created, if it does not exist.
* Added OS version info.
* Added Utility version info.
* Added Hostname info.
* Changed a variable to prevent conflicts with future PowerShell versions.

### 2020-03-18: Version 20.03.18 'Lock'

* Improved feedback in the console and log.
* Improved documentation.

### 2020-03-17: Version 20.03.17 'Lock'

* Added logging.
* Added config report.
* Made available on PowerShell gallery.
* Refactored code.
