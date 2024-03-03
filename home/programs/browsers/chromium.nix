{
  programs.chomium = {
    enable = true;
    extraOpts = {
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "de"
        "en-US"
      ];
    };
  };
}
