### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ d7cb8d55-f078-4478-a9a4-767dd4869f78
using LinearAlgebra, Statistics

# ╔═╡ 45133e10-6a60-4f4c-9f73-d9f309246d64
using StaticArrays

# ╔═╡ 59bc1372-0822-4fc9-8e3a-5ef8662e1f26
using Parameters

# ╔═╡ 63f7289d-fd20-41a3-8018-7805c902f170
using QuantEcon

# ╔═╡ 21fc740c-f155-4432-997d-fa08638ecb30
using Plots

# ╔═╡ fe394e75-2f4e-4f04-92c1-c99743426145
using PlutoUI

# ╔═╡ ab596346-2555-4bbc-9231-7ea42580228c
md"""
# Arrays, Tuples, Ranges, and Other Fundamental Types
"""

# ╔═╡ 5e4d7378-e805-4289-89ce-db24a55c7f49
md"""
## Contents

- Arrays, Tuples, Ranges, and Other Fundamental Types
  - Overview
  - Array Basics
  - Operations on Arrays
  - Ranges
  - Tuples and Named Tuples
  - Nothing, Missing, and Unions
  - Exercises

"""

# ╔═╡ 049a70fa-15c2-468f-9c5a-b9155b48cccd
md"""
> “Let’s be clear: the work of science has nothing whatever to do with consensus.
> Consensus is the business of politics. Science, on the contrary, requires only
> one investigator who happens to be right, which means that he or she has
> results that are verifiable by reference to the real world. In science
> consensus is irrelevant. What is relevant is reproducible results.” – Michael Crichton
"""

# ╔═╡ f8977562-fe6d-422d-9cc8-e92a977931bc
md"""
## Overview

In Julia, arrays and tuples are the most important data type for working with numerical data.

In this lecture we give more details on

- creating and manipulating Julia arrays  
- fundamental array processing operations  
- basic matrix algebra  
- tuples and named tuples  
- ranges  
- nothing, missing, and unions  
"""

# ╔═╡ f3617c37-52fd-42d5-a698-af7a5df7e3de
md"""
### Setup
"""

# ╔═╡ 983822de-a698-4764-90b6-9e3d4b97f5fc
md"""
## Array Basics

([See multi-dimensional arrays documentation](https://docs.julialang.org/en/v1/manual/arrays/))

Since it is one of the most important types, we will start with arrays.

Later, we will see how arrays (and all other types in Julia) are handled in a generic and extensible way.
"""

# ╔═╡ 740f7d48-3cbf-4a6a-bc0d-568ea146f267
md"""
### Shape and Dimension

We’ve already seen some Julia arrays in action
"""

# ╔═╡ 5f2e9f9e-907e-430d-b12e-0a64c75f2ff5
a1 = [10, 20, 30]

# ╔═╡ da981af6-69f2-4f96-9142-ca73468fd3d3
a2 = [1.0, 2.0, 3.0]

# ╔═╡ b5eac13c-a5cb-40c0-84fe-606351fb48cc
md"""
The output tells us that the arrays are of types `Array{Int64,1}` and `Array{Float64,1}` respectively.

Here `Int64` and `Float64` are types for the elements inferred by the compiler.

We’ll talk more about types later.

The `1` in `Array{Int64,1}` and `Array{Any,1}` indicates that the array is
one dimensional (i.e., a `Vector`).

This is the default for many Julia functions that create arrays
"""

# ╔═╡ cb31edb9-205e-4449-a1cd-d3533f85cf92
typeof(randn(100))

# ╔═╡ 6c25642f-dba9-4a49-87bf-02712fb2ecba
md"""
In Julia, one dimensional vectors are best interpreted as column vectors, which we will see when we take transposes.

We can check the dimensions of `a` using `size()` and `ndims()`
functions
"""

# ╔═╡ 974f966b-dd0b-497b-9501-d6e3037bf2a7
ndims(a1)

# ╔═╡ 80f9a279-0090-471f-bb9a-62288951fade
size(a1)

# ╔═╡ 44060480-fe15-4e1f-bfa9-a0de092df763
md"""
The syntax `(3,)` displays a tuple containing one element – the size along the one dimension that exists.
"""

# ╔═╡ 3636b9a7-e453-466c-a37a-23ecdbb367b6
md"""
#### Array vs Vector vs Matrix

In Julia, `Vector` and `Matrix` are just aliases for one- and two-dimensional arrays
respectively
"""

# ╔═╡ de418799-a0d0-4502-bff2-9e575f644ac8
Array{Int64, 1} == Vector{Int64}

# ╔═╡ e234bb39-47b0-42f2-b9bc-807ea395f2f3
Array{Int64, 2} == Matrix{Int64}

# ╔═╡ 866b5359-0185-42d1-b4e9-daa5fea450a4
md"""
Vector construction with `,` is then interpreted as a column vector.

To see this, we can create a column vector and row vector more directly
"""

# ╔═╡ 31369706-d000-489e-b75a-7f720c1af200
[1, 2, 3] == [1; 2; 3]  # both column vectors

# ╔═╡ cd8f8831-43c1-4a0d-ac1b-4b913b59452b
[1 2 3]  # a row vector is 2-dimensional

# ╔═╡ fb87c8f4-ae3b-4de5-814d-0ae6a0347397
md"""
As we’ve seen, in Julia we have both

- one-dimensional arrays (i.e., flat arrays)  
- arrays of size `(1, n)` or `(n, 1)` that represent row and column vectors respectively  


Why do we need both?

On one hand, dimension matters for matrix algebra.

- Multiplying by a row vector is different to multiplying by a column vector.  


On the other, we use arrays in many settings that don’t involve matrix algebra.

In such cases, we don’t care about the distinction between row and column vectors.

This is why many Julia functions return flat arrays by default.


<a id='creating-arrays'></a>
"""

# ╔═╡ d321fd7e-5499-4334-885f-67f90739a10a
md"""
### Creating Arrays
"""

# ╔═╡ fbb10f03-a964-49bf-bc80-9065020946a5
md"""
#### Functions that Create Arrays

We’ve already seen some functions for creating a vector filled with `0.0`
"""

# ╔═╡ 35c7edab-ddcc-4534-9082-544e75d9da38
zeros(3)

# ╔═╡ cc217a0a-0759-4238-94d8-dcbdf571bcaf
md"""
This generalizes to matrices and higher dimensional arrays
"""

# ╔═╡ dd4470b0-8dee-4c4d-b761-6c63a70ed773
zeros(2, 2)

# ╔═╡ e01650bc-8252-4fad-bf69-60bbc224fa12
md"""
To return an array filled with a single value, use `fill`
"""

# ╔═╡ e6369b12-9baf-41ff-b922-8d36bbaf5fe9
fill(5.0, 2, 2)

# ╔═╡ eee21783-8385-4fab-bd7d-aba4e1c324aa
md"""
Finally, you can create an empty array using the `Array()` constructor
"""

# ╔═╡ fb9eec26-6cb0-4be7-8ed8-964ed0f587a2
x2 = Array{Float64}(undef, 2, 2)

# ╔═╡ a2355b0e-cffc-4eeb-9d06-4dad4eebf2e0
md"""
The printed values you see here are just garbage values.

(the existing contents of the allocated memory slots being interpreted as 64 bit floats)

If you need more control over the types, fill with a non-floating point
"""

# ╔═╡ 42414ad7-7cf0-4b13-a9d5-a8c6d6636e09
fill(0, 2, 2)  # fills with 0, not 0.0

# ╔═╡ b6be34ae-522d-482c-a125-4db7a3013bdc
md"""
Or fill with a boolean type
"""

# ╔═╡ 04a285b4-c13c-4a41-9071-f6a10bc24f45
fill(false, 2, 2)  # produces a boolean matrix

# ╔═╡ 0b11f111-7e4d-4af0-b752-0482b1ff8824
md"""
#### Creating Arrays from Existing Arrays

For the most part, we will avoid directly specifying the types of arrays, and let the compiler deduce the optimal types on its own.

The reasons for this, discussed in more detail in [this lecture](https://julia.quantecon.org/../more_julia/generic_programming.html), are to ensure both clarity and generality.

One place this can be inconvenient is when we need to create an array based on an existing array.

First, note that assignment in Julia binds a name to a value, but does not make a copy of that type
"""

# ╔═╡ 6af8fd10-52af-4260-924c-368490b65170
let  # let introduces local scope... so this `x` is only defined in this box
	x = [1, 2, 3]
	y = x
	y[1] = 2
	x
end

# ╔═╡ bc449bc9-ee14-4ac9-9a41-2c16ef6af0b4
md"""
In the above, `y = x` simply creates a new named binding called `y` which refers to whatever `x` currently binds to.

To copy the data, you need to be more explicit
"""

# ╔═╡ 815f37e8-2c87-4f2d-933d-678a5dfdf427
let 
	x = [1, 2, 3]
	y = copy(x)
	y[1] = 2
	x
end

# ╔═╡ 7d87ee6e-649d-4a8a-a71b-61639de32f77
md"""
However, rather than making a copy of `x`, you may want to just have a similarly sized array
"""

# ╔═╡ 32979952-c3c5-42ec-a23f-9db1ec7f653e
let
	x = [1, 2, 3]
	y = similar(x)
	y
end

# ╔═╡ 5858fb41-cada-4f49-82ed-104ede4e8407

md"""
We can also use `similar` to pre-allocate a vector with a different size, but the same shape
"""

# ╔═╡ a2c38114-56d0-49e1-ac0e-933a68bb2feb
let
	x = [1, 2, 3]
	y = similar(x, 4)  # make a vector of length 4
end

# ╔═╡ b117c684-ce1b-41e2-97f4-cd8269f2979e
md"""
Which generalizes to higher dimensions
"""

# ╔═╡ 75369fb4-7c54-4977-a8a4-79759d172f62
let
	x = [1, 2, 3]
	y = similar(x, 2, 2)  # make a 2x2 matrix
end

# ╔═╡ 84bfc209-05fe-4dd6-991d-b0afaa538af1
md"""
#### Manual Array Definitions

As we’ve seen, you can create one dimensional arrays from manually specified data like so
"""

# ╔═╡ 3b125fea-6290-42ff-8157-ad85a950c3ec
a3 = [10, 20, 30, 40]

# ╔═╡ 9706afbc-0dd7-4ea7-a2aa-6f79f10d71fb
md"""
In two dimensions we can proceed as follows
"""

# ╔═╡ b33bba6a-5805-4565-a510-1d1f1df55390
a4 = [10 20 30 40]  # two dimensional, shape is 1 x n

# ╔═╡ 4818cd7a-e394-4ad3-93a3-a0e860127fa6
ndims(a4)

# ╔═╡ 52998b3b-76e5-4685-9328-eb38df1f3bb5
a5 = [10 20; 30 40]  # 2 x 2

# ╔═╡ 7613ccb9-6a06-42fc-977b-eba7ceb91b5b
md"""
You might then assume that `a = [10; 20; 30; 40]` creates a two dimensional column vector but this isn’t the case.
"""

