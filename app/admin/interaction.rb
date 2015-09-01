ActiveAdmin.register Interaction do
  
  require 'csv'
  
  sidebar 'Import Data', priority: 0 do
    render 'admin/import_form'
  end
  
  collection_action :import, method: [:post] do
    
    Interaction.import(params[:file])
    
    flash.alert = 'Your file has been uploaded and processed.'
    redirect_to request.referer
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


