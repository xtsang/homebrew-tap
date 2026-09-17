cask "android-ndk@23" do
  version "23c"
  sha256 "3236a82961fe13f78b9ef7d4ba863c510436b7503e2784d22a52168304257841"

  url "https://dl.google.com/android/repository/android-ndk-r#{version}-darwin.dmg"
  name "Android NDK r23"
  desc "Toolset to implement parts of Android apps in native code"
  homepage "https://developer.android.com/ndk/index.html"

  livecheck do
    skip "Pinned to Android NDK r23 in this cask"
  end

  # Android NDK r23c contains AndroidNDK8568313.app.
  %w[
    build
    gdb
    stack
    which
  ].each do |exec_name|
    command_wrapper "ndk23-#{exec_name}",
                    executable: "#{staged_path}/AndroidNDK8568313.app/Contents/NDK/ndk-#{exec_name}"
  end

  preflight_steps do
    symlink "AndroidNDK8568313.app/Contents/NDK", "share/android-ndk@23",
            target_base: :homebrew_prefix,
            overwrite:   true
  end

  uninstall delete: "#{HOMEBREW_PREFIX}/share/android-ndk@23"

  # No zap stanza required

  caveats <<~EOS
    You may want to add to your profile:
       'export ANDROID_NDK23_HOME="#{HOMEBREW_PREFIX}/share/android-ndk@23"'
  EOS
end
