require_relative "lib/quickquestion"

Gem::Specification.new do |spec|
  spec.name = "quickquestion"
  spec.version = QuickQuestion::VERSION
  spec.required_ruby_version = ">= 3.0.0"
  spec.summary = "Ask LLMs quick questions"
  spec.description = "A command-line tool to quickly ask questions to LLMs"
  spec.authors = ["Peter Bhat Harkins"]
  spec.email = ["peter@push.cx"]
  spec.license = "TODO"

  spec.homepage = "https://push.cx/qq"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pushcx/quickquestion"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.start_with?("test/", "spec/")
    end
  end
  spec.bindir = "bin"
  spec.executables = ["qq"]
  spec.require_paths = ["lib"]
end
