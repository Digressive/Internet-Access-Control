# Internet Access Control Utility

Control internet access with Windows Firewall

For full change log and more information, [visit my site.](https://gal.vin/utils/internet-access-control-utility/)

Internet Access Control Utility is available from:

* [GitHub](https://github.com/Digressive/Internet-Access-Control)
* [The Microsoft PowerShell Gallery](https://www.powershellgallery.com/packages/Internet-Access-Control)

Please consider supporting my work:

* Sign up using [Patreon](https://www.patreon.com/mikegalvin).
* Support with a one-time donation using [PayPal](https://www.paypal.me/digressive).

Please report issues on Github via the issues tab.

-Mike

## Features and Requirements

* It requires Windows Firewall to be active.
* The utility requires at least PowerShell 5.0.
* This utility has been tested on Windows 11 and Windows 10.

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
