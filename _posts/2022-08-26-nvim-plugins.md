---
layout: post
title: Install Neovim Plugins tl;dr
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- Tech Tools
tags:
- documentation
- tech-tools
meta:
author:
  login: nightmarebeforedevops
  email: kbcontactxyz@gmail.com
  display_name: karenb
  first_name: Karen
  last_name: Bruner
permalink: 
excerpt: Very Very Basic Guide to Get Neovim Plug-ins to Work
hide_title: false
---

I recently spent way too much time trying to get `neovim` plugins working.
Hopefully this will keep you from staying up until 2AM.

This assumes you're on a Linux/BSD-ish system and you know basic `vi/vim/nvim`
commands such as how to quit out of the editor.

1. [Install
   `neovim`.](https://github.com/neovim/neovim/wiki/Installing-Neovim) Even
   if your OS package manager has an `neovim` package, it may not be a recent
   version that works with newer plugins. I suggest using the correct package
   for the [latest stable
   version](https://github.com/neovim/neovim/releases/latest)
1. Install the [packer plugin
   manager](https://github.com/wbthomason/packer.nvim)
    ```
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    ```
1. Create the neovim configuration directory
    ```
    mkdir -p "${HOME}/.config/nvim/lua"
    ```
1. Create the `plugins.lua` file to load Packer
    ```
    cat <<EOF >>"${HOME}/.config/nvim/lua/plugins.lua"
    local vim = vim
    local execute = vim.api.nvim_command
    local fn = vim.fn
    
    -- ensure that packer is installed
    local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
    
    if fn.empty(fn.glob(install_path)) > 0 then
        execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
        execute 'packadd packer.nvim'
    end
    
    vim.cmd('packadd packer.nvim')
    local packer = require'packer'
    local util = require'packer.util'
    
    packer.init({
      package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
    })
    
    return require('packer').startup(function()
      use 'wbthomason/packer.nvim'
    
      -- Add plugins here!
    
    end)
    EOF
    ```
1. Configure nvim to load the `plugins.lua`
    ```
    cat <<EOF >>"${HOME}/.config/nvim/init.vim"
    lua require('plugins')
    EOF
    ```
1. Install/update Packer and your plugins
   1. Run `nvim` (no file necessary)
   1. Type `:PackerSync`
   1. Reply `y`
   1. Exit `nvim`

You should now be able to add Packer-compatible plugins around the `-- Add
plugins here!` comment.

If you try to execute `:PackerSync` and get an error, I don't really have any
debugging tips. Try to clean out your `~/.config/nvim` directory and try
again?
