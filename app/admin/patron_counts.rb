ActiveAdmin.register_page "Patron Counts" do
  content do
    if @arbre_context.assigns[:branches] && !@arbre_context.assigns[:branches].empty?
      render 'admin/data/patron_count_charts', context: self, locals: {opts: @arbre_context.assigns[:opts]}
    else
      panel ' ' do
        columns do
          column do
            panel 'Recent Visits' do
              text_node 'No visits to display.'
            end
          end
          column do
            panel 'Frequent Visitors' do
              text_node 'No visitors to display.'
            end
          end
        end
      end
    end


  end #content
  
  controller do
    def index
      # interactions = Interaction.where(page: 'Patron Count').select('date_time, question, response, optional_text, user, branch, desk, library')
      opts = {select: %w[date_time question response optional_text user branch desk library]}
      @branches = Interaction.branches(opts)
    end
  end
end