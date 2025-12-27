function gbl {
	git branch -a
}

# Merge $branch into current branch
function gmerge($branch) {
	git merge $branch
}

function gpr {
	git pull --rebase
}