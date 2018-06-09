require "./spec_helper"

alias R = Result(Int32,String)

describe Result do
  describe "Ok" do
    it "#value returns the value" do
      R.ok(3).value.should eq(3)
    end

    it "#ok? is true" do
      R.ok(9).ok?.should eq(true)
    end

    it "#error? is false" do
      R.ok(123).error?.should eq(false)
    end

    it "#error blows up" do
      result = false

      begin
        R.ok(234).error
      rescue
        result = true
      end

      result.should eq(true)
    end
  end

  describe "Error" do
    it "#value blows up" do
      explosion = false

      begin
        R.error("error").value
      rescue
        explosion = true
      end

      explosion.should eq(true)
    end

    it "#ok? is false" do
      R.error("error").ok?.should eq(false)
    end

    it "#error? is true" do
      R.error("error").error?.should eq(true)
    end

    it "#error returns the error" do
      R.error("error").error.should eq("error")
    end
  end
end
