{
  disko.devices = {

    disk.main = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            end = "-16GiB";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
          swap = {
            size = "100%";
            content = {
              type = "swap";
              resumeDevice = true;
            }; # content
          }; # swap
        }; # partitions
      }; # content
    }; # disk.main
    /*
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        # The default, when neither size nor nr_blocks is specified, is size=50%.
        "default"
        # https://serverfault.com/q/644468
        "noatime"
        # 7=rwx, 5=r-x, 5=r-x
        # set mode to 755, otherwise systemd will set it to 777,
        # which cause problems.
        "mode=755"
      ]; # mountOptions
    }; # nodev."/"
    */
  }; # disko.devices
}

