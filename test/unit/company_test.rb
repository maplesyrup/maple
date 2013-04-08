require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  def setup
    # Have to delete index before each test
    Company.index.delete
    Company.create_elasticsearch_index

    @apple = companies(:apple)
    @microsoft = companies(:microsoft)
    Company.index.import [@microsoft, @apple]
    Company.index.refresh
  end

  def teardown
  end

  test "Basic model search" do
    c = Company.paged_companies
    assert_equal 2, c.results.length
  end

  test "Search by name" do
    c = Company.paged_companies({ :query => 'apple' })
    assert_equal 1, c.results.length
    assert_equal @apple.name, c.results[0].name
  end

  test "Search by blurb title" do
    c = Company.paged_companies({ :crumb => 'blurb_title', :query => 'shit product*' })
    assert_equal 1 ,c.results.length
    assert_equal @microsoft.name, c.results[0].name
  end
end
