# frozen_string_literal: true

module Rubeme
  require_relative "rubeme/version"
  require_relative "rubeme/char"
  require_relative "rubeme/pair"
  require_relative "rubeme/scm_object"
  # scm_number
  # scm_string
  # scm_vector
  # scm_procedure
  require_relative "rubeme/scm_pair"
  require_relative "rubeme/scm_list_operations"
  # scm_expression
  # parser
  # reader
  # evaluator
  # printer

  class Error < StandardError; end

  class << self
    include ListOperations
  end
end
