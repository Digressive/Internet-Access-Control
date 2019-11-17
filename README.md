# Internet Access Control

Control Internet Access with this PowerShell script.

This script is based largly on code by Peter Löfgren. His post on this script (and lots
more great SCCM content) is [available here](https://syscenramblings.wordpress.com/2017/10/25/windows-10-1709-reference-image)

Please consider donating to support my work:

* You can support me on a monthly basis [using Patreon.](https://www.patreon.com/mikegalvin)
* You can support me with a one-time payment [using PayPal](https://www.paypal.me/digressive) or by [using Kofi.](https://ko-fi.com/mikegalvin)

Tweet me if you have questions: [@mikegalvin_](https://twitter.com/mikegalvin_)

## Configuration

``` txt
-Disable
```

Create the firewall rule to block ports 80 and 443

``` txt
-Enable
```

Removes the firewall rule created, allowing the ports 80 and 443
