{ config, pkgs, inputs, ... }:

{

  # Configure Librewolf settings, CSS hacks, and extensions.

  home.file = {
    # Installs CSS hacks for the Librewolf profile.
    ".librewolf/Default/chrome/chrome".source = "${inputs.firefox-csshacks}/chrome";
  };

  programs.librewolf = {
    enable = true;
    profiles.Default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "webgl.disabled" = false;
      };
      # Import CSS hacks and apply tweaks.
      userChrome = ''
        /* Import your desired components first */
        @import url(chrome/autohide_sidebar.css);
        @import url(chrome/autohide_tabstoolbar_v2.css);

        /* Apply your custom modifications after imports */
        #sidebar-box #sidebar-header {
          visibility: collapse;
        }
        #sidebar-box {
          --uc-sidebar-width: 35px;
        }
      '';
    };

    # Extensions
    policies = {
      ExtensionSettings = with builtins;
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in listToAttrs [
          (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "10ten-ja-reader" "{59812185-ea92-4cca-8ab7-cfcacee81281}")
          (extension "absolute-enable-right-click" "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}")
          (extension "multi-account-containers" "@testpilot-containers")
          (extension "traduzir-paginas-web" "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}") # TWP - Translate Web Pages
          (extension "windscribe" "@windscribeff")
          (extension "web-clipper-obsidian" "clipper@obsidian.md")
        ];

        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then, download the XPI by filling it in to the install_url template, unzip it,
        # run `jq .browser_specific_settings.gecko.id manifest.json` or
        # `jq .applications.gecko.id manifest.json` to get the UUID

    };
  };
}
