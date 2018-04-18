# Foreword

The algorithm is slow :/. This project was just about training in haskell language and the discovery of Procedural Content Generation.

# How to build

    ghc --make Main.hs

# Groland cities - Hall Of Fame :)

French generated cities :

- quenaud-mérolière
- peypin-monjaulzy
- tabrezac
- rigneval
- fay-le-médard-notre-de-philbertran
- pettoncourcourdon

# How to use

## First : build a distribution with a given order

```bash
# data is one these two files : communes.txt, prenoms.txt
# The higher the order, the more precise are the words but less creative they are.

./Main genDist data order

# This command generate a .dist file (e.g communes.txt.dist)
```

### Example

    ./Main genDist communes.txt 2

## Second : use the generated distribution to generate a word

```bash
./Main genWord distFile
```

### Example 

    ./Main genWord prenoms.txt.dist

# Troubleshooting

You may have an error message during compilation that says you don't have `System.Random` library in yourghc installation. In that case, you need to install `random` package via cabal, like this :

    cabal install random

In case you didn't install cabal, it should exist in your distribution repository. Example for achlinux :

```bash
sudo pacman -S cabal-install

# sync cabal if you launch it for the first time
cabal update

# then install random package
cabal install random
```
