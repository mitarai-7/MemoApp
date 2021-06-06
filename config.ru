# frozen_string_literal: true

require_relative 'app'
require 'rack/protection'

use Rack::Protection::EscapedParams

enable :method_override

run Sinatra::Application
