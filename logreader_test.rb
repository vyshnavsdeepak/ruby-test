require "test/unit"
require 'tempfile'
require_relative './logreader' 

class LogReaderTest < Test::Unit::TestCase
  def setup
    @tempfile = Tempfile.new

    # home - 3 visits, 2 unique visitors
    @tempfile << "/home 2.2.2.2\n" 
    @tempfile << "/home 2.2.2.2\n"
    @tempfile << "/home 2.2.3.3\n"

    # about - 1 visit,1 unique visitors
    @tempfile << "/about 1.1.1.1\n"

    # contact - 2 visits, 1 unique visitors
    @tempfile << "/contact 3.3.3.3\n"
    @tempfile << "/contact 3.3.3.3\n"

    @tempfile.flush
  end

  def test_get_info
    instance = LogReader.new(@tempfile.path)

    sorted_unique_visitors_count = sortHashByValue(instance.getUniqueVisitsCount())
    expected_unique_visitors_count = [["/home", 2], ["/contact", 1], ["/about", 1]]

    assert_equal(expected_unique_visitors_count, sorted_unique_visitors_count, "Unique visitors count do not match")

    total_vistors_count = sortHashByValue(instance.getViewsCount())
    expected_total_visitors_count = [["/home", 3], ["/contact", 2], ["/about", 1]]
  
    assert_equal(expected_total_visitors_count, total_vistors_count, "Visitors count do not match")
  end
end
