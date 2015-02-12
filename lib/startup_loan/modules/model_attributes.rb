module StartupLoan
  module ModelAttributes
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def set_required_attribute_keys(keys)
        class_variable_set('@@required_attribute', keys.dup)
      end

      def set_attribute_keys(keys)
        class_variable_set('@@attribute_id_keys', keys.dup)
      end

      def set_read_only_attribute_keys(keys)
        class_variable_set('@@read_only_attribute', keys.dup)
      end

      def attribute_id_keys
        class_variable_get('@@attribute_id_keys') || []
      end

      def read_only?(key)
        (class_variable_get('@@read_only_attribute') || []).include?(key)
      end

      def required?(key)
        (class_variable_get('@@required_attribute') || []).include?(key)
      end

      def id?(key)
        (class_variable_get('@@attribute_id_keys') || []).include?(key)
      end
    end

    def attributes
      @attributes ||= {}
    end

    def dirty?
      get_dirty_attributes.size > 0
    end

    def attribute?(key)
      attributes && attributes.key?(key.gsub(/=/, ''))
    end

    def get_dirty_attributes
      attributes ? attributes.select { |_k, v| v[:dirty] || v[:is_key] } : []
    end

    def clear_dirty_flags
      attributes.each do |k, v|
        attributes[k] = { old_value: v[:value], value: v[:value], dirty: false }
      end
    end

    def get_attribute(key)
      attribute?(key) ? attributes[key][:value] : nil
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
      attributes[key] = { old_value: get_attribute(key) || value,
                          value: value,
                          dirty: !loaded || get_attribute(key) == value,
                          is_key: self.class.id?(key),
                          is_read_only: self.class.read_only?(key),
                          is_required: false }
      true
    end

    def handled_by_attributes_module?(method, *args, &_block)
      attribute_name = method.to_s.split('=')
      fail StandardError.new('missing_method') unless attribute?(attribute_name.first)
      if method.to_s[-1] == '='
        set_attribute(attribute_name.first, args.first)
      else
        get_attribute(attribute_name.first)
      end
    end
  end
end
