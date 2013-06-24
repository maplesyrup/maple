![Additt Logo](http://www.additt.co/assets/additt_logo-469bd83f2f3dc81ca74754ab9b7c9469.png)

Contact info: additt.team@gmail.com

Guide to setup/contribution
===========================

[![Build Status](https://secure.travis-ci.org/maplesyrup/maple.png?branch=master)](http://travis-ci.org/maplesyrup/maple)

Setting up rbenv
----------------

`rbenv` allows you to have multiple versions of ruby on your computer which is important since the newer
versions of ruby are not backwards compatable.

To install `rbenv` follow the instructions here for your specific OS: https://github.com/sstephenson/rbenv/

Since rails 3.2 suggests we use ruby 1.9.3 that's what we'll all use. Run these commands after installing
`rbenv`.

    rbenv install 1.9.3-p327
    rbenv rehash
    cd /path/to/rails/project
    rbenv local 1.9.3-p327

That will set your local version of ruby to 1.9.3

Contributing via Pull Request (PR)
----------------------------------

The first thing you'll want to do is fork the `maplesyrup/maple` repo so that you have your own version of the
repo. Here are [instructions](https://help.github.com/articles/fork-a-repo)

Once you have forked a repo, you'll always create new branches on your origin repo, push that repo and then
send a PR to maplesyrup/maple.

Here is an example workflow:

`git checkout -b hotfix`

This will create a new local branch from whatever branch you are on (usually master). You can check what
branch you are on using `git branch`

Make some commits and fixes on branch hotfix. Then when you can push to `origin` which is your remote fork. In
my case it would `benrudolph/maple`. Here's how to do it:

`git push origin hotfix`

This command pushes branch `hotfix` to remote repo `origin`.

Once you've pushed your branch up, log on to github and there will be a button to send a PR to
maplesyrup/maple. You can continue pushing commits to `hotfix` with `git push origin hotfix` and the PR will
be updated. Once the PR is merged with maplesyrup/maple, you'll no longer be able to do so, so you'll need to
work on a new branch.

How to update a branch with the newest code from `upstream/master`
---

Usually you'll want to update your local master branch or the branch you're working on with `upstream/master`
every so often so as to get the recent changes. To do so execute these commands:

    git fetch --all
    git merge upstream/master

The first command gets all the branches on `upstream` and `origin`. The second command merges `upstream/master
with your local branch.

Here's a graphic detailing what this all looks like:

![workflow](./workflow.png)

