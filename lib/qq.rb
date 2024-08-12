require "claude/client"

def qq query
  claude = Claude::Client.new(ENV["ANTHROPIC_API_KEY"])

  prompt = "Give concise expert answers. Answer calmly and directly. Only ask questions if unclear. Never repeat questions or introduce your answer. If giving code samples, do not explain unless explicitly asked."

  puts "query - #{query}"
  messages = claude.user_message(prompt + "\n" + query)
  response = claude.messages(messages, model: Claude::Model::CLAUDE_SONNET_LATEST)
  text = claude.parse_response(response)

  # cost $3 per million input tokens and $15 per million output tokens
  input_tokens = response["usage"]["input_tokens"]
  output_tokens = response["usage"]["output_tokens"]
  cost = (input_tokens * 3 + output_tokens * 15) / 1_000_000.0

  puts
  puts "#{text} (Cost: $#{format("%.4f", cost)})"
end
