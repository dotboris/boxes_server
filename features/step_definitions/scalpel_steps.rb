Given(/have no split images/) do
  FileUtils.rm_rf Dir.glob(File.join(media_root, '*'))
end