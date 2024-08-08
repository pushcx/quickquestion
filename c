#!/usr/bin/env ruby

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
require "bundler/setup"

require "byebug"
require "claude/client"
require "readline"

claude = Claude::Client.new(ENV["ANTHROPIC_API_KEY"])

prompt = "Give concise expert answers. Answer calmly and directly. Only ask questions if unclear. Never repeat questions, introduce your answer."
query = if !$stdin.tty? && !$stdin.closed?
  $stdin.read
else
  Readline.readline("> ", true)
end

puts "query - #{query}"
messages = claude.user_message(prompt + "\n" + query)
response = claude.messages(messages)
text = claude.parse_response(response)

# cost $3 per million input tokens and $15 per million output tokens
input_tokens = response["usage"]["input_tokens"]
output_tokens = response["usage"]["output_tokens"]
cost = (input_tokens * 3 + output_tokens * 15) / 1_000_000.0

puts
puts "#{text} (Cost: $#{format("%.4f", cost)})"
