# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

#Create FAQ page

faq = Page.find_or_create_by_permalink_and_title('faq', "Preguntas frecuentes")
faq.content = File.read(RAILS_ROOT + "/doc/FAQ.md")
faq.save!

editor = Page.find_or_create_by_permalink_and_title('editor', "Ayuda de edición")
editor.content = File.read(RAILS_ROOT + "/doc/editor.md")
editor.save!

# Create see faq announcement
Announcement.delete_all
Announcement.create( :message => '¿Es la primera vez que visitas Wasamblea.org? Échale un vistazo a las <a href="/help/faq">preguntas frecuentes</a>.', 
                     :starts_at => 1.day.ago,
                     :ends_at => 2.years.from_now)
