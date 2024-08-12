require "claude/client"
require "sequel"
require "fileutils"
require "xdg"

module QQ
  DB_PATH = File.join(XDG::Config.new.home, "qq/log.sqlite3")

  def self.setup_db
    FileUtils.mkdir_p(File.dirname(DB_PATH))
    @db ||= Sequel.connect("sqlite://#{DB_PATH}")
    @db.create_table? :queries do
      primary_key :id
      DateTime :at
      String :query
      String :response
    end
    @db
  end

  def self.db
    @db ||= setup_db
  end

  def self.query(input)
    claude = Claude::Client.new(ENV["ANTHROPIC_API_KEY"])
    prompt = "Give concise expert answers. Answer calmly and directly. Only ask questions if unclear. Never repeat questions or introduce your answer. If giving code samples, do not explain unless explicitly asked."
    messages = claude.user_message(prompt + "\n" + input)
    response = claude.messages(messages, model: Claude::Model::CLAUDE_SONNET_LATEST)
    text = claude.parse_response(response)
    cost = calculate_cost(response["usage"])
    log_query(input, text)
    "#{text} (Cost: $#{format("%.4f", cost)})"
  end

  def self.calculate_cost(usage)
    input_tokens = usage["input_tokens"]
    output_tokens = usage["output_tokens"]
    (input_tokens * 3 + output_tokens * 15) / 1_000_000.0
  end

  def self.log_query(query, response)
    db[:queries].insert(
      at: Time.now.utc,
      query: query,
      response: response
    )
  end
end
