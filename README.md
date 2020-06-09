# praatconfig

Imagine that you have a big praat script which takes lots of parameters. Some will be numbers, some text. Some will be required, some not.

This procedure takes two filenames. The first must be a CSV file with two columns, `parameter` and `value`. This is the config file with the values for the script.

The second must be a CSV file with two columns, `parameter` and `type`. The procedure will load the first file, using the second to check that:

* All parameters specified in the second file are present
* All parameters given a type `number` in the second file can be interpreted as a number

It returns these parameters as .number and .string$

There are at least a couple of obvious omissions in this as it is -- see Issues.