# ╔═╡ 967cf427-b287-4bb5-8f00-3a92b8792784
a6 = [10; 20; 30; 40]

# ╔═╡ d36facd9-3d04-471f-aefb-1c9407ce484f
ndims(a6)

# ╔═╡ 75c81a60-d935-4dfb-9cc1-bfeffeecd440
md"""
Instead transpose the matrix (or adjoint if complex)
"""

# ╔═╡ 6ba7122e-9e31-4eed-88e4-45bcb4395066
a7 = [10 20 30 40]'

# ╔═╡ a557bfda-adf7-4b32-9295-2c5d4d2b924b
ndims(a7)

# ╔═╡ db08bce4-4377-4446-899a-8ece08b78018
md"""
### Array Indexing

We’ve already seen the basics of array indexing
"""

# ╔═╡ d62ac4ec-dd62-4325-860f-f0427d0d1b85
begin
	a8 = [10 20 30 40]
	a8[end-1]
end

# ╔═╡ 4a5277dd-4cc4-4c1d-8f4d-44db2644c2c7
a8[1:3]

# ╔═╡ 82ea62ce-1ed0-46e5-a49e-ef9c5d498fb4
md"""
For 2D arrays the index syntax is straightforward
"""

# ╔═╡ 7ac8a2aa-2507-402f-8911-f050df4dc316
a9 = randn(2, 2)

# ╔═╡ a26a295e-1535-4a0d-b657-f370cc74a3ce
a9[1, 1]

# ╔═╡ dd414e29-660f-4846-9ba4-b827ee1ef364
a9[1, :]  # first row

# ╔═╡ d79caf27-2c34-45b8-bc86-cbab1f0886f2
a9[:, 1]  # first column

# ╔═╡ 33e566cc-617e-4868-a9d8-ca4763f5ff35
md"""
Booleans can be used to extract elements
"""

# ╔═╡ d92ebcb4-e6ca-4e30-b03e-88776ec642d2
a10 = randn(2, 2)

# ╔═╡ 49bd2cae-71a5-4b19-ae29-0f3ef4dddd76
b10 = [true false; false true]

# ╔═╡ 5f2ea0a1-031d-4d04-9c73-cfdaad5ad521
a10[b10]

# ╔═╡ e3a7bd52-1ccb-45f3-9405-aacf0d7545da
md"""
This is useful for conditional extraction, as we’ll see below.

An aside: some or all elements of an array can be set equal to one number using slice notation.
"""

# ╔═╡ d7750a33-6c9f-40b3-8f03-5585fafdcb60
a11 = zeros(4)

# ╔═╡ b1fb6c81-3d17-420a-b66a-ae613c21be32
a11[2:end] .= 42

# ╔═╡ c829f6b7-e14c-4f5d-957d-87bbea42d176
a11

# ╔═╡ a75206c1-db79-4d5c-aac6-3b5d0c9fd634
md"""
### Views and Slices

Using the `:` notation provides a slice of an array, copying the sub-array to a new array with a similar type.
"""

# ╔═╡ 0560136b-efea-4170-9ff2-2189c3c3b3c5
with_terminal() do 
	a = [1 2; 3 4]
	b = a[:, 2]
	@show b
	a[:, 2] = [4, 5] # modify a
	@show a
	@show b;
end

# ╔═╡ 6ffde0ed-1f48-4d66-9d8e-8ac35460c784
md"""
A **view** on the other hand does not copy the value
"""

# ╔═╡ 9321528c-0cd8-4282-be44-78ace834dbd4
with_terminal() do 
	a = [1 2; 3 4]
	@views b = a[:, 2]
	@show b
	a[:, 2] = [4, 5]
	@show a
	@show b;
end

# ╔═╡ 900d79a3-667c-4b3f-ac4f-5b84c9ca2aef
md"""
Note that the only difference is the `@views` macro, which will replace any slices with views in the expression.

An alternative is to call the `view` function directly – though it is generally discouraged since it is a step away from the math.
"""

# ╔═╡ 18babd08-399c-414f-96f1-0ac7fa932183
let
	@views b10 = a10[:, 2]
	view(a10, :, 2) == b10
end

# ╔═╡ ebae37a4-ca16-4417-9665-0b5dbaf1764b
md"""
As with most programming in Julia, it is best to avoid prematurely assuming that `@views` will have a significant impact on performance, and stress code clarity above all else.

Another important lesson about `@views` is that they **are not** normal, dense arrays.
"""

# ╔═╡ 8db79033-a1b1-436a-adf7-b8149ec97cfc
with_terminal() do 
	a = [1 2; 3 4]
	b_slice = a[:, 2]
	@show typeof(b_slice)
	@show typeof(a)
	@views b = a[:, 2]
	@show typeof(b);
end

# ╔═╡ 41e54658-490d-4b30-9a43-f28c2ecd0c10
md"""
The type of `b` is a good example of how types are not as they may seem.

Similarly
"""

# ╔═╡ 73b765ad-babc-4201-9344-9277b36eb140
let
	a = [1 2; 3 4]
	b = a'   # transpose
	typeof(b)
end

# ╔═╡ 6b3efc41-7600-4dae-999b-bd9bab388c24
md"""
To copy into a dense array
"""

# ╔═╡ 971e45ea-76de-4031-8827-0f6b751182d1
let
	a = [1 2; 3 4]
	b = a' # transpose
	c = Matrix(b)  # convert to matrix
	d = collect(b) # also `collect` works on any iterable
	c == d
end

# ╔═╡ a953f4dd-0e5f-4868-8d6b-ebea58bddb8f
md"""
### Special Matrices

As we saw with `transpose`, sometimes types that look like matrices are not stored as a dense array.

As an example, consider creating a diagonal matrix
"""

# ╔═╡ 748d9203-b904-4469-b056-d1acb63f8ed6
let
	d = [1.0, 2.0]
	a = Diagonal(d)
end

# ╔═╡ faf2888b-cdaa-4788-96b9-84b3c05fda98
md"""
As you can see, the type is `2×2 Diagonal{Float64,Array{Float64,1}}`, which is not a 2-dimensional array.

The reasons for this are both efficiency in storage, as well as efficiency in arithmetic and matrix operations.

In every important sense, matrix types such as `Diagonal` are just as much a “matrix” as the dense matrices we have using (see the [introduction to types lecture](https://julia.quantecon.org/introduction_to_types.html) for more)
"""

# ╔═╡ 52ce9df7-6c35-4b3c-877e-fe51473b4f80
with_terminal() do 
	@show 2a10
	b = rand(2,2)
	@show b * a10;
end

# ╔═╡ 34eae448-fb56-4db3-a97f-e7d243344cf7
md"""
Another example is in the construction of an identity matrix, where a naive implementation is
"""

# ╔═╡ 8500c54f-33c3-411b-baa5-f90d299689d8
let
	b = [1.0 2.0; 3.0 4.0]
	b - Diagonal([1.0, 1.0])  # poor style, inefficient code
end

# ╔═╡ ccae2fe9-3db3-4a42-924a-4f39da5e6a50
md"""
Whereas you should instead use
"""

# ╔═╡ 606c97aa-7585-4135-98d1-8080ce2dd6ba
let 
	b = [1.0 2.0; 3.0 4.0]
	b - I  # good style, and note the lack of dimensions of I
end

# ╔═╡ 63376e4c-57b3-42c1-b7c1-6d670484b60e
md"""
While the implementation of `I` is a little abstract to go into at this point, a hint is:
"""

# ╔═╡ 7165e4a0-5c89-4898-9d91-0cc1887eb348
typeof(I)

# ╔═╡ c15f9efd-b0e1-4cde-b86a-41c2632f28f7
md"""
This is a `UniformScaling` type rather than an identity matrix, making it much more powerful and general.
"""

# ╔═╡ 1c9616bf-bc77-4950-b80c-cb90d67b04b0
md"""
### Assignment and Passing Arrays

As discussed above, in Julia, the left hand side of an assignment is a “binding” or a label to a value.
"""

# ╔═╡ cc30cf67-776e-472c-ae04-e035464a71f8
let
	x = [1 2 3]
	y = x  # name `y` binds to whatever value `x` bound to
end

# ╔═╡ 4f184a8d-dff2-4102-b7b9-83862f70a26a
md"""
The consequence of this, is that you can re-bind that name.
"""

# ╔═╡ 9cdbcf37-42b2-4353-884c-e4b7f296c03d
with_terminal() do 
	x = [1 2 3]
	y = x        # name `y` binds to whatever `x` bound to
	z = [2 3 4]
	y = z        # only changes name binding, not value!
	@show (x, y, z);
end

# ╔═╡ 4c770d55-c567-4f05-9a27-492a16ac4ad7
md"""
What this means is that if `a` is an array and we set `b = a` then `a` and `b` point to exactly the same data.

In the above, suppose you had meant to change the value of `x` to the values of `y`, you need to assign the values rather than the name.
"""

# ╔═╡ a596e284-eaec-4e97-b2f9-fb3c10be1a2e
with_terminal() do 
	x = [1 2 3]
	y = x       # name `y` binds to whatever `x` bound to
	z = [2 3 4]
	y .= z      # now dispatches the assignment of each element
	@show (x, y, z);
end

# ╔═╡ 1f2417ee-3044-4969-88e8-c6053e6bd289
md"""
Alternatively, you could have used `y[:] = z`.

This applies to in-place functions as well.

First, define a simple function for a linear map
"""

# ╔═╡ 4a647b87-8ef8-4df4-8085-8b1f95ce6165
let
	function f(x)
		return [1 2; 3 4] * x  # matrix * column vector
	end
	val = [1, 2]
	f(val)
end

# ╔═╡ e8005950-153c-4971-ba06-6aa06eaa34ed
md"""
In general, these “out-of-place” functions are preferred to “in-place” functions, which modify the arguments.
"""

# ╔═╡ af23ad91-a088-4538-a688-5bd77ed3f136
with_terminal() do
	function f(x)
		return [1 2; 3 4] * x # matrix * column vector
	end

	val = [1, 2]

	@show y = similar(val)

	function f!(out, x)
		out .= [1 2; 3 4] * x
	end
	f!(y, val)
	@show y
end

# ╔═╡ 09fb8fb3-5768-4a16-9fa2-cb9e9e7c307e
md"""
This demonstrates a key convention in Julia: functions which modify any of the arguments have the name ending with `!` (e.g. `push!`).

We can also see a common mistake, where instead of modifying the arguments, the name binding is swapped
"""

# ╔═╡ 66cbb4f2-dbc9-4a11-acd8-2eebdea5b78b
with_terminal() do
	function f(x)
		return [1 2; 3 4] * x  # matrix * column vector
	end

	val = [1, 2]
	@show y = similar(val)

	function f!(out, x)
		out = [1 2; 3 4] * x   # MISTAKE! Should be .= or [:]
	end
	f!(y, val)
	@show y
end

# ╔═╡ a7e01d05-91a5-4a92-a98f-b1372d214d84
md"""
The frequency of making this mistake is one of the reasons to avoid in-place functions, unless proven to be necessary by benchmarking.
"""

