{ ... }:

{
  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    hashedPassword = "REDACTED=================================================================";
  };
  users.users.shinri = {
    hashedPassword = "REDACTED=================================================================";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
}
