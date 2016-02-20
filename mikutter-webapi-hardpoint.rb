#coding: utf-8

Plugin.create(:"mikutter-webapi-hardpoint") {
  require "webrick"

  @server = WEBrick::HTTPServer.new({ :BindAddress => "127.0.0.1", :Port => 39080 })
  
  # APIを登録する
  defdsl(:webapi) { |endpoint, &handler|
    @server.mount_proc("/#{endpoint}", &handler)
  }

  # プラグインロード時
  on_boot { |service|
    if service == Service.primary 

      # 指定されたタイトルとURLをポストボックスに突っ込む
      webapi("test") { |req, res|
        message = ">#{req.query["title"].force_encoding("UTF-8")}\n#{req.query["url"].force_encoding("UTF-8")}\n"
        
        Plugin[:gtk].widgetof(Plugin::GUI::Postbox::cuscaded.values.first).post.buffer.text = message
      }

      Thread.new {
        @server.start
      }
    end
  }
}
