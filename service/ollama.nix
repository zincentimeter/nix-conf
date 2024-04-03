{ ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  systemd.services.ollama = {
    # Allow immersive translation plugin to use
    environment.OLLAMA_ORIGINS = "*";
  };
}