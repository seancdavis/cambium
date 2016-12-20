module SpecHelpers

  def app_path(*dirs)
    Rails.root.join(*dirs.join('/')).to_s
  end

  def should_have_file(path)
    expect(have_file(path)).to eq(true)
  end

  def should_have_no_file(path)
    expect(have_file(path)).to eq(false)
  end

  def have_file(path)
    File.exists?(app_path(path))
  end

  def remove_file(path)
    return unless have_file(path)
    FileUtils.rm(app_path(path))
  end

end
