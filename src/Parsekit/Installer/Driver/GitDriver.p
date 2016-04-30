# Created by IntelliJ IDEA.
# User: ibodnar
# Date: 30.04.16
# Time: 2:03
# To change this template use File | Settings | File Templates.

@CLASS
GitDriver

@OPTIONS
locals

@USE
VcsDriver.p

@BASE
VcsDriver


@auto[]
###


#------------------------------------------------------------------------------
#:constructor
#
#:param filesystem type Filesystem
#------------------------------------------------------------------------------
@create[filesystem]
    ^BASE:create[$filesystem]
###


#------------------------------------------------------------------------------
#:param url type string
#
#:result bool
#------------------------------------------------------------------------------
@supports[url]
    $result(false)
    ^if(-d url){
        ^rem[ TODO handle local url]
    }{
        ^if(^url.match[(^^git://|\.git^$|git(?:olite)?@|//git\.|//github.com/)][in]>0){
            $result(true)
        }
    }
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@doInstall[dir;package][result]
    $console:line[ do smth to install $package.sourceUrl in $dir ]
    ^if(!^self.filesystem.exists[$dir] && !^self.filesystem.createDir[$dir]){
        ^throw[ExecutionException;GitDriver.p; Could not create directory '$dir' for package $package.name $package.version ]
    }
    $repoUrl[$package.sourceUrl]
    $ref[$package.sourceReference]

    $command[git clone --no-checkout $repoUrl . && git remote add parsekit $repoUrl && git fetch parsekit]
    $exec[^Exec::create[$command;$dir]]
    ^exec.execute[]

    $result(!^self.checkoutToCommit[$dir;$package.sourceReference;$package.prettyVersion])
###


#------------------------------------------------------------------------------
#:param dir type string
#:param package type PackageInterface
#
#:result bool
#------------------------------------------------------------------------------
@doUpdate[dir;package][result]
    ^if(!def $package.sourceReference){
        ^throw[InvalidArgumentException;VcsDriver.p; Git package hasn't source reference. ]
    }
    ^if(!^self.filesystem.exists[$dir/.git/]){
        $console:line[Directory '$dir' exists but do not contain .git. Removed and reinitialize.]
        ^self.doInstall[$dir;$package]
    }{

        $fetchCommand[^Exec::create[git remote set-url parsekit $package.sourceUrl && git fetch parsekit && git fetch --tags parsekit;$dir]]
        ^fetchCommand.execute[]
        $result[^self.checkoutToCommit[$dir;$package.sourceReference;$package.prettyVersion]]
    }
###



#------------------------------------------------------------------------------
#:param dir type string
#:param reference type string
#:param branch type string
#
#:result bool
#------------------------------------------------------------------------------
@checkoutToCommit[dir;reference;branch][result]
    ^rem[ TODO add posibility not to force all commands ? ]
    $complete(false)
    $result[]

    $branch[^branch.match[((?:^^dev-)|(?:\.x?-dev^$))][i]{}] ^rem[ strip out 'dev-' at the start or '.x-dev' at the end]
$console:line[BRANCH $branch]
$console:line[$dir]
    $branchCommand[^Exec::create[git branch -r;$dir]]
    $branches[$branchCommand.text]

$console:line[BRANCHES $branches]
# check whether non-commitish are branches or tags, and fetch branches with the remote name
    ^if(
        ^reference.match[^^[a-f0-9]{40}^$][n] == 0
        && def $branches
        && ^branches.match[parsekit/$reference][nm] > 0
    ){
        $command[git checkout -f -B $branch parsekit/$reference -- && git reset --hard parsekit/$reference --]
        $checkoutCommand[^Exec::create[$command;$dir]]
        ^if(^checkoutCommand.execute[]){
            $complete(true)
        }
    }


#   try to checkout branch by name and then reset it so it's on the proper branch name
    ^if(!$complete && ^reference.match[^^[a-f0-9]{40}^$][n] > 0){
#       add 'v' in front of the branch if it was stripped
        ^if(^branches.match[^^\s*parsekit/$branch^$][mn] == 0 && ^branches.match[^^\s*parsekit/v$branch^$][mn] > 0){
            $branch[v$branch]
        }

        $command[^Exec::create[git checkout $branch --;$dir]]
        $fallbackCommand[^Exec::create[git checkout -f -B $branch parsekit/$branch --;$dir]]

        ^if( ^command.execute[] || ^fallbackCommand.execute[]){
            $resetCommand[^Exec::create[git reset --hard $reference --]]
            ^if(^resetCommand.execute[]){
                $complete(true)
            }
        }
    }

    ^if(!$complete){
        $command[^Exec::create[git checkout -f $reference -- && git reset --hard $reference --;$dir]]
        ^if(^command.execute[]){
            $complete(true)
        }
    }

    ^if(!$complete){
        ^throw[UnexpectedArgumentException;GitDriver.p; Reference '$reference' was not found.]
    }

    $result($complete)
###
