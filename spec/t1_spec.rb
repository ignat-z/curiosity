describe "Post" do
  context "before publication" do
    let(:time) { Date.new(2000, 1, 1) }

    before do
      travel_to time
    end

    it "cannot have comments" do
      expect(Time.now.to_date).to eql(time)
    end
  end
end
