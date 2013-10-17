bashfuns
========

Set up:

```
$ cd $HOME
$ git clone https://github.com/mewlips/bashfuns.git
$ echo "source $HOME/bashfuns/bashfuns.bash" >> $HOME/.bashrc
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
$ savefuns left right mydiff
```
