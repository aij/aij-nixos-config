let hostlist = {
  m0 = {
    net0 = {
      iface= "enp2s0f0";
      mac =  "B8:38:61:7B:F7:DC";
      ip = "192.168.1.11";
    };
    net1 = {
      iface = "enp2s0f1";
      mac = "B8:38:61:7B:F7:DD";
      ip = "10.0.1.11";
    };
  };
  m1 = {
    net0 = {
      iface= "enp1s0f0";
      mac =  "e4:c7:22:84:03:60";
      ip = "192.168.1.22";
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
  };
  c0n0 = {
    net0 = {
      #iface = "eno1"
      mac =  "34:40:b5:bc:15:c7";
      ip = "192.168.1.83";
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

}
