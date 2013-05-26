require_relative "../lib/cube"

describe Cube do

  it "creates a to_sresentation of itself" do
    Cube.new(2, "").to_s.must_equal <<EOF
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
    Cube.new(3, "").to_s.must_equal <<EOF
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
      Cube.new(2, "R'").to_s.must_equal <<EOF
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
      Cube.new(2, "L").to_s.must_equal <<EOF
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
      Cube.new(2, "R").to_s.must_equal <<EOF
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
      Cube.new(2, "U").to_s.must_equal <<EOF
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
      Cube.new(2, "R U").to_s.must_equal <<EOF
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
      Cube.new(3, "R F").to_s.must_equal <<EOF
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
      Cube.new(3, "R").to_s.must_equal <<EOF
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
