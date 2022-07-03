describe "example" do
  subject { digit }

  context "with even digits" do
    let(:digit) { 4 }

    it { expect(subject).to be_even }
    it { expect(subject).not_to be_odd }
  end

  context "with odd digits" do
    let(:digit) { 3 }

    it { expect(subject).to be_odd }
    it { expect(subject).not_to be_even }
  end
end
