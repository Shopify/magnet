module Magnet
  class Parser
    TRACKS = {
      1 => /\A%(?<format>[A-Z])(?<pan>\w{1,19})\^(?<name>[A-Za-z.\/ ]{2,26})\^(?<expiration>\d{4}|\^)(?<service_code>\d{3}|\^)(?<discretionary_data>[^\?]+)\?\Z/,
      2 => /\A;(?<format>[A-Z])(?<pan>\w{1,19})=(?<expiration>\d{4}|=)(?<service_code>\d{3}|=)(?<discretionary_data>[^\?]+)\?\Z/
    }.freeze

    def initialize(track = :auto)
      @track = :auto
    end

    def parse(track_data)
      tracks = @track == :auto ? TRACKS.values : [TRACKS[@track]]

      tracks.each do |track|
        if m = track.match(track_data)
          attributes = {}
          attributes[:format] = m[:format]
          attributes[:pan] = m[:pan]
          attributes[:name] = m[:name]
          attributes[:expiration] = m[:expiration] == "^" ? nil : m[:expiration]
          attributes[:service_code] = m[:service_code] == "^" ? nil : m[:service_code]
          attributes[:discretionary_data] = m[:discretionary_data]
          return attributes
        end
      end

      raise InvalidDataError, "track data is not valid"
    end

    class InvalidDataError < StandardError
    end
  end
end
