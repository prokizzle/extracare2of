extracare2of
============

Send CVS ExtraCare coupon reminders to OmniFocus

This ruby script borrows some code from ttscoff's otask CLI OmniFocus gem.

###Install:
    bundle install


###Usage:
    bin\extracare2of _username_ _password_

It will login to your CVS ExtraCare, parse for active coupons, and send tasks to OmniFocus to help remind you to use them. 

Note: This is for paper coupons only. The actual coupons are on your CVS receipts. This script merely sets reminders for you to use them.

More features to come...