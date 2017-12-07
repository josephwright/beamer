#!/usr/bin/env sh

# See if there is a cached verson of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile=../texlive.profile

  cd ..
fi

tlmgr install \
  babel-german \
  cmap \
  courier \
  ec \
  etoolbox \
  extsizes \
  helvetic \
  listings \
  lm \
  pgf \
  rsfs \
  symbol \
  times \
  translator \
  xcolor \
  yfonts \
  zapfding

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install

export TEXINPUTS=`pwd`/..:$TEXINPUTS
