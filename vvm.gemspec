# frozen_string_literal: true

require_relative 'lib/vvm/version'

Gem::Specification.new do |spec|
  spec.name          = 'vvm'
  spec.version       = Vvm::VERSION
  spec.authors       = ['Alex Bykov']
  spec.email         = ['leksster@gmail.com']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = 'https://github.com'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.2'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com'
  spec.metadata['changelog_uri'] = 'https://github.com'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(File.expand_path(__dir__)) do
  #   `git ls-files -z`.split("\x0").reject do |f|
  #     (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
  #   end
  # end

  spec.files = Dir.glob('lib/**/*', File::FNM_DOTMATCH)

  spec.bindir        = 'exe'
  spec.executables   = ['vvm']
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'tty-prompt', '~> 0.23.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
