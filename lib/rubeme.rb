# frozen_string_literal: true

module Rubeme
  require_relative "rubeme/version"
  require_relative "rubeme/scm_object"
  # scm_number
  # scm_string
  # scm_vector
  # scm_procedure
  require_relative "rubeme/scm_pair"
  # scm_expression
  # parser
  # reader
  # evaluator
  # printer

  class Error < StandardError; end
end
