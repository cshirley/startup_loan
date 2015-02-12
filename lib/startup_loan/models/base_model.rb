module StartupLoan
  class BaseModel
    include ModelAttributes

    VALID_RESOURCE_ACTIONS = [:search, :add, :update]

    attr_reader :connection
    attr_reader :is_new

    set_required_attribute_keys []
    set_attribute_keys []
    set_read_only_attribute_keys []

    def initialize(connection, options = {}, loaded_from_server = false)
      @connection = connection
      set_all_attributes(options, loaded_from_server)
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

    def save
      return self unless is_dirty?
      self.referral_partner = 0
      options = { self.class.resource_name => [build_changed_data] }
      url = self.class.build_url(is_new ? :add : :update)
      response = connection.query_post_api(url, options)
      fail StartupLoan::ApiException.new(0, url, response.errors) unless response.success
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

    def build_changed_data
      get_dirty_attributes.inject({}) do |injected_hash, hash_item|
        key, value = hash_item
        injected_hash[key] = value unless value && !value.to_s.empty?
        injected_hash
      end
    end

    def method_missing(method, *args, &block)
      handled_by_attributes_module?(method, *args, &block)
    rescue
      super
    end
  end
end
