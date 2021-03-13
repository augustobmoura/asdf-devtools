# asdf-devtools

Useful commands for managing and contributing to asdf plugins.

**Attention:** This plugin is in early development and bugs are to be expected,
the code is being kept under strict rules about being readable so plugin
developers could hack into it and contribute back


## Motivation

As of today asdf manages plugins by cloning the plugin repository into
`$ASDF_DIR/plugins`, `asdf-devtools` try to get the work of managing branches
and remotes mainly for plugin repositories mantainers and contributors.
The project was born from a set of alias that I developed while testing
contributing to asdf plugins.

Ideals for the project:
- Keep It Simple Stupid™, too much shell gymnastycs are a sign that something
  is wrong
- Give plugin maintainers and contributors a good set of commands that are
  overused or easily misused
- Compatibility, requirements as few as possible
- **No magic**, the target audience is somewhat capable of understanding system tools,
  we don't need to make things work automagicaly or expect to all problems and setups
  to work
- Well explained and auditable, again, the user base should be familiarized with
  system tools, and the project being able to be read and understood is crucial


## Installation

``` bash
# Commands are available behind `asdf devtools <cmd>`
asdf plugin add devtools https://github.com/augustobmoura/asdf-devtools.git

# You can give a diffrente name for devtools by changing the argument after add
asdf plugin add dev https://github.com/augustobmoura/asdf-devtools.git
# Now the commands are behind `asdf dev`
```

## Available command worklflows

### Alternatives

Set of commands to manage different remotes and branches of plugins locally

#### `alternative add [<plugin>] <alt_url>`

Aliases: `alternative`, `alt add`, `alt`

Add a remote with a optional branch to the local plugin installation and switch
the the pluin to it. Supports full git urls both ssh and https, try to infer the
target plugin name from the repository name. Accepts a optional first argument
to explicitly define the plugin to install the alternative

``` bash
# Infers the plugin devtools from the url
asdf devtools alternative add https://github.com/augustobmoura/asdf-devtools.git
asdf devtools alternative add git@github.com:augustobmoura/asdf-devtools.git

# Explicitly defines the plugin name as `dev`
asdf devtools alternative add dev git@github.com:augustobmoura/asdf-devtools.git
```

Supports a shorthand syntax defaulting to github:

``` bash
# Infers https://github.com/augustobmoura/asdf-devtools
asdf devtools alternative augustobmoura/asdf-devtools

# You can change the default shorthand url by providing the variable
# ASDF_DEVTOOLS_SHORTHAND_REPO_PATTERN with a printf single argument pattern
export ASDF_DEVTOOLS_SHORTHAND_REPO_PATTERN="git@bitbucket.org:%s.git"
# Now it infers to `git@bitbucket.org:augustobmoura/asdf-devtools.git`
asdf devtools alternative augustobmoura/asdf-devtools
```

Also supports passing branches at the end of the url after a `#` char
``` bash
# Add the augustobmoura/asdf-devtools remote and checkouts
# the `fix/add-support-alternatives` branch
asdf devtools alt augustobmoura/asdf-devtools#feat/add-support-to-alternatives

# Also you can note that the last command used the alias `alt`
# instead of `alternative add`
```

#### `alternative reset <plugin | --all> [refspec]`

Aliases: `alt reset`, `reset`

Resets the plugin to the latest "official" version or refspec, currently it only
delegates execution to `asdf plugin-update`

``` bash
# Will bring all plugins to the official version
asdf devtools alternative reset --all

# Will only bring devtools to the latest official version
asdf devtools reset devtools

# Should bring devtools to the tag v8.0.0
asdf devtools reset devtools v8.0.0

# Same as before, reset only work is to call plugin-update
asdf plugin-update devtools v8.0.0
```

### Git

#### `git <plugin> [args...]`

Execute a git command at the said plugin, useful for quick checks and used
internally

``` bash
# Print the git status of local nodejs plugin repository
asdf devtools git nodejs status

# Checkouts the v8.0.0 git ref into nodejs asdf plugin
# NOTE: this will only affect plugins (asdf-nodejs in this example), installed
# versions of node will be still unaffected
# NOTE: this is not the same of installing the v8.0.0 of the nodejs plugin, asdf
# has several hooks that need to be run in a lot of plugins, this command should
# be used with caution
asdf devtools git nodejs checkout v8.0.0
```

## Future ideas

Some commands that are useful today and might be implemented in the future
- `installs backup` for backuping current installed versions, so a install can be run in
  a clean slate
- `alias`, `link`? Link versions or plugins to symlinks, might be more useful as
  a [independent repository](https://github.com/andrewthauer/asdf-alias)

## License

See [LICENSE](LICENSE) © [Augusto Moura](https://github.com/augustobmoura)
