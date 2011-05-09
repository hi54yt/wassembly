class LoggedException < ActiveRecord::Base
  attr_accessible :exception_class, :message, :controller_name, :action_name, :backtrace, :environment, :request, :created_at
  class << self
    def create_from_exception(controller, exception, data)
      message = exception.message.inspect
      message << "\n* Extra Data\n\n#{data}" unless data.blank?
      create! :exception_class => exception.class.name,
              :controller_name => controller.controller_name,
              :action_name     => controller.action_name,
              :message         => message,
              :backtrace       => exception.backtrace,
              :request         => controller.request
    end
    
    def find_exceptions(page, exception_conditions)
      conditions = {}
      [:exception_class, :controller_name, :action_name].each do |param|
        conditions[param] = exception_conditions[param] if exception_conditions[param]
      end
      all.paginate(:per_page => 20, :page => page, :conditions => conditions, :order => 'created_at DESC')
    end
    
    def find_exception_class_names
      connection.select_values "SELECT DISTINCT exception_class FROM #{table_name} ORDER BY exception_class"
    end
    
    def find_exception_controllers_and_actions
      select("DISTINCT controller_name, action_name").order("controller_name, action_name").to_a.collect(&:controller_action)
    end
    
    def host_name
      `hostname -s`.chomp
    end
  end

  def backtrace=(backtrace)
    backtrace = sanitize_backtrace(backtrace) * "\n" unless backtrace.is_a?(String)
    write_attribute :backtrace, backtrace
  end

  def request=(request)
    if request.is_a?(String)
      write_attribute :request, request
    else
      max = request.env.keys.max { |a,b| a.length <=> b.length }
      env = request.env.keys.sort.inject [] do |env, key|
        env << '* ' + ("%-*s: %s" % [max.length, key, request.env[key].to_s.strip])
      end
      write_attribute(:environment, (env << "* Process: #{$$}" << "* Server : #{self.class.host_name}") * "\n")
      
      write_attribute(:request, [
        "* URL:#{" #{request.method.to_s.upcase}" unless request.get?} #{request.protocol}#{request.env["HTTP_HOST"]}#{request.request_uri}",
        "* Format: #{request.format.to_s}",
        "* Parameters: #{request.parameters.inspect}",
        "* Rails Root: #{Rails.root}"
      ] * "\n")
    end
  end

  def controller_action
    @controller_action ||= "#{controller_name.camelcase}/#{action_name}"
  end

  private

  def sanitize_backtrace(trace)
    trace.collect { |line| Pathname.new(line.gsub(LoggedException.backtrace_regex, "[RAILS ROOT]")).cleanpath.to_s }
  end
  
  def self.backtrace_regex
    @backtrace_regex ||= /^#{Regexp.escape(Rails.root)}/
  end
end