# Internet Access Control Utility

Control internet access with Windows Firewall

``` txt
   ____     __                   __    ___
  /  _/__  / /____ _______  ___ / /_  / _ |___________ ___ ___
 _/ // _ \/ __/ -_) __/ _ \/ -_) __/ / __ / __/ __/ -_|_-<(_-<
/___/_//_/\__/\__/_/ /_//_/\__/\__/_/_/_|_\__/\__/\__/___/___/
 / ___/__  ___  / /________  / / / / / / /_(_) (_) /___ __
/ /__/ _ \/ _ \/ __/ __/ _ \/ / / /_/ / __/ / / / __/ // /
\___/\___/_//_/\__/_/  \___/_/  \____/\__/_/_/_/\__/\_, /
                                                   /___/

  Mike Galvin   https://gal.vin    Version 21.12.08
```

This script is based on code by Peter Löfgren, [check out his website here.](https://syscenramblings.wordpress.com)

For full instructions and documentation, [visit my site.](https://gal.vin/posts/internet-access-control-utility)

Please consider supporting my work:

* Sign up [using Patreon.](https://www.patreon.com/mikegalvin)
* Support with a one-time payment [using PayPal.](https://www.paypal.me/digressive)

Internet Access Control Utility can also be downloaded from:

* [The Microsoft PowerShell Gallery](https://www.powershellgallery.com/packages/Internet-Access-Control)

Join the [Discord](http://discord.gg/5ZsnJ5k) or Tweet me if you have questions: [@mikegalvin_](https://twitter.com/mikegalvin_)

-Mike

## Features and Requirements

* It requires Windows Firewall to be active.
* The utility requires at least PowerShell 5.0.
* This utility has been tested on Windows 10.

### Configuration

Here’s a list of all the command line switches and example configurations.

| Command Line Switch | Description | Example |
| ------------------- | ----------- | ------- |
| -Disable | Block the internet. Create the firewall rule to block ports 80 and 443 | N/A |
| -Enable | Allow the internet. Removes the firewall rule created, allowing the ports 80 and 443 | N/A |
| -NoBanner | Use this option to hide the ASCII art title in the console. | N/A |
| -L | The path to output the log file to. The file name will be Inet-Access-Control_YYYY-MM-dd_HH-mm-ss.log. Do not add a trailing \ backslash. | ```C:\scripts\logs``` |

### Example

``` txt
Internet-Access-Control.ps1 -Disable -L C:\scripts\logs
```

The above command will disable the internet access using Windows Firewall and the log file will be output to ```C:\scripts\logs```.
