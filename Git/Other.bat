# delete local branch from remote
git checkout master
git fetch --prune
git branch -vv | grep gone | awk '{print $1}' | xargs git branch -d