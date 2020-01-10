Dot Files
=========

My configuration files, along with a python script to deploy them.

The dotfiles are organized in folders. For instance the folder for zsh::

  zsh/
      .marks/
          documents -> ~/Documents
      .zsh/
          oh-my-zsh/
          .zshrc
      .zshenv
     
The files can be deployed easily using the 'deploy.py' python script.
The target directory and dotfiles directory can be changed, they
defaults to ~/ and ~/.dotfiles.
Only a dry-run can be iniated.

The file tree inside each category
is reproduced in a target directory (your home by default).
Directories are recreated.
For each file, a symlink a created from the target directory to the dotfiles directory.

If symlinks are present in the dotfiles, they are moved to the target directory (without
changing where they point to).

Directories and files can be ignored by listing them in the ~/.dotfiles/ignore file.
The paths must be relative to the dotfiles directories.

*The files already present in the target directory are replaced.*

For instance the zsh folder above would be deployed as::

  ~/
      .marks/
          documents -> ~/Documents
      .zsh/
          oh-my-zsh/
          .zshrc -> .dotfiles/zsh/.zsh/.zshrc
      .zshenv -> .dotfiles/zsh/.zshenv
     
  
