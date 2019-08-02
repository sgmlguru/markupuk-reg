# Ideas & Plans for MUL 2019 App


## Admin Page

### Modes

We need different modes for the registration app:

* Test mode - test registrations
* Live mode - live registrations

The test mode should probably be default - changing to live mode should be done from an admin page requiring a password.


### Changes to registered delegates?

We might need to change registration details for registered delegates, or otherwise look them up.

Maybe edit the XML: add `other` structure?


### Backup & Report

We should be able to produce a backup and/or report of the delegates at any time.


## Registration Page

* Better CSS
* Help texts for everything
* Email validation in form
* Address validation in form?
* Calculation of registration fee
    - Delegate type (early bird, XML Prague, speaker, PC member, full)
    - Discount codes (act on delegate type? full?)
    - Delegate types, discount codes in lookup XML
* Generate unique code per delegate for demojam
    - Include in invoice/registration info
    - Use in delegate pack later
* Paypal
    - Fee
    - ...
* Print invoice/registration info after completed payment
* Add delegate info in XML file(s) somewhere.
* Opt-in to mailing list?
* GDPR info  and handling


## Demojam Application

* Register participants
* Vote
* Present (export to Norm's application?)
    - Randomise
    - Calculate votes
    - Show only position of first three (if they win something)


## New Workflow

1. Enter name and, optionally, affiliation
2. Enter email
3. Enter dietary requirements
4. Select type of registration
5. Select discount
6. Calculate price incl UK VAT
7. Register 
8. Save reg info to temp XML (or insert XML into register and add `@temp='true'` to `person` element)
9. Generate new page with a generated Paypal button and summary of the above
10. Hit Pay with Paypal
    - Send type, discount, user ID, and price to Paypal
    - Do Paypal stuff at Paypal (address, etc)
    - Let Paypal calculate VAT
    - Return to temp page, hopefully add confirmation details...
    - Catch Paypal user ID
    - Add delegate and payment details using XQ w/ ID to fetch data from Paypal
    - Fill in delegate details to temp XML
    - Save everything in a proper user XML file
11. Calculate Invoice ID from registered user XML position
12. Add the Invoice ID to user XML (?)
13. Generate unique code for demojam vote
14. Save code in user's XML
15. Print invoice using user ID and info in user XML
16. Email to user, cc to info@markupuk.org


## New XForm Registration Page

### Fields & Stuff

* Name
* Email
* Dietary requirements (optional)
* Type of registration
* Discount code
* Register


## Registration Summary and Pay

* Summary of registration details
* Generated Paypal button

### Info to Paypal

* Amount (price for the registration type, including any discount, given in GBP incl VAT)
* Registration type? DO WE NEED THIS?
* User MUK ID (should be sent back to us)


## Return/Pay Confirmation Page

* Summary via Paypal
    - Address
    - Payment
    - VAT
    - MUK User ID
    - Paypal ID
* All of the above should go into the user XML in tmp
* The tmp file should be copied to `data`
    - Rename to include date
    - Insert address
    - Insert amount
    - Insert VAT details
* Print invoice


## Admin Page

* Switch between Test and Live modes
    - eXist path for user XML
    - Paypal sandbox/live URL
* Export all user XML files
    - Email?
    - Consolidate & zip?
* Add info to user XML?
* Search, review?
* Link to demojam participant registration
* Link to demojam votes
* Link to vote count


## Demojam Participant Registration Page

* Register user, topic
* Set maximum no participants
* Stop registration at maximum


## eXist Structure

/db/apps/MUK-reg

/db/MUK-data
/db/MUK-data/sandbox
/db/MUK-data/sandbox/tmp
/db/MUK-data/sandbox/data
/db/MUK-data/sandbox/pdf
/db/MUK-data/live
/db/MUK-data/live/tmp
/db/MUK-data/live/data
/db/MUK-data/live/pdf


## Init function

* Create `sandbox`, `live` if they don't exist
* Create `pdf`, `data` and `tmp` below `sandbox`/`live` if they don't exist


## Generated IDs

* MUK-ID: `count(person) + 1` in the `data` structure, prefix with `MUK2019-LIVE-`
* Invoice ID should be similar
* 


## Flow

1. Enter reg details
2. Hit Register
3. XXX-tmp.xml file saved in tmp
4. Summary+Paypal button
5. Hit Pay
6. Paypal experience...
7. Transaction saved as uid-XXX.xml (should be saved in tmp!)
8. Transaction details inserted into XXX-tmp.xml from uid-XXX.xml
9. Transaction registered and moved
10. Invoice generated
11. Email sent
12. Thanks page - transaction details, info about email and invoice, ...



