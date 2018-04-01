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
      iface= "enp2s0f0";
      mac =  "B8:38:61:7B:F7:DC";
      ip = "192.168.1.11";
    };
    net1 = {
      iface = "enp2s0f1";
      mac = "B8:38:61:7B:F7:DD";
      ip = "10.0.1.10";
    };
    ib = {
      iface ="ib0";
      ip = "10.0.9.10";
    };
  };
  m1 = {
    net0 = {
      iface = "enp1s0f0";
      mac =  "e4:c7:22:84:03:60";
      ip = "192.168.1.22";
    };
    net1 = {
      iface = "enp1s0f1";
      ip = "10.0.1.11";
    };
    ib = {
      iface ="ib0";
      ip = "10.0.9.11";
    };
  };
  m2 = {
    net0 = {
      iface= "eno1";
      mac =  "84:2b:2b:56:17:a6";
      ip = "192.168.1.21";
    };
  };
  m4 = {
    net0 = {
      #iface= "";
      mac =  "BC:16:65:0B:0C:1A";
      ip = "192.168.1.23";
    };
    ib = {
      iface ="ib0";
      ip = "10.0.9.14";
    };
  };
  m5 = {
    net1 = {
      mac = "90:b1:1c:fc:c6:51";
      ip = "10.0.1.180";
    };
  };
  c0n0 = {
    net0 = {
      #iface = "eno1"
      mac =  "34:40:b5:bc:15:c7";
      ip = "192.168.1.83";
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
};
#netOrder = ["net0", "net1"];
in {
  networking.hosts = (
    with builtins;
    let names = attrNames hostlist; in
    let genLine = hostname: netname: let conf = hostlist.${hostname}.${netname}; in {
      name = conf.ip;
      value = [ "${hostname}.${netname}" hostname ];
    }; in
    # TODO: Avoid duplicating short names
    let nested = map (hostname:
      map (genLine hostname) (attrNames hostlist.${hostname})
    ) names; in
    listToAttrs(concatLists nested)
  );

  networking.interfaces = { config, lib, ...}: (
    with builtins;
    let c = hostlist.${config.networking.hostName} or {}; in
    let s = lib.filterAttrs (_: i: i ? iface) c; in
    {
      networking.interfaces =  lib.mapAttrs' (n: v: {
        name = v.iface;
        value = {
          ipv4.addresses = [{
            address = v.ip;
            prefixLength = nets.${n}.prefixLength;
          }];
        };
      }) s;
    }
  );
}
