# frozen_string_literal: true

require_relative 'lib/vvm/version'

Gem::Specification.new do |spec|
  spec.name          = 'vvm'
  spec.version       = Vvm::VERSION
  spec.authors       = ['Alex Bykov']
  spec.email         = ['leksster@gmail.com']

  spec.summary       = 'Vvm'
  spec.description   = 'CLI app which emulates the goods buying operations and change calculation.'
  spec.homepage      = 'https://github.com/leksster/vvm'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  spec.files = [*Dir.glob('{config,lib}/**/*', File::FNM_DOTMATCH)]

  spec.bindir        = 'exe'
  spec.executables   = ['vvm']
  spec.require_paths = ['lib']

  spec.add_dependency 'tty-prompt', '~> 0.23.1'
end
