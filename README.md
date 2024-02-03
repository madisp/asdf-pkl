<div align="center">

# asdf-pkl [![Build](https://github.com/madisp/asdf-pkl/actions/workflows/build.yml/badge.svg)](https://github.com/madisp/asdf-pkl/actions/workflows/build.yml) [![Lint](https://github.com/madisp/asdf-pkl/actions/workflows/lint.yml/badge.svg)](https://github.com/madisp/asdf-pkl/actions/workflows/lint.yml)

[pkl](https://pkl-lang.org/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add pkl https://github.com/madisp/asdf-pkl.git
```

pkl:

```shell
# Show all installable versions
asdf list-all pkl

# Install specific version
asdf install pkl latest

# Set a version globally (on your ~/.tool-versions file)
asdf global pkl latest

# Now pkl commands are available
pkl --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/madisp/asdf-pkl/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Madis Pink](https://github.com/madisp/)
