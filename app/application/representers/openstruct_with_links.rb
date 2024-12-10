# frozen_string_literal: true

require 'ostruct'

module RoutePlanner
  module Representer
    # OpenStruct for deserializing json with hypermedia
    class OpenStructWithLinks < OpenStruct
      attr_accessor :links
    end
  end
end