# ╔═╡ 9fab1a41-d16a-427f-bfc6-fcfe2b127b43
md"""
### In-place and Immutable Types

Note that scalars are always immutable, such that
"""

# ╔═╡ 9a8d1ff7-7446-44f2-ab53-1278e089d167
y3 = [1 2]

# ╔═╡ 8fffc456-a354-46ce-a450-3e692b803db6
y3 .-= 2    # y .= y .- 2, no problem

# ╔═╡ 13e819b5-070d-4586-b9ac-614e17650b0a
x3 = 5

# ╔═╡ b0363b55-2408-4634-ae43-8fcd81b80189
# x3 .-= 2  # Fails!
# NOTE: the below doesn't work in Pluto, but does work in other Julia environments
# x3 = x3 - 2  # subtle difference - creates a new value and rebinds the variable 

# ╔═╡ 5eb0c1c5-485e-4fc9-b8d4-768cbba61346
md"""
In particular, there is no way to pass any immutable into a function and have it modified
"""

# ╔═╡ bba7b6e3-49a6-4e7e-bfd3-9c2f1c143998
with_terminal() do 
	@show x = 2

	function f(x)
		x = 3     # MISTAKE! does not modify x, creates a new value!
	end

	@show f(x)  # cannot modify immutables in place
	@show x
end

# ╔═╡ 0091bf90-8047-4ae4-8146-f0b88c9ab2c5
md"""
This is also true for other immutable types such as tuples, as well as some vector types
"""

# ╔═╡ 9f6c678b-888c-4fc3-9a0d-dcd54831d07a
xdynamic = [1, 2]

# ╔═╡ d94515f4-4608-4cef-8ab9-7f04ea8834df
xstatic = @SVector [1, 2]  # turns it into a highly optimized static vector

# ╔═╡ 87900d3a-13d4-4319-8549-21236a510030
with_terminal() do 
	f(x) = 2x
	@show f(xdynamic)
	@show f(xstatic)
end

# ╔═╡ 18cf26c8-4800-425e-8491-e80a005d9006
with_terminal() do 
	# inplace version
	function g(x)
		x .= 2x
		return "Success!"
	end
	@show xdynamic
	@show g(xdynamic)
	@show xdynamic
	# g(xstatic) # would fail, b/c static vectors are immutable
end

# ╔═╡ 3a693f58-a749-4439-b1dd-e8af43122846
md"""
## Operations on Arrays
"""

# ╔═╡ d9873739-11ad-437b-be41-099b604adfd3
md"""
### Array Methods

Julia provides standard functions for acting on arrays, some of which we’ve
already seen
"""

# ╔═╡ 1f35adad-5a6a-47e6-a6b9-b2d4ba18577c
a12 = [-1, 0, 1]

# ╔═╡ 25cf84f5-0ef6-4d49-839d-59bcb671ad00
with_terminal() do 
	@show length(a12)
	@show sum(a12)
	@show mean(a12)
	@show std(a12)      # standard deviation
	@show var(a12)      # variance
	@show maximum(a12)
	@show minimum(a12)
	@show extrema(a12)  # (mimimum(a), maximum(a))
end

# ╔═╡ 150b2154-0993-4461-b37a-8139407ddd0a
md"""
To sort an array
"""

# ╔═╡ 164b7baf-eca0-4a72-8078-f1a85927f25d
sort(a12, rev = true)  # returns new array, original not modified

# ╔═╡ c2e37372-53c5-454b-a239-2de3587c2b95
with_terminal() do
	b = sort!(a12, rev = true)  # returns *modified original* array
	@show b == a12  # tests if have the same values
	@show b === a12 # tests if arrays are identical (i.e share same memory address)
end

# ╔═╡ a56723a6-f868-4bf9-bcbb-57a3c9e30210
md"""
### Matrix Algebra

For two dimensional arrays, `*` means matrix multiplication
"""

# ╔═╡ 44f33143-f37f-45b9-9cd0-d0eb2f835d69
a13 = ones(1, 2)

# ╔═╡ ccba94af-0284-463d-b422-2f10b78eab4b
b13 = ones(2, 2)

# ╔═╡ 09fd3ef9-8368-45c2-a795-349210c2f26c
a13 * b13

# ╔═╡ a114cfef-4337-42ea-af81-82c1c374322f
b13 * a13'

# ╔═╡ c7c2b60b-6b02-4576-9994-741e73ad380c
md"""
To solve the linear system $ A X = B $ for $ X $ use `A \ B`
"""

# ╔═╡ d417449e-704c-4558-b7a2-7e82836422f8
A2 = [1 2; 2 3]

# ╔═╡ e1a110f3-1525-422e-b54d-db1e1f05cef9
B2 = ones(2, 2)

# ╔═╡ cf5c693a-fe06-4133-994a-3e35d3440581
A2 \ B2

# ╔═╡ 179ecb86-a27b-49f8-be98-da8f594318f3
inv(A2) * B2

# ╔═╡ b00ea21a-3605-4e06-91cc-6eb96fbf976a
md"""
Although the last two operations give the same result, the first one is numerically more stable and should be preferred in most cases.

Multiplying two **one** dimensional vectors gives an error – which is reasonable since the meaning is ambiguous.

More precisely, the error is that there isn’t an implementation of `*` for two one dimensional vectors.

The output explains this, and lists some other methods of `*` which Julia thinks are close to what we want.
"""

# ╔═╡ d1fdf622-2e2d-4dfb-8a70-5e94a6e50369
ones(2) * ones(2)  # does not conform, expect error

# ╔═╡ b896877a-11c7-4f7b-85e2-eee964651f40
md"""
Instead, you could take the transpose to form a row vector
"""

# ╔═╡ 996f68b0-6060-483e-95a2-796ff40754b9
ones(2)' * ones(2)

# ╔═╡ f041a926-2d31-4640-be23-27b46e0ca706
md"""
Alternatively, for inner product in this setting use `dot()` or the unicode `\cdot<TAB>`
"""

# ╔═╡ bec60f2c-51c2-4c92-a063-9f28d37a62a8
with_terminal() do 
	@show dot(ones(2), ones(2))
	@show ones(2) ⋅ ones(2);
end

# ╔═╡ 44ec67b7-1e16-4a50-a1a5-74aa0a2bf9e9
md"""
Matrix multiplication using one dimensional vectors similarly follows from treating them as
column vectors.  Post-multiplication requires a transpose
"""

# ╔═╡ a171844f-4935-4794-8881-c98dcef8c15d
b14 = ones(2, 2)

# ╔═╡ c8dad863-6fcf-4dd5-bc6d-6c8b817db65b
b14 * ones(2)

# ╔═╡ 87074f57-afcb-490d-aaf8-3c4634614e5c
ones(2)' * b14

# ╔═╡ 4edc8ef0-1d65-4710-b44d-46bff985aabc
md"""
Note that the type of the returned value in this case is not `Array{Float64,1}` but rather
`Adjoint{Float64,Array{Float64,1}}`.

This is since the left multiplication by a row vector should also be a row-vector.  It also hints
that the types in Julia more complicated than first appears in the surface notation, as we will explore
further in the [introduction to types lecture](https://julia.quantecon.org/introduction_to_types.html).
"""

# ╔═╡ d7990843-2e03-4aec-913b-b0a4a2a027b4
md"""
### Elementwise Operations
"""

# ╔═╡ e2056f08-2d3a-471e-a8f9-717dae7266fa
md"""
#### Algebraic Operations

Suppose that we wish to multiply every element of matrix `A` with the corresponding element of matrix `B`.

In that case we need to replace `*` (matrix multiplication) with `.*` (elementwise multiplication).

For example, compare
"""

# ╔═╡ cfbb2476-0bd4-485f-8758-26e235b6a632
ones(2, 2) * ones(2, 2)   # matrix multiplication

# ╔═╡ 3c4341a4-eb3f-4bce-ae16-102c69e69951
ones(2, 2) .* ones(2, 2)   # element by element multiplication

# ╔═╡ ff8b97c8-b026-4116-bd03-bcc538c18d33
md"""
This is a general principle: `.x` means apply operator `x` elementwise
"""

# ╔═╡ b32aa919-8933-423e-a074-2c555b002484
A3 = -ones(2, 2)

# ╔═╡ 038034cf-b099-4409-b189-1382692c9195
A3.^2  # square every element

# ╔═╡ 63211fb9-eb43-4255-a81f-333e9c0856f5
md"""
However in practice some operations are mathematically valid without broadcasting, and hence the `.` can be omitted.
"""

# ╔═╡ 07f722fe-2476-47d6-b98d-7ebcbcdbdb7c
ones(2, 2) + ones(2, 2)  # same as ones(2, 2) .+ ones(2, 2)

# ╔═╡ 8a6c0e12-e69a-47c0-8f26-e9e5d28a9064
md"""
Scalar multiplication is similar
"""

# ╔═╡ 6085e1bb-bb5e-445e-b9b3-e40fb123d5e9
A4 = ones(2, 2)

# ╔═╡ 85749deb-4147-4d76-b208-a95daf6ba6d6
2 * A4  # same as 2 .* A

# ╔═╡ 46d032c9-305b-4ed6-bf95-24db6866985a
md"""
In fact you can omit the `*` altogether and just write `2A`.

Unlike MATLAB and other languages, scalar addition requires the `.+` in order to correctly broadcast
"""

# ╔═╡ bb2fe3fe-152f-4beb-aa4b-6cd5b28bfc8c
let
	x = [1, 2]
	x .+ 1     # not x + 1
	x .- 1     # not x - 1
end

# ╔═╡ f06a66bf-b7ab-4351-9f5a-2505aa6da71f
md"""
#### Elementwise Comparisons

Elementwise comparisons also use the `.x` style notation
"""

# ╔═╡ e372e417-a9f5-46a6-bbbc-006b94bb9889
a01 = [10, 20, 30]

# ╔═╡ 578ac4f0-754c-4f3a-a8f7-e49e66fd3e55
b01 = [-100, 0, 100]

# ╔═╡ ea1ca1ec-9a04-42b9-94ae-dbce6178e268
b01 .> a01

# ╔═╡ 0497a6ce-2695-4e44-a985-1583ca840428
a01 .== b01

# ╔═╡ 0d23d78f-25ad-4247-aac4-b3880ec26ffc
md"""
We can also do comparisons against scalars with parallel syntax
"""

# ╔═╡ 2b941d8b-811e-4f15-ba21-9a807806d24b
b01

# ╔═╡ 0f69bbfb-f908-4f76-8067-dc8dd3c4fc43
b01 .> 1

# ╔═╡ 0e03fc22-57f2-45fe-b130-cce90c40ae7f
md"""
This is particularly useful for *conditional extraction* – extracting the elements of an array that satisfy a condition
"""

# ╔═╡ f89a277d-84b5-4493-9e2a-860e8bb3e2d6
a15 = randn(4)

# ╔═╡ c2e0839c-e4fd-45c1-ae91-fb9819b352ae
a15 .< 0

# ╔═╡ c6142c5f-9281-4723-924f-5a1aa3461f22
a15[a15 .< 0]

