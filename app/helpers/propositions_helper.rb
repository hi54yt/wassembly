module PropositionsHelper  
  def votes_for(proposition)   
    vote = current_user.vote_for(proposition) if current_user 
    render(:partial => '/shared/vote', :object => vote, :locals => { :proposition => proposition })
  end
end
