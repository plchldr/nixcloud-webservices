{
  name = "static-nginx";

  machine.nixcloud.reverse-proxy.enable = true;
  machine.nixcloud.reverse-proxy.extendEtcHosts = true;
  machine.nixcloud.webservices.static-nginx = {
    foo.enable = true;
    foo.proxyOptions.TLS = "none";
    foo.proxyOptions.domain = "example.com";
    foo.proxyOptions.http.mode = "on";
    foo.proxyOptions.https.mode = "off";
    foo.proxyOptions.port = 8080;

    bar.enable = true;
    bar.proxyOptions.TLS = "none";
    bar.proxyOptions.domain = "example.org";
    bar.proxyOptions.http.mode = "on";
    bar.proxyOptions.https.mode = "off";
    bar.proxyOptions.port = 8081;
  };

  testScript = ''
    $machine->waitForUnit('multi-user.target');
    $machine->waitForOpenPort(80);
    $machine->succeed('echo works > /var/lib/nixcloud/webservices/static-nginx-foo/index.html');
    $machine->succeed('echo works > /var/lib/nixcloud/webservices/static-nginx-bar/index.html');
    $machine->succeed('test "$(curl -L http://example.com/)" = works');
    $machine->succeed('test "$(curl -L http://example.org/)" = works');
  '';
}
