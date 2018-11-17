{config, ...}:
let id = config.networking.hostName; in
{
  boot.kernel.sysctl = { "vm.nr_hugepages" = 128; };

  services.xmr-stak = {
    enable = true;
    extraArgs =  [
      #"--rigid ${id}"
      #"--httpd 8081"
      #"-o cryptonightv7.usa.nicehash.com:3363 -u 37xxrZgNu8ytQfEFo6jVC9nJ4tAEb73URJ.${id} -p x --use-nicehash --currency monero7"
      #"-o a.mwork.io:4334 -u WmtysDKqGscTRaFnPMPQyiHJ93hdKmifaDfhgCp1k44QXCuDYpnSY9MSU4BfWaLutETaNvqBwBSykXAXTuZBLoCj33gPcZpEU -p x --currency cryptonight_lite"
      #"-o m0:3333 -u ${id} -p x --use-nicehash --currency monero7"
      #"-o m1:3333 -u ${id} -p x --use-nicehash --currency monero7"
    ];

    configFiles = {
    "config.txt" = ''
      "daemon_mode" : true,
      "h_print_time" : 600,
      "verbose_level" : 4,
      "flush_stdout" : true,
      "httpd_port" : 8081,
      /* defaults */
      "call_timeout" : 10,
      "retry_time" : 30,
      "giveup_limit" : 0,
      "print_motd" : true,
      "aes_override" : null,
      "use_slow_memory" : "warn",
      "tls_secure_algo" : true,
      "output_file" : "",
      "http_login" : "",
      "http_pass" : "",
      "prefer_ipv4" : true,
    '';
    "pools.txt" =
      let proxy = ''
        "currency" : "cryptonight_v7",
        "pool_list" :
        [
          {"pool_address" : "m0:3333", "wallet_address" : "${id}", "rig_id" : "${id}", "pool_password" : "x", "use_nicehash" : true, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },
          {"pool_address" : "m1:3333", "wallet_address" : "${id}", "rig_id" : "${id}", "pool_password" : "x", "use_nicehash" : true, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 2 },
        ],
      '';
       nicehash = ''
        "currency" : "cryptonight_v8",
        "pool_list" :
        [
          {"pool_address" : "cryptonightv8.usa.nicehash.com:3367", "wallet_address" : "37xxrZgNu8ytQfEFo6jVC9nJ4tAEb73URJ.${id}", "rig_id" : "${id}", "pool_password" : "x", "use_nicehash" : true, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },
        ],
       '';
       aeon = ''
        "currency" : "aeon7",
        "pool_list" :
        [
          {"pool_address" : "mine.aeon-pool.com:7777", "wallet_address" : "WmtysDKqGscTRaFnPMPQyiHJ93hdKmifaDfhgCp1k44QXCuDYpnSY9MSU4BfWaLutETaNvqBwBSykXAXTuZBLoCj33gPcZpEU", "rig_id" : "${id}", "pool_password" : "x", "use_nicehash" : false, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },
          // STH pool didn't update for the fork. :(
          // {"pool_address" : "a.mwork.io:4334", "wallet_address" : "WmtysDKqGscTRaFnPMPQyiHJ93hdKmifaDfhgCp1k44QXCuDYpnSY9MSU4BfWaLutETaNvqBwBSykXAXTuZBLoCj33gPcZpEU", "rig_id" : "${id}", "pool_password" : "x", "use_nicehash" : false, "use_tls" : false, "tls_fingerprint" : "", "pool_weight" : 1 },
        ],
       '';
      in nicehash;
    };
    #niceness = 10;
  };
  networking.firewall.allowedTCPPorts = [
    8081
  ];
}
