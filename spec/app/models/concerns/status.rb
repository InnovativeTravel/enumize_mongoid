class Status
  include EnumizeMongoid::Field

  enumize([:bouncing, :still], create_constants: true)
end