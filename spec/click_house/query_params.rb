RSpec.describe 'query parameters' do
  subject do
    ClickHouse.connection
  end

  context 'NULL' do
    it 'works' do
      val = nil
      resp = subject.select_value('select {id:Nullable(String)} as id', id: val)
      expect(resp).to eq(val)
    end
  end

  context 'UInt8' do
    it 'works' do
      val  = 255
      resp = subject.select_value('select {id:UInt8}', id: val)
      expect(resp).to eq(val)
    end
  end

  context 'Bool' do
    it 'works' do
      val  = true
      resp = subject.select_value('select {id:Bool}', id: val)
      expect(resp).to eq(val)
    end
  end

  context 'Decimal' do
    it 'works' do
      val  = BigDecimal('1.0')
      resp = subject.select_value('select {id:Decimal}', id: val)
      expect(resp).to eq(val)
    end
  end

  context 'String' do
    it 'works' do
      val = "1 ' \t \" 2"
      resp = subject.select_value('select {id:String}', id: val)
      expect(resp).to eq(val)
    end
  end

  context 'DateTime' do
    it 'works' do
      val = DateTime.now
      resp = subject.select_value('select {id:DateTime}', id: val)
      expect(resp).to eq(Time.at(val.to_i))
    end
  end

  context 'DateTime64(9)' do
    it 'works' do
      val = DateTime.now
      ser = ClickHouse::Type::DateTime64Type.new.serialize(val, 9)
      resp = subject.select_value('select {id:DateTime64(9)}', id: ser)
      expect(resp).to eq(val)
    end
  end

  context 'Array(Int8)' do
    it 'works' do
      vals = [-128, 127]
      resp = subject.select_value('select {id:Array(Int8)}', id: vals)
      expect(resp).to eq(vals)
    end
  end

  context 'Array(String)' do
    it 'works' do
      vals = ['arr\'1', 'arr\'2']
      resp = subject.select_value('select {id:Array(String)}', id: vals)
      expect(resp).to eq(vals)
    end
  end

  context 'Map(String, UInt64)' do
    it 'works' do
      vals = {'First' => 12345, 'Second' => 56789}
      resp = subject.select_value('select {id:Map(String,UInt64)}', id: vals)
      expect(resp).to eq(vals)
    end
  end
end
