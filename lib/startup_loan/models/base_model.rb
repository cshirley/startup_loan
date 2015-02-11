module StartupLoan
  class BaseModel

    VALID_RESOURCE_ACTIONS = [:search, :add, :update]

    attr_accessor :connection

    def initialize(connection, options = {}, loaded_from_server = false)
      @connection = connection
      @attributes = {}
      set_all_attributes(options, loaded_from_server)
    end

    def is_new?
      @is_new
    end

    def self.resource_name
      name.split('::').last.downcase + 's'
    end

    def self.build_url(resource_action)
      "#{resource_name}/#{resource_action}"
    end

    def self.find(connection, params = {})
      process_response(connection,
                       connection.query_get_api(build_url(:search), params))
    end

    def self.process_response(connection, response)
      response.results.inject([]) do |arr, data_item|
        arr << new(connection, data_item, true)
      end
    end

    def attribute_names
      @attributes.keys
    end

    def save
      return self unless is_dirty?
      options = { self.class.resource_name => [build_changed_data] }
      url = self.class.build_url(is_new? ? :add : :update)
      response = connection.query_post_api(url, options)
      raise StartupLoan::ApiException.new(0,response.errors.join("\n")) unless response.success
      set_all_attributes(response.results.first, true)
      self
    end

    def reload
      response = self.class.find(connection, id: id)
      return false if response['size'] ==  0
      remote_data = response[self.class.resource_name].select { |model_instance| model_instance.id == id }.first
      set_all_attributes(remote_data, true)
      true
    end

    def is_dirty?
      get_dirty_attributes.size > 0
    end

    def method_missing(method, *args, &block)
      attribute_name = method.to_s.split('=')
      if has_attribute?(attribute_name.first)
        if method.to_s[-1] == '='
          set_attribute(attribute_name.first, args.first)
        else
          get_attribute(attribute_name.first)
        end
      else
        super
      end
    end

    def build_changed_data
      get_dirty_attributes.keys.inject({}) do |h, k|
        if @attributes[k][:value] && !@attributes[k][:value].to_s.empty?
          h[k] = @attributes[k][:value]
        end
        h
      end
    end

    def has_attribute?(key)
      @attributes && @attributes.key?(key.gsub(/=/, ''))
    end

    def get_dirty_attributes
      @attributes ? @attributes.select { |_k, v| v[:is_dirty] } : []
    end

    def clear_dirty_flags
      @attributes.each do |k, v|
        @attributes[k] = { old_value: v[:value], value: v[:value], is_dirty: false }
      end
    end

    def get_attribute(key)
      has_attribute?(key) ? @attributes[key][:value] : nil
    end

    def set_all_attributes(attributes, loaded = false)
      @is_new = !loaded
      attributes.each do |k, v|
        if self.respond_to? k
          send("#{k}=", v)
        else
          set_attribute(k.to_s, v, loaded)
        end
      end
    end

    def set_attribute(key, value, loaded = false)
      @attributes[key] = { old_value: get_attribute(key) || value,
                           value: value,
                           is_dirty: !loaded || get_attribute(key) == value }
      true
    end
  end
end
