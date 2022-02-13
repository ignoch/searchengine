# frozen_string_literal: true

class Context < OpenStruct
  def self.fail!(message)
    context = Context.new
    context.fail!(message)
    context
  end

  def self.empty_collection
    Context.new(collection: [])
  end

  def success?
    !failure?
  end

  def failure?
    @failed || false
  end

  def fail!(message)
    @failed = true
    self.error = message
  end
end
