
# ExtraCare Reminders

## Synopsis

This script will send CVS ExtraCare coupon reminders to [OmniFocus](!g), [iCloud Reminders](!g), [Things for Mac](!g), or [DueApp](!g). It includes SQLite database support for tracking previously imported coupons and will set task name, due date, start date, and a note

This script performs the following actions:

+ Logs into [CVS mobile](!g) web
+ Scans the ExtraCare page for active coupons on your card/account
+ Checks coupons against the database for previously imported coupons
+ Sends every new coupon to the task manager of your choice

## Code Example

    $ ruby bin/extracare2of username password
    $ Looking for coupons...
    $ ----
    $  Title: 10% off skincare products
    $  - Due Date: 8/10/2013
    $  - Start Date: 8/1/2013
    $  - Note: Reedemable in-store only
    


## Installation

    Bundle install

Edit `config/config.yml` to choose which reminder app you'd like to use.

## Todo

+ Parse ExtraBucks... I need to wait for CVS to send me some before I can figure out the right regular expression
+ Handle deals that require action, i.e., activate coupon via web

_Note: This is for paper coupons only. The actual coupons are on your CVS receipts. This script merely sets reminders for you to use them._

## Credits

This ruby script borrows some code from [ttscoff's](!g) [otask](!github) CLI OmniFocus gem.

## License

Licensed under the [MIT License](!g)