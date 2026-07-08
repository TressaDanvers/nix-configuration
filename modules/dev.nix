{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ bat jujutsu git gh tree sops age ];
}
