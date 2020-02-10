#!/usr/bin/env sh

# See if there is a cached verson of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile=../support/texlive.profile

  cd ..
fi

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install

# l3build itself and LuaTeX: need for texlua
tlmgr install l3build luatex

tlmgr install \
  babel-german \
  bitset \
  cmap \
  courier \
  ec \
  etoolbox \
  extsizes \
  helvetic \
  hyphen-german \
  letltxmacro \
  listings \
  lm \
  pgf \
  pdfescape \
  rsfs \
  symbol \
  times \
  translator \
  xcolor \
  yfonts \
  zapfding

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0
