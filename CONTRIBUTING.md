# CONTRIBUTING
Contributing to Cequal is somewhat easy.

The first thing you need to do is figure out what you would like to contribute.

You can contribute by:
#### Adding a new function
#### Fixing/modiying current functions
#### Adding change/feature to the compiler in general

## Adding a new function
If you take a look inside ceq-compiler.bat, you can see where the function if-statements are kept.
(Around line 35-45)
```batch
if not "%line:print=%"=="%line%" goto print
if not "%line:execute=%"=="%line%" goto execute
if not "%line:input=%"=="%line%" goto input
if not "%line:newline=%"=="%line%" goto newline
```
As you can see, simple if statements check a variable if it contains a function key-word.
It is able to be so simple to check for functions because of some complicated back-end code that puts each line of input.ceq in a variable.

To add a new function, you must first make an if statement around the others that checks for your function name.
#### Example
```batch
if not "%line:shinynewfunction=%"=="%line%" goto shinynewfunction
```
The above code adds the function "shinynewfunction" to Cequal.
However, we still need to tell Cequal what to do with this function.

As you can see around the end of the line, it sends the compiler to shinynewfunction, which is where the actual function is held.
Here is an example of a function:
```batch
:print
set prevline=%cline%
set line=%line:print=%
if not "%line:`=%"=="%line%" goto print_var
echo|set /p=%line%
goto run1
:print_var
set line=%line:`=%
set line=%line: =%
echo|set /p=!x%line%!
goto run1
```
That code there that says `set prevline=%cline%` is required in every function. This simply helps the line-reader later.
After that we need to get the argument our function was fed. We do this by setting our variable "line" to remove the function name.
In our function, that'd be set `line=%line:shinynewfunction=%`.
This would leave us just with our argument.

Next thing we do is test if our argument is a variable. We will get to that line in a second.

If it passes that if statement, it assumes our argument is text. it uses `echo|set /p=%line%` to print our argument onto the current line.
We use `echo|set /p=%line%` so that every print function prints onto the same line. You can read more about this under 'Limitations' in 'README.md'.

Finally, we end this line and go back so the compiler can do the next line.
However, we still need to talk about testing if our argument is a variable.

This is done in the if-statement you can see. In summary, it checks for the '`' character. If it detects it, it sends it to a different area of code with the same name of the function, but with '_var' added.
You can see above it sends it to 'print_var'. Under print_var, it removes our variable identifiers with `set line=%line:`=%` and spaces with `set line=%line: =%`.
And then it echos the variable with `echo|set /p=!x%line%!`. Finally it sends the code back up to the line-reader, ready for the next line of code.

If you are still confused, read through ceq-compiler.bat and take a look at some more of the functions.

## Fixing/modifying current functions
If you think you have a good change/fix to a current function, feel free to make a pull request!

## Adding change/feature to the compiler in general
This option means you're probably looking to make a change to the line-reader. The line-reader code is the heart and soul of Cequal.
It is what lets Cequal function. If you're making a modification to the line reader, be **VERY** careful. Many of the systems in the line-reader are just bodges.
