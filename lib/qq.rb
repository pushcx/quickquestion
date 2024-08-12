require "claude/client"
require "sequel"
require "fileutils"
require "xdg"

module QQ
  VERSION = "0.1.0" # Add this line to define the current version
  DB_PATH = File.join(XDG::Config.new.home, "qq/log.sqlite3")

  def self.setup_db
    FileUtils.mkdir_p(File.dirname(DB_PATH))
    @db ||= Sequel.connect("sqlite://#{DB_PATH}")

    @db.create_table? :queries do
      primary_key :id
      DateTime :at, null: false
      String :query, null: false
      String :response, null: false
    end

    @db.create_table? :version do
      String :version, null: false
    end

    check_and_update_version
    @db
  end

  def self.db
    @db ||= setup_db
  end

  def self.check_and_update_version
    version_count = @db[:version].count

    if version_count == 0
      @db[:version].insert(version: VERSION)
    elsif version_count > 1
      raise "Invalid 'version' table: multiple rows found"
    else
      db_version = @db[:version].first[:version]
      if db_version != VERSION
        warn "Warning: Database version (#{db_version}) does not match current version (#{VERSION})"
      end
    end
  end

  def self.query(input)
    api_key = ENV["ANTHROPIC_API_KEY"]
    raise "ANTHROPIC_API_KEY environment variable is not set" if api_key.nil? || api_key.empty?

    claude = Claude::Client.new(api_key)
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
