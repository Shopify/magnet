require "test_helper"

describe Magnet::Card do
  describe "Parse" do
    before do
      @attributes = { :format => "B", :pan => "5452300551227189", :name => "HOGAN/PAUL      ", :expiration => "0804", :service_code => "321", :discretionary_data => "0000000725000000" }
      @parser = stub()
      @track_data = stub()
      @parser.stubs(:parse).with(@track_data).returns(@attributes)
    end

    it "should parse basic attributes" do
      card = Magnet::Card.parse(@track_data, @parser)

      assert_equal :no_restrictions, card.allowed_services
      assert_equal :by_issuer, card.authorization_processing
      assert_equal "0000000725000000", card.discretionary_data
      assert_equal 8, card.expiration_year
      assert_equal 4, card.expiration_month
      assert_equal "PAUL", card.first_name
      assert_equal :bank, card.format
      assert_equal nil, card.initial
      assert_equal nil, card.interchange
      assert_equal "HOGAN", card.last_name
      assert_equal "5452300551227189", card.number
      assert_equal nil, card.pin_requirements
      assert_equal nil, card.technology
      assert_equal nil, card.title
    end

    it "should parse an initial" do
      @attributes = { :format => "B", :pan => "5452300551227189", :name => "HOGAN/PAUL A    ", :expiration => "0804", :service_code => "321", :discretionary_data => "0000000725000000" }
      @parser.stubs(:parse).with(@track_data).returns(@attributes)

      card = Magnet::Card.parse(@track_data, @parser)

      assert_equal "PAUL", card.first_name
      assert_equal "A", card.initial
      assert_equal "HOGAN", card.last_name
      assert_equal nil, card.title
    end

    it "should parse a title" do
      @attributes = { :format => "B", :pan => "5452300551227189", :name => "HOGAN/PAUL A.DR ", :expiration => "0804", :service_code => "321", :discretionary_data => "0000000725000000" }
      @parser.stubs(:parse).with(@track_data).returns(@attributes)

      card = Magnet::Card.parse(@track_data, @parser)

      assert_equal "PAUL", card.first_name
      assert_equal "A", card.initial
      assert_equal "HOGAN", card.last_name
      assert_equal "DR", card.title
    end
  end
end
