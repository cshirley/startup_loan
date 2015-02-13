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
      return self unless dirty?
      options = { self.class.resource_name => [build_changed_data] }
      url = self.class.build_url(is_new ? :add : :update)
      response = connection.query_post_api(url, options)
      fail StartupLoan::ApiException.new(0, url, response.errors) unless response.success
      set_all_attributes(response.results['0'], true)
      self
    end

    def reload!
      response = self.class.find(connection, build_find_by_remote_key)
      return false unless response.count == 1
      remote_data = response.first
      set_all_attributes(remote_data.attributes, true)
      true
    end

    def build_find_by_remote_key
      keys = self.class.attribute_id_keys
      keys.inject({}) { |h, k|
        h[k] = get_attribute(k)
        h
      }
    end
    def build_changed_data
      data = get_dirty_attributes.inject({}) do |injected_hash, hash_item|
        key, value = hash_item.first, hash_item.last[:value]
        injected_hash[key] = value if value && !value.to_s.empty?
        injected_hash
      end
      data.merge!(build_find_by_remote_key) unless is_new
      data
    end

    def method_missing(method, *args, &block)
      handled_by_attributes_module?(method, *args, &block)
    rescue
      super
    end
  end
end
