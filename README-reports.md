# READMEfor Reports

This is about reports.


## Search

If you need to search for one or more users who's registered, or tried to, enter your search terms in the *Choose Registrant/String* field. The dropdown is modified accordingly.

TBA (the presentation part is not done as I write this)


## Compare Temp/Data Folders

This compares the `tmp` and `data` collections used to register delegates.

The registration process goes through two phases:

1. Temp registration of the delegate details. This happens when hitting *Register* on the XForm and generates an XML file with the delegate's details but does NOT indicate payment. The temp XML is saved in `tmp`. Hitting *Register* also generates a summary and the all-important PayPal button.
2. Payment registration. When the delegate completes "the PayPal experience", having paid, the temp XML is saved in `data`. This should result in a than-you page and an email to the delegate with an invoice attached. The invoice is a formality - the payment should be done by now.

Both XML files, in `tmp` and in `data`, can be identified as being the same because they *use the same user ID* in the `person` element.

If something goes wrong during the two steps, step 2 never happens and we never receive payment. Step 1 does complete in most cases, however, and so we get a temp XML file in `tmp`. This function, then, simply lists the contents of the two collections in the DB, comparing the user IDs. A user ID present in both collections is marked with a light green colour.
