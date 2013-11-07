bashfuns
========

Set up:

```
$ git clone https://github.com/mewlips/bashfuns.git
$ cd bashfuns
$ ./install.sh
$ source $HOME/.bashrc # or exit then re-login
```

Usage example:

```
$ left() {
> LEFT=`realpath "$1"`
}
$ right() {
> RIGHT=`realpath "$1"`
}
$ mydiff {
> diff "$LEFT" "$RIGHT"
}
$ left somefile
$ right somefile2
$ mydiff
...
$ bf save -g left right mydiff
```
