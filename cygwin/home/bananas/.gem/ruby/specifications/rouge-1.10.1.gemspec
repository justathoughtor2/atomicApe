# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rouge"
  s.version = "1.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeanine Adkisson"]
  s.date = "2015-09-10"
  s.description = "Rouge aims to a be a simple, easy-to-extend drop-in replacement for pygments."
  s.email = ["jneen@jneen.net"]
  s.executables = ["rougify"]
  s.files = ["bin/rougify"]
  s.homepage = "http://rouge.jneen.net/"
  s.licenses = ["MIT (see LICENSE file)"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "rouge"
  s.rubygems_version = "1.8.30"
  s.summary = "A pure-ruby colorizer based on pygments"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
