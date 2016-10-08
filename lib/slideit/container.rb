require "slideit/template"

module Slideit
  class Container
    def initialize(file, options = {})
      @file = file
      @options = options
      prepare
    end

    def start
      if @server
        file_name = File.basename(@file)
        url = "http://localhost:#{@port}/#{file_name}"
        if @options[:pdf]
          url << "?print-pdf"
        end
        Thread.new {
          puts "Just waiting for 1 second...\n"
          sleep 1
          system "open #{url}"
        }

        @server.start
      end
    end

    private

    def prepare
      root = File.expand_path "../../../res/reveal.js-3.3.0", __FILE__
      @port = @options[:port] ? @options[:port].to_i : 8000

      @server = WEBrick::HTTPServer.new Port: @port, DocumentRoot: root

      trap 'INT' do @server.shutdown end

      mount_slide
      mount_assets
    end

    def mount_slide
      file_name = File.basename(@file)
      @server.mount_proc "/#{file_name}" do |req, res|
        res.status = 200
        res['Content-Type'] = 'text/html'
        res.body = slide_content(file_name)
      end
    end

    def slide_content(file_name)
      markdown = File.read(@file)
      template = Template.new file_name, markdown, @options
      template.render
    end

    def mount_assets
      #puts "assets is #{asset_files.inspect}"
      asset_files.each do |key, file|
        @server.mount(key,
                     WEBrick::HTTPServlet::DefaultFileHandler,
                     file)
      end
    end

    EXECLUDES = %W(.md .rb)
    def asset_files
      md_dir = File.expand_path "..", @file
      files = Dir["#{md_dir}/**/*"]
      pairs = {}
      files.each do |file|
        if File.file?(file) && !EXECLUDES.include?(File.extname(file))
          key = file.sub md_dir, ""
          pairs[key] = file
        end
      end
      pairs
    end
  end
end
