#coding: utf-8

Plugin.create(:"mikutter-webapi-hardpoint") {
  require "webrick"

  # APIを登録する
  defdsl(:webapi) { |endpoint, &handler|
    if @server
      @server.mount_proc("/#{endpoint}", &handler)
    end
  }

  # プラグインロード時
  on_boot { |service|
    if service == Service.primary 
      begin
        @server = WEBrick::HTTPServer.new({ :BindAddress => "127.0.0.1", :Port => 39080 })
      rescue => e
        activity(:system, _("WebAPI用のWebサーバの起動に失敗しました"))
	next
      end

      # 指定されたタイトルとURLをポストボックスに突っ込む
      webapi("test") { |req, res|
        message = ">#{req.query["title"].force_encoding("UTF-8")}\n#{req.query["url"].force_encoding("UTF-8")}\n"
        postbox = Plugin::GUI::Postbox.instance
        postbox.options = {header: message, delegate_other: false}
        Plugin::GUI::Window.instance(:default) << postbox
      }

      Thread.new {
        @server.start
      }
    end
  }
}
