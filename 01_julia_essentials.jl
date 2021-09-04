### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ c17c64f6-f371-45e5-9ef0-fa490740a667
using LinearAlgebra, Statistics

# ╔═╡ 52a3fe68-451e-40d9-b28b-252a92c990b9
using BenchmarkTools

# ╔═╡ 83352088-498f-482b-b233-e914a047e434
using Expectations, Distributions

# ╔═╡ c721c291-0444-4b9b-a22d-4957df3f5fdf
using PlotlyBase

# ╔═╡ 92c06022-82df-4b8e-bdd7-6d5495e44880
using PlutoUI

# ╔═╡ 9b12258e-25fe-4505-b3f3-77951ae48ede
using Plots

# ╔═╡ 0febc432-5dd4-4af0-973c-79b741c42d39
md"""
# Julia Essentials
"""

# ╔═╡ fd8e9c4c-1107-403f-bb78-0ff350c38384
md"""
## Contents

- Julia Essentials
  - Overview
  - Common Data Types
  - Iterating
  - Comparisons and Logical Operators
  - User-Defined Functions
  - Broadcasting
  - Scoping and Closures
  - Exercises
"""

# ╔═╡ 24df2ff7-686a-4229-8b1f-83546e61c8f8
md"""
Having covered a few examples, let’s now turn to a more systematic exposition
of the essential features of the language.
"""

# ╔═╡ ac6ff259-230c-4c8c-a9ff-83b437df7426
md"""
## Overview

Topics:

- Common data types  
- Iteration  
- More on user-defined functions  
- Comparisons and logic  
"""

# ╔═╡ a882c82c-f9c0-497d-8c7c-36ad9e5ac02e
md"""
### Setup
"""

# ╔═╡ 136e7ec0-5f5a-4fd6-bb70-39d783a2356d
md"""
## Common Data Types

Like most languages, Julia language defines and provides functions for operating on standard data types such as

- integers  
- floats  
- strings  
- arrays, etc…  


Let’s learn a bit more about them.
"""

# ╔═╡ 30bc31c0-1fef-4a1a-87e0-0f91249341d8
md"""
### Primitive Data Types

A particularly simple data type is a Boolean value, which can be either `true` or
`false`.
"""

# ╔═╡ f567b33e-f643-4aa2-98ca-c91fca847768
x1 = true

# ╔═╡ 681ff476-2289-493c-b678-06b01d091648
typeof(x1)

# ╔═╡ 2aed9492-d454-45ef-9145-5d4e9ee7314b
y1 = 1 > 2  # now y = false

# ╔═╡ 1cbae7e7-7f87-4552-9475-9255b6118893
md"""
The two most common data types used to represent numbers are integers and
floats.

(Computers distinguish between floats and integers because arithmetic is
handled in a different way)
"""

# ╔═╡ ab7b88fc-0ecf-46db-8a87-5880c8e2268f
typeof(1.0)

# ╔═╡ d223bf98-17c6-4fd1-8f4c-6f3be0847697
typeof(1)

# ╔═╡ 92b3b48e-f155-48e5-8407-7a5a43fe6a5b
md"""
If you’re running a 32 bit system you’ll still see `Float64`, but you will see `Int32` instead of `Int64` (see [the section on Integer types](https://docs.julialang.org/en/v1.1/manual/integers-and-floating-point-numbers/#Integers-1) from the Julia manual).

Arithmetic operations are fairly standard.
"""

# ╔═╡ b20a6c87-90ff-4253-a5d0-39fd676fca72
x2 = 2; y2 = 1.0;

# ╔═╡ fd45d8c3-bc41-4187-ab41-efa656b81a25
md"""
The `;` can be used to suppress output from a line of code, or to combine two lines of code together (as above), but is otherwise not necessary.
"""

# ╔═╡ 3290e6b8-aa10-43e9-a0d7-68315c966f5c
x2 * y2

# ╔═╡ a42a0201-d1a3-4772-bd39-d03006536e67
x2^2

# ╔═╡ bfab2d5e-edd5-46f8-856e-c547ca7e88b8
y2 / x2

# ╔═╡ 44c47bd0-cdf2-4b8d-8c2e-e02ba9a4b82b
md"""
Although the `*` can be omitted for multiplication between a numeric literal and a variable.
"""

# ╔═╡ bd02a8ec-79e1-43f8-8513-5739284c6532
2x2 - 3y2

# ╔═╡ 87806765-cab2-4982-bb1d-9bf05fe27a6c
md"""
Complex numbers are another primitive data type, with the imaginary part being specified by `im`.
"""

# ╔═╡ 4cb18a21-80b1-48e1-9386-da682c1a4504
x3 = 1 + 2im

# ╔═╡ 1188c331-ec06-483f-91bf-104132e907d1
y3 = 1 - 2im

# ╔═╡ 5eeae80d-c018-4541-a2bc-aaf1fb7809a0
x3 * y3  # complex multiplication

# ╔═╡ 55772dc0-988f-4112-a532-ad7d873ce698
md"""
There are several more primitive data types that we’ll introduce as necessary.
"""

# ╔═╡ ad061423-f0f3-4d23-ab24-3fce8ec769ec
md"""
### Strings

A string is a data type for storing a sequence of characters.

In Julia, strings are created using double quotation marks (single quotations are
reserved for the character type).
"""

# ╔═╡ eb3f01a5-3c7f-435d-bc26-3abca8dccb31
xs = "foobar"

# ╔═╡ 662d4a50-f750-4c82-8810-a0070388fb47
typeof(xs)

# ╔═╡ 9495db0a-09c4-4ecd-aae6-f1b0d6345b25
md"""
You’ve already seen examples of Julia’s simple string formatting operations.
"""

# ╔═╡ acd634a0-be87-4e93-811e-c0b1182621ac
x4 = 10; y4 = 20

# ╔═╡ b71768f6-9c9e-4fe3-b5fe-49e848e76a9a
md"""
The `\$` inside of a string is used to interpolate a variable.
"""

# ╔═╡ eaab189c-0e2c-4f20-86bc-fdf6a1f7f19a
"x4 = $x4"

# ╔═╡ 233f8ac9-2638-4cc1-8272-b39965b28f6a
md"""
With parentheses, you can splice the results of expressions into strings as well.
"""

# ╔═╡ 355a1e6c-ae52-489c-b5e4-74c361addb3f
"x4 + y4 = $(x4 + y4)"

# ╔═╡ 122f0aee-74d4-4716-9c3b-af2d9e7fded4
md"""
To concatenate strings use `*`
"""

# ╔═╡ b7d12f75-dc93-4a84-9c57-035149fc7663
"foo" * "bar"

# ╔═╡ e93e89af-5ed1-44dc-ac4b-73f363c19ec6
md"""
Julia provides many functions for working with strings.
"""

# ╔═╡ 9eb78ffb-41fd-4514-b085-24dfe575d167
s = "Charlie don't surf"

# ╔═╡ 505d0656-0548-499f-bb45-3268aaa8d4b5
split(s)

# ╔═╡ 1dc356d8-5c50-443b-9d56-75c66b12bd1e
replace(s, "surf" => "ski")

# ╔═╡ dafcebe7-c3ad-48b9-b8d7-61ccfd8fc9d7
split("fee,fi,fo", ",")

# ╔═╡ cd244c8b-02c4-4a7e-9e26-2bc5172162a8
strip(" foobar ")  # remove whitespace

# ╔═╡ 9b388fb8-009c-4ee3-b401-c0c11bd84b17
md"""
Julia can also find and replace using [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) ([see regular expressions documentation](https://docs.julialang.org/en/v1/manual/strings/#Regular-Expressions-1) for more info).
"""

# ╔═╡ 70db7569-4b3f-4958-adf9-c255c5381620
match(r"(\d+)", "Top 10")  # find digits in string

# ╔═╡ 77ef78d1-83d7-4cc1-b216-20d8a1a26006
md"""
### Containers

Julia has several basic types for storing collections of data.

We have already discussed arrays.

A related data type is a **tuple**, which is immutable and can contain different types.
"""