# ╔═╡ d3ea41b9-ca4c-4d74-9e8d-9a1d73fd1b2c
md"""
#### Changing Dimensions

The primary function for changing the dimensions of an array is `reshape()`
"""

# ╔═╡ 4404149a-2a30-4f13-9ea4-8224c77cad01
a16 = [10, 20, 30, 40]

# ╔═╡ 75cdfbb9-b329-458e-b02d-31718af65407
b16 = reshape(a16, 2, 2)

# ╔═╡ 9f3ed43e-4ebf-4639-8834-4ba2b89d55de
b16

# ╔═╡ e214783a-35f1-4333-9c7d-d73934a4d848
md"""
Notice that this function returns a view on the existing array.

This means that changing the data in the new array will modify the data in the
old one.
"""

# ╔═╡ 33677178-d9cf-4aed-89da-14610e87a1d4
b16[1, 1] = 100  # continuing the previous example

# ╔═╡ 6e30f561-081c-4169-8ef1-051dc60f612e
b16

# ╔═╡ 88a7bc7f-3553-44fd-9bcb-1c5430be6d2f
a16

# ╔═╡ 8375d553-4800-4b19-b706-9819d73c67f9
md"""
To collapse an array along one dimension you can use `dropdims()`
"""

# ╔═╡ 0c42dcd6-01a9-42de-b686-822238f40bcd
a17 = [1 2 3 4]  # two dimensional

# ╔═╡ a91a8738-6013-4e26-8735-380170d3caf9
dropdims(a17, dims = 1)

# ╔═╡ 711a016c-aa57-417a-9898-5d85257a366a
md"""
The return value is an array with the specified dimension “flattened”.
"""

# ╔═╡ 8ac2e669-9f84-47e5-be0b-0cba5171f195
md"""
### Broadcasting Functions

Julia provides standard mathematical functions such as `log`, `exp`, `sin`, etc.
"""

# ╔═╡ 6f162de2-9bd7-4bf5-96a0-dd923e5d4ca8
log(1.0)

# ╔═╡ 1a88d730-5de2-48ae-aa01-6c4812a37f50
md"""
By default, these functions act *elementwise* on arrays
"""

# ╔═╡ d4662fd7-fed4-4ea7-9d2e-9ed6e55aa1bd
log.(1:4)

# ╔═╡ 67a68038-f724-4c88-819d-c452c5e0a221
md"""
Note that we can get the same result as with a comprehension or more explicit loop
"""

# ╔═╡ 3ab463e6-e43d-41c8-a5ad-e95db8da1b9a
[ log(x) for x in 1:4 ]

# ╔═╡ f2202828-68fb-4451-b3ef-691e6f65fea2
md"""
Nonetheless the syntax is convenient.
"""

# ╔═╡ e2327ce6-593e-427f-bd1f-4f56f0a2259c
md"""
### Linear Algebra

([See linear algebra documentation](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/))

Julia provides some a great deal of additional functionality related to linear operations
"""

# ╔═╡ 6ca08594-de75-4ff5-b6c0-628bf9a8a2ad
A5 = [1 2; 3 4]

# ╔═╡ a6ad2c47-5f06-4587-9d0b-89607c23b6b4
det(A5)

# ╔═╡ 5a50afe8-0637-4467-a7fa-a0dea8319994
tr(A5)

# ╔═╡ 3e593290-a17e-4a67-8675-d74cf2649553
eigvals(A5)

# ╔═╡ 74856d23-b5dc-43ca-bb45-0c05cee6ffa1
rank(A5)

# ╔═╡ 3134bc12-dbeb-409f-a9e9-e31f7148bb6c
md"""
## Ranges

As with many other types, a `Range` can act as a vector.
"""

# ╔═╡ 3d11e9c1-7324-49f2-b690-d70cda65d4c4
with_terminal() do
	a = 10:12        # a range, equivalent to 10:1:12
	@show Vector(a)  # can convert, but shouldn't

	b = Diagonal([1.0, 2.0, 3.0])
	@show b * a .- [1.0; 2.0; 3.0]
end

# ╔═╡ 4a542b98-4ce8-4e14-b821-bc24bcfc7485
md"""
Ranges can also be created with floating point numbers using the same notation.
"""

# ╔═╡ 05adbddf-acbe-4e01-8b39-a8c46697d5de
0.0:0.1:1.0  # 0.0, 0.1, 0.2, ... 1.0

# ╔═╡ bcc36ee7-36e2-4fb5-8a74-6671499572d1
md"""
But care should be taken if the terminal node is not a multiple of the set sizes.
"""

# ╔═╡ 7bfded48-7697-41ba-ab51-3a2e9dd3d4c4
let
	maxval = 1.0
	minval = 0.0
	stepsize = 0.15
	a = minval:stepsize:maxval # 0.0, 0.15, 0.3, ...
	maximum(a) == maxval
end

# ╔═╡ a6613181-c2a3-4bf3-86a0-b85037586613
md"""
To evenly space points where the maximum value is important, i.e., `linspace` in other languages
"""

# ╔═╡ 4ac346ea-f37c-4881-a482-65acc67589d5
let
	maxval = 1.0
	minval = 0.0
	numpoints = 10
	a = range(minval, maxval, length=numpoints)
	# or range(minval, stop=maxval, length=numpoints)

	maximum(a) == maxval
end

# ╔═╡ 31e48682-b919-4ccf-b9f2-ed49c9e5d738
md"""
## Tuples and Named Tuples

([See tuples](https://docs.julialang.org/en/v1/manual/functions/#Tuples-1) and [named tuples documentation](https://docs.julialang.org/en/v1/manual/functions/#Named-Tuples-1))

We were introduced to tuples earlier, which provide high-performance immutable sets of distinct types.
"""

# ╔═╡ f3eb3ba5-3f51-4bc3-8051-54203a286f25
with_terminal() do
	t = (1.0, "test")
	t[1]            # access by index
	a, b = t        # unpack
	# t[1] = 3.0    # would fail as tuples are immutable
	println("a = $a and b = $b")
end

# ╔═╡ 0c6c78f0-4328-44db-9a5a-3cb9e517e585
md"""
As well as **named tuples**, which extend tuples with names for each argument.
"""

# ╔═╡ 220a6d12-e576-40b4-9f5e-660fe90260bc
with_terminal() do
	t = (val1 = 1.0, val2 = "test")
	t.val1      # access by index
	# a, b = t  # bad style, better to unpack by name with @unpack
	println("val1 = $(t.val1) and val1 = $(t.val1)") # access by name
end

# ╔═╡ 03e00ee9-65a7-43fe-8ef7-158c93437de1
md"""
While immutable, it is possible to manipulate tuples and generate new ones
"""

# ╔═╡ f49e63b4-f26c-4dd2-a1f7-813d59167d26
begin
	t = (val1 = 1.0, val2 = "test")
	t2 = (val3 = 4, val4 = "test!!")
	t3 = merge(t, t2)  # new tuple
end

# ╔═╡ 54983b4f-b805-4daa-97bb-d72cbf161740
md"""
Named tuples are a convenient and high-performance way to manage and unpack sets of parameters
"""

# ╔═╡ 3018e66e-79e0-42ad-a452-d0ac6d893309
let
	function f(parameters)
		α, β = parameters.α, parameters.β  # poor style, error prone if adding parameters
		return α + β
	end

	parameters = (α = 0.1, β = 0.2)
	f(parameters)
end

# ╔═╡ 550319e4-02a7-4012-8826-5b752f03a2f5
md"""
This functionality is aided by the `Parameters.jl` package and the `@unpack` macro
"""

# ╔═╡ 6fec6537-f523-43c0-81f3-b788548d138f
let
	function f(parameters)
		@unpack α, β = parameters  # good style, less sensitive to errors
		return α + β
	end

	parameters = (α = 0.1, β = 0.2)
	f(parameters)
end

# ╔═╡ e71aa285-63c5-4fe8-b8a9-f363d738948b
md"""
In order to manage default values, use the `@with_kw` macro
"""

# ╔═╡ c4e890b0-ac7a-452a-9aaf-443b033e0d4d
with_terminal() do
	paramgen = @with_kw (α = 0.1, β = 0.2)  # create named tuples with defaults

	# creates named tuples, replacing defaults
	@show paramgen()  # calling without arguments gives all defaults
	@show paramgen(α = 0.2)
	@show paramgen(α = 0.2, β = 0.5);
end

# ╔═╡ 7af141de-7816-47e4-92e5-7d8c681ce39c
md"""
An alternative approach, defining a new type using `struct` tends to be more prone to accidental misuse, and leads to a great deal of boilerplate code.

For that, and other reasons of generality, we will use named tuples for collections of parameters where possible.
"""

# ╔═╡ 9204e290-2f5c-42b1-9011-b42fc7acb1ed
md"""
## Nothing, Missing, and Unions

Sometimes a variable, return type from a function, or value in an array needs to represent the absence of a value rather than a particular value.

There are two distinct use cases for this

1. `nothing` (“software engineers null”): used where no value makes sense in a particular context due to a failure in the code, a function parameter not passed in, etc.  
1. `missing` (“data scientists null”): used when a value would make conceptual sense, but it isn’t available.  



<a id='error-handling'></a>
"""

# ╔═╡ d4e4e4c7-f4db-4491-88dd-e891fac786e9
md"""
### Nothing and Basic Error Handling

The value `nothing` is a single value of type `Nothing`
"""

# ╔═╡ 71ebc134-8313-42a1-9084-ab2ecd7bed34
typeof(nothing)

# ╔═╡ 753b74fc-54cb-4c0d-bd57-694e5b234eb7
md"""
An example of a reasonable use of `nothing` is if you need to have a variable defined in an outer scope, which may or may not be set in an inner one
"""

# ╔═╡ 290d9edb-e3bd-4d9a-91dc-f05a7e972e01
with_terminal() do 
	function f(y)
		x = nothing
		if y > 0.0
			# calculations to set `x`
			x = y
		end

		# later, can check `x`
		if isnothing(x)
			println("x was not set")
		else
			println("x = $x")
		end
		x
	end

	@show f(1.0)
	@show f(-1.0)
end

# ╔═╡ b6a4f8b8-d8dd-47a5-8947-7b96ea0beb9a
md"""
While in general you want to keep a variable name bound to a single type in Julia, this is a notable exception.

Similarly, if needed, you can return a `nothing` from a function to indicate that it did not calculate as expected.
"""

# ╔═╡ fcbf48e7-3340-4030-bf2f-1862fb74dceb
with_terminal() do 
	function f(x)
		if x > 0.0
			return sqrt(x)
		else
			return nothing
		end
	end
	x1 = 1.0
	x2 = -1.0
	y1 = f(x1)
	y2 = f(x2)

	# check results with isnothing
	if isnothing(y1)
		println("f($x2) successful")
	else
		println("f($x2) failed");
	end
end

# ╔═╡ 0aac7270-20bc-418d-bb95-3c67e6bfacfa
md"""
As an aside, an equivalent way to write the above function is to use the
[ternary operator](https://docs.julialang.org/en/v1/manual/control-flow/index.html#man-conditional-evaluation-1),
which gives a compact if/then/else structure
"""

