{ config, pkgs, ...}:
{
  containers.dbmysql1 = {
    privateNetwork = true;
    hostAddress = "192.168.10.10";
    localAddress = "192.168.10.11";
    config = { config, pkgs, ...}: {
      services.mysql = {
        enable = true;
        package = pkgs.mysql;
        user = "mysql";
        settings.mysqld = {
          port = 3306;
          bind-address = "0.0.0.0";
        };
        ensureDatabases = [
          "pogo"
        ];
        ensureUsers = [
          {
            name = "pogo-serv";
            ensurePermissions = {
              "pogo.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };
    };
  };
}