# ╔═╡ 13f0845b-9a5a-4d12-af10-6c23ccbd9ec0
xt = ("foo", "bar")

# ╔═╡ b73e34d8-2e8c-447e-9046-622a480f8687
yt = ("foo", 2)

# ╔═╡ 3602e1bd-a0c3-40db-82b6-ef95212135f2
typeof(xt), typeof(yt)

# ╔═╡ dd0daabe-ecc4-43fb-abba-07136649fe9d
md"""
An immutable value is one that cannot be altered once it resides in memory.

In particular, tuples do not support item assignment (i.e. `xt[1] = "test"` would fail).

Tuples can be constructed with or without parentheses.
"""

# ╔═╡ faf98152-62be-4161-bc23-e0539dcf15b1
xt2 = "foo", 1

# ╔═╡ 464d3aa1-51cb-471e-a746-f55c7b9334c9
function f()
    return "foo", 1
end

# ╔═╡ 80afc234-7d21-443c-9b36-66282b2cdf44
md"""
Tuples can also be unpacked directly into variables.
"""

# ╔═╡ 6208905e-08c0-49fd-b6db-77e1789982a5
xt3 = ("foo", 1)

# ╔═╡ afaab37d-6db9-40f5-a15b-7c48ab4c0f06
word, val = xt3

# ╔═╡ 70b7589c-ea7d-4063-89fd-30940ff890c5
"word = $word, val = $val"

# ╔═╡ d48e267b-cd38-4c27-881d-76ade9738458
md"""
Tuples can be created with a hanging `,` – this is useful to create a tuple with one element.
"""

# ╔═╡ 94b285d8-4858-40bc-bfdf-9650738e40e6
begin
	xt4 = ("foo", 1,)
	yt4 = ("foo",)
	typeof(xt4), typeof(yt4)
end

# ╔═╡ 0057bd59-9d39-4b40-928e-849ce9571a14
md"""
#### Referencing Items

The last element of a sequence type can be accessed with the keyword `end`.
"""

# ╔═╡ 8433aa9e-6a90-4959-acb8-403261b05f48
xv = [10, 20, 30, 40]

# ╔═╡ a65b8574-d885-413d-af36-c3e0952b049b
xv[end]

# ╔═╡ 151822e7-ad81-4a4d-816b-47807892faaf
xv[end-1]

# ╔═╡ 98760262-34b5-4627-9e99-316304e24932
md"""
To access multiple elements of an array or tuple, you can use slice notation.
"""

# ╔═╡ c5d51264-53f1-48aa-a2ce-ce286ba93d82
xv[1:3]

# ╔═╡ 0d053b7f-3411-4a88-88ac-f6af47ca38cd
xv[2:end]

# ╔═╡ efc2cea0-112d-4f13-86d9-5db47ae8674b
md"""
The same slice notation works on strings.
"""

# ╔═╡ 702d7f70-788a-4cc1-a5ab-e1b3944daf4a
"foobar"[3:end]

# ╔═╡ f920dd7a-11c9-42c2-89ea-eeecc218a9a6
md"""
#### Dictionaries

Another container type worth mentioning is dictionaries.

Dictionaries are like arrays except that the items are named instead of numbered.
"""

# ╔═╡ 11f82811-5a56-427b-962a-64aed1ae5203
d1 = Dict("name" => "Frodo", "age" => 33)

# ╔═╡ 76c7a116-608e-4adb-9712-4d6259406fb7
d1["age"]

# ╔═╡ 89aab4c1-0971-4fcb-bb80-1ba08beb42ac
md"""
The strings `name` and `age` are called the **keys**.

The keys are mapped to **values** (in this case `"Frodo"` and `33`).

They can be accessed via `keys(d1)` and `values(d1)` respectively.

**Note** Unlike in Python and some other dynamic languages, dictionaries
are rarely the right approach (ie. often referred to as “the devil’s datastructure”).

The flexibility (i.e. can store anything and use anything as a key) frequently
comes at the cost of performance if misused.

It is usually better to have collections of parameters and results in a named
tuple, which both provide the compiler with more opportunties to optimize the
performance, and also makes the code more safe.

"""

# ╔═╡ e1a9e187-c9d6-4cb9-a20d-9fa1996691d5
md"""
## Iterating

One of the most important tasks in computing is stepping through a
sequence of data and performing a given action.

Julia provides neat and flexible tools for iteration as we now discuss.
"""

# ╔═╡ 68044bfd-9b61-4de0-990e-99b65c9e7946
Markdown.MD(Markdown.Admonition("info", "with_terminal?", [md"In the examples below we use a function `with_terminal` to get Pluto to show the output of `print` or `println`. This is necessary only in Pluto. If you were working in a different environment like the Julia REPL or Jupyter notebooks, you could omit the `with_terminal() do` and the closing `end`"]))

# ╔═╡ 3129d8b8-2aeb-44de-9827-bb18cc3b433c
md"""
### Iterables

An iterable is something you can put on the right hand side of `for` and loop over.

These include sequence data types like arrays.
"""

# ╔═╡ 4e657cd7-c44a-4985-b635-d5b9fecf6f8a
actions = ["surf", "ski"]

# ╔═╡ cc32086f-58a5-448c-81ba-0e987cf38044
with_terminal() do 
	for action in actions
    	println("Charlie doesn't $action")
	end
end

# ╔═╡ cdc3168f-e9b2-42fa-8424-048ac191fe43
md"""
They also include so-called **iterators**.

You’ve already come across these types of values
"""

# ╔═╡ 7422cdae-78b5-405e-b077-58739d487a76
with_terminal() do 
	for i in 1:3
		println(i)
	end
end

# ╔═╡ 965bc5e2-7c69-4053-97cc-6dfa9078686f
md"""
If you ask for the keys of dictionary you get an iterator
"""

# ╔═╡ ac5808f5-9a3f-459d-8c10-820dfa00108c
d = Dict("name" => "Frodo", "age" => 33)

# ╔═╡ 6b3132c5-e4f4-4091-9087-368165fa2072
keys(d)

# ╔═╡ f2812e82-39e7-4114-a441-5666e751feea
md"""
This makes sense, since the most common thing you want to do with keys is loop over them.

The benefit of providing an iterator rather than an array, say, is that the former is more memory efficient.

Should you need to transform an iterator into an array you can always use `collect()`.
"""

# ╔═╡ 3ab8c5ac-6777-4273-bd51-3277b1d1b512
collect(keys(d))

# ╔═╡ 14221766-9b5f-483e-8b41-2460ff6f6e1c
md"""
### Looping without Indices

You can loop over sequences without explicit indexing, which often leads to
neater code.

For example compare
"""

# ╔═╡ 79024997-6e27-47a1-97bd-5f2805984f5b
x_values = 1:5

# ╔═╡ 584c9ba8-fdd8-49be-a2d5-d02a5ba93554
with_terminal() do 
	for x in x_values
		println(x * x)
	end
end

# ╔═╡ 7a59014a-dd21-4e6d-97bb-3ecfdf55a77b
with_terminal() do 
	for i in eachindex(x_values)
		println(x_values[i] * x_values[i])
	end
end

# ╔═╡ 0d398fe1-37e1-4d4e-9236-3c1c69ba4836
md"""
Julia provides some functional-style helper functions (similar to Python and R) to facilitate looping without indices.

One is `zip()`, which is used for stepping through pairs from two sequences.

For example, try running the following code
"""

# ╔═╡ ec4540a4-21f9-4068-87a9-b41dfc98b2b1
with_terminal() do 
	countries = ("Japan", "Korea", "China")
	cities = ("Tokyo", "Seoul", "Beijing")
	for (country, city) in zip(countries, cities)
		println("The capital of $country is $city")
	end
end

# ╔═╡ cb2222ce-92cc-401c-87d1-f85e042054bc
md"""
If we happen to need the index as well as the value, one option is to use `enumerate()`.

The following snippet will give you the idea
"""

