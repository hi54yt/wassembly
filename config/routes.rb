ActionController::Routing::Routes.draw do |map|  
  map.resources :propositions, 
                :has_many => [:comments, :votes, :ratings], 
                :collection => { :latest => :get, :voting => :get}
  
  map.static 'help/:permalink', :controller => 'pages', :action => 'show'
  map.resources :ratings
  map.resources :users
  map.resources :ratings
  map.resources :user_sessions
  map.resources :user_verifications
  map.resources :pages
  map.resources :announcements, :collection => {:hide => :get}
  map.resources :logged_exceptions, :collection => { :destroy_all => :delete }
  
  map.root :controller => 'propositions', :action => 'voting'
  
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.connect ":controller/:action.:format"
end
