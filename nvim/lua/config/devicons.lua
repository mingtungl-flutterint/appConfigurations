require'nvim-web-devicons'.setup {
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
  -- your personnal icons can go here (to override)
  -- DevIcon will be appended to `name`
  override = {
    windows = {
      icon = "",
      color = "#428850",
      name = "MsWindows"
    },
    arch = {
       icon = "",
       color = "#428850",
       name = "ArchLinux"
    },
    gentoo = {
       icon = "",
       color = "#428850",
       name = "Gentoo"
    },
    ubuntu = {
       icon = "",
       color = "#428850",
       name = "Ubuntu"
    },
    centos = {
       icon = "",
       color = "#428850",
       name = "CentOS"
    },
    debian = {
       icon = "",
       color = "#428850",
       name = "Debian"
    },
    opensuse = {
       icon = "",
       color = "#428850",
       name = "openSUSE"
    },
    docker = {
       icon = "",
       color = "#428850",
       name = "Docker"
    },
    linux = {
       icon = "" ,
       color = "#428850",
       name = "Linux"
    }
  };
}
