module Magnet
  class Parser
    TRACKS = {
      1 => /\A%(?<format>[A-Z])(?<pan>[0-9 ]{1,19})\^(?<name>[^^]*)\^\s?(?<expiration>\d{4}|\^)(?<service_code>\d{3}|\^)(?<discretionary_data>[^\?]*)\?\Z/,
      2 => /\A;(?<pan>[0-9 ]{1,19})=(?<expiration>\d{4}|=)(?<service_code>\d{3}|=)(?<discretionary_data>[^\?]*)\?.?\Z/,
    }.freeze

    def initialize(track = :auto)
      @track = :auto
    end

    def parse(track_data)
      tracks = @track == :auto ? TRACKS.values : [TRACKS[@track]]

      tracks.each do |track|
        if m = track.match(track_data)
          attributes = {}
          if track == TRACKS[1]
            attributes[:format] = m[:format]
            attributes[:pan] = m[:pan]
            attributes[:name] = m[:name]
            attributes[:expiration] = m[:expiration] == "^" ? nil : m[:expiration]
            attributes[:service_code] = m[:service_code] == "^" ? nil : m[:service_code]
            attributes[:discretionary_data] = m[:discretionary_data] == "" ? nil : m[:discretionary_data]
            return attributes
          elsif track == TRACKS[2]
            attributes[:pan] = m[:pan]
            attributes[:expiration] = m[:expiration] == "=" ? nil : m[:expiration]
            attributes[:service_code] = m[:service_code] == "=" ? nil : m[:service_code]
            attributes[:discretionary_data] = m[:discretionary_data] == "" ? nil : m[:discretionary_data]
            return attributes
          end
        end
      end

      raise InvalidDataError, "track data is not valid"
    end

    class InvalidDataError < StandardError
    end
  end
end
