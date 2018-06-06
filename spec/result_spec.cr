require "./spec_helper"

describe Result do
  describe Ok do
    it "#value returns the value" do
      Ok(Int32, String).new(3).value.should eq(3)
    end

    it "#ok? is true" do
      Ok(Int32, String).new(9).ok?.should eq(true)
    end

    it "#error? is false" do
      Ok(Int32, String).new(123).error?.should eq(false)
    end

    it "#error blows up" do
      result = false

      begin
        Ok(Int32, String).new(234).error
      rescue
        result = true
      end

      result.should eq(true)
    end
  end

  describe Error do
    it "#value blows up" do
      explosion = false

      begin
        Error(Int32, String).new("error").value
      rescue
        explosion = true
      end

      explosion.should eq(true)
    end

    it "#ok? is false" do
      Error(Int32, String).new("error").ok?.should eq(false)
    end

    it "#error? is true" do
      Error(Int32, String).new("error").error?.should eq(true)
    end

    it "#error returns the error" do
      Error(Int32, String).new("error").error.should eq("error")
    end
  end
end
