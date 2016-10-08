require "slideit/version"
require "slideit/template"

require 'webrick'

module Slideit
  def self.show(file, options)
    root = File.expand_path "../../res/reveal.js-3.3.0", __FILE__
    #puts "root is #{root}"

    port = options[:port] ? options[:port].to_i : 8000
    server = WEBrick::HTTPServer.new Port: port, DocumentRoot: root

    trap 'INT' do server.shutdown end

    file_name = File.basename(file)
    server.mount_proc "/#{file_name}" do |req, res|
      res.status = 200
      res['Content-Type'] = 'text/html'
      res.body = slide_content(file_name, file)
    end

    server.start
  end

  def self.slide_content(file_name, file)
    markdown = File.read(file)
    template = Template.new file_name, markdown
    template.render
  end
end
