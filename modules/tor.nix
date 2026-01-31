{
  config,
  pkgs,
  ...
}: {
  # Install obfs4proxy
  environment.systemPackages = with pkgs; [obfs4];

  services.tor = {
    enable = true;
    client.enable = true;

    # settings = {
    #   SOCKSPort = [{port = 9050;}];
    #   ControlPort = [{port = 9050;}];
    # UseBridges = 1;
    # ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
    #
    # # Try with just bridges first
    # Bridge = ["obfs4 86.30.100.123:42957 F3FA0D45D35E987484848345F8D92AB1D883889B cert=cxC0DfySYT/IBGBesOq64QKHCl5WdiR08qxcdsCpbpkj/2m6vwzpCFsP6m8r/+ZhdC26CA iat-mode=0"];
    # };
  };
}
