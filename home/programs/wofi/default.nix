{ pkgs, input, config, ... }:
{
  programs.wofi = {
    enable = true;
    style = ''* {
        all: unset;
        font-family: "JetBrainsMono";
        font-size: 16px;
      }

      #window {
        background-color: #292a37;
        border-radius: 12px;
      }

      #outer-box {
        background-color: #292a37
        border: 4px solid #44465c;
        border-radius: 12px;
      }

      #input{
        margin: 1rem;
        padding: 0.5rem;
        border-radius: 10px;
        background-color: #303241;
      }

      #entry {
        margin: 0.25rem 0.75rem 0.25rem 0.75rem;
        padding: 0.25rem 0.75rem 0.25rem 0.75rem;
        color: #9699b7;
        border-radius: 8px;
      }

      #entry:selected {
        background-color: #303241;
        color: #d9e0ee;
      }'';
  };
}
