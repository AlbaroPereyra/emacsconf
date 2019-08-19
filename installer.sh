#! /bin/sh -

if [ "X-h" = "X$1" ];
then
  cat<<EOF;
help stuff.
EOF
  exit 0;
fi

# Variables
repoUrl="https://github.com/albaropereyra/emacsconf";
fileName=${repoUrl##*/};


git clone $repoUrl ~/${fileName};
# Creates a directory if it does not exist
mkdir -p ~/.emacs.d;
touch ~/.emacs.d/.emacs-custom.el;
mv ~/${fileName}/init.el ~/.emacs.d;
rm -rf ~/${fileName};
printf "Emacs conf has been updated.\n";
