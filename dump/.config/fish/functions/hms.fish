function hms --wraps=home-manager\ switch\ --flake\ \~/.nix\\\?submodules=1 --description alias\ hms\ home-manager\ switch\ --flake\ \~/.nix\\\?submodules=1
  nix flake update ~/.nix && home-manager switch --flake ~/.nix\?submodules=1 $argv
        
end
