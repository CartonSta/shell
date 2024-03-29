#!/bin/bash

func() {
  sudo wget -N --no-check-certificate "${1}" -O /usr/bin/"${2}"
  sudo chmod +x /usr/bin/"${2}"
}

catbox="https://files.catbox.moe/ct8vm8"
func "${catbox}" "catbox"

vimcn="https://img.vim-cn.com/4b/d623a900d9e3c1972d0ecd91e5e922c3336030.bat"
func "${vimcn}" "vimcn"

replace="http://fars.ee/4H74"
func "${replace}" "replace"

gdrive_err() {
  echo "your $1 is $2, Not $3"
  echo "Plese download your $1 and move it to /usr/bin"
  echo "${gdrive_all}"
  exit 1
}
os=$(uname)
platform=$(uname -m)
gdrive_all="https://drive.google.com/drive/folders/12GSQhLLdKDdKzq_a-7WOrip5HnFmm1v9"
gdrive_Linux_x86_64="https://drive.google.com/uc?id=1iIjBty1FKxdGvyc4GATngwgbzQdPYz2p&export=download"
gdrive_Darwin_x86_64="https://drive.google.com/uc?id=1GL18Ety5Le8IpNwRKO1iZg1YWV_cCWUN&export=download"
case "${platform}" in
x86_64)
  case "${os}" in
  Linux)
    func "${gdrive_Linux_x86_64}" "gdrive"
    ;;
  Darwin)
    func "${gdrive_Darwin_x86_64}" "gdrive"
    ;;
  *)
    gdrive_err os ${os} "linux or macos"
    ;;
  esac
  ;;
*)
  gdrive_err platform ${platform} "x86_64"
  ;;
esac
