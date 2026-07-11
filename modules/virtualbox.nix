{ host, ... }: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
    headless = host.session == null;
  };
}
