#!/bin/bash
# DON'T MODIFY THIS FILE
# Place new config in a separate file within ~/.bashrc.d/

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.bashrc.d/.{path,bash4,bash_prompt,exports,aliases,functions,extra}; do
  # shellcheck source=/dev/null
	[ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;
