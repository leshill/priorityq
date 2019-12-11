require 'priorityq/version'

module Priorityq
  class Error < StandardError; end
  # Your code goes here...

  autoload :Heap, 'priorityq/heap'
end
