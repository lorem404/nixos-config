# SECRETS - DO NOT COMMIT TO GIT!
# Add this file to .gitignore
{ config, pkgs, ... }: {

  # Environment variables with secrets
  home.sessionVariables = {
    PGPASSWORD = "goapp123";
    REDIS_PASSWORD = "goapp123";
  };
  programs.fish = {
    shellAliases = {
      redis-cli = "redis-cli -h localhost -p 6379 -a goapp123";
    }; 
  };

  # Or system-wide environment
}
