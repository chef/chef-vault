# Contributing to Chef-Vault

We welcome contributions. Your patch is part of a vibrant open source
community which makes Chef-Vault great. These guidelines will help your pull
request to be merged sooner.

### Create an Issue

Each pull request should have a corresponding [Chef-Vault GitHub
issue](https://github.com/Nordstrom/chef-vault/issues?state=open). Search the
issue list to make sure someone hasn't already submitted a pull request to fix
your issue. If not, please create a new issue.

Later, you'll create a feature branch with this issue number.

### Fork the Repo

Fork the Chef-Vault project and check out your copy. See this [GitHub
guide](https://help.github.com/articles/fork-a-repo) for more info.

```bash
$ git clone https://github.com/<username>/chef-vault.git
$ cd chef-vault
$ git remote add upstream https://github.com/Nordstrom/chef-vault.git
```

### Create a Local Feature Branch

Create a feature branch and start hacking:

```
$ git checkout -b my-feature-branch
```

### Code

Please follow the [Ruby Style
Guide](https://github.com/bbatsov/ruby-style-guide) when writing Ruby code for
Chef-Vault.

### Commit

Make sure git knows your name and email address:

```bash
$ git config --global user.name "Jane Doe"
$ git config --global user.email "jane.doe@example.com"
```

Writing good commit messages is important. A commit message should describe what
changed and why. Follow these guidelines when writing one:

1. The first line should be 50 or fewer characters and contain a short
   description of the change.
   If this commit fixes/closes an issue, prefix the commit message
   like this: "Fixes #7: ". Here's a complete example:
`Fixes #9: Use getters instead of instance vars`
2. Keep the second line blank.
3. Wrap all other lines at 72 columns.

A good commit log looks like this:

```
Fixes #9: Use getters instead of instance vars

Body of commit message is a few lines of text, explaining things
in more detail, possibly giving some background about the issue
being fixed, etc etc.

The body of the commit message can be several paragraphs, and
please do proper word-wrap and keep columns shorter than about
72 characters or so. That way `git log` will show things
nicely even when it is indented.
```

The header line should be meaningful; it is what other people see when they
run `git shortlog` or `git log --oneline`.

### Rebase

Use `git rebase` (not `git merge`) to sync your work from time to time if
upstream/master has moved ahead of you.

```bash
$ git fetch upstream
$ git rebase upstream/master
```

### Test

Bug fixes and features should come with RSpec tests. Add your tests in the
`spec` directory. Look at other tests to see how they should be
structured (license boilerplate, common includes, etc.).

Run `bundle install && bundle exec rake` to run the test suite.

Make sure all tests pass.

### Push

```bash
$ git push origin my-feature-branch
```

### Create a Pull Request
Go to https://github.com/<username>/chef-vault and select your feature branch. Click
the 'Pull Request' button and fill out the form.

Pull requests are usually reviewed within a few days.  If there are comments
to address, apply your changes in a separate commit and push that to your
feature branch. Post a comment in the pull request afterwards; GitHub does
not send out notifications when you add commits.

### Thank You
Thank you for reading this far. We look forward to your contribution.

Kevin Moser, Doug Ireton
Nordstrom
