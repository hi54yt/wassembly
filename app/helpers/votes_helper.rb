require 'google_chart'

module VotesHelper
 
  def votes_pie_chart(yes_count, no_count, chart_title = "Votos totales")
    vote_count = yes_count + no_count 
    
    yes_percent =  (100*yes_count.to_f/vote_count).round
    no_percent  =  (100*no_count.to_f/vote_count).round

    chart = GoogleChart::PieChart.new('350x120',nil,true) do |pc|
          pc.data "#{yes_percent}% a favor ", yes_count, '55ff55'
          pc.data "#{no_percent}% en contra", no_count, 'ff5555'
          pc.show_legend = false
    end
    
    tag("img", {  :src => chart.to_url, 
                  :alt => "#{yes_percent} votos a favor y #{no_percent} en contra",
                  :class => "votes_graph"})
  end
end
