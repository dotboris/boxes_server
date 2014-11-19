module Boxes
  module Test
    module Env
      def amqp_url
        ENV['BOXES_AMQP_URL'] || 'amqp://boxes:boxes@localhost'
      end

      def media_root
        ENV['BOXES_MEDIA_ROOT'] || tmp_media_root.to_s
      end

      def inject_test_env!
        ENV['BOXES_AMQP_URL'] = amqp_url
        ENV['BOXES_MEDIA_ROOT'] = media_root
      end
    end
  end
end