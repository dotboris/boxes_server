module Boxes
  module Test
    module Env
      def maybe_create_media_root
        create_media_root! unless media_root
      end

      def maybe_delete_media_root
        delete_tmp_media_root! if @tmp_media_root
      end

      def create_media_root!
        @tmp_media_root = Dir.mktmpdir
        puts "Created tmp media root #{@tmp_media_root}"
      end

      def delete_tmp_media_root!
        FileUtils.rmtree @tmp_media_root
        puts "Deleted tmp media root #{@tmp_media_root}"
        @tmp_media_root = nil
      end

      def project_root
        File.expand_path '../../../../..', __FILE__
      end

      def amqp_url
        ENV['BOXES_AMQP_URL'] || 'amqp://boxes:boxes@localhost'
      end

      def media_root
        ENV['BOXES_MEDIA_ROOT'] || @tmp_media_root
      end

      def mongodb_url
        ENV['BOXES_MONGODB_URL'] || 'mongodb://localhost/boxes-test'
      end

      def inject_test_env!
        ENV['BOXES_AMQP_URL'] = amqp_url
        ENV['BOXES_MEDIA_ROOT'] = media_root
        ENV['BOXES_MONGODB_URL'] = mongodb_url
      end

      def drivethrough_port
        ENV['BOXES_DRIVE_THROUGH_PORT'] || 23456.to_s
      end
    end
  end
end