# ╔═╡ 35bfacee-ef04-4d54-93dd-1ecdf9ca1406
with_terminal() do 
	countries = ("Japan", "Korea", "China")
	cities = ("Tokyo", "Seoul", "Beijing")
	for (i, country) in enumerate(countries)
		city = cities[i]
		println("The capital of $country is $city")
	end
end

# ╔═╡ f612fd27-ae0a-46dc-9bef-e1645e470659
md"""
### Comprehensions

([See comprehensions documentation](https://docs.julialang.org/en/v1/manual/arrays/#man-comprehensions-1))

Comprehensions are an elegant tool for creating new arrays, dictionaries, etc. from iterables.

Here are some examples
"""

# ╔═╡ e07693e3-4101-4f00-9477-e759b5347350
doubles = [ 2i for i in 1:4 ]

# ╔═╡ d0852cc1-0035-45f7-8fa1-84b7ba7b8897
animals = ["dog", "cat", "bird"];   # Semicolon suppresses output

# ╔═╡ f1a58f7a-25dc-4b99-a51a-d02f16ddc775
plurals = [ animal * "s" for animal in animals ]

# ╔═╡ bec06f8f-4257-4707-8817-8e93a592af5d
[ i + j for i in 1:3, j in 4:6 ]

# ╔═╡ 49f00ef8-f2fa-4e66-a30e-9a2b5c29de02
[ i + j + k for i in 1:3, j in 4:6, k in 7:9 ]

# ╔═╡ 44e95bb8-ec8b-49e7-8880-238663f1c4a4
md"""
Comprehensions can also create arrays of tuples or named tuples
"""

# ╔═╡ d7b910a0-28a7-474c-84ba-a6076ccfac6e
[ (i, j) for i in 1:2, j in animals]

# ╔═╡ b2c1f050-44f3-4e1e-9fbc-df0fc708cf05
[ (num = i, animal = j) for i in 1:2, j in animals]

# ╔═╡ 1c936480-75bd-45e0-9f62-d649aac24eb6
md"""
### Generators

([See generator documentation](https://docs.julialang.org/en/v1/manual/arrays/#Generator-Expressions-1))

In some cases, you may wish to use a comprehension to create an iterable list rather
than actually making it a concrete array.

The benefit of this is that you can use functions which take general iterators rather
than arrays without allocating and storing any temporary values.

For example, the following code generates a temporary array of size 10,000 and finds the sum.
"""

# ╔═╡ 3fe98b7b-414e-440d-a702-d0c9ade8206a
begin
	xv2 = 1:10000
	f2(x) = x^2
	f_xv2 = f2.(xv2)
	sum(f_xv2)
end

# ╔═╡ 3b8bf562-c919-46ff-a12e-95a9d3d86a20
md"""
We could have created the temporary using a comprehension, or even done the comprehension
within the `sum` function, but these all create temporary arrays.
"""

# ╔═╡ e2cd4427-71e4-4432-ad18-8f09597f7aaf
md"""
Note, that if you were hand-code this, you would be able to calculate the sum by simply
iterating to 10000, applying `f` to each number, and accumulating the results.  No temporary
vectors would be necessary.

A generator can emulate this behavior, leading to clear (and sometimes more efficient) code when used
with any function that accepts iterators.  All you need to do is drop the `]` brackets.
"""

# ╔═╡ 9b52b407-466b-4f0e-9d9f-7e849b8fb229
md"""
We can use `BenchmarkTools` to investigate
"""

# ╔═╡ e0e2cb00-ac9b-4f0d-8c36-1b3537293178
md"""
Notice that the first two cases are nearly identical, and allocate a temporary array, while the
final case using generators has no allocations.

In this example you may see a speedup of over 1000x.  Whether using generators leads to code that is faster or slower depends on the cirumstances, and you should (1) always profile rather than guess; and (2) worry about code clarify first, and performance second—if ever.
"""

# ╔═╡ 2ab15730-0586-42a6-a5b8-be6b907e2218
md"""
## Comparisons and Logical Operators
"""

# ╔═╡ a6f5c1bc-af74-4a89-b1e8-7779c9d6c1be
md"""
### Comparisons

As we saw earlier, when testing for equality we use `==`.
"""

# ╔═╡ 5d6d6fc8-02e6-477d-a729-68ef0b0d31bb
x5 = 1

# ╔═╡ a1a592fb-5ee7-426c-8f00-1cf4d63e1dc0
x5 == 2

# ╔═╡ 69c7ec31-007a-407a-8290-6e5f50fcbdbc
md"""
For “not equal” use `!=` or `≠` (`\ne<TAB>`).
"""

# ╔═╡ bd720a73-44fd-40b3-ac0d-bfbf69d1fdc1
x5 != 3

# ╔═╡ b6667cb0-42f9-41fe-bdcc-384cb91eefd6
md"""
Julia can also test approximate equality with `≈` (`\approx<TAB>`).
"""

# ╔═╡ 668b0d24-320d-456e-96a7-0dda9dbd7b34
1 + 1E-8 ≈ 1

# ╔═╡ de644bf8-2aeb-4a97-8491-a84017b33fb4
md"""
Be careful when using this, however, as there are subtleties involving the scales of the quantities compared.
"""

# ╔═╡ e87d74ba-6f3b-4257-80b3-9c66fa06def9
md"""
### Combining Expressions

Here are the standard logical connectives (conjunction, disjunction)
"""

# ╔═╡ 698d3a6d-c88d-407e-8d20-25a084989550
true && false

# ╔═╡ 1afd967f-d089-4233-a307-ad8f34d513c2
true || false

# ╔═╡ c28bbd9d-235b-4d6c-bcd5-e984b42f9ef0
md"""
Remember

- `P && Q` is `true` if both are `true`, otherwise it’s `false`.  
- `P || Q` is `false` if both are `false`, otherwise it’s `true`.  
"""

# ╔═╡ 4005e1f3-e73d-4df5-b597-de46edfe1a9d
md"""
## User-Defined Functions

Let’s talk a little more about user-defined functions.

User-defined functions are important for improving the clarity of your code by

- separating different strands of logic  
- facilitating code reuse (writing the same thing twice is always a bad idea)  


Julia functions are convenient:

- Any number of functions can be defined in a given file.  
- Any “value” can be passed to a function as an argument, including other functions.  
- Functions can be (and often are) defined inside other functions.  
- A function can return any kind of value, including functions.  


We’ll see many examples of these structures in the following lectures.

For now let’s just cover some of the different ways of defining functions.
"""

# ╔═╡ 807c664d-214f-47a4-aa4d-5c996c597a10
md"""
### Return Statement

In Julia, the `return` statement is optional, so that the following functions
have identical behavior
"""

# ╔═╡ fad24cbf-85a2-4731-9312-5335c85ef507
function f1(a, b)
    return a * b
end

# ╔═╡ f6cdba88-328a-47ef-b3e0-485817b774bf
function f2(a, b)
    a * b
end

# ╔═╡ d3bce31b-865b-4e7e-ab31-14982bbe15ee
md"""
When no return statement is present, the last value obtained when executing the code block is returned.

Although some prefer the second option, we often favor the former on the basis that explicit is better than implicit.

A function can have arbitrarily many `return` statements, with execution terminating when the first return is hit.

You can see this in action when experimenting with the following function
"""

# ╔═╡ 28047846-ee05-467f-831d-df972dc256b9
function foo(x)
    if x > 0
        return "positive"
    end
    return "nonpositive"
end

# ╔═╡ d53ee7cf-5a66-49e7-8198-b30aefd6e670
md"""
### Other Syntax for Defining Functions

For short function definitions Julia offers some attractive simplified syntax.

First, when the function body is a simple expression, it can be defined
without the `function` keyword or `end`.
"""

# ╔═╡ ca2bd5c5-7429-4121-b27d-25e790ac2303
f3(x) = sin(1 / x)

# ╔═╡ 1d6d3d8d-fdb2-4242-bdb1-a9cd51acddce
md"""
Let’s check that it works
"""

