require_relative "../lib/cube"

describe Cube do

  describe "#rotate" do
    it "rotates the square representation of an array clockwise" do
      Cube.new(2).rotate([1, 2,
                          3, 4]).must_equal(
                         [3, 1,
                          4, 2])
    end
  end

  it "creates a representation of itself" do
    Cube.new(2).rep.must_equal <<EOF
  UU
  UU
LLFFRR
LLFFRR
  DD
  DD
  BB
  BB
EOF
  end

  it "works for multiple sizes" do
    Cube.new(3).rep.must_equal <<EOF
   UUU
   UUU
   UUU
LLLFFFRRR
LLLFFFRRR
LLLFFFRRR
   DDD
   DDD
   DDD
   BBB
   BBB
   BBB
EOF
  end

  describe "turns" do

    it "does R' turns" do
      Cube.new(2).perform("R'").rep.must_equal <<EOF
  UB
  UB
LLFURR
LLFURR
  DF
  DF
  BD
  BD
EOF
    end

    it "does L turns" do
      Cube.new(2).perform("L").rep.must_equal <<EOF
  BU
  BU
LLUFRR
LLUFRR
  FD
  FD
  DB
  DB
EOF
    end

    it "does R turns" do
      Cube.new(2).perform("R").rep.must_equal <<EOF
  UF
  UF
LLFDRR
LLFDRR
  DB
  DB
  BU
  BU
EOF
    end

    it "does U turns" do
      Cube.new(2).perform("U").rep.must_equal <<EOF
  UU
  UU
FFRRBB
LLFFRR
  DD
  DD
  BB
  LL
EOF
    end

    it "does multiple turns" do
      Cube.new(2).perform("R U").rep.must_equal <<EOF
  UU
  FF
FDRRUB
LLFDRR
  DB
  DB
  BU
  LL
EOF
    end

    it "does multiple turns for other cubes" do
      Cube.new(3).perform("R F").rep.must_equal <<EOF
   UUF
   UUF
   LLL
LLDFFFURR
LLDFFFURR
LLBDDDFRR
   RRR
   DDB
   DDB
   BBU
   BBU
   BBU
EOF
    end

    it "does R turns for other cubes" do
      Cube.new(3).perform("R").rep.must_equal <<EOF
   UUF
   UUF
   UUF
LLLFFDRRR
LLLFFDRRR
LLLFFDRRR
   DDB
   DDB
   DDB
   BBU
   BBU
   BBU
EOF
    end

  end
end
