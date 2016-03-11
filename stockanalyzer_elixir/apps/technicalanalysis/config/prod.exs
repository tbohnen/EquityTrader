use Mix.Config

    config :logger, :console,
        level: :debug,
        format: "$date $time [$level] $metadata$message\n",
        metadata: [:user_id]

    config :db, dbname: "stockanalyzer_prod"
