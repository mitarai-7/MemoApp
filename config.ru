# frozen_string_literal: true

require_relative 'app'
require 'rack/protection'

DATADIR = 'data'
DATASTORE = 'data/memo.json'
Dir.open(DATADIR) unless Dir.exist?(DATADIR)
File.open(DATASTORE, 'w') { |io| io.puts '[]' } unless File.exist?(DATASTORE)

use Rack::Protection::EscapedParams

run Sinatra::Application