# ╔═╡ d727aab9-6c7d-44c0-8b9a-4ab2021a08a9
md"""
Julia also allows you to define anonymous functions.

For example, to define `f(x) = sin(1 / x)` you can use `x -> sin(1 / x)`.

The difference is that the second function has no name bound to it.

How can you use a function with no name?

Typically it’s as an argument to another function
"""

# ╔═╡ 6fcc85c8-7a1f-46a8-9d9f-8e74db9f73db
map(x -> sin(1 / x), randn(3))  # map: apply function to each element

# ╔═╡ ec1a3625-0fb2-469a-9794-9540746148a1
md"""
### Optional and Keyword Arguments

([See keyword arguments documentation](https://docs.julialang.org/en/v1/manual/functions/#Keyword-Arguments-1))

Function arguments can be given default values
"""

# ╔═╡ a4d32a9f-4216-4774-9626-1b62b8312514
f3(x, a = 1) = exp(cos(a * x))

# ╔═╡ 79197cf8-3ae8-433a-807e-c0171fa6bba1
f3(1 / pi)

# ╔═╡ a63483d1-5cf3-4614-813b-d03aa50d28f3
md"""
If the argument is not supplied, the default value is substituted.
"""

# ╔═╡ 9e9152f7-e01a-4c61-845f-89401961a801
3(pi)

# ╔═╡ 5c8ba98c-e858-4aea-ad88-f2a590390aa2
f3(pi, 2)

# ╔═╡ 2b9987ef-9b1d-4d43-921a-23b3c2709949
md"""
Another option is to use **keyword** arguments.

The difference between keyword and standard (positional) arguments is that
they are parsed and bounded by name rather than the order in the function call.

For example, in the call
"""

# ╔═╡ 1f4af12f-c524-47c6-8f74-5e968411fb3e
f4(x; a = 1) = exp(cos(a * x))  # note the ; in the definition

# ╔═╡ ca03875e-8fa0-4d5e-8402-7fbe75e1f02c
f4(pi, a = 2) # calling with ; is usually optional and generally discouraged

# ╔═╡ e426bb65-0f99-45d6-b5c2-a6d59cdc4d20
md"""
## Broadcasting

([See broadcasting documentation](https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting-1))

A common scenario in computing is that

- we have a function `f` such that `f(x)` returns a number for any number `x`  
- we wish to apply `f` to every element of an iterable `x_vec` to produce a new result `y_vec`  


In Julia loops are fast and we can do this easily enough with a loop.

For example, suppose that we want to apply `sin` to `x_vec = [2.0, 4.0, 6.0, 8.0]`.

The following code will do the job
"""

# ╔═╡ 4bb4c573-96bc-4bb4-ba6f-9c9aa21b77d8
begin
	x_vec = [2.0, 4.0, 6.0, 8.0]
	y_vec1 = similar(x_vec)
	for (i, x) in enumerate(x_vec)
	    y_vec1[i] = sin(x)
	end
	y_vec1
end

# ╔═╡ 91fd4121-2c48-41e1-80d6-42c495d35302
md"""
But this is a bit unwieldy so Julia offers the alternative syntax
"""

# ╔═╡ 764aaa78-7bf8-4aea-98b9-b30bda9d2c2e
y_vec2 = sin.(x_vec)

# ╔═╡ 9af5994a-54cb-476c-8778-559761c8139e
md"""
More generally, if `f` is any Julia function, then `f.` references the broadcasted version.

Conveniently, this applies to user-defined functions as well.

To illustrate, let’s write a function `chisq` such that `chisq(k)` returns a chi-squared random variable with `k` degrees of freedom when `k` is an integer.

In doing this we’ll exploit the fact that, if we take `k` independent standard normals, square them all and sum, we get a chi-squared with `k` degrees of freedom.
"""

# ╔═╡ 72a82b74-24f6-462e-a709-1d692a86aa4f
function chisq(k)
    @assert k > 0
    z = randn(k)
    return sum(z -> z^2, z)  # same as `sum(x^2 for x in z)`
end

# ╔═╡ 161a68ab-f298-4cfa-982c-7eb160415ad4
md"""
The macro `@assert` will check that the next expression evaluates to `true`, and will stop and display an error otherwise.
"""

# ╔═╡ b8e451f5-31bb-42e0-a675-7066a15d2f37
chisq(3)

# ╔═╡ 7bd54924-aea3-4290-b2b5-b3bbf61021e3
md"""
Note that calls with integers less than 1 will trigger an assertion failure inside
the function body.
"""

# ╔═╡ cad7a289-eba5-4dbd-9c18-4e625f4181c6
chisq(-2)

# ╔═╡ 919e122e-85ee-403c-952e-13ed2ad49baa
md"""
Let’s try this out on an array of integers, adding the broadcast
"""

# ╔═╡ 1652b3e1-89be-49dd-9ced-4def1c6a7a93
chisq.([2, 4, 6])

# ╔═╡ 82a2b07c-9343-4ec1-aeb4-921f5e53a5b5
md"""
The broadcasting notation is not simply vectorization, as it is able to “fuse” multiple broadcasts together to generate efficient code.
"""

# ╔═╡ 31773b48-7854-4025-94db-880d813db9cb
begin
	x6 = 1.0:1.0:5.0
	y6 = [2.0, 4.0, 5.0, 6.0, 8.0]
	z6 = similar(y6)
	z6 .= x6 .+ y6 .- sin.(x6) # generates efficient code instead of many temporaries
end

# ╔═╡ 3713be31-9930-4096-a357-4552f848216f
md"""
A convenience macro for adding broadcasting on every function call is `@.`
"""

# ╔═╡ b46fd7fb-2c6b-448e-9bbc-c8242b66b847
@. x6 + y6 - sin(x6)

# ╔═╡ 70ef1c5c-cb9c-496b-9711-86f95c54ac0d
md"""
Since the `+, -, =` operators are functions, behind the scenes this is broadcasting against both the `x` and `y` vectors.

The compiler will fix anything which is a scalar, and otherwise iterate across every vector
"""

# ╔═╡ e791f551-be41-41de-9fd6-0090ccb20cf4
with_terminal() do 
	f4(a, b) = a + b # bivariate function
	a = [1 2 3]
	b = [4 5 6]
	@show f4.(a, b) # across both
	@show f4.(a, 2); # fix scalar for second
end

# ╔═╡ ed8507d2-a0ab-4c51-96b0-72d9da0d3c7e
md"""
The compiler is only able to detect “scalar” values in this way for a limited number of types (e.g. integers, floating points, etc) and some packages (e.g. Distributions).

For other types, you will need to wrap any scalars in `Ref` to fix them, or else it will try to broadcast the value.

Another place that you may use a `Ref` is to fix a function parameter you do not want to broadcast over.
"""

# ╔═╡ 7f81a7aa-6d70-4b42-953c-1b2c1795078b
with_terminal() do 
	f5(x, y) = [1, 2, 3] ⋅ x + y   # "⋅" can be typed by \cdot<tab>
	@show f5([3, 4, 5], 2)   # uses vector as first parameter
	@show f5.(Ref([3, 4, 5]), [2, 3])   # broadcasting over 2nd parameter, fixing first
end

# ╔═╡ 06311095-4509-497d-ab7a-5f59d1af6562
md"""
### Higher-Order Functions

One of the benefits of working with closures and functions is that you can return them from other functions.

This leads to some natural programming patterns we have already been using, where we can use **functions of functions** and **functions returning functions** (or closures).

To see a simple example, consider functions that accept other functions (including closures)
"""

# ╔═╡ 7818c63f-4de9-4875-82d3-e0b4998aa414
with_terminal() do 
	twice(f, x) = f(f(x))  # applies f to itself twice
	f9(x) = x^2
	@show twice(f9, 2.0)

	twice(x -> x^2, 2.0)
	a = 5
	g2(x) = a * x
	@show twice(g2, 2.0);   # using a closure (g2 closes over `a`)
end

# ╔═╡ 61aed18e-ac30-4d3e-99d6-5d63e82a59cc
md"""
This pattern has already been used extensively in our code and is key to keeping things like interpolation, numerical integration, and plotting generic.

One example of using this in a library is [Expectations.jl](https://github.com/QuantEcon/Expectations.jl), where we can pass a function to the `expectation` function.
"""

