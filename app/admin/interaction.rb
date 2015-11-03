ActiveAdmin.register Interaction do
  
  require 'csv'
  
  index do |interaction|
    id_column
    column :branch
    column :desk
    column :page
    column :question
    column :response
    column :optional_text
    column :user
    column :count_date
    actions
  end
  
  filter :branch, as: :check_boxes, collection: proc { Interaction.select('branch').distinct.collect { |b| b.branch} }
  filter :desk
  filter :count_date
  filter :page, as: :check_boxes, collection: proc { Interaction.select('page').distinct.collect { |b| b.page} }
  filter :question
  filter :user
  
  
  
  sidebar 'Import Data', priority: 0 do
    render 'admin/import_form'
  end

  
  collection_action :import, method: [:post] do
    
    # name = params[:upload][:file].original_filename
 #        directory = "public/images/upload"
 #        path = File.join(directory, name)
 #        File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
 #        flash[:notice] = "File uploaded"
 #        redirect_to "/upload/new"
 
 
    directory = 'public/data_files'
    path = File.join(directory, params[:file].original_filename)
    File.open(path, 'wb') { |f| f.write(params[:file].read) }
    
    import = CSVImport.create(file_name: path)
    
    import.delay(queue: 'csv_imports').import
    
    flash.alert = 'Your file has been uploaded and is being processed.'
    redirect_to admin_interactions_path
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end


