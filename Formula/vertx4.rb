class Vertx4 < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://repo1.maven.org/maven2/io/vertx/vertx-stack-manager/4.4.4/vertx-stack-manager-4.4.4-full.zip"
  sha256 "d0735b14cb0b415985c1b5fa5e344ad123293ad7e0b0e2960a79257af085bc5c"
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
