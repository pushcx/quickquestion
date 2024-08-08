#!/usr/bin/env ruby

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
require "bundler/setup"

require "byebug"
require "claude/client"

claude = Claude::Client.new(ENV["ANTHROPIC_API_KEY"])

prompt = "Give concise expert answers. Answer calmly and directly. Ask questions if needed to clarify. Never repeat questions or introduce your answer."
query = ARGF.read

puts "query - #{query}"
messages = claude.user_message(prompt + "\n" + query)
response = claude.messages(messages)
text = claude.parse_response(response)

puts "messages"
puts messages.inspect
puts

puts "response"
puts response.inspect
puts

puts "text"
puts text
