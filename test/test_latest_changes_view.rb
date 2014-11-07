# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require File.expand_path '../../lib/gollum/views/latest_changes', __FILE__

context "Precious::Views::LatestChanges" do
  include Rack::Test::Methods

  def app
    Precious::App
  end

  setup do
    @path = cloned_testpath("examples/lotr.git")
    @wiki = Gollum::Wiki.new(@path)
    Precious::App.set(:gollum_path, @path)
    Precious::App.set(:wiki_options, {:latest_changes_count => 10})
  end

  test "displays_latest_changes" do
    get('/latest_changes')
    body = last_response.body
    assert body.include?('<span class="username">Charles Pence</span>'), "/latest_changes should include the Author Charles Pence"
    assert body.include?('60f12f4'), "/latest_changes should include the :latest_changes_count commit"
    assert !body.include?('0ed8cbe'), "/latest_changes should not include more than latest_changes_count commits"
    assert body.include?('<a href="Data-Two.csv">Data-Two.csv</a>'), "/latest_changes include links to modified files in #{body}"
    assert body.include?('<a href="Hobbit">Hobbit.md</a>'), "/latest_changes should include links to modified pages in #{body}"
    assert body.include?('<a href="My-Precious">My-&lt;b&gt;Precious.md =&gt; My-Precious.md</a>'), "/latest_changes should indicate renaming action in #{body}"
  end

  teardown do
    FileUtils.rm_rf(@path)
  end
end
