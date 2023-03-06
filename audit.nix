{ config, pkgs, ... }: {
  # Based on https://xeiaso.net/blog/paranoid-nixos-2021-07-18
  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    # Log all executed programs
    #"-a exit,always -F arch=b64 -S execve"
    # Log when root accesses other users files
    "-a always,exit -F dir=/home/ -F uid=0 -C auid!=obj_uid"
  ];
}
