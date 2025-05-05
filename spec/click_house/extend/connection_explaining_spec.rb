RSpec.describe ClickHouse::Extend::ConnectionExplaining do
  subject do
    ClickHouse.connection
  end

  before do
    subject.execute <<~SQL
      CREATE TABLE rspec(id Int64) ENGINE TinyLog
    SQL
  end

  let(:expectation) do
    <<~TXT
      Expression ((Project names + (Projection + Drop unused columns after JOIN)))
        Join (JOIN FillRightFirst)
          Expression (Change column names to column identifiers)
            ReadFromStorage (TinyLog)
          Expression (Change column names to column identifiers)
            ReadFromStorage (TinyLog)
    TXT
  end

  context 'when normal query' do
    it 'works' do
      buffer = StringIO.new
      subject.explain('SELECT 1 FROM rspec CROSS JOIN rspec', io: buffer)
      expect(buffer.string).to eq(expectation)
    end
  end

  context 'when EXPLAIN query' do
    it 'works' do
      buffer = StringIO.new
      subject.explain('EXPLAIN SELECT 1 FROM rspec CROSS JOIN rspec', io: buffer)
      expect(buffer.string).to eq(expectation)
    end
  end
end