# ╔═╡ c525873d-e357-4f04-a9f8-d5a3056c9624
d_exp = Exponential(2.0)

# ╔═╡ 70c84021-02eb-4a58-b532-7f5b581a76eb
square(x) = x^2

# ╔═╡ 2a45c889-38f3-43f0-8653-8649da936003
expectation(square, d_exp)  # E(f(x))

# ╔═╡ 520748c9-7bbf-45ef-837b-fa12635319cf
md"""
Another example is for a function that returns a closure itself.
"""

# ╔═╡ f0b9bef1-a5fc-44b6-9e8c-cf51d4bf0497
function multiplyit(a, g)
    return x -> a * g(x)  # function with `g` used in the closure
end

# ╔═╡ 30f82d7a-aedd-4186-895a-29151cabff94
h1 = multiplyit(2.0, square)    # use our quadratic, returns a new function which doubles the result

# ╔═╡ 43e3d7ba-32b9-4950-9028-d452c5ee9d49
h1(2)     # returned function is like any other function

# ╔═╡ 943bfac2-c70e-4b33-948f-d2bcbc8fbaa8
md"""
You can create and define using `function` as well
"""

# ╔═╡ 7aa15c77-23d9-4cf2-b9f4-ac4ed2a57edf
begin
	function snapabove(g, a)
	    function f(x)
	        if x > a         # "a" is captured in the closure f
	            return g(x)
	        else
	            return g(a)
	        end
	    end
	    return f    # closure with the embedded a
	end
	
	f(x) = x^2
	h2 = snapabove(f, 2.0)
	Plot(h2, 0, 3, Layout(height=600))
end

# ╔═╡ 8850eea8-5977-46bf-b3ed-fa576e17b8d7
f()

# ╔═╡ f16e96b9-16e6-4fb5-ba37-dbe12486ba43
with_terminal() do 
	f2_xv2 = [f(x) for x in xv2]
	@show sum(f2_xv2)
	@show sum([f(x) for x in xv2]); # still allocates temporary
end

# ╔═╡ 6bfd875d-4689-40d6-b743-4c29378724e6
sum(f(x) for x in xv2)

# ╔═╡ a2027d55-2f2c-4310-83b3-3cc4d3246af4
with_terminal() do 
	@btime sum([f(x) for x in $xv2])
	@btime sum(f.($xv2))
	@btime sum(f(x) for x in $xv2);
end

# ╔═╡ adb4b8e3-c710-4105-b818-174f6276a293
md"""
# Exercises
"""

# ╔═╡ 71b436a3-0211-48bf-8654-7269eeb5be21
md"""
### Exercise 1

Part 1: Given two numeric arrays or tuples `x_vals` and `y_vals` of equal length, compute
their inner product using `zip()`.

Part 2: Using a comprehension, count the number of even numbers between 0 and 99.

- Hint: `iseven` returns `true` for even numbers and `false` for odds.  


Part 3: Using a comprehension, take `pairs = ((2, 5), (4, 2), (9, 8), (12, 10))` and count the number of pairs `(a, b)` such that both `a` and `b` are even.
"""

# ╔═╡ 1870681e-4515-43ca-a677-0703e78b11f9
md""" ### Part 1 Answer"""

# ╔═╡ 0360c6e8-7d91-430a-b961-fe21db2fe1a6
x_vals = [1,2,3,4,5]

# ╔═╡ cc6c5bf9-12d7-4963-8c06-886a5d2d4a6f
y_vals = [6,7,8,9,10]

# ╔═╡ a6e4e90f-f1be-4b44-ab17-f06313377e0b
sum([x * y for (x, y) in zip(x_vals, y_vals)]) #We are defining the operation in the first part, second part is defining where the variables are located, and third part calls the variables.

# ╔═╡ 89632d23-0822-476f-ac17-7f58b92874d1
md"""
### Part 2 Answer
"""

# ╔═╡ 7100ad67-d6f5-4db3-a366-7c30c38b95d2
evennum = [0:1:99;]

# ╔═╡ ec4472c2-66e9-4a0d-ba5c-bcfcbfd21105
sum(iseven, evennum)

# ╔═╡ d6317cee-56a7-459b-b2ac-083c293e2091
md"""
### Part 3 Answer
"""

# ╔═╡ 55b2d9a2-6ef6-4917-9789-61a5bfb0ef93
pairs = ((2, 5), (4, 2), (9, 8), (12, 10))

# ╔═╡ 65bd6374-ba49-41ec-99c9-443f42445f7f
sum(i -> all(iseven, i), pairs)#Need to figure out what '->' means in this and what does all mean? Does the arrow mean passing the function.

# ╔═╡ 6049ad41-13b0-49c1-aeb2-8467a8572f08
md"""
### Exercise 2

Consider the polynomial


$$p(x)
= a_0 + a_1 x + a_2 x^2 + \cdots a_n x^n
= \sum_{i=0}^n a_i x^i \tag{1}$$

Using `enumerate()` in your loop, write a function `p` such that `p(x, coeff)` computes the value in the above equation given a point `x` and an array of coefficients `coeff`.

"""

# ╔═╡ c2cd2139-9a0e-4de5-a96d-26d0b273ddee
md"""
### Exercise 2 Answer
"""

# ╔═╡ 9f3e6bee-e43e-4591-b64f-b9aab7e61325
p(x, coeff) = sum(a * x^(i-1) for (i, a) in enumerate(coeff))

# ╔═╡ 19bf15e5-0761-4005-805b-fc29d8428527
p(1, (2,4))

# ╔═╡ c39a9257-da88-40ee-912b-0e9f2a764cc0
md"""
### Exercise 3

Write a function that takes a string as an argument and returns the number of capital letters in the string.

Hint: `uppercase("foo")` returns `"FOO"`.

"""

# ╔═╡ 92359e13-5f8b-4205-8966-c51a4a59c940
function upcount(string)
    count = 0
    for letter in string
        if (letter == uppercase(letter)) && isletter(letter)
            count += 1
        end
    end
    return count
end

# ╔═╡ 7b651723-18c2-4254-a095-23d3db15c63a
upcount("FOO")

# ╔═╡ cf71c412-4ade-4478-a662-5991d95c7d10
md"""
### Exercise 4

Write a function that takes two sequences `seq_a` and `seq_b` as arguments and
returns `true` if every element in `seq_a` is also an element of `seq_b`, else
`false`.

- By “sequence” we mean an array, tuple or string.  
"""

# ╔═╡ dd3b7ef4-fe0f-44c1-aabd-7c3496195c73
md"""
### Exercise 4 Answer
"""

# ╔═╡ aa772616-1ae9-4f70-a367-9ca794b8dce2
function sequence(seq_a, seq_b)
    is_subset = true
    for a in seq_a
        if a ∉ seq_b
            is_subset = false
        end
    end
    return is_subset
end

# ╔═╡ b00f76d5-3a2a-4fcc-991b-3f9857b14e7f
sequence([1, 2], [1, 2, 3])

# ╔═╡ d9360338-acba-4222-ad06-a60d9ec8f7a0
md"""
### Exercise 5

The Julia libraries include functions for interpolation and approximation.

Nevertheless, let’s write our own function approximation routine as an exercise.

In particular, write a function `linapprox` that takes as arguments

- A function `f` mapping some interval $ [a, b] $ into $ \mathbb R $.  
- two scalars `a` and `b` providing the limits of this interval.  
- An integer `n` determining the number of grid points.  
- A number `x` satisfying `a ≤ x ≤ b`.  


and returns the [piecewise linear interpolation](https://en.wikipedia.org/wiki/Linear_interpolation) of `f` at `x`, based on `n` evenly spaced grid points `a = point[1] < point[2] < ... < point[n] = b`.

Aim for clarity, not efficiency.

Hint: use the function `range` to linearly space numbers.
"""

