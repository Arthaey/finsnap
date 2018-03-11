module FakeWeb
  def self.register_uri_with_html(uri, html)
    FakeWeb.register_uri(:any, uri, :content_type => "text/html",
                         :body => html)
  end

  def self.register_uri_with_filename(uri, filename)
    FakeWeb.register_uri(:any, uri, :content_type => "text/html",
                         :body => File.read(filename))
  end
end
