ExtraCare Reminders
============

Send CVS ExtraCare coupon reminders to OmniFocus, Reminders, Things, or DueApp
Includes SQLite database support for tracking previously imported coupons
Sets task name, due date, start date, and a note
This script performs the following actions:
* Logs into CVS mobile web
* Scans the ExtraCare page for active coupons on your card/account
* Checks coupons against the database for previously imported coupons
* Sends every new coupon to the task manager of your choice


__Install:__
    bundle install

__Configure:__
Edit config/config.yml to choose which reminder app you'd like to use.


__Usage:__
   ruby bin\extracare2of username password

Todo:
* Parse ExtraBucks... I need to wait for CVS to send me some before I can figure out the right regular expression
* Handle deals that require action, i.e., activate coupon via web



Note: This is for paper coupons only. The actual coupons are on your CVS receipts. This script merely sets reminders for you to use them.

Credits:
This ruby script borrows some code from ttscoff's otask CLI OmniFocus gem.