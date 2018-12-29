# frozen_string_literal: true

class ApplicationState < StateBase
  include RedisConnection
end
