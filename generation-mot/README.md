# How to build

ghc --make Main.hs

# How to use

## First : build a distribution with a given order

```bash
# data is one these two files : communes.txt, prenoms.txt
# The higher the order, the more precise are the words but less creative they are.

./Main generateDistribution data order

# This command generate a .dist file (e.g communes.txt.dist)
```

### Example

    ./Main generateDistribution communes.txt 2

## Second : use the generated distribution to generate a word

```bash
./Main generateWord distFile wordLength
```

### Example 

    ./Main generateWord prenoms.txt.dist 6
