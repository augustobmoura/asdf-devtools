# ASDF Devtools

Useful commands for managing and contributing to asdf plugins. As of today asdf
manages plugins by cloning the plugin repository into `$ASDF_DIR/plugins`, this
plugin try to get the work of managing branches and remotes mainly for plugin
repositories mantainers and contributors.

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
```

### Git

#### `git <plugin> [args...]`

Execute a git command at the said plugin, useful for quick checks and used
internally

``` bash
# Print the git status of local nodejs plugin repository
asdf devtools git nodejs status

# Checkouts the v8.0.0 git ref into nodejs asdf plugin
# NOTE: this will only affect plugins asdf-nodejs for example, installed
# versions of node will be still unaffected
# NOTE: this is not the same of installing the v8.0.0 of the nodejs plugin, asdf
# has several hooks that need to be run in a lot of plugins, this command should
# be used with caution
asdf devtools git nodejs checkout v8.0.0
```
