module Shoulda
  module Matchers
    module ActiveModel
      # @private
      class CouldNotDetermineValueOutsideOfArray < RuntimeError; end

      # @private
      class NonNullableBooleanError < Shoulda::Matchers::Error
        def self.create(attribute)
          super(attribute: attribute)
        end

        attr_accessor :attribute

        def message
          <<-EOT.strip
You have specified that your model's #{attribute} should ensure inclusion of nil.
However, #{attribute} is a boolean column which does not allow null values.
Hence, this test will fail and there is no way to make it pass.
          EOT
        end
      end

      class CouldNotSetAttribute < StandardError
        def self.create(instance, attribute, expected_value, actual_value)
          message = Shoulda::Matchers.word_wrap <<EOT.strip
allow_value tried to set the #{instance.class}'s #{attribute} to
#{expected_value.inspect}, but had trouble doing so: when reading the attribute
back out, its value was #{actual_value.inspect}. This makes it very difficult,
if not impossible, to test against. If you can, we recommend writing a test
against this attribute manually.
EOT
          new(message)
        end
      end

      class CouldNotSetPasswordError < Shoulda::Matchers::Error
        def self.create(model)
          super(model: model)
        end

        attr_accessor :model

        def message
          <<-EOT.strip
The validation failed because your #{model_name} model declares `has_secure_password`, and
`validate_presence_of` was called on a #{record_name} which has `password` already set to a value.
Please use a #{record_name} with an empty `password` instead.
          EOT
        end

        private

        def model_name
          model.name
        end

        def record_name
          model_name.humanize.downcase
        end
      end
    end
  end
end
