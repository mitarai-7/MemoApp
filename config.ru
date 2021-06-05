# frozen_string_literal: true

require_relative 'app'
require 'rack/protection'

DATADIR = 'data'
DATASTORE = 'data/memo.json'
Dir.mkdir(DATADIR) unless Dir.exist?(DATADIR)
File.open(DATASTORE, 'w') { |io| io.puts '[]' } unless File.exist?(DATASTORE)

use Rack::Protection::EscapedParams

enable :method_override

run Sinatra::Application
