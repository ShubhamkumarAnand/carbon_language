# Google Carbon Snippets

This file contains some of the basic syntax for Google Carbon as well as some info and how to get set up.

The official repo and docs can be found at:
<https://github.com/carbon-language/carbon-lang>

Carbon is an **experimental** successor to `C++`. It is NOT ready for production and will not be for a while. This crash course and document were made to explore some of the basic syntax.

## How to get started

There is no compiler or Toolchain yet, but you can get started playing around with Carbon by installing `Bazel`, which is Google's build tool as well as something called `LLVM`, which is a "low-level virtual machine". You can install these with **Homebrew** or if you don't have access to Homebrew, you can use the demo interpreter at [https://compiler-explorer.com](https://compiler-explorer.com) demo interpreter.

If you want to setup via Homebrew:

Install bazel

```bash
brew install bazelisk
```

Install LLVM

```bash
brew install llvm
```

Add to PATH

```bash
export PATH="$(brew --prefix llvm)/bin:${PATH}"
```

Clone the repo

```bash
git clone https://github.com/carbon-language/carbon-lang
cd carbon-lang
```

Now you can run .carbon files. There are a bunch in **explorer/testdata**, but I am going to create a new file to work in.

```bash
mkdir sandbox
cd sandbox
touch test.carbon
code test.carbon
```

To run the file:

```bash
bazel run //explorer -- ./sandbox/test.carbon
```

Again, if this does not work for you or you do not have Homebrew, just go to [https://compiler-explorer.com](https://compiler-explorer.com) and you can write Carbon code directly in the browser.

Now we're going to start looking at the syntax of Carbon. The repo at <https://github.com/carbon-language/carbon-lang/tree/trunk/explorer/testdata> has a bunch of files that you can use to see some examples and test the syntax of Carbon.

## Packages

A package is a group of libraries in Carbon, and is the standard unit
for distribution. The package name also serves as the root namespace for
all name paths in its libraries. The package name should be a single,
globally-unique identifier. So let's give this package/namespace a name of `sandbox`. Now `sandbox` is the package and root namespace.

```C++
package sandbox;
```

Each library must have exactly one api file. This file includes declarations for all public names of the library. Definitions for those declarations must be in some file in the library, either the `api` file or an `impl` file. So after the package declaration, we need to add 'api' and 'impl' files.

```C++
package sandbox api;
```

## Main Function

Our Carbon file must have a Main() function. This is the entry point for the program. Since we're going to write the Main() function, we should just talk about the basic syntax of a function in Carbon.

We use the `fn` keyword to declare a function. Functions use the `UpperCamelCase` syntax. We also need to specify the return type. I'll go over data types more in a few minutes, but let's say that we want to return a string:

```C++
  fn Main() -> String {
    return "Hello World!";
  }
```

The format for a function is correct, however, we are going to get an error that says "expected i32, actual string". This is because we are working with the `Main()` function, which should return an integer.

In `C++`, `Main()` returns an integer. Even if you don't explicitly return anything, it returns a `0` implicitly, which usually represents an **exit status** that means **success**. So let's change the return type to `i32`, which is a signed 32-bit integer and we will explicitly return `0`:

```C++
  fn Main() -> i32 {
    return 0;
  }
```

Now we aren't getting any errors.

## The Print Command

If we want to print something out, we can use the `Print` command. be sure to use `UpperCamelCase`. I'll talk about naming conventions soon.

We can print a string with double quotes

```C++
  fn Main() -> i32 {
    Print("Hello World!"); // Prints "Hello World!"
    return 0;
  }
```

If we try and print a number directly, it won't work. Instead, we can use a placeholder

```C++
  fn Main() -> i32 {
    Print("{0}", 42); // Prints "42"
    return 0;
  }
```

Typically, you're not going to have all of your code in the `Main()` function. Let's create another function and invoke it in `Main()`:

```C++
  fn OutputText() -> String {
    return "Hello World!";
  }

  fn Main() -> i32 {
    Print(OutputText()); // Prints "Hello World!"
    return 0;
  }
```

## Void Functions

If your function does not return anything, you can ignore the return type.

```C++
  fn OutputText() {
    Print("Hello World!");
  }

  fn Main() -> i32 {
    OutputText(); // Prints "Hello World!"
    return 0;
  }
```

## Primitive Data Types

I think this is a good time to talk about the primitive types in Carbon. Carbon is a statically-typed language, which means that we have to define our types. Primitive types fall into the following categories:

- boolean (bool) types
- Signed & unsigned integer types
- IEEE-754 floating-point types
- string types

`bool` is a boolean type that can be either `true` or `false`.

Signed integers can be positive or negative. Unsigned integers can only be positive. They are written as i or u along with the size, which for integers is either `i8`, `i16`, `i32`, `i64`, `i128`, `i256`, `u8`, `u16`, `u32`, `u64`, `u128`, `u256`. Typically, you'll use `i32` for integers.

Floating-point types in Carbon are named with an f and the number of bits: `f16`, `f32`, `f64`, and `f128`.

Strings are a string of characters wrapped in double quotes. You can also create multi-line strings by using triple quotes. I'll go over that in a bit.

## Naming Conventions

- `UpperCamelCase` will be used when the named entity cannot have a dynamically varying value. For example, functions, namespaces, or compile-time constant values.

- `lower_snake_case` will be used when the named entity's value won't be known until runtime, such as for variables.

| Item                      | Convention         | Explanation                                                                                |
| ------------------------- | ------------------ | ------------------------------------------------------------------------------------------ |
| Packages                  | `UpperCamelCase`   | Used for compile-time lookup.                                                              |
| Types                     | `UpperCamelCase`   | Resolved at compile-time.                                                                  |
| Functions                 | `UpperCamelCase`   | Resolved at compile-time.                                                                  |
| Methods                   | `UpperCamelCase`   | Methods, including virtual methods, are equivalent to functions.                           |
| Generic parameters        | `UpperCamelCase`   | May vary based on inputs, but are ultimately resolved at compile-time.                     |
| Compile-time constants    | `UpperCamelCase`   | Resolved at compile-time. See [constants](#constants) for more remarks.                    |
| Variables                 | `lower_snake_case` | May be reassigned and thus require runtime information.                                    |
| Member variables          | `lower_snake_case` | Behave like variables.                                                                     |
| Keywords                  | `lower_snake_case` | Special, and developers can be expected to be comfortable with this casing cross-language. |
| Type literals             | `lower_snake_case` | Equivalent to keywords.                                                                    |
| Boolean type and literals | `lower_snake_case` | Equivalent to keywords.                                                                    |
| Other Carbon types        | `UpperCamelCase`   | Behave like normal types.                                                                  |
| `Self` and `Base`         | `UpperCamelCase`   | These are similar to type members on a class.                                              |

## Variables

Alright, so let's create some variables. In Carbon, we use the `var` keyword. We also have to define the type.

```C++
   fn OutputText() -> String {
    var text: String = "Hello World";
    Print(text); // Prints "Hello World"
  }
```

We can re-assign a variable declared with `var`

```C++
    var text: String = "Hello World";
    text = "Hi There";
    Print(text); // Prints "Hi There"
```

We can also define constants with the `let` keyword. I know this is a little weird for my fellow JavaScript developers, because in JavaScript we use `const` for constants and `let` for variables that can be re-assigned. The following will result in an error.

```C++
    let text: String = "Hello World";
    text = "Hi There";
    Print(text); // Throws an error
```

## Using `auto`

`auto` can be used to automatically infer the type of a variable or a function (except for Main())

```C++
     var text: auto = "Hello World";
```

## Global Variables

Like with most languages, variables defined in a function are limited to that scope. We can define global variables outside of any function and use it within any function

```C++
    var text: String = "Hello World";
    fn OutputText() {
        Print(text); // Prints "Hello World"
    }
```

## Multi-Line Strings

You can use tripe quotes to create multi-line strings.

```
var text: String = """
        Hello World
        Goodbye World
""";
```

## Function Arguments

Let's create another function that also takes in arguments. The argument types are also defined.

```C++
fn Add(var x: i32, var y: i32) -> i32 {
    return x + y;
}
```

If we wanted to print the result within a string, we could do that like this

```C++
Print("The sum is {0}", Add(5, 5)); // The sum is 10
```

## Arrays

Arrays are data structures that hold multiple values. When defining arrays, we specify the type and size

```C++
fn Main() -> i32 {
  var i_arr: [i32; 5] = (1 ,2, 3, 4, 5);
  var s_arr: [String; 2] = ("Hello", "World");
  Print(s_arr[0]);
  return i_arr[4] + i_arr[1]; // 6
}
```

## Tuples

A Tuple is an object that can hold multiple elements. We do not need to define the length of the tuple, but we do need to specify the types of the elements.

```C++
fn Main() -> i32 {
  var t: auto = (1, 2);
  return t[2]; // Returns 2
```

We can have multiple types

```C++
fn Main() -> i32 {
  var t: (i32, String) = (5, "Hello");
  Print(t[2]);
  return t[1]; // Returns "Hello"
}
```

We can also convert a tuple to an array.

```C++
fn Main() -> i32 {
  var t: auto = (1, 2);
  var a: [i32; 2] = t;
  return a[0] + a[1]; // 3
}
```

## Structs

Structs are similar to a hash or a dictionary in Python. They are key/value pairs or values that can be accessed by a name rather than an index.

```C++
 fn Main() -> i32 {
    var person: auto = {.name = "Brad", .loc = "MA"};
    Print(person.name); // Prints "Brad"

    // Change name value
    person.name = "John";
    Print(person.name); // Prints "John"

    // Define types
    var p: {.x: i32, .y: i32} = {.x = 1, .y = 2};
    Print("Value: {0}", p.x); // Prints 1
    return 0;
  }
```

## Classes

Classes can be used to create objects. Classes can have properties, methods and functions.

```C++
class Point {
    var x: i32;
    var y: i32;
}


fn Main() -> i32 {
    // Instantiate a new object
    var p: Point = {.x = 1, .y = 6};
    Print("Result: {0}", p.y - p.x); // Prints 5
    return 0;
}
```

### Class Methods

A method is a function that is defined within a class. We can then run that method on the instantiated object.

```C++
class Point {
    var x: i32;
    var y: i32;

    // Can also use "Self"  instead of "Point"
    fn GetX[me: Point]() -> i32 {
      return me.x;
    }

     fn GetY[me: Point]() -> i32 {
      return me.y;
    }
}


fn Main() -> i32 {
    var p: Point = {.x = 1, .y = 6};
    Print("X: {0}", p.GetX());  // Prints "X: 1"
    Print("Y: {0}", p.GetY()); // Prints "Y: 6"

    return 0;
}
```

### Class Functions

A class function is run on the class itself instead of the instantiated object.

```C++
class Point {
    var x: i32;
    var y: i32;

    fn Origin() -> Point {
      return {.x = 0, .y = 0};
    }
}


fn Main() -> i32 {
  var p: Point = Point.Origin();
  Print("Result: {0}", p.x); // Prints 0
  return 0;
}
```

## Pointers

A pointer is a variable that holds the address of another variable. We can use the `&` operator to get the address of a variable.

```C++
fn Main() -> i32 {
    var x: i32 = 5;

    // Change x to 10
    x = 10;

    var p: i32* = &x;

    // This will change x to 7
    *p = 7;

    var q: i32* = &*p;

    // Changes x to 0
    *q = 0;

    return x; // Returns 7
}
```

### Struct Pointers

Here is an example using a `struct`

```C++
fn Main() -> i32 {
  var x: auto = {.x = 10, .y = 1};
  var p: i32* = &x.x;
  *p = 0;

  return x.x; // Returns 0
}
```

## If-Else Statements

If statements are pretty straightforward. Curly braces are always required unlike in C++ which allows control-flow constructs to omit curly braces around a single statement

It seems that comparison operators like `<` and `>` have not been implemented yet. If you use them you may get an error that says something like "unknown character".

```C++
  fn GuessNumber(num: i32) {
    if (num == 7) {
        Print("You guessed correctly!");
    } else {
        Print("Please Try Again");
    }
  }

  fn Main() -> i32 {
    GuessNumber(7); // Prints "You guessed correctly!"
    return 0;
  }
```

## Matches

Control-flow similar to switch statements in C++.

```C++
 fn LuckyNumbers(number: i32) -> i32 {
    match(number) {
        case 7 => {
            Print("7 is a lucky number!");
            return number;
        }
        case 11 => {
            Print("11 is a lucky number!");
            return number;
        }
        case 12 => {
            Print("12 is a lucky number!");
            return number;
        }
         default => {
            Print("{0} is not a lucky number!", number);
            return number;
        }
    }
}

fn Main() -> i32 {
    LuckyNumbers(11);
    return 0;
}
```

## While Loops

A while loop to count down from 10

```C++
  var i: i32 = 10;
  while (not (i == 0)) {
    i = i - 1;
    Print("{0}  ", i); // Prints "9 8 7 6 5 4 3 2 1 0"
  }
  return i;
```

## For Loops

I could not find an example of a for loop that works at this time. I will update this when for loops are implemented.

## Generics

Generics are a mechanism for writing parameterized code that applies generally instead of making near-duplicates for very similar situations using the same code for different types. `T` is used to represent the type.

```C++
fn GetInt(x: i32) -> i32 {
    return x;
}

fn GetStr(x: String) -> String {
    return x;
}

// Use a generic instead of multiple functions
fn GetVal[T:! Type](x: T) -> T {
  return x;
}

fn Main() -> i32 {
    Print(GetStr("10"));
    Print("{0}", GetInt(10));

    Print(GetVal("20"));
    Print("{0}", GetVal(20));
    return 0;
}
```

## Aliases

```C++
alias TypeAlias = i32;

fn Function(a: i32, b: TypeAlias) -> i32 { return a + b; }
fn GenericFunction[T:! Type](x: T) -> T { return x; }

alias FunctionAlias = Function;
alias GenericFunctionAlias = GenericFunction;

fn Main() -> i32 {
 return FunctionAlias(1, 2) + GenericFunctionAlias(4);
}
```
