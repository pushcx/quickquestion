require "claude/client"
require "sequel"
require "fileutils"
require "xdg"
require "bigdecimal"

module QuickQuestion
  VERSION = "0.1.1"
  DB_PATH = File.join(XDG::Config.new.home, "qq/log.sqlite3")

  def self.setup_db
    FileUtils.mkdir_p(File.dirname(DB_PATH))
    @db ||= Sequel.connect("sqlite://#{DB_PATH}")

    Sequel.extension :migration
    Sequel::TimestampMigrator.run(@db, File.join(File.dirname(__FILE__), "migration"))

    @db
  end

  def self.db
    @db ||= setup_db
  end

  def self.query(input)
    api_key = ENV["ANTHROPIC_API_KEY"]
    raise "ANTHROPIC_API_KEY environment variable is not set" if api_key.nil? || api_key.empty?

    claude = Claude::Client.new(api_key)
    prompt = "Give concise expert answers. Answer calmly and directly. If unsure, answer about the most common case. Never repeat questions or introduce your answer. If giving code samples, do not explain unless explicitly asked."
    messages = claude.user_message(prompt + "\n" + input)
    response = claude.messages(messages, model: Claude::Model::CLAUDE_SONNET_LATEST)
    text = claude.parse_response(response)
    usage = response["usage"]
    input_tokens = usage["input_tokens"]
    output_tokens = usage["output_tokens"]
    cost = calculate_cost(usage)
    log_query(input, text, input_tokens, output_tokens, cost)
    "#{text} (Cost: $#{cost.truncate(4).to_s("F")})"
  end

  def self.calculate_cost(usage)
    input_tokens = BigDecimal(usage["input_tokens"])
    output_tokens = BigDecimal(usage["output_tokens"])
    (input_tokens * 3 + output_tokens * 15) / BigDecimal("1_000_000")
  end

  def self.log_query(query, response, input_tokens, output_tokens, cost)
    db[:queries].insert(
      at: Time.now.utc,
      query: query,
      response: response,
      input_tokens: input_tokens,
      output_tokens: output_tokens,
      cost: cost
    )
  end
end
