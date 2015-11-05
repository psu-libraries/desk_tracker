ActiveAdmin.register_page "Full Time Series" do
  menu parent: 'Patron Counts'
  content do
    render 'admin/data/patron_count_charts', context: self, locals: {opts: @arbre_context.assigns[:opts]}
  end #content
  
  
  sidebar 'Patron Count Timeseries' do
    para "Patron counts for each branch over time are represented in each graph."
    
    para "The solid line represents the average patron count, the dots represent the maximum count for the day. "
          
    para "You can hide a given series (i.e. Research Hub: Maximum Patron Count) by clicking on its legend item."
    
    para "You can download individual branch graphs by clicking on the action item button (three horizontal lines) "+
         "on the top right of a char."
  end
  
  sidebar :filters, partial: 'admin/data/patron_count_filters', context: self
  
  controller do
    def index
      # interactions = Interaction.where(page: 'Patron Count').select('date_time, question, response, optional_text, user, branch, desk, library')
      @opts = {select: %w[date_time question response optional_text user branch desk library]}.merge(params)
      @branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
    end
  end
end