require 'spec_helper'
describe RSSGenerator do
  subject(:generator) { RSSGenerator.new }
  it { is_expected.not_to be_nil }
end

describe Article do
  describe ".all" do
    subject(:articles) { Article.all([
        '- [title](https://link.to.article){: .article data-date="2015.01.12" data-tags="translated ruby" data-author="author" }',
        '- [title](https://link.to.article){: .article data-date="2015.01.12" data-tags="ruby" data-author="author" }',
      ]) }
    it { expect(articles.size).to be(2) }
  end

  describe "#new" do
    subject(:article) { Article.new(row) }
    context 'when translated row' do
      let(:row) { '- [title](https://link.to.article){: .article data-date="2015.01.12" data-tags="translated ruby" data-author="author" }' }
      it { expect(subject.to_h["title"]).to eq("[번역] title") }
    end

    context 'when normal row' do
      let(:row) { '- [title](https://link.to.article){: .article data-date="2015.01.12" data-tags="ruby" data-author="author" }' }
      it { expect(subject.to_h["title"]).to eq("title") }
    end

    context 'when invalid row' do
      let(:row) { '' }
      it { expect { article }.to raise_error Article::InvalidRow }
    end
  end
end
