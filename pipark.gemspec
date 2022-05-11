require_relative 'lib/pipark/version'

Gem::Specification.new do |s|

  s.name     = 'pipark'
  s.summary  = "Pea-brained control of Raspberry Pi's"
  s.version  = Pipark::VERSION

  s.homepage = 'https://github.com/lllisteu/pipark'
  s.authors  = [ 'lllist.eu' ]
  s.license  = 'MIT'

  all_files     = `git ls-files -z`.split("\x0")
  s.files       = all_files.grep(%r{^(bin|lib)/})
  s.executables = all_files.grep(%r{^bin/.+}) { |f| File.basename(f) }

  s.required_ruby_version = '>=2.5.0'

  s.metadata = {
    'homepage_uri'      => 'https://github.com/lllisteu/pipark',
    'changelog_uri'     => 'https://github.com/lllisteu/pipark/blob/master/History.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/pipark',
  }

end
