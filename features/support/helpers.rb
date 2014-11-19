module SplitImageHelpers
  def delete_all_split_images
    FileUtils.rm_rf Dir.glob(File.join(media_root, '*'))
  end
end

module CommandHelpers
  def run_in_dir(dir, *cmd)
    Bundler.with_clean_env do
      inject_test_env!
      Dir.chdir dir do
        Open3.popen2e(*cmd) do |_, out, waiter|
          status = waiter.value
          raise "#{cmd.join(' ')} failed with status #{status.exitstatus} output:\n#{out.read}" unless status.success?
        end
      end
    end
  end
end

World(SplitImageHelpers, CommandHelpers)
