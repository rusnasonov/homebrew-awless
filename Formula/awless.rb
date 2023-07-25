class Awless < Formula
  version = "v0.1.11"

  desc "The Mighty CLI for AWS"
  homepage "https://github.com/wallix/awless"
  url "https://github.com/wallix/awless.git",
        :tag => version
  head "https://github.com/wallix/awless.git"

  bottle do
    root_url "https://github.com/wallix/homebrew-awless/releases/download/#{version}"
    sha256 cellar: :any, big_sur: "dbd1e5f4afd1de6fe00372bd8b6fffa9a448bbf461019094a5061b1b96924096"
    sha256 cellar: :any, ventura: "dbd1e5f4afd1de6fe00372bd8b6fffa9a448bbf461019094a5061b1b96924096"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"
  
    # Install bash completion
    output = Utils.popen_read("#{bin}/awless completion bash")
    (bash_completion/"awless").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/awless completion zsh")
    (zsh_completion/"_awless").write output
  end

  def caveats
    <<~EOS

      In order to get awless completion,
        [bash] you need to install `bash-completion` with brew.
        OR
        [zsh], add the following line to your ~/.zshrc:
          source #{HOMEBREW_PREFIX}/share/zsh/site-functions/_awless
    EOS
  end

  test do
    run_output = shell_output("#{bin}/awless --help 2>&1")
    assert_match "Awless is a powerful command line tool to inspect, sync and manage your infrastructure", run_output
  end
end
