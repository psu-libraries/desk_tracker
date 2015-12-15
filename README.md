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

The CSV upload makes use of the Delayed Job gem. This gem should be fine for this application, but it does hit the database every few seconds. A switch to somethign like Resque might be desired in the future. To start the Delayed Jobs, on the command line

```
    RAILS_ENV=production script/delayed_job start
    RAILS_ENV=production script/delayed_job stop

    # Runs two workers in separate processes.
    RAILS_ENV=production script/delayed_job -n 2 start
    RAILS_ENV=production script/delayed_job stop
```

Further documentation can be found at https://github.com/collectiveidea/delayed_job.

## Usage
### Uploading Data
The Desk Tracker Dashboard used the CSV files generated from the Desk Tracker reports. The first step is to download the required data.

Log into the desk tracker system and choose the reports tab. Click the **Data File Generator** link in the **Downloads** section. Then in the **Report Options** section choose **[Show Options]**. The Desk Tracker Dashboard is designed to run with the default options, however, you should filter by **Date Range**. If you attempt to download all the data at once the Desk Tracker app will likely run out of memory and crash. the best option seems to be to download data a year at a time. Its fine to be careful and overlap dates a little bit too. The Dashboard will simply update any duplicate rows with any changes in the new CSV. 

To upload the data log into the Desk Tracker Dashboard. The initial page should be the **Interactions** page, but if its not, choose that tab. In the top right sidebar is the uploading widget. Choose a file to upload and then click the **Upload** button. The upoad will take some time, depending on how large the CSV file is. The processing is handled in the background, so if you wish, you may upload more CSV files. The Dashboard, currently only uploads one file at at time.

You can view what CSV files are queued for processing in the **Queued Imports** link on the top right of the top navbar. 
### Editing Data
The Dashboard currently allows you to edit all fields. However, best practice often dictates removing the data from the analyses unless you are absolutely sure of the best value to change the data too. Rather than deleting the record, change the record's data quality to poor. It will be excluded from all analyses and visualizations.

