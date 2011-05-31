# SequenceId

SequenceId is the gem for Rails 3 that allows for creating URL permalinks that start from 1 and increment in a continuum. 
As an example for a SaaS based accounting application using SequenceId, you'll have the first three URL's for a new signup like:

    http://company1.7vals.com/invoices/1
    http://company1.7vals.com/invoices/2
    http://company1.7vals.com/invoices/3

instead of:

    http://company1.7vals.com/invoices/11232
    http://company1.7vals.com/invoices/11240 #notice a jump of 8 id's due to other companies creating their invoices
    http://company1.7vals.com/invoices/11242

## SequenceId Features

SequenceId is a fairly straight forward gem and you need to ensure only ONE condition
    Resource with sequenceid must be a NESTED resource

Back to our original example, if you want invoices to start from 1 for each new company, the Invoice RESOURCE is nested to the Company RESOURCE. The gem will check for the relationhip in the database (Invoice table in this case) and ensure the sequence_num (SequenceId column created in the table)  and the parent resource_id are a secondary compound key in the nested resource's table. 

SequenceId is compatible with Active Record  **3.0**.

## Docs, Info and Support

* [Bugs/Help](https://groups.google.com/group/sequenceid)
* Email: info@7vals.com 

## Rails Quickstart

    rails new my_app

    cd my_app

    # add to Gemfile
    gem "sequenceid"

    rails generate sequenceid <parent resource> <nested resource> #eg rails generate sequenceid Company Invoice 

    rake db:migrate

    # edit app/controller/invoices_controller.rb
    # :id is NO LONGER a unique identifier since its the sequence_num, so you MUST edit the resource find in each of the actions (or create a before filter)
    @company = Company.find(params[:company_id]) # or Company.find_by_name(request.subdomain)
    @invoice = @company.invoices.find_by_sequence_num!(params[:id])

    rails server

    #i assuming you have 7vals mapped to localhost in your host file

    GET http://company1.7vals.com:3000/invoices/1
    Get http://company2.7vals.com:3000/invoices/1

## Bugs

Please report them on the [Github issue tracker](http://github.com/alisyed/issues)
for this project.

If you have a bug to report, please include the following information:

* **Version information for SequenceId, Rails and Ruby.**
* Stack trace and error message.
* Any snippets of relevant model, view or controller code that shows how your
  are using SequenceId

## Credits

SequenceId was create by Syed Ali @ 7vals 
*   [7vals](http://www.7vals.com)

Special thanks to
*   [cancan](https://github.com/ryanb/cancan)

*   [FriendlyId](https://github.com/norman/friendly_id)

for serving as a template on certain best practices.

Thanks!

Copyright (c) 2011, released under the MIT license.
