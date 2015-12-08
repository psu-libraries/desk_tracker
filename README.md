# Desk Tracker

A fairly simple web application to provide an administrative dashboard for library data with minimal programming. Currently the application
has the following features.

1. Ability upload CSV files proved by Desk Tracker and load it into a relational database.
2. Editing and filtering of data.
3. Graphical and Tabular display of data.

The primary UI is established using the ActiveAdmin gem ([Github](https://github.com/activeadmin/activeadmin) | 
[Documentation](http://activeadmin.info/)). ActiveAdmin creates an out of the box admin interface using the data
provided in the ActiveRecord models. The interface can then be easily customized.

The graphs and charts are created using [HighCharts](http://www.highcharts.com/), a jQuery based charting library.

Details of implementation, suggestions for improvement etc are provided in the wiki, a general overview is provided here. The application
can be thought of as two separate components. First is an API for creating the data to be fed to the charts. While part of the same code 
base, it does not function specifically for ActiveAdmin and can be used by other systems if desired. The API is documented in the wiki.

The second component is the ActiveAdmin UI. The tables are generated directly from the database using ActiveAdmin. All charts and figures,
however, result from AJAX calls to the API noted above. 

There is also a basic [Devise](https://github.com/plataformatec/devise) authentication and authorization system. Most likely you will
want to replace this with something more suited to your institution, such as an LDAP authentication.

## Installation
This application should install like a rails app. Create a copy of the codebase, and run ```bundle install```. Update 
the ```database.yml``` to match your database and credentials. Launch the server and it should be running. You will need to use 
rails console to create an initial user though.
