require "test_helper"

describe Magnet::Card do
  describe "Parse" do
    before do
      @parser = Magnet::Parser.new(:auto)
    end

    it "track 2 should work" do
      track_data = ";4716916000001234=1809901123?"
      card = Magnet::Card.parse(track_data, @parser)
      assert_equal "4716916000001234", card.number
      assert_equal :no_restrictions, card.allowed_services
      assert_equal :normal, card.authorization_processing
      assert_equal "123", card.discretionary_data
      assert_equal 9, card.expiration_month
      assert_equal 18, card.expiration_year
      assert_equal :test, card.interchange
      assert_nil card.first_name
      assert_nil card.format
      assert_nil card.initial
      assert_nil card.last_name
      assert_nil card.pin_requirements
      assert_nil card.technology
      assert_nil card.title
    end

    it "track 1 should work" do
      track_data = "%B5452300551227189^HOGAN/PAUL      ^08043210000000725000000?"
      card = Magnet::Card.parse(track_data, @parser)
      assert_equal "5452300551227189", card.number
      assert_equal :no_restrictions, card.allowed_services
      assert_equal :by_issuer, card.authorization_processing
      assert_equal "0000000725000000", card.discretionary_data
      assert_equal 4, card.expiration_month
      assert_equal 8, card.expiration_year
      assert_nil card.interchange
      assert_equal "PAUL", card.first_name
      assert_equal :bank, card.format
      assert_nil card.initial
      assert_equal "HOGAN", card.last_name
      assert_nil card.pin_requirements
      assert_nil card.technology
      assert_nil card.title
    end

    it "EMV track 2 should work" do
      track_data = "5213320039019055d2512620062930423f"
      card = Magnet::Card.parse(track_data, @parser)
      assert_equal "5213320039019055", card.number
      assert_equal :no_restrictions, card.allowed_services
      assert_equal :by_issuer, card.authorization_processing
      assert_equal "062930423", card.discretionary_data
      assert_equal 12, card.expiration_month
      assert_equal 25, card.expiration_year
      assert_equal :national, card.interchange
      assert_equal :integrated_circuit_card, card.technology
      assert_equal :pin_required, card.pin_requirements
      assert_nil card.first_name
      assert_nil card.format
      assert_nil card.initial
      assert_nil card.last_name
      assert_nil card.title
    end
  end
end