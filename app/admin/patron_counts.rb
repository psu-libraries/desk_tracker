ActiveAdmin.register_page "Patron Counts" do
  content do
    render 'admin/data/patron_count_charts', context: self, locals: {opts: @arbre_context.assigns[:opts]}
  end #content
  
  sidebar :filters, partial: 'admin/data/patron_count_filter', context: self
  
  controller do
    def index
      # interactions = Interaction.where(page: 'Patron Count').select('date_time, question, response, optional_text, user, branch, desk, library')
      @opts = {select: %w[date_time question response optional_text user branch desk library]}.merge(params)
      @branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
    end
  end
end