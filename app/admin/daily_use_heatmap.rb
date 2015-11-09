ActiveAdmin.register_page "Daily Use Heatmap" do
  
  menu parent: 'Patron Counts', priority: 3
  
  content do
    within @head do
          script :src => javascript_path('daily_use_heatmap.js'), :type => "text/javascript"
    end
    render 'admin/data/daily_use_heatmaps', context: self, locals: {opts: @arbre_context.assigns[:opts]}
  end #content
  
  
  sidebar 'Daily Use' do
    para "Patron counts for each branch at each hour of the day are shown."
    
    para "You can download individual branch graphs by clicking on the action item button (three horizontal lines) "+
         "on the top right of a char."
  end
  
  sidebar :filters, partial: 'admin/data/daily_use_heatmap_filters', context: self
  
  controller do
    def index
      # interactions = Interaction.where(page: 'Patron Count').select('date_time, question, response, optional_text, user, branch, desk, library')
      @opts = {select: %w[date_time question response optional_text user branch desk library]}.merge(params)
      @branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
    end
  end
end