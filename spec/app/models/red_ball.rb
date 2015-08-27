require 'app/models/concerns/status'

class RedBall
  include Mongoid::Document

  field :status, type: Status
end