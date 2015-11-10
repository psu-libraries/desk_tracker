ActiveAdmin.register_page "Reference Time Series" do
  
  menu parent: 'Reference Questions', priority: 1
  
  content do
    within @head do
      script :src => javascript_path('reference_timeseries.js'), :type => "text/javascript"
    end
    render 'admin/data/reference_time_series_charts', context: self, locals: {opts: @arbre_context.assigns[:opts]}
  end #content


  sidebar 'Reference Count Timeseries' do
    para "Refernce questions for each branch over time are represented in each graph."

    para "You can download individual branch graphs by clicking on the action item button (three horizontal lines) "+
         "on the top right of a char."
  end
  
  sidebar :filters, partial: 'admin/data/reference_time_series_filters', context: self
  
  controller do
    def index
      # interactions = Interaction.where(page: 'Patron Count').select('date_time, question, response, optional_text, user, branch, desk, library')
      @opts = {select: %w[date_time question response optional_text user branch desk library]}.merge(params)
      @branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
    end
  end
end