# ╔═╡ 8c7ac1c9-0a36-4bbb-a05f-f9de73c40605
begin
	f_nothing(x) = x > 0.0 ? sqrt(x) : nothing  # the "a ? b : c" pattern is the ternary

	f_nothing(1.0)
end

# ╔═╡ 4845a678-3cc9-4414-baa1-70f0f1aee5fe
md"""
We will sometimes use this form when it makes the code more clear (and it will occasionally make the code higher performance).

Regardless of how `f(x)` is written,  the return type is an example of a union, where the result could be one of an explicit set of types.

In this particular case, the compiler would deduce that the type would be a `Union{Nothing,Float64}` – that is, it returns either a floating point or a `nothing`.

You will see this type directly if you use an array containing both types
"""

# ╔═╡ 46a299b4-e632-4b8e-af65-44339237cd05
typeof([1.0, nothing])

# ╔═╡ c268f611-3e5e-4a5d-85e7-bb934a9f3ecd
md"""
When considering error handling, whether you want a function to return `nothing` or simply fail depends on whether the code calling `f(x)` is carefully checking the results.

For example, if you were calling on an array of parameters where a priori you were not sure which ones will succeed, then
"""

# ╔═╡ 3dd97415-c331-498f-bd3c-145d27ef6e71
let
	x = [0.1, -1.0, 2.0, -2.0]
	y = f_nothing.(x)
end

# ╔═╡ 29765ded-f03b-4d86-bc00-f1bbeb3fa269
md"""
On the other hand, if the parameter passed is invalid and you would prefer not to handle a graceful failure, then using an assertion is more appropriate.
"""

# ╔═╡ bcb229da-0118-4b1d-b0c2-6c4b2873a4ec
let 
	function f(x)
		@assert x > 0.0
		sqrt(x)
	end

	f(1.0)
end

# ╔═╡ 0045fd83-2974-4242-8c6e-1e40c4e5c3e7
md"""
Finally, `nothing` is a good way to indicate an optional parameter in a function
"""

# ╔═╡ 54f743ed-1b01-47e4-9c97-276cc3a3b424
with_terminal() do
	function f(x; z = nothing)

		if isnothing(z)
			println("No z given with $x")
		else
			println("z = $z given with $x")
		end
	end

	f(1.0)
	f(1.0, z=3.0)
end

# ╔═╡ eaaf8f09-19c7-416c-a493-b12c2e7f6bb7
md"""
An alternative to `nothing`, which can be useful and sometimes higher performance,
is to use `NaN` to signal that a value is invalid returning from a function.
"""

# ╔═╡ bebca508-437e-4c0d-b4fb-fdbf402da652
with_terminal() do
	function f(x)
		if x > 0.0
			return x
		else
			return NaN
		end
	end

	f(0.1)
	f(-1.0)

	@show typeof(f(-1.0))
	@show f(-1.0) == NaN  # note, this fails!
	@show isnan(f(-1.0))  # check with this
end

# ╔═╡ 4f9ddb83-a4a7-4c3f-afa5-1858ce64deed
md"""
Note that in this case, the return type is `Float64` regardless of the input for `Float64` input.

Keep in mind, though, that this only works if the return type of a function is `Float64`.
"""

# ╔═╡ ce9968a9-be63-42f6-ba35-28298d7761df
md"""
### Exceptions

(See [exceptions documentation](https://docs.julialang.org/en/v1/manual/control-flow/index.html#Exception-Handling-1))

While returning a `nothing` can be a good way to deal with functions which may or may not return values, a more robust error handling method is to use exceptions.

Unless you are writing a package, you will rarely want to define and throw your own exceptions, but will need to deal with them from other libraries.

The key distinction for when to use an exceptions vs. return a `nothing` is whether an error is unexpected rather than a normal path of execution.

An example of an exception is a `DomainError`, which signifies that a value passed to a function is invalid.
"""

# ╔═╡ 5e764ca4-943a-48bc-94a3-326dbecfde07
# throws exception, turned off to prevent breaking notebook
# sqrt(-1.0)

# to see the error
try sqrt(-1.0); catch err; err end  # catches the exception and prints it

# ╔═╡ 08710444-56bc-418f-99c1-15009fdc21fe
md"""
Another example you will see is when the compiler cannot convert between types.
"""

# ╔═╡ b0f1d29e-41c8-4ea1-8109-cab78a6b04f2
# throws exception, turned off to prevent breaking notebook
# convert(Int64, 3.12)

# to see the error
try convert(Int64, 3.12); catch err; err end  # catches the exception and prints it.

# ╔═╡ 3732abd0-ffc3-4d2c-9975-53cc6e53c1e7
md"""
If these exceptions are generated from unexpected cases in your code, it may be appropriate simply let them occur and ensure you can read the error.

Occasionally you will want to catch these errors and try to recover, as we did above in the `try` block.
"""

# ╔═╡ 44737f50-ee32-4732-95ae-ad735bed6571
let
	function f(x)
		try
			sqrt(x)
		catch err                # enters if exception thrown
			sqrt(complex(x, 0))  # convert to complex number
		end
	end

	f(0.0)
	f(-1.0)
end

# ╔═╡ a6ff7f30-39ec-419b-b432-eedb8245d129
md"""
### Missing

(see [“missing” documentation](https://docs.julialang.org/en/v1/manual/missing/))

The value `missing` of type `Missing` is used to represent missing value in a statistical sense.

For example, if you loaded data from a panel, and gaps existed
"""

# ╔═╡ 03cc1ac6-d38a-4a0d-b61b-5ffcadce419b
x = [3.0, missing, 5.0, missing, missing]

# ╔═╡ 931d6534-b085-40e8-b5da-6aa1de9fbdfe
md"""
A key feature of `missing` is that it propagates through other function calls - unlike `nothing`
"""

# ╔═╡ d65410a6-a94f-4641-9c7d-e4c61a3a6b5b
with_terminal() do 
	f(x) = x^2

	@show missing + 1.0
	@show missing * 2
	@show missing * "test"
	@show f(missing);      # even user-defined functions
	@show mean(x);
end

# ╔═╡ 9434d50a-5345-45f2-a47b-f6c31830f583
md"""
The purpose of this is to ensure that failures do not silently fail and provide meaningless numerical results.

This even applies for the comparison of values, which
"""

# ╔═╡ c8b3b951-14cc-4dcd-99d9-1612d9d305b1
with_terminal() do 
	x = missing

	@show x == missing
	@show x === missing  # an exception
	@show ismissing(x);
end

# ╔═╡ 96a1079d-e2b1-4dce-8f93-ddb249f21d39
md"""
Where `ismissing` is the canonical way to test the value.

In the case where you would like to calculate a value without the missing values, you can use `skipmissing`.
"""

# ╔═╡ 7ce9a521-f271-4630-bb0d-afb86feba973
with_terminal() do 
	x = [1.0, missing, 2.0, missing, missing, 5.0]

	@show mean(x)
	@show mean(skipmissing(x))
	@show coalesce.(x, 0.0);  # replace missing with 0.0;
end

# ╔═╡ 04b6a8db-3825-4a91-a52f-dbebad4eef6f
md"""
As `missing` is similar to R’s `NA` type, we will see more of `missing` when we cover `DataFrames`.
"""

# ╔═╡ b2521cb3-043e-4910-ae64-5ffad70ad939
md"""
## Exercises
"""

# ╔═╡ 1110f3b6-1531-489e-9946-a08007062c79
md"""
### Exercise 1

This exercise uses matrix operations that arise in certain problems,
including when dealing with linear stochastic difference equations.

If you aren’t familiar with all the terminology don’t be concerned – you can
skim read the background discussion and focus purely on the matrix exercise.

With that said, consider the stochastic difference equation


$$X_{t+1} = A X_t + b + \Sigma W_{t+1} \tag{1}$$

Here

 $X_t$, $b$ and $X_{t+1}$ are $n \times 1$  

 $A$ is $n \times n$  

 $\Sigma$ is $n \times k$  

 $W_t$ is $k \times 1$ and $\{W_t\}$ is iid with zero mean and variance-covariance matrix equal to the identity matrix  


Let $S_t$ denote the $n \times n$ variance-covariance matrix of $X_t$.

Using the rules for computing variances in matrix expressions, it can be shown from (1) that $ \{S_t\} $ obeys



$$S_{t+1} = A S_t A' + \Sigma \Sigma' \tag{2}$$

It can be shown that, provided all eigenvalues of $A$ lie within the unit circle, the sequence $\{S_t\}$ converges to a unique limit $S$.

This is the **unconditional variance** or **asymptotic variance** of the stochastic difference equation.

As an exercise, try writing a simple function that solves for the limit $S$ by iterating on (2) given $A$ and $\Sigma$.

To test your solution, observe that the limit $S$ is a solution to the matrix equation



$$S = A S A' + Q \quad \text{where} \quad Q := \Sigma \Sigma' \tag{3}$$

This kind of equation is known as a **discrete time Lyapunov equation**.

The [QuantEcon package](http://quantecon.org/quantecon-jl)
provides a function called `solve_discrete_lyapunov` that implements a fast
“doubling” algorithm to solve this equation.

Test your iterative method against `solve_discrete_lyapunov` using matrices

$$A =
\begin{bmatrix}
    0.8 & -0.2  \\
    -0.1 & 0.7
\end{bmatrix}
\qquad
\Sigma =
\begin{bmatrix}
    0.5 & 0.4 \\
    0.4 & 0.6
\end{bmatrix}$$
"""

# ╔═╡ 45e84aa2-4001-43e6-a919-8b8d1e1379c8
function compute_asymptotic_var(A, Σ;
                                S0 = Σ * Σ',
                                tolerance = 1e-6,
                                maxiter = 500)
    V = Σ * Σ'
    S = S0
    err = tolerance + 1
    i = 1
    while err > tolerance && i ≤ maxiter
        next_S = A * S * A' + V
        err = norm(S - next_S)
        S = next_S
        i += 1
    end
    return S
end

# ╔═╡ 3a24c418-7aac-4d61-92fa-62ffdda7c195
A = [0.8  -0.2;
     -0.1  0.7]

# ╔═╡ 71afbeab-500a-445d-b77e-aebf263eaef5
Σ = [0.5 0.4;
     0.4 0.6]

# ╔═╡ 5050e645-8abd-45d6-9cee-565df4429cd4
maximum(abs, eigvals(A))

# ╔═╡ 1e7f30b8-7fa8-457f-adfe-9606f0cdfc5f
our_solution = compute_asymptotic_var(A, Σ)

