xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{@title} en Wasamblea.org"
    xml.description "#{@title} en Wasamblea.org"
    xml.link propositions_url :format => :rss
    
    for proposition in @propositions
      xml.item do
        xml.title proposition.title
        xml.description proposition.summary
        xml.pubDate proposition.created_at.to_s(:rfc822)
        xml.link proposition_url proposition
      end
    end
  end
end