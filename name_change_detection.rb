require './database'

module NameChangeDetection
  # 今回のメイン機能を実装したクラス
  class Main
    def initialize
      @manager = SimpleMastodon.new
    end

    # threadを追加するメソッド
    def register_thread
      ncd_thread = Thread.new do
        loop do
          sleep(5.0)
          name_change_detection
        end
      end
      ncd_thread.join

      rm_thread = Thread.new do
        loop do
          sleep(2.0)
          reaction_mention
        end
      end
      rm_thread.join
    end

    # 名前変更検知を行うメソッド
    def name_change_detection

    end

    # mentionに合わせてtootをリプライするメソッド
    def reaction_mention

    end
  end
end
