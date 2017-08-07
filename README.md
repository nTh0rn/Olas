# Olas
Most of my projects are just tests to see if I can do it. Olas is one of these projects.

Olas is a simple scripting language made inside the scripting language Batch.

It is a horrible and useless language and should never be used.

# Documentation

## Syntax
Olas scripts **MUST** start with 1 single blank line. This means you start writing your code on line 2.

After the first line, there should also never, **never** be any whitespace in your code. This will break the compiler.

Functions are always 1 word and in lower case.

Functions can also only accept 1 form of input.
#### Example
`print hello!`

### Feeding variables into function

To input a variable into a function, you surround the variable name with the ` character.


### Variable use example
```html
print `x`
```

## Limitations
Olas has many limitations.

These limitations are because a function can intake only 1 input/type of input at a time.

### Printing onto the same line
To compensate for the limitation of each function only being able to take 1 input, print functions will print onto the same line.

This is so you can have variables and text on the same line in the compiler output.

You can break onto a new line by using the '`newline`' function.

#### Improper use:
```html
print Hello `name`!
newline
```

#### Proper use:
```html
print Hello 
print `name`
print !
newline
```

If the variable 'name' is equal to 'John', then the output above will be:
`Hello John!`

## Functions
Currently the functions included in Olas are:

`print`

`newline`

`execute`

`input`

### Print
The print function can print out text or a variable.

#### Printing text example
`print Hello!`

#### Printing variables example
```html
print `x`
```

Now you cannot mix-mash printing text and variables in the same print function.

This would require the function being able to take 2 types of input. You can read more about this in the Limitations section of the documentation.

To get around these limitations, the print function will always print onto the same line.

To print onto a new line, you use the '`newline`' function.

### Newline
The newline function will generate a new line for the print function.

#### Newline example
```html
print I'm line 1!
newline
print I'm line 2!
```

### Execute
The execute function will open up whatever file you input to it.

the execute function will only open files in the compiler's directory unless the file path is specified in the execute function's input.

#### Execute example
`execute textfile.txt`

### Input
This lets the user input text and it will be saved a variable with whatever name you gave it in the input function's argument.

#### Input example
```html
input name
print `name`
```