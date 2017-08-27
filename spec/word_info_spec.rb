describe WordInfo do
  let(:word) { "cat" }

  before do
    allow(Lingvo).to receive(:translation).with(word) { fixture("word_translation").to_json }
    allow(Mashape).to receive(:information).with(word) { fixture("word_full_info").to_json }
    described_class.word = word
  end

  it "should give information" do
    expect(described_class.word_translation).to eql("кот, кошка")
    expect(described_class.word_definition).to eql("Cat [kæt]\n\nCat is cat\n\n")
    expect(described_class.word_synonyms).to eql("True cat\n\n")
  end
end
