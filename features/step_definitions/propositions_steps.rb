Given /^The latest propositions are titled (.*)$/ do |propositions|
  propositions.split(",").each do |title|
    Factory.create(:proposition, :title => title)
  end
end
