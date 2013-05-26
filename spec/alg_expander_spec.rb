require_relative "../lib/alg_expander"
require "minitest/autorun"

describe AlgExpander do
  let(:expander) {AlgExpander.new}
  it "keeps clockwise moves the same" do
    expander.expand("R").must_equal ["R"]
  end

  it "expands double moves into two clockwise moves" do
    expander.expand("R2").must_equal ["R", "R"]
  end

  it "expands prime moves into three clockwise moves" do
    expander.expand("R'").must_equal ["R", "R", "R"]
  end

  it "expands multiple-move algs" do
    expander.expand("R U2").must_equal ["R", "U", "U"]
  end

  it "doesn't mind if there's no whitespace" do
    expander.expand("RU2").must_equal ["R", "U", "U"]
  end
end
