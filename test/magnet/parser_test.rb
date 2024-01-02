require "test_helper"

describe Magnet::Parser do
  describe "Track 1" do
    before do
      @parser = Magnet::Parser.new()
    end

    it "should parse sample #1" do
      attributes = @parser.parse("%B6011898748579348^DOE/ JOHN              ^37829821000123456789?")

      assert_equal "B", attributes[:format]
      assert_equal "6011898748579348", attributes[:pan]
      assert_equal "DOE/ JOHN              ", attributes[:name]
      assert_equal "3782", attributes[:expiration]
      assert_equal "982", attributes[:service_code]
      assert_equal "1000123456789", attributes[:discretionary_data]
      assert_equal 1, attributes[:track_format]
    end

    it "should ignore checksum when parsing track 1" do
      attributes = @parser.parse("%B6011898748579348^DOE/ JOHN              ^37829821000123456789??")

      assert_equal "B", attributes[:format]
      assert_equal "6011898748579348", attributes[:pan]
      assert_equal "DOE/ JOHN              ", attributes[:name]
      assert_equal "3782", attributes[:expiration]
      assert_equal "982", attributes[:service_code]
      assert_equal "1000123456789", attributes[:discretionary_data]
      assert_equal 1, attributes[:track_format]
    end

    it "should parse sample #2" do
      attributes = @parser.parse("%B6011785948493759^DOE/JOHN L                ^^^0000000      00998000000?")

      assert_equal "B", attributes[:format]
      assert_equal "6011785948493759", attributes[:pan]
      assert_equal "DOE/JOHN L                ", attributes[:name]
      assert_equal nil, attributes[:expiration]
      assert_equal nil, attributes[:service_code]
      assert_equal "0000000      00998000000", attributes[:discretionary_data]
      assert_equal 1, attributes[:track_format]
    end

    it "should parse sample #3" do
      attributes = @parser.parse("%B5452300551227189^HOGAN/PAUL      ^08043210000000725000000?")

      assert_equal "B", attributes[:format]
      assert_equal "5452300551227189", attributes[:pan]
      assert_equal "HOGAN/PAUL      ", attributes[:name]
      assert_equal "0804", attributes[:expiration]
      assert_equal "321", attributes[:service_code]
      assert_equal "0000000725000000", attributes[:discretionary_data]
      assert_equal 1, attributes[:track_format]
    end

    it "should parse without discretionary data" do
      attributes = @parser.parse("%B5452300551227189^HOGAN/PAUL      ^0804321?")

      assert_equal "B", attributes[:format]
      assert_equal "5452300551227189", attributes[:pan]
      assert_equal "HOGAN/PAUL      ", attributes[:name]
      assert_equal "0804", attributes[:expiration]
      assert_equal "321", attributes[:service_code]
      assert_equal nil, attributes[:discretionary_data]
    end

    it "should parse with ^ as the expiration" do
      attributes = @parser.parse("%B5452300551227189^HOGAN/PAUL      ^^321?")

      assert_equal "B", attributes[:format]
      assert_equal "5452300551227189", attributes[:pan]
      assert_equal "HOGAN/PAUL      ", attributes[:name]
      assert_equal nil, attributes[:expiration]
      assert_equal "321", attributes[:service_code]
      assert_equal nil, attributes[:discretionary_data]
    end

    it "should parse with ^ as the service code" do
      attributes = @parser.parse("%B5452300551227189^HOGAN/PAUL      ^0804^?")

      assert_equal "B", attributes[:format]
      assert_equal "5452300551227189", attributes[:pan]
      assert_equal "HOGAN/PAUL      ", attributes[:name]
      assert_equal "0804", attributes[:expiration]
      assert_equal nil, attributes[:service_code]
      assert_equal nil, attributes[:discretionary_data]
    end

    it "should parse track data with asterisk in the name" do
      attributes = @parser.parse("%B4750550000000000^MCTEST/SYDNEY*GEE^^^?")

      assert_equal "B", attributes[:format]
      assert_equal "4750550000000000", attributes[:pan]
      assert_equal "MCTEST/SYDNEY*GEE", attributes[:name]
    end

    it "should parse track data with spaces in the pan" do
      attributes = @parser.parse("%B3715 700000 00000^HAMMOND/G                 ^^^?")

      assert_equal "B", attributes[:format]
      assert_equal "3715 700000 00000", attributes[:pan]
      assert_equal "HAMMOND/G                 ", attributes[:name]
    end

    it "should parse track data with no name" do
      attributes = @parser.parse("%B4717270000000000^^0000000000000000000000000000000?")

      assert_equal "", attributes[:name]
    end

    it "should parse track data with numbers in the name" do
      attributes = @parser.parse("%B4717270000000000^LLC/TESTING SCENTS5^0000000000000000000000000000000?")

      assert_equal "LLC/TESTING SCENTS5", attributes[:name]
    end

    it "should parse track data with single quotes in the name" do
      attributes = @parser.parse("%B4717270000000000^JIM/O'CONNOR^0000000000000000000000000000000?")

      assert_equal "JIM/O'CONNOR", attributes[:name]
    end

    it "should parse track data with double quotes in the name" do
      attributes = @parser.parse('%B4717270000000000^JIM/O"CONNOR^0000000000000000000000000000000?')

      assert_equal 'JIM/O"CONNOR', attributes[:name]
    end

    it "should parse track data with backslash in the name" do
      attributes = @parser.parse('%B4717270000000000^JIM/O\CONNOR^0000000000000000000000000000000?')

      assert_equal 'JIM/O\CONNOR', attributes[:name]
    end

    it "should parse track data with dashes in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON-MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON-MAYNE/B", attributes[:name]
    end

    it "should parse track data with underscore in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON_MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON_MAYNE/B", attributes[:name]
    end

    it "should parse track data with ampersands in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON&MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON&MAYNE/B", attributes[:name]
    end

    it "should parse track data with exclamation mark in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON!MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON!MAYNE/B", attributes[:name]
    end

    it "should parse track data with at sign in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON@MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON@MAYNE/B", attributes[:name]
    end

    it "should parse track data with pound sign in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON#{}MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON#{}MAYNE/B", attributes[:name]
    end

    it "should parse track data with dollar sign in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON$MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON$MAYNE/B", attributes[:name]
    end

    it "should parse track data with percent in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON%MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON%MAYNE/B", attributes[:name]
    end

    it "should parse track data with star in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON*MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON*MAYNE/B", attributes[:name]
    end

    it "should parse track data with tilda in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON~MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON~MAYNE/B", attributes[:name]
    end

    it "should parse track data with comma in the name" do
      attributes = @parser.parse("%B4717270000000000^ALISON,MAYNE/B^0000000000000000000000000000000?")

      assert_equal "ALISON,MAYNE/B", attributes[:name]
    end

    it "should parse track data with 27 character names" do
      attributes = @parser.parse("%B4717270000000000^ALISON,MAYNE/B            /^0000000000000000000000000000000?")

      assert_equal "ALISON,MAYNE/B            /", attributes[:name]
    end

    it "should parse track data with space after the second carrot" do
      attributes = @parser.parse("%B4717270000000000^ALISON MAYNE/B^ 0000000?")
      assert_equal "ALISON MAYNE/B", attributes[:name]
    end
  end

  describe "Track 2" do
    before do
      @parser = Magnet::Parser.new()
    end
    
    it "should parse track 2 data sample #1" do
      attributes = @parser.parse(";4716916000001234=1809901123?")

      assert_equal "4716916000001234", attributes[:pan]
      assert_equal "1809", attributes[:expiration]
      assert_equal "901", attributes[:service_code]
      assert_equal "123", attributes[:discretionary_data]
      assert_equal 2, attributes[:track_format]
    end

    it "should parse track 2 data sample #2" do
      attributes = @parser.parse(";5301250070000191=08051010912345678901?")

      assert_equal "5301250070000191", attributes[:pan]
      assert_equal "0805", attributes[:expiration]
      assert_equal "101", attributes[:service_code]
      assert_equal "0912345678901", attributes[:discretionary_data]
      assert_equal 2, attributes[:track_format]
    end

    it "should parse track 2 data sample #3" do
      attributes = @parser.parse(";3540599999991047=080501234567?")

      assert_equal "3540599999991047", attributes[:pan]
      assert_equal "0805", attributes[:expiration]
      assert_equal "012", attributes[:service_code]
      assert_equal "34567", attributes[:discretionary_data]
      assert_equal 2, attributes[:track_format]
    end

    it "should ignore checksum when parsing track 2" do
      attributes = @parser.parse(";5413330089020037=1412101050930812??")

      assert_equal "5413330089020037", attributes[:pan]
      assert_equal "1412", attributes[:expiration]
      assert_equal "101", attributes[:service_code]
      assert_equal "050930812", attributes[:discretionary_data]
      assert_equal 2, attributes[:track_format]
    end
  end

  describe "EMV" do
    before do
      @parser = Magnet::Parser.new()
    end
    
    it "should parse emv track data sample #1" do
      attributes = @parser.parse("4716916000001234D18099011234")

      assert_equal "4716916000001234", attributes[:pan]
      assert_equal "1809", attributes[:expiration]
      assert_equal "901", attributes[:service_code]
      assert_equal "1234", attributes[:discretionary_data]
      assert_equal :emv, attributes[:track_format]
    end

    it "should parse emv track data sample #2" do
      attributes = @parser.parse("5301250070000191D08051010912345678901F")

      assert_equal "5301250070000191", attributes[:pan]
      assert_equal "0805", attributes[:expiration]
      assert_equal "101", attributes[:service_code]
      assert_equal "0912345678901", attributes[:discretionary_data]
      assert_equal :emv, attributes[:track_format]
    end

    it "should parse emv track data sample #3" do
      attributes = @parser.parse("3540599999991047D080501234567F")

      assert_equal "3540599999991047", attributes[:pan]
      assert_equal "0805", attributes[:expiration]
      assert_equal "012", attributes[:service_code]
      assert_equal "34567", attributes[:discretionary_data]
      assert_equal :emv, attributes[:track_format]
    end

    it "should parse emv track data sample with start sentinel" do
      attributes = @parser.parse("B3540599999991047D080501234567F")

      assert_equal "3540599999991047", attributes[:pan]
      assert_equal "0805", attributes[:expiration]
      assert_equal "012", attributes[:service_code]
      assert_equal "34567", attributes[:discretionary_data]
      assert_equal :emv, attributes[:track_format]
    end

    it "should parse emv track data sample with trailing zeroes" do
      attributes = @parser.parse("B3540599999991047D080501234567F000000000000")

      assert_equal "3540599999991047", attributes[:pan]
      assert_equal "0805", attributes[:expiration]
      assert_equal "012", attributes[:service_code]
      assert_equal "34567", attributes[:discretionary_data]
      assert_equal :emv, attributes[:track_format]
    end
  end

  describe "auto" do
    before do
      @parser = Magnet::Parser.new()
    end

    it "should parse track 1" do
      attributes = @parser.parse("%B6011898748579348^DOE/ JOHN              ^37829821000123456789?")

      assert_equal "B", attributes[:format]
      assert_equal "6011898748579348", attributes[:pan]
      assert_equal "DOE/ JOHN              ", attributes[:name]
      assert_equal "3782", attributes[:expiration]
      assert_equal "982", attributes[:service_code]
      assert_equal "1000123456789", attributes[:discretionary_data]
      assert_equal 1, attributes[:track_format]
    end

    it "should parse track 2" do
      attributes = @parser.parse(";4716916000001234=1809901123?")

      assert_equal "4716916000001234", attributes[:pan]
      assert_equal "1809", attributes[:expiration]
      assert_equal "901", attributes[:service_code]
      assert_equal "123", attributes[:discretionary_data]
      assert_equal 2, attributes[:track_format]
    end

    it "should parse emv tracks" do
      attributes = @parser.parse("4716916000001234D18099011234")

      assert_equal "4716916000001234", attributes[:pan]
      assert_equal "1809", attributes[:expiration]
      assert_equal "901", attributes[:service_code]
      assert_equal "1234", attributes[:discretionary_data]
      assert_equal :emv, attributes[:track_format]
    end
  end
end
