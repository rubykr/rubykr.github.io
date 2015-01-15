require 'spec_helper'
describe RSSGenerator do
  subject(:generator) { RSSGenerator.new }
  it { is_expected.not_to be_nil }

  describe "#articles" do
    before do
      allow(subject).to receive(:rows).and_return([
        '- [title](https://link.to.article){: .article data-date="2015.01.12" data-tags="translated ruby" data-author="author" }',
        '- [title](https://link.to.article){: .article data-date="2015.01.12" data-tags="ruby" data-author="author" }',
      ])
    end

    it { expect(subject.articles.size).to be(2) }
    it { expect(subject.articles.first["title"]).to eq("[번역] title") }
    it { expect(subject.articles.last["title"]).to eq("title") }

  end
end
