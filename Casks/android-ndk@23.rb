cask "android-ndk@23" do
  version "23c"
  sha256 "3236a82961fe13f78b9ef7d4ba863c510436b7503e2784d22a52168304257841"

  url "https://dl.google.com/android/repository/android-ndk-r#{version}-darwin.dmg",
      verified: "dl.google.com/android/repository/"
  name "Android NDK r23"
  desc "Toolset to implement parts of Android apps in native code"
  homepage "https://developer.android.com/ndk/index.html"

  livecheck do
    skip "Pinned to Android NDK r23 in this cask"
  end

  # shim script
  shimscript = "#{staged_path}/ndk_exec.sh"
  preflight do
    Pathname.new("#{HOMEBREW_PREFIX}/share").mkpath

    build = File.read("#{staged_path}/source.properties").match(/(?<=Pkg.Revision\s=\s\d\d.\d.)\d+/)
    FileUtils.ln_sf("#{staged_path}/AndroidNDK#{build}.app/Contents/NDK", "#{HOMEBREW_PREFIX}/share/android-ndk@23")

    File.write shimscript, <<~EOS
      #!/bin/bash
      readonly executable="#{staged_path}/AndroidNDK#{build}.app/Contents/NDK/ndk-$(basename ${0})"
      test -f "${executable}" && exec "${executable}" "${@}"
    EOS
  end

  %w[
    build
    depends
    gdb
    stack
    which
  ].each { |exec_name| binary shimscript, target: "ndk23-#{exec_name}" }

  uninstall delete: "#{HOMEBREW_PREFIX}/share/android-ndk@23"

  # No zap stanza required

  caveats <<~EOS
    You may want to add to your profile:
       'export ANDROID_NDK23_HOME="#{HOMEBREW_PREFIX}/share/android-ndk@23"'
  EOS
end
