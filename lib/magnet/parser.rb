module Magnet
  class Parser
    TRACKS = {
      1 => /\A%(?<format>[A-Z])(?<pan>[0-9 ]{1,19})\^(?<name>[^^]*)\^\s?(?<expiration>\d{4}|\^)(?<service_code>\d{3}|\^)(?<discretionary_data>[^\?]*)\?\Z/,
      2 => /\A;(?<pan>[0-9 ]{1,19})=(?<expiration>\d{4}|=)(?<service_code>\d{3}|=)(?<discretionary_data>[^\?]*)\?.?\Z/,
      :emv => /\AB?(?<pan>[0-9 ]{1,19})(d|D)(?<expiration>\d{4}|(d|D))(?<service_code>\d{3}|(d|D))(?<discretionary_data>[^\?fF]*)(f|F)?0?.*\Z/,
    }.freeze

    def parse(track_data)
      TRACKS.each do |track_format, track|
        if m = track.match(track_data)
          attributes = {}
          attributes[:track_format] = track_format
          attributes[:pan] = m[:pan]
          attributes[:discretionary_data] = m[:discretionary_data].empty? ? nil : m[:discretionary_data]
          if track_format == 1
            attributes[:format] = m[:format]
            attributes[:name] = m[:name]
            attributes[:expiration] = m[:expiration] == "^" ? nil : m[:expiration]
            attributes[:service_code] = m[:service_code] == "^" ? nil : m[:service_code]
          elsif track_format == 2 || track_format == :emv
            attributes[:expiration] = m[:expiration] == "=" ? nil : m[:expiration]
            attributes[:service_code] = m[:service_code] == "=" ? nil : m[:service_code]
          end
          return attributes
        end
      end

      raise InvalidDataError, "track data is not valid"
    end

    class InvalidDataError < StandardError
    end
  end
end
