require "enumize_mongoid/version"

module EnumizeMongoid
  module Field
    def self.included(klass)

      klass.instance_eval do
        def enumize(values, create_constants: false)
          @@value_map = create_value_map(values)

          if create_constants
            const_set('VALUES', @@value_map)

            @@value_map.each do |key, value|
              const_set(key.to_s.upcase, value)
            end
          end
        end

        def create_value_map(opts)
          return opts if opts.is_a? Hash

          return Hash[opts.zip(0...opts.size)] if opts.is_a? Array

          raise 'Not supported type'
        end

        def value_of(value)
          @@value_map.invert[value]
        end

        # Get the object as it was stored in the database, and instantiate
        # this custom class from it.
        def demongoize(object)
          new(value_of(object))
        end

        # Takes any possible object and converts it to how it would be
        # stored in the database.
        def mongoize(object)
          case object
          when self then object.mongoize
          when Symbol then new(object).mongoize
          else object
          end
        end

        # Converts the object that was supplied to a criteria and converts it
        # into a database friendly form.
        def evolve(object)
          case object
          when self then object.mongoize
          when Symbol then mongoize(object)
          else object
          end
        end
      end

      klass.class_eval do
        attr_reader :value

        def initialize(value)
          @value = value
        end

        def ==(obj)
          case obj
          when Symbol then obj == value
          when self.class then obj.value == value
          when Numeric then obj == @@value_map[value]
          else false
          end
        end

        # Converts an object of this instance into a database friendly value.
        def mongoize
          @@value_map[value]
        end

        def to_s
          "<#{self.class}|#{value}>"
        end
      end
    end
  end
end
