require 'rdiscount'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def m(text)
    RDiscount.new(text, :smart, :filter_html).to_html.html_safe!
  end
  
  def m_with_html(text)
    RDiscount.new(text, :smart).to_html.html_safe!
  end
  
  def is_admin?
    current_user && current_user.role == 'admin'
  end
  
  def admin_links(resource)
    render :partial => '/shared/admin_links', :locals => {:resource => resource}
  end
  
  def rating_for(rateable)
    if current_user
      rating = (rateable.rating_for_user(current_user) || rateable.ratings.build(:rater_id => current_user.id))
    else
       rating = Rating.new(:rateable_type => rateable.class.name, :rateable_id => rateable.id )
     end
    render :partial => '/shared/rating', :locals => { :rating => rating, :rateable => rateable }
  end
  
  def current_announcements
    @current_announcements ||= Announcement.current_announcements(session[:announcement_hide_time])
  end
  
  def include_javascript_editor_if_needed
    javascript_include_merged :editor if params[:controller] == 'propositions' && (params[:action] == 'show' || params[:action] == 'new' )  
  end
      
end
