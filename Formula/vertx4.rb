class Vertx4 < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://repo1.maven.org/maven2/io/vertx/vertx-stack-manager/4.5.6/vertx-stack-manager-4.5.6-full.zip"
  sha256 "7470d4cb98275fc391b23caabeb9c927889ea3040ce8c57caeeb2d80bac4e620"
  license any_of: ["EPL-2.0", "Apache-2.0"]

  livecheck do
    url "https://vertx.io/download/"
    regex(/href=.*?vert\.x[._-]v?(\d+(?:\.\d+)+)-full\.t/i)
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script "#{libexec}/bin/vertx", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      import io.vertx.core.AbstractVerticle;
      public class HelloWorld extends AbstractVerticle {
        public void start() {
          System.out.println("Hello World!");
          vertx.close();
          System.exit(0);
        }
      }
    EOS
    output = shell_output("#{bin}/vertx run HelloWorld.java")
    assert_equal "Hello World!\n", output
  end
end
