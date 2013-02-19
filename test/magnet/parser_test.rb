require "test_helper"

describe Magnet::Parser do
  describe "Track 1" do
    before do
      @parser = Magnet::Parser.new(1)
    end

    it "should parse sample #1" do
      attributes = @parser.parse("%B6011898748579348^DOE/ JOHN              ^37829821000123456789?")

      assert_equal "B", attributes[:format]
      assert_equal "6011898748579348", attributes[:pan]
      assert_equal "DOE/ JOHN              ", attributes[:name]
      assert_equal "3782", attributes[:expiration]
      assert_equal "982", attributes[:service_code]
      assert_equal "1000123456789", attributes[:discretionary_data]
    end

    it "should parse sample #2" do
      attributes = @parser.parse("%B6011785948493759^DOE/JOHN L                ^^^0000000      00998000000?")

      assert_equal "B", attributes[:format]
      assert_equal "6011785948493759", attributes[:pan]
      assert_equal "DOE/JOHN L                ", attributes[:name]
      assert_equal nil, attributes[:expiration]
      assert_equal nil, attributes[:service_code]
      assert_equal "0000000      00998000000", attributes[:discretionary_data]
    end

    it "should parse sample #3" do
      attributes = @parser.parse("%B5452300551227189^HOGAN/PAUL      ^08043210000000725000000?")

      assert_equal "B", attributes[:format]
      assert_equal "5452300551227189", attributes[:pan]
      assert_equal "HOGAN/PAUL      ", attributes[:name]
      assert_equal "0804", attributes[:expiration]
      assert_equal "321", attributes[:service_code]
      assert_equal "0000000725000000", attributes[:discretionary_data]
    end
  end
end
