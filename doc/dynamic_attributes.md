# Dynamic attributes

```DynamicAttributes``` is an includable module, located at
```lib/dynamic_attributes```. Its function is to provide a key-value kind of
storage for product attributes.

## Overview

```ProductPropertyKeys``` belongs to a ```Website``` and
```ProductPropertyValues``` belongs to a ```ProductPropertyKey``` and a
```Product``` or a ```ProductVariant```.

## Usage

The module implements two methods in its includer.

### ```dynamic_attributes```

This is the reader. It returns a hash with the attribute names as keys and the
product values as values.

### ```update_dynamic_attributes```

This is the writer. It takes a hash with the attribute names as keys and the
product values as values

## TODO

* Accessors similar to those in Active Record (for example Product#height and
  Product#height=).
