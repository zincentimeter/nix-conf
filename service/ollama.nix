{ ... }:

{
  services.ollama = {
    enable = false;
    acceleration = "cuda";
  };
  # systemd.services.ollama = {
  #   # Allow immersive translation plugin to use
  #   environment.OLLAMA_ORIGINS = "*";
  # };
}
