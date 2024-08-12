Gem::Specification.new do |s|
  s.name = "qq"
  s.version = "0.1.0"
  s.required_ruby_version = "3.0"
  s.summary = "quick question"
  s.description = "ask LLMs quick questions"
  s.authors = ["Peter Bhat Harkins"]
  s.email = "peter@push.cx"
  s.files = ["lib/qq.rb"]

  # package non-test files from git
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git))})
    end
  end

  s.homepage = "https://push.cx/qq"
  s.license = "MIT"
end
