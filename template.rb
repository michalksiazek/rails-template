# frozen_string_literal: true

def add_gems
  gem 'slim'

  gem_group :development do
     gem 'rubocop', require: false
     gem 'rubocop-rails'
     gem 'rubocop-rspec'
   end

  gem_group :development, :test do
    gem 'fabrication'
    gem 'rspec-rails'
  end
end

def remove_unnecessary_files
  run 'rm -r app/channels'
  run 'rm -r app/controllers/concerns'
  run 'rm -r app/helpers'
  run 'rm -r app/jobs'
  run 'rm -r app/models/concerns'
  run 'rm -r storage'
end

def add_rubocop_config
  file '.rubocop.yml', <<-CODE
  require:
    - rubocop-rails
    - rubocop-rspec

  AllCops:
    Exclude:
      - '**/config.ru'
      - '**/Rakefile'
      - 'bin/**/*'
      - 'db/**/*'
      - 'log/**/*'
      - 'node_modules/**/*'
      - 'tmp/**/*'
      - 'vendor/**/*'
    NewCops: enable
  Documentation:
    Enabled: false
  Style/SymbolArray:
    EnforcedStyle: brackets
  Layout/LineLength:
    Exclude:
      - 'config/**/*'
  Metrics/BlockLength:
    Exclude:
      - 'spec/**/*_spec.rb'
      - 'config/routes.rb'
  Metrics/AbcSize:
    Max: 20
  Rails:
    Enabled: true
  Rails/FilePath:
    EnforcedStyle: arguments
  RSpec/ExampleLength:
    Max: 50
  RSpec/MultipleExpectations:
    Enabled: false
  CODE
end

add_gems
remove_unnecessary_files
add_rubocop_config

after_bundle do
  # rails_command 'generate rspec:install'
  run 'bundle exec rubocop --auto-correct-all'
end