# ╔═╡ 17866462-5b77-44bc-9bfb-07af57910035
md"""
### Exercise 5 Answer
"""

# ╔═╡ 521ff353-a85c-4dc2-8623-17581d22d128
function linapprox(f, a, b, n, x)
    # evaluates the piecewise linear interpolant of f at x,
    # on the interval [a, b], with n evenly spaced grid points.

    length_of_interval = b - a
    num_subintervals = n - 1
    step = length_of_interval / num_subintervals

    # find first grid point larger than x
    point = a
    while point ≤ x
        point += step
    end

    # x must lie between the gridpoints (point - step) and point
    u, v = point - step, point

    return f(u) + (x - u) * (f(v) - f(u)) / (v - u)
end

# ╔═╡ bd6f09bb-1389-46f3-a9f7-c061e003d9fc
f_ex5(x) = x^2

# ╔═╡ 4497dda7-c07c-451c-935e-b751c3291bb8
g_ex5(x) = linapprox(f_ex5, -1, 1, 3, x)

# ╔═╡ 6ec191c2-17e5-4ab8-aac2-40725f19523f
begin
	x_grid = range(-1.0, 1.0, length = 100)
	y_val = f_ex5.(x_grid)
	y = g_ex5.(x_grid)
	plot(x_grid, y_val, label = "true")
	plot!(x_grid, y, label = "approximation")
end

# ╔═╡ 16f20c48-0ab0-4bb2-881b-42a728e7c7bf
md"""
### Exercise 6

The following data lists US cities and their populations.

The code below creates a file called us_cicites.txt in your working directory

It fills it with the data shown in the string
"""

