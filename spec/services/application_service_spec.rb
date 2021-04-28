require 'rails_helper'

class Coso < ApplicationService
  def call
    "called"
  end
end

RSpec.describe "ApplicationService" do
  it "returns a new instance and send call method" do
    expect_any_instance_of(Coso).to receive(:call)
    Coso.call
  end
end