# ╔═╡ 1ce3a3a7-c7a2-4a7a-87a8-19d96f6b3e08
norm(our_solution - solve_discrete_lyapunov(A, Σ * Σ'))

# ╔═╡ f33342a2-052d-4463-8d24-bb6921d16b4e
md"""
### Exercise 2

Take a stochastic process for $\{y_t\}_{t=0}^T$

$$y_{t+1} = \gamma + \theta y_t + \sigma w_{t+1}$$

where

 $w_{t+1}$ is distributed `Normal(0,1)`  
 $\gamma=1, \sigma=1, y_0 = 0$  
 $\theta \in \Theta \equiv \{0.8, 0.9, 0.98\}$  


Given these parameters

- Simulate a single $y_t$ series for each $\theta \in \Theta$
  for $T = 150$.  Feel free to experiment with different $T$.  
- Overlay plots of the rolling mean of the process for each $\theta \in \Theta$,
  i.e. for each $1 \leq \tau \leq T$ plot  


$$\frac{1}{\tau}\sum_{t=1}^{\tau}y_T$$

- Simulate $ N=200 $ paths of the stochastic process above to the $T$,
  for each $ \theta \in \Theta $, where we refer to an element of a particular
  simulation as $ y^n_t $.  
- Overlay plots a histogram of the stationary distribution of the final
  $y^n_T$ for each $ \theta \in \Theta $.  Hint: pass `alpha`
  to a plot to make it transparent (e.g. `histogram(vals, alpha = 0.5)`) or
  use `stephist(vals)` to show just the step function for the histogram.  
- Numerically find the mean and variance of this as an ensemble average, i.e.
  $\sum_{n=1}^N\frac{y^n_T}{N}$ and
  $\sum_{n=1}^N\frac{(y_T^n)^2}{N} -\left(\sum_{n=1}^N\frac{y^n_T}{N}\right)^2$.  


In [another lecture](https://julia.quantecon.org/../tools_and_techniques/lln_clt.html) these are interpreted.
"""

# ╔═╡ 7b39423b-c456-44d6-a51f-9a34c3c49158
md"""
### Exercise 2 Answer
"""

# ╔═╡ e2e77b7a-e4ba-4032-adc5-cd7cd554cd5f
function simulate_y(gamma, sigma, theta, T)
	y = zeros(T)
	for t in 1:(T-1)
		y[t+1] = gamma + theta * y[t] + sigma * randn()
	end
	y
end

# ╔═╡ 50693824-d0c6-4fa1-9861-521835c60717
cumsum([1, 2, 3])

# ╔═╡ ee7e5b48-8237-4b2f-b513-2bc6019ec352
function simulate_y(gamma, sigma, theata, T, N)
	hcat([simulate_y(gamma, sigma, theta, T) for _ in 1:N]...)
end

# ╔═╡ 9eaefbbe-8c84-4bab-ae13-3389aa3afa99
cummean(x) = cumsum(x) ./ (1:length(x))

# ╔═╡ e3714d0c-e856-4fba-8b9e-1457df417107
begin
	gamma = 1
	sigma = 1
	thetas = [0.8, 0.9, 0.98]
	T = 150
end

# ╔═╡ 4562c1c9-6ed8-4f33-b6ff-18385fd25b49
let
	Ys = simulate_y.(gamma, sigma, thetas, T)
	y1, y2, y3 = cummean.(Ys)
	plot([y1 y2 y3], label = ["theta = $th" for th in thetas], legend = :topleft)
end

# ╔═╡ 866bb509-7047-4f68-9a8c-8dea8e3f2be6
let
	N = 200
	P = plot()
	means =[]
	vars = []
	for theta in thetas
		YN = simulate_y(gamma, sigma, theta, T, N)
		
		yT = YN[end, :]
		histogram!(p, yT, alpha = 0.5, label = "theta = $theta")
		push!(means, mean(yT))
		push!(vars, var(yT))
	end
	P, means, vars
end

# ╔═╡ 80ea79ba-f18f-41f9-832c-d4654ed4839e
md"""
### Exercise 3

Let the data generating process for a variable be

$$y = a x_1 + b x_1^2 + c x_2 + d + \sigma w$$

where $y, x_1, x_2$ are scalar observables, $a,b,c,d$ are parameters to estimate, and $w$ are iid normal with mean 0 and variance 1.

First, let’s simulate data we can use to estimate the parameters

- Draw $N=50$ values for $x_1, x_2$ from iid normal distributions.  


Then, simulate with different $w$
* Draw a $w$ vector for the `N` values and then `y` from this simulated data if the parameters were $a = 0.1, b = 0.2 c = 0.5, d = 1.0, \sigma = 0.1$.
* Repeat that so you have `M = 20` different simulations of the `y` for the `N` values.

Finally, calculate order least squares manually (i.e., put the observables
into matrices and vectors, and directly use the equations for
[OLS](https://en.wikipedia.org/wiki/Ordinary_least_squares) rather than a package).

- For each of the `M=20` simulations, calculate the OLS estimates for $a, b, c, d, \sigma$.  
- Plot a histogram of these estimates for each variable.  
"""

# ╔═╡ 9c8f7403-6245-4033-b692-093531c3d37f
md"""
### Exercise 3 Answer
"""

# ╔═╡ f631d2b1-552f-48f5-b6bd-ebf8d3420ed2
@. [1, 2, 3] + 4.0 + 2 + 1 + 3 + 6

# ╔═╡ 200a2ea5-70e5-43be-a46a-652e0bad4e5a
let
	N = 50
	M = 20
	x1 = randn(N)
	x2 = randn(N)
	X = [x1 x1^2 x2 ones(N)] 
	
	a = 0.1
	b = 0.2
	c = 0.5
	d = 1.0
	sigma = 0.1
	
	for m in 1:M
		w = randn(N)
		y = @.a * x1 + b * x1^2 + c + x2 + d + sigma*w
		beta = inv(X'X)*X'y
		residuals = y - X*beta
		sigma = sqrt((residuals'residuals) / N)
		
		params[:, m] = beta
		sigmas[m] = sigma
	end
	histogram(
		[params' sigmas],
		alpha=0.5,
		label = ["a", "b", "c", "d", "omega"]
	)
end

# ╔═╡ b6c46c5a-2882-44d0-ad5e-ee9c9f79b8e9
md"""
# Dependencies
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuantEcon = "fcd29c91-0bd7-5a09-975d-7ac3f643a60c"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
Parameters = "~0.12.2"
Plots = "~1.21.3"
PlutoUI = "~0.7.9"
QuantEcon = "~0.16.2"
StaticArrays = "~1.2.12"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[ArrayInterface]]
deps = ["IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "85d03b60274807181bae7549bb22b2204b6e5a0e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.30"

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

[[CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

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

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

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

[[DSP]]
deps = ["FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "2a63cb5fc0e8c1f0f139475ef94228c7441dc7d0"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.6.10"

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

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "3ed8fa7178a10d1cd0f1ca524f249ba6937490c0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "3676697fd903ba314aaaa0ec8d6813b354edb875"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.23.11"

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

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

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

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "f985af3b9f4e278b1d24434cbb546d6092fca661"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.3"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3676abafff7e4ff07bbd2c42b3d8201f31653dcc"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.9+8"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "502b3de6039d5b78c76118423858d981349f3823"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.9.7"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "8b3c09b56acaf3c0e581c66638b85c8650ee9dca"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.8.1"

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

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "b5e930ac60b613ef3406da6d4f42c35d8dc51419"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.19"

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

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[IfElse]]
git-tree-sha1 = "28e837ff3e7a6c3cdb252ce49fb412c8eb3caeef"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

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

[[JSONSchema]]
deps = ["HTTP", "JSON", "ZipFile"]
git-tree-sha1 = "b84ab8139afde82c7c65ba2b792fe12e01dd7307"
uuid = "7d188eb4-7ad8-530c-ae41-71a32a6d4692"
version = "0.3.3"

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

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[LightGraphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "432428df5f360964040ed60418dd5601ecd240b6"
uuid = "093fc24a-ae57-5d10-9952-331d41423f4d"
version = "1.3.5"

[[LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

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

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "c253236b0ed414624b083e6b72bfe891fbd2c7af"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+1"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "JSON", "JSONSchema", "LinearAlgebra", "MutableArithmetics", "OrderedCollections", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "575644e3c05b258250bb599e57cf73bbf1062901"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.9.22"

[[MathProgBase]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9abbe463a1e9fc507f12a69e7f29346c2cdc472c"
uuid = "fdba3010-5040-5b88-9595-932c9decdf73"
version = "0.7.8"

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

[[Mocking]]
deps = ["ExprTools"]
git-tree-sha1 = "748f6e1e4de814b101911e64cc12d83a6af66782"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.2"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "3927848ccebcc165952dc0d9ac9aa274a87bfe01"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.20"

[[NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "144bab5b1443545bc4e791536c9f1eacb4eed06a"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.1"

[[NLopt]]
deps = ["MathOptInterface", "MathProgBase", "NLopt_jll"]
git-tree-sha1 = "d80cb3327d1aeef0f59eacf225e000f86e4eee0a"
uuid = "76087f3c-5699-56af-9a33-bf431cd00edd"
version = "0.6.3"

[[NLopt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "2b597c46900f5f811bec31f0dcc88b45744a2a09"
uuid = "079eb43e-fd8e-5478-9966-2cf3e3edb778"
version = "2.7.0+0"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "c870a0d713b51e4b49be6432eff0e26a4325afee"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.6"

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

[[Optim]]
deps = ["Compat", "FillArrays", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7863df65dbb2a0fa8f85fcaf0a41167640d2ebed"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.4.1"

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
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse", "Test"]
git-tree-sha1 = "95a4038d1011dfdbde7cecd2ad0ac411e53ab1bc"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.10.1"

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

[[Polynomials]]
deps = ["Intervals", "LinearAlgebra", "OffsetArrays", "RecipesBase"]
git-tree-sha1 = "0b15f3597b01eb76764dd03c3c23d6679a3c32c8"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "1.2.1"

[[PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Primes]]
git-tree-sha1 = "afccf037da52fa596223e5a0e331ff752e0e845c"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.0"

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

[[QuantEcon]]
deps = ["DSP", "DataStructures", "Distributions", "FFTW", "LightGraphs", "LinearAlgebra", "Markdown", "NLopt", "Optim", "Pkg", "Primes", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "Test"]
git-tree-sha1 = "4e2dc3044303aa2cbf6e321cb9af3982f6774e6a"
uuid = "fcd29c91-0bd7-5a09-975d-7ac3f643a60c"
version = "0.16.2"

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

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

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
deps = ["OpenSpecFun_jll"]
git-tree-sha1 = "d8d8b8a9f4119829410ecd706da4cc8594a1e020"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "0.10.3"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "854b024a4a81b05c0792a4b45293b85db228bd27"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.3.1"

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

[[TimeZones]]
deps = ["Dates", "Future", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "6c9040665b2da00d30143261aea22c7427aada1c"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.5.7"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

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

[[ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "c3a5637e27e914a7a445b8d0ad063d701931e9f7"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.9.3"

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
# ╟─ab596346-2555-4bbc-9231-7ea42580228c
# ╟─5e4d7378-e805-4289-89ce-db24a55c7f49
# ╟─049a70fa-15c2-468f-9c5a-b9155b48cccd
# ╟─f8977562-fe6d-422d-9cc8-e92a977931bc
# ╟─f3617c37-52fd-42d5-a698-af7a5df7e3de
# ╠═d7cb8d55-f078-4478-a9a4-767dd4869f78
# ╟─983822de-a698-4764-90b6-9e3d4b97f5fc
# ╟─740f7d48-3cbf-4a6a-bc0d-568ea146f267
# ╠═5f2e9f9e-907e-430d-b12e-0a64c75f2ff5
# ╠═da981af6-69f2-4f96-9142-ca73468fd3d3
# ╟─b5eac13c-a5cb-40c0-84fe-606351fb48cc
# ╠═cb31edb9-205e-4449-a1cd-d3533f85cf92
# ╟─6c25642f-dba9-4a49-87bf-02712fb2ecba
# ╠═974f966b-dd0b-497b-9501-d6e3037bf2a7
# ╠═80f9a279-0090-471f-bb9a-62288951fade
# ╟─44060480-fe15-4e1f-bfa9-a0de092df763
# ╟─3636b9a7-e453-466c-a37a-23ecdbb367b6
# ╠═de418799-a0d0-4502-bff2-9e575f644ac8
# ╠═e234bb39-47b0-42f2-b9bc-807ea395f2f3
# ╟─866b5359-0185-42d1-b4e9-daa5fea450a4
# ╠═31369706-d000-489e-b75a-7f720c1af200
# ╠═cd8f8831-43c1-4a0d-ac1b-4b913b59452b
# ╟─fb87c8f4-ae3b-4de5-814d-0ae6a0347397
# ╟─d321fd7e-5499-4334-885f-67f90739a10a
# ╟─fbb10f03-a964-49bf-bc80-9065020946a5
# ╠═35c7edab-ddcc-4534-9082-544e75d9da38
# ╟─cc217a0a-0759-4238-94d8-dcbdf571bcaf
# ╠═dd4470b0-8dee-4c4d-b761-6c63a70ed773
# ╟─e01650bc-8252-4fad-bf69-60bbc224fa12
# ╠═e6369b12-9baf-41ff-b922-8d36bbaf5fe9
# ╟─eee21783-8385-4fab-bd7d-aba4e1c324aa
# ╠═fb9eec26-6cb0-4be7-8ed8-964ed0f587a2
# ╟─a2355b0e-cffc-4eeb-9d06-4dad4eebf2e0
# ╠═42414ad7-7cf0-4b13-a9d5-a8c6d6636e09
# ╟─b6be34ae-522d-482c-a125-4db7a3013bdc
# ╠═04a285b4-c13c-4a41-9071-f6a10bc24f45
# ╟─0b11f111-7e4d-4af0-b752-0482b1ff8824
# ╠═6af8fd10-52af-4260-924c-368490b65170
# ╟─bc449bc9-ee14-4ac9-9a41-2c16ef6af0b4
# ╠═815f37e8-2c87-4f2d-933d-678a5dfdf427
# ╟─7d87ee6e-649d-4a8a-a71b-61639de32f77
# ╠═32979952-c3c5-42ec-a23f-9db1ec7f653e
# ╟─5858fb41-cada-4f49-82ed-104ede4e8407
# ╠═a2c38114-56d0-49e1-ac0e-933a68bb2feb
# ╟─b117c684-ce1b-41e2-97f4-cd8269f2979e
# ╠═75369fb4-7c54-4977-a8a4-79759d172f62
# ╟─84bfc209-05fe-4dd6-991d-b0afaa538af1
# ╠═3b125fea-6290-42ff-8157-ad85a950c3ec
# ╟─9706afbc-0dd7-4ea7-a2aa-6f79f10d71fb
# ╠═b33bba6a-5805-4565-a510-1d1f1df55390
# ╠═4818cd7a-e394-4ad3-93a3-a0e860127fa6
# ╠═52998b3b-76e5-4685-9328-eb38df1f3bb5
# ╟─7613ccb9-6a06-42fc-977b-eba7ceb91b5b
# ╠═967cf427-b287-4bb5-8f00-3a92b8792784
# ╠═d36facd9-3d04-471f-aefb-1c9407ce484f
# ╟─75c81a60-d935-4dfb-9cc1-bfeffeecd440
# ╠═6ba7122e-9e31-4eed-88e4-45bcb4395066
# ╠═a557bfda-adf7-4b32-9295-2c5d4d2b924b
# ╟─db08bce4-4377-4446-899a-8ece08b78018
# ╠═d62ac4ec-dd62-4325-860f-f0427d0d1b85
# ╠═4a5277dd-4cc4-4c1d-8f4d-44db2644c2c7
# ╟─82ea62ce-1ed0-46e5-a49e-ef9c5d498fb4
# ╠═7ac8a2aa-2507-402f-8911-f050df4dc316
# ╠═a26a295e-1535-4a0d-b657-f370cc74a3ce
# ╠═dd414e29-660f-4846-9ba4-b827ee1ef364
# ╠═d79caf27-2c34-45b8-bc86-cbab1f0886f2
# ╟─33e566cc-617e-4868-a9d8-ca4763f5ff35
# ╠═d92ebcb4-e6ca-4e30-b03e-88776ec642d2
# ╠═49bd2cae-71a5-4b19-ae29-0f3ef4dddd76
# ╠═5f2ea0a1-031d-4d04-9c73-cfdaad5ad521
# ╟─e3a7bd52-1ccb-45f3-9405-aacf0d7545da
# ╠═d7750a33-6c9f-40b3-8f03-5585fafdcb60
# ╠═b1fb6c81-3d17-420a-b66a-ae613c21be32
# ╠═c829f6b7-e14c-4f5d-957d-87bbea42d176
# ╟─a75206c1-db79-4d5c-aac6-3b5d0c9fd634
# ╠═0560136b-efea-4170-9ff2-2189c3c3b3c5
# ╟─6ffde0ed-1f48-4d66-9d8e-8ac35460c784
# ╠═9321528c-0cd8-4282-be44-78ace834dbd4
# ╟─900d79a3-667c-4b3f-ac4f-5b84c9ca2aef
# ╠═18babd08-399c-414f-96f1-0ac7fa932183
# ╟─ebae37a4-ca16-4417-9665-0b5dbaf1764b
# ╠═8db79033-a1b1-436a-adf7-b8149ec97cfc
# ╟─41e54658-490d-4b30-9a43-f28c2ecd0c10
# ╠═73b765ad-babc-4201-9344-9277b36eb140
# ╟─6b3efc41-7600-4dae-999b-bd9bab388c24
# ╠═971e45ea-76de-4031-8827-0f6b751182d1
# ╟─a953f4dd-0e5f-4868-8d6b-ebea58bddb8f
# ╠═748d9203-b904-4469-b056-d1acb63f8ed6
# ╟─faf2888b-cdaa-4788-96b9-84b3c05fda98
# ╠═52ce9df7-6c35-4b3c-877e-fe51473b4f80
# ╟─34eae448-fb56-4db3-a97f-e7d243344cf7
# ╠═8500c54f-33c3-411b-baa5-f90d299689d8
# ╟─ccae2fe9-3db3-4a42-924a-4f39da5e6a50
# ╠═606c97aa-7585-4135-98d1-8080ce2dd6ba
# ╟─63376e4c-57b3-42c1-b7c1-6d670484b60e
# ╠═7165e4a0-5c89-4898-9d91-0cc1887eb348
# ╟─c15f9efd-b0e1-4cde-b86a-41c2632f28f7
# ╟─1c9616bf-bc77-4950-b80c-cb90d67b04b0
# ╠═cc30cf67-776e-472c-ae04-e035464a71f8
# ╟─4f184a8d-dff2-4102-b7b9-83862f70a26a
# ╠═9cdbcf37-42b2-4353-884c-e4b7f296c03d
# ╟─4c770d55-c567-4f05-9a27-492a16ac4ad7
# ╠═a596e284-eaec-4e97-b2f9-fb3c10be1a2e
# ╟─1f2417ee-3044-4969-88e8-c6053e6bd289
# ╠═4a647b87-8ef8-4df4-8085-8b1f95ce6165
# ╟─e8005950-153c-4971-ba06-6aa06eaa34ed
# ╠═af23ad91-a088-4538-a688-5bd77ed3f136
# ╟─09fb8fb3-5768-4a16-9fa2-cb9e9e7c307e
# ╠═66cbb4f2-dbc9-4a11-acd8-2eebdea5b78b
# ╟─a7e01d05-91a5-4a92-a98f-b1372d214d84
# ╟─9fab1a41-d16a-427f-bfc6-fcfe2b127b43
# ╠═9a8d1ff7-7446-44f2-ab53-1278e089d167
# ╠═8fffc456-a354-46ce-a450-3e692b803db6
# ╠═13e819b5-070d-4586-b9ac-614e17650b0a
# ╠═b0363b55-2408-4634-ae43-8fcd81b80189
# ╟─5eb0c1c5-485e-4fc9-b8d4-768cbba61346
# ╠═bba7b6e3-49a6-4e7e-bfd3-9c2f1c143998
# ╟─0091bf90-8047-4ae4-8146-f0b88c9ab2c5
# ╠═45133e10-6a60-4f4c-9f73-d9f309246d64
# ╠═9f6c678b-888c-4fc3-9a0d-dcd54831d07a
# ╠═d94515f4-4608-4cef-8ab9-7f04ea8834df
# ╠═87900d3a-13d4-4319-8549-21236a510030
# ╠═18cf26c8-4800-425e-8491-e80a005d9006
# ╟─3a693f58-a749-4439-b1dd-e8af43122846
# ╟─d9873739-11ad-437b-be41-099b604adfd3
# ╠═1f35adad-5a6a-47e6-a6b9-b2d4ba18577c
# ╠═25cf84f5-0ef6-4d49-839d-59bcb671ad00
# ╟─150b2154-0993-4461-b37a-8139407ddd0a
# ╠═164b7baf-eca0-4a72-8078-f1a85927f25d
# ╠═c2e37372-53c5-454b-a239-2de3587c2b95
# ╟─a56723a6-f868-4bf9-bcbb-57a3c9e30210
# ╠═44f33143-f37f-45b9-9cd0-d0eb2f835d69
# ╠═ccba94af-0284-463d-b422-2f10b78eab4b
# ╠═09fd3ef9-8368-45c2-a795-349210c2f26c
# ╠═a114cfef-4337-42ea-af81-82c1c374322f
# ╟─c7c2b60b-6b02-4576-9994-741e73ad380c
# ╠═d417449e-704c-4558-b7a2-7e82836422f8
# ╠═e1a110f3-1525-422e-b54d-db1e1f05cef9
# ╠═cf5c693a-fe06-4133-994a-3e35d3440581
# ╠═179ecb86-a27b-49f8-be98-da8f594318f3
# ╟─b00ea21a-3605-4e06-91cc-6eb96fbf976a
# ╠═d1fdf622-2e2d-4dfb-8a70-5e94a6e50369
# ╟─b896877a-11c7-4f7b-85e2-eee964651f40
# ╠═996f68b0-6060-483e-95a2-796ff40754b9
# ╟─f041a926-2d31-4640-be23-27b46e0ca706
# ╠═bec60f2c-51c2-4c92-a063-9f28d37a62a8
# ╟─44ec67b7-1e16-4a50-a1a5-74aa0a2bf9e9
# ╠═a171844f-4935-4794-8881-c98dcef8c15d
# ╠═c8dad863-6fcf-4dd5-bc6d-6c8b817db65b
# ╠═87074f57-afcb-490d-aaf8-3c4634614e5c
# ╟─4edc8ef0-1d65-4710-b44d-46bff985aabc
# ╟─d7990843-2e03-4aec-913b-b0a4a2a027b4
# ╟─e2056f08-2d3a-471e-a8f9-717dae7266fa
# ╠═cfbb2476-0bd4-485f-8758-26e235b6a632
# ╠═3c4341a4-eb3f-4bce-ae16-102c69e69951
# ╟─ff8b97c8-b026-4116-bd03-bcc538c18d33
# ╠═b32aa919-8933-423e-a074-2c555b002484
# ╠═038034cf-b099-4409-b189-1382692c9195
# ╟─63211fb9-eb43-4255-a81f-333e9c0856f5
# ╠═07f722fe-2476-47d6-b98d-7ebcbcdbdb7c
# ╟─8a6c0e12-e69a-47c0-8f26-e9e5d28a9064
# ╠═6085e1bb-bb5e-445e-b9b3-e40fb123d5e9
# ╠═85749deb-4147-4d76-b208-a95daf6ba6d6
# ╟─46d032c9-305b-4ed6-bf95-24db6866985a
# ╠═bb2fe3fe-152f-4beb-aa4b-6cd5b28bfc8c
# ╟─f06a66bf-b7ab-4351-9f5a-2505aa6da71f
# ╠═e372e417-a9f5-46a6-bbbc-006b94bb9889
# ╠═578ac4f0-754c-4f3a-a8f7-e49e66fd3e55
# ╠═ea1ca1ec-9a04-42b9-94ae-dbce6178e268
# ╠═0497a6ce-2695-4e44-a985-1583ca840428
# ╟─0d23d78f-25ad-4247-aac4-b3880ec26ffc
# ╠═2b941d8b-811e-4f15-ba21-9a807806d24b
# ╠═0f69bbfb-f908-4f76-8067-dc8dd3c4fc43
# ╟─0e03fc22-57f2-45fe-b130-cce90c40ae7f
# ╠═f89a277d-84b5-4493-9e2a-860e8bb3e2d6
# ╠═c2e0839c-e4fd-45c1-ae91-fb9819b352ae
# ╠═c6142c5f-9281-4723-924f-5a1aa3461f22
# ╟─d3ea41b9-ca4c-4d74-9e8d-9a1d73fd1b2c
# ╠═4404149a-2a30-4f13-9ea4-8224c77cad01
# ╠═75cdfbb9-b329-458e-b02d-31718af65407
# ╠═9f3ed43e-4ebf-4639-8834-4ba2b89d55de
# ╟─e214783a-35f1-4333-9c7d-d73934a4d848
# ╠═33677178-d9cf-4aed-89da-14610e87a1d4
# ╠═6e30f561-081c-4169-8ef1-051dc60f612e
# ╠═88a7bc7f-3553-44fd-9bcb-1c5430be6d2f
# ╟─8375d553-4800-4b19-b706-9819d73c67f9
# ╠═0c42dcd6-01a9-42de-b686-822238f40bcd
# ╠═a91a8738-6013-4e26-8735-380170d3caf9
# ╟─711a016c-aa57-417a-9898-5d85257a366a
# ╟─8ac2e669-9f84-47e5-be0b-0cba5171f195
# ╠═6f162de2-9bd7-4bf5-96a0-dd923e5d4ca8
# ╟─1a88d730-5de2-48ae-aa01-6c4812a37f50
# ╠═d4662fd7-fed4-4ea7-9d2e-9ed6e55aa1bd
# ╟─67a68038-f724-4c88-819d-c452c5e0a221
# ╠═3ab463e6-e43d-41c8-a5ad-e95db8da1b9a
# ╟─f2202828-68fb-4451-b3ef-691e6f65fea2
# ╟─e2327ce6-593e-427f-bd1f-4f56f0a2259c
# ╠═6ca08594-de75-4ff5-b6c0-628bf9a8a2ad
# ╠═a6ad2c47-5f06-4587-9d0b-89607c23b6b4
# ╠═5a50afe8-0637-4467-a7fa-a0dea8319994
# ╠═3e593290-a17e-4a67-8675-d74cf2649553
# ╠═74856d23-b5dc-43ca-bb45-0c05cee6ffa1
# ╟─3134bc12-dbeb-409f-a9e9-e31f7148bb6c
# ╠═3d11e9c1-7324-49f2-b690-d70cda65d4c4
# ╟─4a542b98-4ce8-4e14-b821-bc24bcfc7485
# ╠═05adbddf-acbe-4e01-8b39-a8c46697d5de
# ╟─bcc36ee7-36e2-4fb5-8a74-6671499572d1
# ╠═7bfded48-7697-41ba-ab51-3a2e9dd3d4c4
# ╟─a6613181-c2a3-4bf3-86a0-b85037586613
# ╠═4ac346ea-f37c-4881-a482-65acc67589d5
# ╟─31e48682-b919-4ccf-b9f2-ed49c9e5d738
# ╠═f3eb3ba5-3f51-4bc3-8051-54203a286f25
# ╟─0c6c78f0-4328-44db-9a5a-3cb9e517e585
# ╠═220a6d12-e576-40b4-9f5e-660fe90260bc
# ╟─03e00ee9-65a7-43fe-8ef7-158c93437de1
# ╠═f49e63b4-f26c-4dd2-a1f7-813d59167d26
# ╟─54983b4f-b805-4daa-97bb-d72cbf161740
# ╠═3018e66e-79e0-42ad-a452-d0ac6d893309
# ╟─550319e4-02a7-4012-8826-5b752f03a2f5
# ╠═59bc1372-0822-4fc9-8e3a-5ef8662e1f26
# ╠═6fec6537-f523-43c0-81f3-b788548d138f
# ╟─e71aa285-63c5-4fe8-b8a9-f363d738948b
# ╠═c4e890b0-ac7a-452a-9aaf-443b033e0d4d
# ╟─7af141de-7816-47e4-92e5-7d8c681ce39c
# ╟─9204e290-2f5c-42b1-9011-b42fc7acb1ed
# ╟─d4e4e4c7-f4db-4491-88dd-e891fac786e9
# ╠═71ebc134-8313-42a1-9084-ab2ecd7bed34
# ╟─753b74fc-54cb-4c0d-bd57-694e5b234eb7
# ╠═290d9edb-e3bd-4d9a-91dc-f05a7e972e01
# ╟─b6a4f8b8-d8dd-47a5-8947-7b96ea0beb9a
# ╠═fcbf48e7-3340-4030-bf2f-1862fb74dceb
# ╟─0aac7270-20bc-418d-bb95-3c67e6bfacfa
# ╠═8c7ac1c9-0a36-4bbb-a05f-f9de73c40605
# ╟─4845a678-3cc9-4414-baa1-70f0f1aee5fe
# ╠═46a299b4-e632-4b8e-af65-44339237cd05
# ╟─c268f611-3e5e-4a5d-85e7-bb934a9f3ecd
# ╠═3dd97415-c331-498f-bd3c-145d27ef6e71
# ╟─29765ded-f03b-4d86-bc00-f1bbeb3fa269
# ╠═bcb229da-0118-4b1d-b0c2-6c4b2873a4ec
# ╟─0045fd83-2974-4242-8c6e-1e40c4e5c3e7
# ╠═54f743ed-1b01-47e4-9c97-276cc3a3b424
# ╟─eaaf8f09-19c7-416c-a493-b12c2e7f6bb7
# ╠═bebca508-437e-4c0d-b4fb-fdbf402da652
# ╟─4f9ddb83-a4a7-4c3f-afa5-1858ce64deed
# ╟─ce9968a9-be63-42f6-ba35-28298d7761df
# ╠═5e764ca4-943a-48bc-94a3-326dbecfde07
# ╟─08710444-56bc-418f-99c1-15009fdc21fe
# ╠═b0f1d29e-41c8-4ea1-8109-cab78a6b04f2
# ╟─3732abd0-ffc3-4d2c-9975-53cc6e53c1e7
# ╠═44737f50-ee32-4732-95ae-ad735bed6571
# ╟─a6ff7f30-39ec-419b-b432-eedb8245d129
# ╠═03cc1ac6-d38a-4a0d-b61b-5ffcadce419b
# ╟─931d6534-b085-40e8-b5da-6aa1de9fbdfe
# ╠═d65410a6-a94f-4641-9c7d-e4c61a3a6b5b
# ╟─9434d50a-5345-45f2-a47b-f6c31830f583
# ╠═c8b3b951-14cc-4dcd-99d9-1612d9d305b1
# ╟─96a1079d-e2b1-4dce-8f93-ddb249f21d39
# ╠═7ce9a521-f271-4630-bb0d-afb86feba973
# ╟─04b6a8db-3825-4a91-a52f-dbebad4eef6f
# ╠═63f7289d-fd20-41a3-8018-7805c902f170
# ╟─b2521cb3-043e-4910-ae64-5ffad70ad939
# ╟─1110f3b6-1531-489e-9946-a08007062c79
# ╠═45e84aa2-4001-43e6-a919-8b8d1e1379c8
# ╠═3a24c418-7aac-4d61-92fa-62ffdda7c195
# ╠═71afbeab-500a-445d-b77e-aebf263eaef5
# ╠═5050e645-8abd-45d6-9cee-565df4429cd4
# ╠═1e7f30b8-7fa8-457f-adfe-9606f0cdfc5f
# ╠═1ce3a3a7-c7a2-4a7a-87a8-19d96f6b3e08
# ╟─f33342a2-052d-4463-8d24-bb6921d16b4e
# ╟─7b39423b-c456-44d6-a51f-9a34c3c49158
# ╠═e2e77b7a-e4ba-4032-adc5-cd7cd554cd5f
# ╠═50693824-d0c6-4fa1-9861-521835c60717
# ╠═ee7e5b48-8237-4b2f-b513-2bc6019ec352
# ╠═9eaefbbe-8c84-4bab-ae13-3389aa3afa99
# ╠═21fc740c-f155-4432-997d-fa08638ecb30
# ╠═e3714d0c-e856-4fba-8b9e-1457df417107
# ╠═4562c1c9-6ed8-4f33-b6ff-18385fd25b49
# ╠═866bb509-7047-4f68-9a8c-8dea8e3f2be6
# ╟─80ea79ba-f18f-41f9-832c-d4654ed4839e
# ╟─9c8f7403-6245-4033-b692-093531c3d37f
# ╠═f631d2b1-552f-48f5-b6bd-ebf8d3420ed2
# ╠═200a2ea5-70e5-43be-a46a-652e0bad4e5a
# ╟─b6c46c5a-2882-44d0-ad5e-ee9c9f79b8e9
# ╠═fe394e75-2f4e-4f04-92c1-c99743426145
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
