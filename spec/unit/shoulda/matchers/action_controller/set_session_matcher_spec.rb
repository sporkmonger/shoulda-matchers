require 'unit_spec_helper'

describe Shoulda::Matchers::ActionController::SetSessionMatcher do
  it_behaves_like 'set session or flash matcher' do
    def store_name
      'session'
    end

    def set_store
      set_session
    end

    def store
      session
    end

    def store_within(controller)
      controller.session
    end
  end
end
