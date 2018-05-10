#!/usr/bin/env bash
#
# Changes a commit's GIT_COMMITER_NAME|EMAIL to GIT_AUTHOR_NAME|EMAIL
#
# set-commiter-to-author [-f] commit-to-change
#
#     If -f is supplied it is passed to "git filter-branch".
#
#     If <branch-to-rewrite> is not provided or is empty HEAD will be used.
#     Use "--all" or a space separated list (e.g. "master next") to rewrite
#     multiple branches.
#

# Based on http://stackoverflow.com/questions/3042437/change-commit-author-at-one-specific-commit

force=''
if test "x$1" = "x-f"; then
  force='-f'
  shift
fi

br="${1:-HEAD}"
echo "$br"
#TARG_COMMIT="$targ"
#export TARG_COMMIT

filt='
if test "$GIT_AUTHOR_EMAIL" != "$GIT_COMMITTER_EMAIL"; then
  GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
  GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL
  export GIT_COMMITTER_NAME
fi
git commit-tree "$@"
'

git filter-branch $force --commit-filter "$filt" "$br"
