RSpec.describe "sometime" do
  describe "sentence" do
    context "no verb adjective conjunction" do
      it "ok" do
        expect(1).to eq 1
      end

      it "difficult" do
        expect(1).to eq 1
      end
    end

    context "all noun" do
      it "hard" do
        expect(1).to eq 1
      end

      context "noun arrival important" do
        it "just noun" do
          expect(1).to eq 1
        end
      end

      context "noun departure important" do
        it "just noun" do
          expect(1).to eq 1
        end
      end
    end
  end
end

RSpec.describe "we" do
  describe "can still" do
    it "friends" do
      expect(1).to eq 1
    end
  end
end

RSpec.describe "you" do
  it "monster" do
    expect(1).to eq 1
  end
end
