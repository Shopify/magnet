module Magnet
  class Card
    ALLOWED_SERVICES = {
      0..1 => :no_restrictions,
      2 => :goods_and_services_only,
      3 => :atm_only,
      4 => :cash_only,
      5 => :goods_and_services_only,
      6 => :no_restrictions,
      7 => :goods_and_services_only
    }.freeze

    AUTHORIZATION_PROCESSING = {
      0 => :normal,
      2 => :by_issuer,
      4 => :by_issuer_unless_explicit_agreement
    }.freeze

    FORMAT = {
      "A" => :reserved,
      "B" => :bank,
      "C".."M" => :reserved,
      "N".."Z" => :available
    }.freeze

    INTERCHANGE = {
      1..2 => :international,
      5..6 => :national,
      7 => :private,
      9 => :test
    }.freeze

    PIN_REQUIREMENTS = {
      0 => :pin_required,
      3 => :pin_required,
      5 => :pin_required,
      6..7 => :prompt_for_pin_if_ped_present
    }.freeze

    TECHNOLOGY = {
      2 => :integrated_circuit_card,
      6 => :integrated_circuit_card
    }.freeze

    attr_accessor :allowed_services, :authorization_processing, :discretionary_data, :expiration_year, :expiration_month, :first_name, :format, :initial, :interchange, :last_name, :number, :pin_requirements, :technology, :title

    class << self
      def parse(track_data, parser = Parser.new(:auto))
        attributes = parser.parse(track_data)
        position1, position2, position3 = (attributes[:service_code] || "").scan(/\d/).map(&:to_i)
        year, month = (attributes[:expiration] || "").scan(/\d\d/).map(&:to_i)
        title, first_name, initial, last_name = parse_name(attributes[:name].rstrip)

        card = new
        card.allowed_services = hash_lookup(ALLOWED_SERVICES, position3)
        card.authorization_processing = hash_lookup(AUTHORIZATION_PROCESSING, position2)
        card.discretionary_data = attributes[:discretionary_data]
        card.expiration_month = month
        card.expiration_year = year
        card.first_name = first_name
        card.format = hash_lookup(FORMAT, attributes[:format])
        card.initial = initial
        card.interchange = hash_lookup(INTERCHANGE, position1)
        card.last_name = last_name
        card.number = parse_pan(attributes[:pan])
        card.pin_requirements = hash_lookup(PIN_REQUIREMENTS, position3)
        card.technology = hash_lookup(TECHNOLOGY, position1)
        card.title = title
        card
      end

      private
      def hash_lookup(hash, key)
        hash.each do |k, v|
          return v if k === key
        end
        nil
      end

      def parse_name(name)
        last, first = name.split("/", 2)
        first, initial = first.split(" ", 2) if first
        initial, title = initial.split(".", 2) if initial
        [title, first, initial, last]
      end

      def parse_pan(pan)
        pan.delete(" ")
      end
    end

    def atm_only?
      allowed_services == :atm_only
    end

    def cash_only?
      allowed_services == :cash_only
    end

    def goods_and_services_only?
      allowed_services == :goods_and_services_only
    end

    def integrated_circuit_card?
      technology == :integrated_circuit_card
    end

    def international?
      interchange == :international
    end

    def national?
      interchange == :national
    end

    def no_service_restrictions?
      allowed_services = :no_restrictions
    end

    def pin_required?
      pin_requirements == :pin_required
    end

    def private?
      interchange == :private
    end

    def process_by_issuer?
      authorization_processing == :by_issuer
    end

    def process_by_issuer_unless_explicit_agreement?
      authorization_processing == :by_issuer_unless_explicit_agreement
    end

    def process_normally?
      authorization_processing == :normal
    end

    def prompt_for_pin_if_ped_present?
      pin_requirements == :prompt_for_pin_if_ped_present
    end

    def test?
      interchange == :test
    end
  end
end