# ╔═╡ 9bde553f-6c46-46a5-9a41-07662fdd9378
open("us_cities.txt", "w") do f
  write(f,
"new york: 8244910
los angeles: 3819702
chicago: 2707120
houston: 2145146
philadelphia: 1536471
phoenix: 1469471
san antonio: 1359758
san diego: 1326179
dallas: 1223229")
end;

# ╔═╡ 7d9cc62d-adf3-4a83-808e-e443f735485e
md"""
Write a program to calculate total population across these cities.

Hints:

- If `f` is a file type then `eachline(f)` provides an iterable that steps you through the lines in the file.  
- `parse(Int, "100")` converts the string `"100"` into an integer.  

"""

# ╔═╡ a9f3b177-9c9b-4b3d-861a-416f46e47c34
md"""
### Exercise 6 Answer
"""

# ╔═╡ 6e4175d6-56e8-426f-b4ac-ee4deda94114
begin
	cities = open("us_cities.txt", "r")
	tot_pop = 0
	for line in eachline(cities)
	city, population = split(line, ':') # tuple unpacking
	tot_pop += parse(Int, population)
	end
	close(cities)
	with_terminal() do
		println("Total population = $tot_pop")
	end
end

# ╔═╡ d7d74238-8c94-4172-9cc7-0b8943c69760
md"""
### Exercise 7

Redo Exercise 5 except

1. Pass in a range instead of the `a, b,` and `n`.  Test with a range such as `nodes = -1.0:0.5:1.0`.  
1. Instead of the `while` used in the solution to Exercise 5, find a better way to efficiently bracket the `x` in the nodes.  


Hints:
* Rather than the signature as `function linapprox(f, a, b, n, x)`, it should be called as `function linapprox(f, nodes, x)`.
* `step(nodes), length(nodes), nodes[1]`, and `nodes[end]` may be useful.
* Type `?÷` into Pluto to explore quotients from Euclidean division for more efficient bracketing.
"""

# ╔═╡ 21b94552-e264-415b-8ede-d9d36db3c6db
nodes = -1.0:0.5:1.0

# ╔═╡ 9736d58b-7e56-499e-8d8e-b5aed12524b6
function lineapprox2(f, nodes, x)
	ix = searchsortedfirst(nodes, x)
	
	x1 = nodes[ix]
	x0 = nodes[ix-1]
	
	f(x0) + (f(x1) - f(x0)) / (x1-x0) * (x- x0)

# ╔═╡ 3a6202ba-e199-4c6d-890b-96c52cb422bb
md"""
# Dependencies
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Expectations = "2fe49d83-0758-5602-8f54-1f90ad0d522b"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
BenchmarkTools = "~1.1.3"
Distributions = "~0.24.18"
Expectations = "~1.7.1"
PlotlyBase = "~0.8.13"
Plots = "~1.21.3"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "42ac5e523869a84eac9669eaceed9e4aa0e1587b"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.4"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "bdc0937269321858ab2a4f288486cb258b9a0af7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.3.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "727e463cfebd0c7b999bbf3e9e7e16f254b94193"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.34.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "a837fdf80f333415b69684ba8e8ae6ba76de6aaa"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.24.18"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[Expectations]]
deps = ["Compat", "Distributions", "FastGaussQuadrature", "LinearAlgebra", "SpecialFunctions"]
git-tree-sha1 = "0f906c5edffe266acbf471734ac942d4aa9b7235"
uuid = "2fe49d83-0758-5602-8f54-1f90ad0d522b"
version = "1.7.1"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FastGaussQuadrature]]
deps = ["LinearAlgebra", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "5829b25887e53fb6730a9df2ff89ed24baa6abf6"
uuid = "442a2c76-b920-505d-bb47-c5924d526838"
version = "0.4.7"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "693210145367e7685d8604aee33d9bfb85db8b31"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.11.9"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "dba1e8614e98949abfa60480b13653813d8f0157"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "182da592436e287758ded5be6e32c406de3a2e47"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.58.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "ef49a187604f865f4708c90e3f431890724e9012"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.59.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "7bf67e9a481712b3dbe9cb3dac852dc4b1162e02"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+0"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "60ed5f1643927479f845b0135bb369b031b541fa"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.14"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "8a954fed8ac097d5be04921d595f741115c1b2ad"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+0"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "761a393aeccd6aa92ec3515e428c26bf99575b3b"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+0"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "3d682c07e6dd250ed082f883dc88aee7996bf2cc"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.0"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "2ca267b08821e86c5ef4376cffed98a46c2cb205"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4dd403333bcf0909341cfe57ec115152f937d7d8"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "9ff1c70190c1c30aebca35dc489f7411b256cd23"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.13"

[[PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "e9b96dd840b3c9d01669f1df28982b530b711165"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "2dbafeadadcf7dadff20cd60046bba416b4912be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.21.3"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "12fbe86da16df6679be7521dfb39fbc861e1dc7b"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "d4491becdc53580c6dadb0f6249f90caae888554"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StatsFuns]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "46d7ccc7104860c38b11966dd1f72ff042f382e4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.10"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "1700b86ad59348c0f9f68ddc95117071f947072d"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.1"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─0febc432-5dd4-4af0-973c-79b741c42d39
# ╟─fd8e9c4c-1107-403f-bb78-0ff350c38384
# ╟─24df2ff7-686a-4229-8b1f-83546e61c8f8
# ╟─ac6ff259-230c-4c8c-a9ff-83b437df7426
# ╟─a882c82c-f9c0-497d-8c7c-36ad9e5ac02e
# ╠═c17c64f6-f371-45e5-9ef0-fa490740a667
# ╟─136e7ec0-5f5a-4fd6-bb70-39d783a2356d
# ╟─30bc31c0-1fef-4a1a-87e0-0f91249341d8
# ╠═f567b33e-f643-4aa2-98ca-c91fca847768
# ╠═681ff476-2289-493c-b678-06b01d091648
# ╠═2aed9492-d454-45ef-9145-5d4e9ee7314b
# ╟─1cbae7e7-7f87-4552-9475-9255b6118893
# ╠═ab7b88fc-0ecf-46db-8a87-5880c8e2268f
# ╠═d223bf98-17c6-4fd1-8f4c-6f3be0847697
# ╟─92b3b48e-f155-48e5-8407-7a5a43fe6a5b
# ╠═b20a6c87-90ff-4253-a5d0-39fd676fca72
# ╟─fd45d8c3-bc41-4187-ab41-efa656b81a25
# ╠═3290e6b8-aa10-43e9-a0d7-68315c966f5c
# ╠═a42a0201-d1a3-4772-bd39-d03006536e67
# ╠═bfab2d5e-edd5-46f8-856e-c547ca7e88b8
# ╟─44c47bd0-cdf2-4b8d-8c2e-e02ba9a4b82b
# ╠═bd02a8ec-79e1-43f8-8513-5739284c6532
# ╟─87806765-cab2-4982-bb1d-9bf05fe27a6c
# ╠═4cb18a21-80b1-48e1-9386-da682c1a4504
# ╠═1188c331-ec06-483f-91bf-104132e907d1
# ╠═5eeae80d-c018-4541-a2bc-aaf1fb7809a0
# ╟─55772dc0-988f-4112-a532-ad7d873ce698
# ╟─ad061423-f0f3-4d23-ab24-3fce8ec769ec
# ╠═eb3f01a5-3c7f-435d-bc26-3abca8dccb31
# ╠═662d4a50-f750-4c82-8810-a0070388fb47
# ╟─9495db0a-09c4-4ecd-aae6-f1b0d6345b25
# ╠═acd634a0-be87-4e93-811e-c0b1182621ac
# ╟─b71768f6-9c9e-4fe3-b5fe-49e848e76a9a
# ╠═eaab189c-0e2c-4f20-86bc-fdf6a1f7f19a
# ╟─233f8ac9-2638-4cc1-8272-b39965b28f6a
# ╠═355a1e6c-ae52-489c-b5e4-74c361addb3f
# ╟─122f0aee-74d4-4716-9c3b-af2d9e7fded4
# ╠═b7d12f75-dc93-4a84-9c57-035149fc7663
# ╟─e93e89af-5ed1-44dc-ac4b-73f363c19ec6
# ╠═9eb78ffb-41fd-4514-b085-24dfe575d167
# ╠═505d0656-0548-499f-bb45-3268aaa8d4b5
# ╠═1dc356d8-5c50-443b-9d56-75c66b12bd1e
# ╠═dafcebe7-c3ad-48b9-b8d7-61ccfd8fc9d7
# ╠═cd244c8b-02c4-4a7e-9e26-2bc5172162a8
# ╟─9b388fb8-009c-4ee3-b401-c0c11bd84b17
# ╠═70db7569-4b3f-4958-adf9-c255c5381620
# ╟─77ef78d1-83d7-4cc1-b216-20d8a1a26006
# ╠═13f0845b-9a5a-4d12-af10-6c23ccbd9ec0
# ╠═b73e34d8-2e8c-447e-9046-622a480f8687
# ╠═3602e1bd-a0c3-40db-82b6-ef95212135f2
# ╟─dd0daabe-ecc4-43fb-abba-07136649fe9d
# ╠═faf98152-62be-4161-bc23-e0539dcf15b1
# ╠═464d3aa1-51cb-471e-a746-f55c7b9334c9
# ╠═8850eea8-5977-46bf-b3ed-fa576e17b8d7
# ╟─80afc234-7d21-443c-9b36-66282b2cdf44
# ╠═6208905e-08c0-49fd-b6db-77e1789982a5
# ╠═afaab37d-6db9-40f5-a15b-7c48ab4c0f06
# ╠═70b7589c-ea7d-4063-89fd-30940ff890c5
# ╟─d48e267b-cd38-4c27-881d-76ade9738458
# ╠═94b285d8-4858-40bc-bfdf-9650738e40e6
# ╟─0057bd59-9d39-4b40-928e-849ce9571a14
# ╠═8433aa9e-6a90-4959-acb8-403261b05f48
# ╠═a65b8574-d885-413d-af36-c3e0952b049b
# ╠═151822e7-ad81-4a4d-816b-47807892faaf
# ╟─98760262-34b5-4627-9e99-316304e24932
# ╠═c5d51264-53f1-48aa-a2ce-ce286ba93d82
# ╠═0d053b7f-3411-4a88-88ac-f6af47ca38cd
# ╟─efc2cea0-112d-4f13-86d9-5db47ae8674b
# ╠═702d7f70-788a-4cc1-a5ab-e1b3944daf4a
# ╟─f920dd7a-11c9-42c2-89ea-eeecc218a9a6
# ╠═11f82811-5a56-427b-962a-64aed1ae5203
# ╠═76c7a116-608e-4adb-9712-4d6259406fb7
# ╟─89aab4c1-0971-4fcb-bb80-1ba08beb42ac
# ╟─e1a9e187-c9d6-4cb9-a20d-9fa1996691d5
# ╟─68044bfd-9b61-4de0-990e-99b65c9e7946
# ╟─3129d8b8-2aeb-44de-9827-bb18cc3b433c
# ╠═4e657cd7-c44a-4985-b635-d5b9fecf6f8a
# ╠═cc32086f-58a5-448c-81ba-0e987cf38044
# ╟─cdc3168f-e9b2-42fa-8424-048ac191fe43
# ╠═7422cdae-78b5-405e-b077-58739d487a76
# ╟─965bc5e2-7c69-4053-97cc-6dfa9078686f
# ╠═ac5808f5-9a3f-459d-8c10-820dfa00108c
# ╠═6b3132c5-e4f4-4091-9087-368165fa2072
# ╟─f2812e82-39e7-4114-a441-5666e751feea
# ╠═3ab8c5ac-6777-4273-bd51-3277b1d1b512
# ╟─14221766-9b5f-483e-8b41-2460ff6f6e1c
# ╠═79024997-6e27-47a1-97bd-5f2805984f5b
# ╠═584c9ba8-fdd8-49be-a2d5-d02a5ba93554
# ╠═7a59014a-dd21-4e6d-97bb-3ecfdf55a77b
# ╟─0d398fe1-37e1-4d4e-9236-3c1c69ba4836
# ╠═ec4540a4-21f9-4068-87a9-b41dfc98b2b1
# ╟─cb2222ce-92cc-401c-87d1-f85e042054bc
# ╠═35bfacee-ef04-4d54-93dd-1ecdf9ca1406
# ╟─f612fd27-ae0a-46dc-9bef-e1645e470659
# ╠═e07693e3-4101-4f00-9477-e759b5347350
# ╠═d0852cc1-0035-45f7-8fa1-84b7ba7b8897
# ╠═f1a58f7a-25dc-4b99-a51a-d02f16ddc775
# ╠═bec06f8f-4257-4707-8817-8e93a592af5d
# ╠═49f00ef8-f2fa-4e66-a30e-9a2b5c29de02
# ╟─44e95bb8-ec8b-49e7-8880-238663f1c4a4
# ╠═d7b910a0-28a7-474c-84ba-a6076ccfac6e
# ╠═b2c1f050-44f3-4e1e-9fbc-df0fc708cf05
# ╟─1c936480-75bd-45e0-9f62-d649aac24eb6
# ╠═3fe98b7b-414e-440d-a702-d0c9ade8206a
# ╟─3b8bf562-c919-46ff-a12e-95a9d3d86a20
# ╠═f16e96b9-16e6-4fb5-ba37-dbe12486ba43
# ╟─e2cd4427-71e4-4432-ad18-8f09597f7aaf
# ╠═6bfd875d-4689-40d6-b743-4c29378724e6
# ╟─9b52b407-466b-4f0e-9d9f-7e849b8fb229
# ╠═52a3fe68-451e-40d9-b28b-252a92c990b9
# ╠═a2027d55-2f2c-4310-83b3-3cc4d3246af4
# ╟─e0e2cb00-ac9b-4f0d-8c36-1b3537293178
# ╟─2ab15730-0586-42a6-a5b8-be6b907e2218
# ╟─a6f5c1bc-af74-4a89-b1e8-7779c9d6c1be
# ╠═5d6d6fc8-02e6-477d-a729-68ef0b0d31bb
# ╠═a1a592fb-5ee7-426c-8f00-1cf4d63e1dc0
# ╟─69c7ec31-007a-407a-8290-6e5f50fcbdbc
# ╠═bd720a73-44fd-40b3-ac0d-bfbf69d1fdc1
# ╟─b6667cb0-42f9-41fe-bdcc-384cb91eefd6
# ╠═668b0d24-320d-456e-96a7-0dda9dbd7b34
# ╟─de644bf8-2aeb-4a97-8491-a84017b33fb4
# ╟─e87d74ba-6f3b-4257-80b3-9c66fa06def9
# ╠═698d3a6d-c88d-407e-8d20-25a084989550
# ╠═1afd967f-d089-4233-a307-ad8f34d513c2
# ╟─c28bbd9d-235b-4d6c-bcd5-e984b42f9ef0
# ╟─4005e1f3-e73d-4df5-b597-de46edfe1a9d
# ╟─807c664d-214f-47a4-aa4d-5c996c597a10
# ╠═fad24cbf-85a2-4731-9312-5335c85ef507
# ╠═f6cdba88-328a-47ef-b3e0-485817b774bf
# ╟─d3bce31b-865b-4e7e-ab31-14982bbe15ee
# ╠═28047846-ee05-467f-831d-df972dc256b9
# ╟─d53ee7cf-5a66-49e7-8198-b30aefd6e670
# ╠═ca2bd5c5-7429-4121-b27d-25e790ac2303
# ╟─1d6d3d8d-fdb2-4242-bdb1-a9cd51acddce
# ╠═79197cf8-3ae8-433a-807e-c0171fa6bba1
# ╟─d727aab9-6c7d-44c0-8b9a-4ab2021a08a9
# ╠═6fcc85c8-7a1f-46a8-9d9f-8e74db9f73db
# ╟─ec1a3625-0fb2-469a-9794-9540746148a1
# ╠═a4d32a9f-4216-4774-9626-1b62b8312514
# ╟─a63483d1-5cf3-4614-813b-d03aa50d28f3
# ╠═9e9152f7-e01a-4c61-845f-89401961a801
# ╠═5c8ba98c-e858-4aea-ad88-f2a590390aa2
# ╟─2b9987ef-9b1d-4d43-921a-23b3c2709949
# ╠═1f4af12f-c524-47c6-8f74-5e968411fb3e
# ╠═ca03875e-8fa0-4d5e-8402-7fbe75e1f02c
# ╟─e426bb65-0f99-45d6-b5c2-a6d59cdc4d20
# ╠═4bb4c573-96bc-4bb4-ba6f-9c9aa21b77d8
# ╟─91fd4121-2c48-41e1-80d6-42c495d35302
# ╠═764aaa78-7bf8-4aea-98b9-b30bda9d2c2e
# ╟─9af5994a-54cb-476c-8778-559761c8139e
# ╠═72a82b74-24f6-462e-a709-1d692a86aa4f
# ╟─161a68ab-f298-4cfa-982c-7eb160415ad4
# ╠═b8e451f5-31bb-42e0-a675-7066a15d2f37
# ╟─7bd54924-aea3-4290-b2b5-b3bbf61021e3
# ╠═cad7a289-eba5-4dbd-9c18-4e625f4181c6
# ╟─919e122e-85ee-403c-952e-13ed2ad49baa
# ╠═1652b3e1-89be-49dd-9ced-4def1c6a7a93
# ╟─82a2b07c-9343-4ec1-aeb4-921f5e53a5b5
# ╠═31773b48-7854-4025-94db-880d813db9cb
# ╟─3713be31-9930-4096-a357-4552f848216f
# ╠═b46fd7fb-2c6b-448e-9bbc-c8242b66b847
# ╟─70ef1c5c-cb9c-496b-9711-86f95c54ac0d
# ╠═e791f551-be41-41de-9fd6-0090ccb20cf4
# ╟─ed8507d2-a0ab-4c51-96b0-72d9da0d3c7e
# ╠═7f81a7aa-6d70-4b42-953c-1b2c1795078b
# ╟─06311095-4509-497d-ab7a-5f59d1af6562
# ╠═7818c63f-4de9-4875-82d3-e0b4998aa414
# ╟─61aed18e-ac30-4d3e-99d6-5d63e82a59cc
# ╠═83352088-498f-482b-b233-e914a047e434
# ╠═c525873d-e357-4f04-a9f8-d5a3056c9624
# ╠═70c84021-02eb-4a58-b532-7f5b581a76eb
# ╠═2a45c889-38f3-43f0-8653-8649da936003
# ╟─520748c9-7bbf-45ef-837b-fa12635319cf
# ╠═f0b9bef1-a5fc-44b6-9e8c-cf51d4bf0497
# ╠═30f82d7a-aedd-4186-895a-29151cabff94
# ╠═43e3d7ba-32b9-4950-9028-d452c5ee9d49
# ╟─943bfac2-c70e-4b33-948f-d2bcbc8fbaa8
# ╠═c721c291-0444-4b9b-a22d-4957df3f5fdf
# ╠═7aa15c77-23d9-4cf2-b9f4-ac4ed2a57edf
# ╟─adb4b8e3-c710-4105-b818-174f6276a293
# ╟─71b436a3-0211-48bf-8654-7269eeb5be21
# ╟─1870681e-4515-43ca-a677-0703e78b11f9
# ╠═0360c6e8-7d91-430a-b961-fe21db2fe1a6
# ╠═cc6c5bf9-12d7-4963-8c06-886a5d2d4a6f
# ╠═a6e4e90f-f1be-4b44-ab17-f06313377e0b
# ╟─89632d23-0822-476f-ac17-7f58b92874d1
# ╠═7100ad67-d6f5-4db3-a366-7c30c38b95d2
# ╠═ec4472c2-66e9-4a0d-ba5c-bcfcbfd21105
# ╟─d6317cee-56a7-459b-b2ac-083c293e2091
# ╠═55b2d9a2-6ef6-4917-9789-61a5bfb0ef93
# ╠═65bd6374-ba49-41ec-99c9-443f42445f7f
# ╟─6049ad41-13b0-49c1-aeb2-8467a8572f08
# ╟─c2cd2139-9a0e-4de5-a96d-26d0b273ddee
# ╠═9f3e6bee-e43e-4591-b64f-b9aab7e61325
# ╠═19bf15e5-0761-4005-805b-fc29d8428527
# ╟─c39a9257-da88-40ee-912b-0e9f2a764cc0
# ╠═92359e13-5f8b-4205-8966-c51a4a59c940
# ╠═7b651723-18c2-4254-a095-23d3db15c63a
# ╟─cf71c412-4ade-4478-a662-5991d95c7d10
# ╟─dd3b7ef4-fe0f-44c1-aabd-7c3496195c73
# ╠═aa772616-1ae9-4f70-a367-9ca794b8dce2
# ╠═b00f76d5-3a2a-4fcc-991b-3f9857b14e7f
# ╟─d9360338-acba-4222-ad06-a60d9ec8f7a0
# ╟─17866462-5b77-44bc-9bfb-07af57910035
# ╠═521ff353-a85c-4dc2-8623-17581d22d128
# ╠═bd6f09bb-1389-46f3-a9f7-c061e003d9fc
# ╠═4497dda7-c07c-451c-935e-b751c3291bb8
# ╠═6ec191c2-17e5-4ab8-aac2-40725f19523f
# ╟─16f20c48-0ab0-4bb2-881b-42a728e7c7bf
# ╠═9bde553f-6c46-46a5-9a41-07662fdd9378
# ╟─7d9cc62d-adf3-4a83-808e-e443f735485e
# ╟─a9f3b177-9c9b-4b3d-861a-416f46e47c34
# ╠═6e4175d6-56e8-426f-b4ac-ee4deda94114
# ╟─d7d74238-8c94-4172-9cc7-0b8943c69760
# ╠═21b94552-e264-415b-8ede-d9d36db3c6db
# ╠═9736d58b-7e56-499e-8d8e-b5aed12524b6
# ╟─3a6202ba-e199-4c6d-890b-96c52cb422bb
# ╠═92c06022-82df-4b8e-bdd7-6d5495e44880
# ╠═9b12258e-25fe-4505-b3f3-77951ae48ede
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
