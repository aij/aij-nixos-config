{ config, lib, ... }:
let
  nets = {
    net0 = {
      prefixLength = 24;
    };
    net1 = {
      prefixLength = 24;
    };
    ib = {
      prefixLength = 24;
    };
  };
  hostlist = {
    m0 = {
      net0 = {
        iface = "enp2s0f0";
        mac = "B8:38:61:7B:F7:DC";
        ip = "10.0.0.10";
      };
      net1 = {
        iface = "enp2s0f1";
        mac = "B8:38:61:7B:F7:DD";
        ip = "10.0.1.10";
      };
      ib = {
        iface = "ibp5s0";
        ip = "10.0.9.10";
      };
    };
    m1 = {
      net0 = {
        iface = "enp1s0f0";
        mac = "e4:c7:22:84:03:60";
        ip = "10.0.0.11";
      };
      net1 = {
        iface = "enp1s0f1";
        ip = "10.0.1.11";
      };
      ib = {
        iface = "ibp3s0";
        ip = "10.0.9.11";
      };
    };
    m2 = {
      net0 = {
        iface = "eno1";
        mac = "84:2b:2b:56:17:a6";
        ip = "192.168.1.21";
      };
    };
    m3 = {
      net0 = {
        iface = "eno1";
        mac = "9C:B6:54:9B:CA:F8";
        ip = "10.0.0.13";
      };
      ib = {
        iface = "ibp10s0d1";
        ip = "10.0.9.13";
      };
    };
    m4 = {
      net0 = {
        iface = "enp8s0f0";
        mac = "BC:16:65:0B:0C:1A";
        ip = "10.0.0.14";
      };
      net1 = {
        iface = "enp8s0f1";
        ip = "10.0.1.14";
      };
      ib = {
        iface = "ibp3s0";
        ip = "10.0.9.14";
      };
    };
    m5 = {
      net0 = {
        iface = "eno1";
        mac = "d4:ae:52:e8:e8:25";
        ip = "10.0.0.15";
        driver = "bnx2";
      };
      net1 = {
        iface = "eno2";
        mac = "d4:ae:52:e8:e8:27";
        ip = "10.0.1.15";
      };
      ib = {
        iface = "ibp35s0";
        ip = "10.0.9.15";
      };
    };
    m6 = {
      net0 = {
        iface = "eno1";
        mac = "90:b1:1c:fc:c6:51";
        ip = "10.0.0.16";
        driver = "bnx2";
      };
      net1 = {
        iface = "eno2";
        mac = "90:b1:1c:fc:c6:53";
        ip = "10.0.1.16";
      };
      ib = {
        iface = "ibp8s0";
        ip = "10.0.9.16";
      };
    };
    c0n0 = {
      net1 = {
        #iface = "eno1"
        mac = "34:40:b5:bc:15:c7";
        ip = "10.0.1.184";
      };
    };
    c0n1 = {
      net1 = {
        mac = "34:40:b5:bc:15:e0";
        ip = "10.0.1.178";
      };
    };

    c1n0 = {
      net1 = {
        mac = "00:25:90:d3:fd:04";
        ip = "10.0.1.163"; # Change to 110
      };
    };
    c1n1 = {
      net1 = {
        mac = "00:25:90:d3:fc:48";
        ip = "10.0.1.176";
      };
    };
    c1n2 = {
      net1 = {
        mac = "00:25:90:d3:fc:5c";
        ip = "10.0.1.165";
      };
    };
    c1n3 = {
      net1 = {
        mac = "00:25:90:d3:fc:fc";
        ip = "10.0.1.167";
      };
    };

    c2n0 = {
      net1 = {
        mac = "00:25:90:d4:27:24";
        ip = "10.0.1.169";
      };
    };
    c2n1 = {
      net1 = {
        mac = "00:25:90:d3:fc:4e";
        ip = "10.0.1.171";
      };
    };
    c2n2 = {
      net1 = {
        mac = "00:25:90:d4:47:8c";
        ip = "10.0.1.161"; # Change to 123
      };
    };
    c2n3 = {
      net1 = {
        mac = "00:25:90:d4:24:d8";
        ip = "10.0.1.173";
      };
    };
    sw0 = {
      net0 = {
        ip = "10.0.0.2";
      };
      net1 = {
        ip = "10.0.1.1";
      };
    };
  };
  localnetpref = [ "ib" "net1" "net0" ];
  defaultnetpref = [ "net0" ];
  myconf = hostlist.${config.networking.hostName} or { };
  mystatic = lib.filterAttrs (_: i: i ? iface) myconf;
  mynetpref = lib.filter (n: myconf ? ${n}) localnetpref ++ defaultnetpref;
in
{
  networking.hosts = (
    with builtins;
    let names = attrNames hostlist; in
    let genLine = hostname: netname:
      let
        hostconf = hostlist.${hostname};
        conf = hostlist.${hostname}.${netname};
        is_preferred = netname == lib.findFirst (x: hostconf ? ${x}) "net0" mynetpref;
      in
      {
        name = conf.ip;
        value = [ "${hostname}.${netname}" ] ++ lib.optional is_preferred hostname;
      }; in
    let nested = map
      (hostname:
        map (genLine hostname) (attrNames hostlist.${hostname})
      )
      names; in
    listToAttrs (concatLists nested)
  );

  networking.interfaces = (
    with builtins;
    let s = lib.filterAttrs (_: i: i ? iface) myconf; in
    lib.mapAttrs'
      (n: v: {
        name = v.iface;
        value = {
          ipv4.addresses = [{
            address = v.ip;
            prefixLength = nets.${n}.prefixLength;
          }];
        };
      })
      s
  );

  boot.kernelParams = lib.optional (mystatic ? net0 && mystatic.net0 ? driver) (
    let
      client-ip = mystatic.net0.ip;
      server-ip = "";
      gw-ip = "10.0.0.1";
      netmask = "255.255.255.0";
      hostname = config.networking.hostName;
      device = mystatic.net0.iface;
      autoconf = "off";
      dns0-ip = builtins.head config.networking.nameservers;
      dns1-ip = builtins.head (builtins.tail config.networking.nameservers);
      ntp0-ip = "";
    in
    # Per https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
    "ip=${client-ip}:${server-ip}:${gw-ip}:${netmask}:${hostname}:${device}:${autoconf}:${dns0-ip}:${dns1-ip}:${ntp0-ip}"
  );

  boot.initrd.availableKernelModules = lib.optional (mystatic ? net0 && mystatic.net0 ? driver) mystatic.net0.driver;

}
