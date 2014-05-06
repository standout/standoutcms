require 'test_helper'

describe PageTemplate do

  describe 'versioning' do
    before do
      @pt = PageTemplate.new
    end

    it 'has many versions' do
      @pt.html = 'Test'
      @pt.save
      @pt.html = 'Test2'
      @pt.save
      @pt.versions.size.must_equal(1)
      @pt.versions.last.html.must_equal('Test2')
      @pt.versions.first.html.must_equal('Test')
    end

  end

end
