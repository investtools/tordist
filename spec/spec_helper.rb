$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$fixture_path = "spec/fixtures"
require "tordist"
RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end