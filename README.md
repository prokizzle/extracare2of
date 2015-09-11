
# ExtraCare Reminders

## Synopsis

This script will send CVS ExtraCare coupon reminders to [OmniFocus][6764-001], [iCloud Reminders][6764-002], [Things for Mac][6764-003], or [DueApp][6764-004]. It includes SQLite database support for tracking previously imported coupons and will set task name, due date, start date, and a note

This script performs the following actions:

+ Logs into [CVS mobile][6764-005] web
+ Scans the ExtraCare page for active coupons on your card/account
+ Checks coupons against the database for previously imported coupons
+ Sends every new coupon to the task manager of your choice

## Code Example

    $ extracare2of username password
    $ Looking for coupons...
    $ ----
    $  Title: 10% off skincare products
    $  - Due Date: 8/10/2013
    $  - Start Date: 8/1/2013
    $  - Note: Reedemable in-store only



## Installation

    gem install extracare2of

## Configuration

Config file is location at `~/.extracare2of/config/config.yml`.
Here you can change which todo manager you use.

        ---
    :services:
      :use_omnifocus: true
      :use_reminders: false
      :use_things: false
      :use_dueapp: false

## Todo

+ Parse ExtraBucks... I need to wait for CVS to send me some before I can figure out the right regular expression
+ Handle deals that require action, i.e., activate coupon via web

_Note: This is for paper coupons only. The actual coupons are on your CVS receipts. This script merely sets reminders for you to use them._

## Credits

This ruby script borrows some code from [ttscoff's][6764-006] [otask](http://brettterpstra.com/2011/07/02/otask-cli-for-omnifocus/) CLI OmniFocus gem.

## License

Licensed under the [MIT License][6764-007]
[6764-001]: http://www.omnigroup.com/products/omnifocus/ "OmniFocus for Mac - The Omni Group"
[6764-002]: http://support.apple.com/kb/ht4861 "iCloud: Calendar Events, Reminders, To Dos, and Tasks behavior ..."
[6764-003]: http://culturedcode.com/things/ "Things - task management for Mac &amp; iOS | Cultured Code"
[6764-004]: http://www.dueapp.com/ "Due: The Superfast Reminder App for iPhone &amp; iPad"
[6764-005]: http://www.cvs.com/promo/promoLandingTemplate.jsp?promoLandingId=mobile-apps "CVS Mobile Apps - CVS pharmacy"
[6764-006]: https://github.com/ttscoff "ttscoff (Brett Terpstra) · GitHub"
[6764-007]: http://opensource.org/licenses/MIT "The MIT License (MIT) | Open Source Initiative"