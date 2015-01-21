module Shoulda
  module Matchers
    module ActiveModel
      class Validator
        include Helpers

        attr_accessor :record, :context, :strict

        def initialize(attribute)
          @attribute = attribute
          @captured_range_error = nil
          reset
        end

        def reset
          @messages = nil
        end

        def allow_description(allowed_values)
          if strict?
            "doesn't raise when #{attribute} is set to #{allowed_values}"
          else
            "allow #{attribute} to be set to #{allowed_values}"
          end
        end

        def expected_message_from(attribute_message)
          if strict?
            "#{human_attribute_name} #{attribute_message}"
          else
            attribute_message
          end
        end

        def messages
          @messages ||= validation_exceptions_or_errors
        end

        def formatted_messages
          if strict?
            [messages.first.message]
          else
            messages
          end
        end

        def has_messages?
          messages.any?
        end

        def messages_description
          if captured_range_error?
            ' RangeError: ' + captured_range_error.message.inspect
          elsif strict?
            if has_messages?
              ': ' + format_exception(messages.first).inspect
            else
              ' no exception'
            end
          else
            if has_messages?
              " errors:\n#{pretty_error_messages(record)}"
            else
              ' no errors'
            end
          end
        end

        def expected_messages_description(expected_message)
          if expected_message
            if strict?
              "exception to include #{expected_message.inspect}"
            else
              "errors to include #{expected_message.inspect}"
            end
          else
            if strict?
              "an exception to have been raised"
            else
              "errors"
            end
          end
        end

        def capture_range_error(exception)
          @captured_range_error = exception
        end

        def captured_range_error?
          !!captured_range_error
        end

        protected

        attr_reader :record, :attribute, :context,
          :captured_range_error

        private

        def strict?
          !!@strict
        end

        def validation_exceptions_or_errors
          if strict?
            validation_exceptions
          else
            validation_errors
          end
        rescue RangeError => exception
          capture_range_error(exception)
          []
        end

        def validation_exceptions
          record.valid?(context)
          []
        rescue ::ActiveModel::StrictValidationFailed => exception
          [exception]
        end

        def validation_errors
          if context
            record.valid?(context)
          else
            record.valid?
          end

          if record.errors.respond_to?(:[])
            record.errors[attribute]
          else
            record.errors.on(attribute)
          end
        end

        def format_exception(exception)
          if exception.is_a?(::ActiveModel::StrictValidationFailed)
            "#{exception.message}"
          else
            "#{exception.class}: #{exception.message}"
          end
        end

        def human_attribute_name
          record.class.human_attribute_name(attribute)
        end
      end
    end
  end
end
