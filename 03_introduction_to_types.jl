### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 834ca983-bb32-4426-b122-9be9a821a645
using LinearAlgebra, Statistics

# ╔═╡ 19f75cac-89ba-4f53-b528-f3e6f7811589
using Base:show_supertypes  # import the function from the `Base` package

# ╔═╡ 0686f351-3506-4fa1-b3bd-cd1e34a6e9d3
using Parameters

# ╔═╡ 58f1fb96-85bb-4936-97cb-ab2c696ae09e
using PlotlyBase, ForwardDiff

# ╔═╡ c47b72a8-4ae4-4c31-bedc-70f3bfcb3fab
using StaticArrays


# ╔═╡ 77faa48c-0d35-4d3f-8473-aacdc1ee3eec
using BenchmarkTools

# ╔═╡ b22743f6-b735-4869-8417-634d2246c572
using Polynomials

# ╔═╡ 867ffdd5-cdeb-43dc-95a4-bca4cfa067b7
using Plots

# ╔═╡ 522abd65-175d-4a6c-960b-d8bf3cc5ceed
using PlutoUI

# ╔═╡ 6c95c3e6-ee1f-4269-a2a0-be4fed0a2b9a
md"""
# Introduction to Types and Generic Programming
"""

# ╔═╡ 4a5d7fdc-0283-4e75-b8c1-32a392333996
md"""
## Contents

- Introduction to Types and Generic Programming
  - Overview
  - Finding and Interpreting Types
  - The Type Hierarchy
  - Deducing and Declaring Types
  - Creating New Types
  - Introduction to Multiple Dispatch
  - Exercises
"""

# ╔═╡ d878fc00-93e2-4c2c-908c-5e5039cbe9e6
md"""
## Overview

In Julia, arrays and tuples are the most important data type for working with numerical data.

In this lecture we give more details on

- declaring types
- abstract types
- motivation for generic programming
- multiple dispatch
- building user-defined types
"""

# ╔═╡ 800990bf-7e9d-419b-bb80-8147ef03c012
md"""
### Setup
"""

# ╔═╡ 5bb8f3ec-8e76-4f15-b590-d768cd21fb2c
md"""
## Finding and Interpreting Types
"""

# ╔═╡ 4236d872-1be6-4581-8b26-deea4984bf02
md"""
### Finding The Type

As we have seen in the previous lectures, in Julia all values have a type, which can be queried using the `typeof` function
"""

# ╔═╡ 37e08965-ae8d-41cc-898c-649f5acdcae1
typeof(1)

# ╔═╡ b3608ad2-8c2f-4ebe-bcd9-70821b856da8
md"""
The hard-coded values `1` and `1.0` are called literals in a programming
language, and the compiler deduces their types (`Int64` and `Float64` respectively in the example above).

You can also query the type of a value
"""

# ╔═╡ 7a5b374d-8355-4525-95f6-6c97648fec09
x = 1

# ╔═╡ 616ebea1-8136-4789-b439-e21887bb01d9
md"""
The name `x` binds to the value `1`, created as a literal.
"""

# ╔═╡ e959da83-9d66-48b9-9ed8-3c936240d823
md"""
### Parametric Types

(See [parametric types documentation](https://docs.julialang.org/en/v1/manual/types/#Parametric-Types-1)).

The next two types use curly bracket notation to express the fact that they are *parametric*
"""

# ╔═╡ c4365cec-3ff8-4ad0-a891-4eb4b4573f42
typeof(1.0 + 1im)

# ╔═╡ dba322cd-240c-49a9-8f74-de1bf1749bb7
md"""
We will learn more details about [generic programming](https://julia.quantecon.org/../more_julia/generic_programming.html) later, but the key is to interpret the curly brackets as swappable parameters for a given type.

For example, `Array{Float64, 2}` can be read as

1. `Array` is a parametric type representing a dense array, where the first parameter is the type stored, and the second is the number of dimensions.
1. `Float64` is a concrete type declaring that the data stored will be a particular size of floating point.
1. `2` is the number of dimensions of that array.


A concrete type is one where values can be created by the compiler (equivalently, one which can be the result of `typeof(x)` for some object `x`).

Values of a **parametric type** cannot be concretely constructed unless all of the parameters are given (themselves with concrete types).

In the case of `Complex{Float64}`

1. `Complex` is an abstract complex number type.
1. `Float64` is a concrete type declaring what the type of the real and imaginary parts of the value should store.


Another type to consider is the `Tuple` and `NamedTuple`
"""

# ╔═╡ 7570163b-e47f-4a1e-aad8-8376b7276617
with_terminal() do
    x = (1, 2.0, "test")
    @show typeof(x)
end

# ╔═╡ f8884394-b5f2-4a0b-a71e-d4dfa73bfb3b
md"""
In this case, `Tuple` is the parametric type, and the three parameters are a list of the types of each value.

For a named tuple
"""

# ╔═╡ 8297b497-08bf-4973-9e27-cdac9ae06adf
with_terminal() do
    x = (a = 1, b = 2.0, c = "test")
    @show typeof(x)
end

# ╔═╡ 7b08e82d-29c9-4873-bb24-e6313275c11b
md"""
The parametric `NamedTuple` type contains two parameters: first a list of names for each field of the tuple, and second the underlying `Tuple` type to store the values.

Anytime a value is prefixed by a colon, as in the `:a` above, the type is `Symbol` – a special kind of string used by the compiler.
"""

# ╔═╡ 479c76f7-af2f-4ec5-ae2c-3cdaade896fd
typeof(:a)

# ╔═╡ dcfd7014-81a3-4ffc-9bab-7388ee5cb4b5
md"""
**Remark:** Note that, by convention, type names use CamelCase –  `Array`, `AbstractArray`, etc.
"""

# ╔═╡ c2127863-d10d-45cd-84fa-e001a8d0aacd
md"""
### Variables, Types, and Values

Since variables and functions are lower case by convention, this can be used to easily identify types when reading code and output.

After assigning a variable name to a value, we can query the type of the
value via the name.
"""

# ╔═╡ e576cb0f-1ad6-46bb-9a87-237a43df74cd
with_terminal() do
    x = 42
    @show typeof(x);
end

# ╔═╡ fa17a200-5e33-40cb-be19-40a878817af6
md"""
Thus, `x` is just a symbol bound to a value of type `Int64`.
"""

# ╔═╡ f483e5b4-e984-4be7-82e2-2c1426e084dc
md"""
## The Type Hierarchy

Let’s discuss how types are organized.
"""

# ╔═╡ d1b3fb64-eca4-4286-91ff-8c0f8219c2f6
md"""
### Abstract vs Concrete Types

(See [abstract types documentation](https://docs.julialang.org/en/v1/manual/types/#man-abstract-types-1))

Up to this point, most of the types we have worked with (e.g., `Float64, Int64`) are examples of **concrete types**.

Concrete types are types that we can *instantiate* – i.e., pair with data in memory.

We will now examine **abstract types** that cannot be instantiated (e.g., `Real`, `AbstractFloat`).

For example, while you will never have a `Real` number directly in memory, the abstract types
help us organize and work with related concrete types.
"""

# ╔═╡ b1aeb00b-756a-4edf-9a6c-2bb1f09aecb1
md"""
### Subtypes and Supertypes

How exactly do abstract types organize or relate different concrete types?

In the Julia language specification, the types form a hierarchy.

You can check if a type is a subtype of another with the `<:` operator.
"""

# ╔═╡ 41a1b28a-f602-4df3-ba6b-302773642a54
with_terminal() do
    @show Float64 <: Real
    @show Int64 <: Real
    @show Complex{Float64} <: Real
    @show Array <: Real;
end

# ╔═╡ 8ad1b3d9-71f5-492b-a00b-34afe903a8a2
md"""
In the above, both `Float64` and `Int64` are **subtypes** of `Real`, whereas the `Complex` numbers are not.

They are, however, all subtypes of `Number`
"""

# ╔═╡ 959d0a0a-df82-4503-9778-de8a3914b1d2
with_terminal() do
    @show Real <: Number
    @show Float64 <: Number
    @show Int64 <: Number
    @show Complex{Float64} <: Number;
end

# ╔═╡ 54ea88d4-125a-4dc4-958c-c3978f3b862c
md"""
`Number` in turn is a subtype of `Any`, which is a parent of all types.
"""

# ╔═╡ 01ac6c62-a6b1-4bc0-ae1f-cd274b5405c7
Number <: Any

# ╔═╡ 69cc5e4a-715b-4689-9f30-25aaf222fc68
md"""
In particular, the type tree is organized with `Any` at the top and the concrete types at the bottom.

We never actually see *instances* of abstract types (i.e., `typeof(x)` never returns an abstract type).

The point of abstract types is to categorize the concrete types, as well as other abstract types that sit below them in the hierarchy.

There are some further functions to help you explore the type hierarchy, such as `show_supertypes` which walks up the tree of types to `Any` for a given type.
"""

# ╔═╡ d4b6ac90-6677-4e1f-a260-003a8332c22e
md"""
And the `subtypes` which gives a list of the available subtypes for any packages or code currently loaded
"""

# ╔═╡ 772a082e-c279-425d-ab34-f114ea013446
with_terminal() do
    @show subtypes(Real)
    @show subtypes(AbstractFloat);
end

# ╔═╡ f5a182f4-daad-422d-812a-7b9dc58ebc86
md"""
## Deducing and Declaring Types

We will discuss this in detail in [generic programming](https://julia.quantecon.org/../more_julia/generic_programming.html),
but much of Julia’s performance gains and generality of notation comes from its type system.

For example
"""

# ╔═╡ 0bdb3cce-919d-4fbe-9504-ef893b1b59d2
with_terminal() do
    x1 = [1, 2, 3]
    x2 = [1.0, 2.0, 3.0]

    @show typeof(x1)
    @show typeof(x2)
end

# ╔═╡ 6ab88815-bd0c-435d-8cbb-022ba5a3abf5
md"""
These return `Array{Int64,1}` and `Array{Float64,1}` respectively, which the compiler is able to infer from the right hand side of the expressions.

Given the information on the type, the compiler can work through the sequence of expressions to infer other types.
"""

# ╔═╡ ace5dbad-7dcb-452d-a73c-c5756291fe36
md"""
### Good Practices for Functions and Variable Types

In order to keep many of the benefits of Julia, you will sometimes want to ensure
the compiler can always deduce a single type from any function or expression.

An example of bad practice is to use an array to hold unrelated types
"""

# ╔═╡ fc23c125-2751-4fc8-829f-f763f27a8219
[1.0, "test", 1]  # typically poor style

# ╔═╡ a5feac12-69e7-4d68-ad4a-ece589394010
md"""
The type of this array is `Array{Any,1}`, where `Any` means the compiler has determined that any valid Julia type can be added to the array.

While occasionally useful, this is to be avoided whenever possible in performance sensitive code.

The other place this can come up is in the declaration of functions.

As an example, consider a function which returns different types depending on the arguments.
"""

# ╔═╡ 0654c732-5eb2-4c8c-ab2b-9774d6e0bc2f
md"""
The issue here is relatively subtle:  `1.0` is a floating point, while `0` is an integer.

Consequently, given the type of `x`, the compiler cannot in general determine what type the function will return.

This issue, called **type stability**, is at the heart of most Julia performance considerations.

Luckily, trying to ensure that functions return the same types is also generally consistent with simple, clear code.
"""

# ╔═╡ 547d4df4-ece6-4ba7-8f57-fd08f1f615ed
md"""
### Manually Declaring Function and Variable Types

(See [type declarations documentation](https://docs.julialang.org/en/v1/manual/types/#Type-Declarations-1))

You will notice that in the lecture notes we have never directly declared any types.

This is intentional both for exposition and as a best practice for using packages (as opposed to writing new packages, where declaring these types is very important).

It is also in contrast to some of the sample code you will see in other Julia sources, which you will need to be able to read.

To give an example of the declaration of types, the following are equivalent
"""

# ╔═╡ c9de02da-091b-4b23-9973-d0d13cdf697d

function f(x, A)
    b = [5.0, 6.0]
    return A * x .+ b
end

# ╔═╡ c7187fae-d148-4899-9be1-d0c012b4cad9
function f2(x::Vector{Float64}, A::Matrix{Float64})::Vector{Float64}
    # argument and return types
    b::Vector{Float64} = [5.0, 6.0]
    return A * x .+ b
end

# ╔═╡ ae1d5137-819b-4153-94b5-5917257d72d4
md"""
While declaring the types may be verbose, would it ever generate faster code?

The answer is almost never.

Furthermore, it can lead to confusion and inefficiencies since many things that behave like vectors and matrices are not `Matrix{Float64}` and `Vector{Float64}`.

Here, the first line works and the second line fails
"""

# ╔═╡ f70b7fb2-0e9c-4f39-b986-d3ff20acddc5
md"""
## Creating New Types

(See [type declarations documentation](https://docs.julialang.org/en/v1/manual/types/#Type-Declarations-1))

Up until now, we have used `NamedTuple` to collect sets of parameters for our models and examples.

These are useful for maintaining values for model parameters,
but you will eventually need to be able to use code that creates its own types.
"""

# ╔═╡ e967ba4d-8cb9-417d-9ded-454ca9303683
md"""
### Syntax for Creating Concrete Types

(See [composite types documentation](https://docs.julialang.org/en/v1/manual/types/#Composite-Types-1))

While other sorts of types exist, we almost always use the `struct` keyword, which is for creation of composite data types

- “Composite” refers to the fact that the data types in question can be used as collection of named fields.
- The `struct` terminology is used in a number of programming languages to refer to composite data types.


Let’s start with a trivial example where the `struct` we build has fields named `a, b, c`, are not typed
"""

# ╔═╡ 7d27a06e-782d-453a-be56-567786704e61
struct FooNotTyped  # immutable by default, use `mutable struct` otherwise
    a # BAD! not typed
    b
    c
end

# ╔═╡ cf33c56c-0ef5-4d82-9ef2-2d43810a835f
md"""
And another where the types of the fields are chosen
"""

# ╔═╡ 244ef85e-7ac6-4fe1-8cba-dc2b768bed11
struct Foo
    a::Float64
    b::Int64
    c::Vector{Float64}
end

# ╔═╡ 9118ee77-ae6d-490a-9886-665464721fcd
md"""
In either case, the compiler generates a function to create new values of the data type, called a “constructor”.

It has the same name as the data type but uses function call notion
"""

# ╔═╡ 8a3fe30c-1591-44f9-ab29-adbef2ac9b3f
with_terminal() do
    foo_nt = FooNotTyped(2.0, 3, [1.0, 2.0, 3.0])  # new `FooNotTyped`
    foo = Foo(2.0, 3, [1.0, 2.0, 3.0]) # creates a new `Foo`

    @show typeof(foo)
    @show foo.a       # get the value for a field
    @show foo.b
    @show foo.c;
    # foo.a = 2.0     # fails since it is immutable
end


# ╔═╡ 9a7e1775-688f-4822-82f0-1581c0515be5
md"""
You will notice two differences above for the creation of a `struct` compared to our use of `NamedTuple`.

- Types are declared for the fields, rather than inferred by the compiler.
- The construction of a new instance has no named parameters to prevent accidental misuse if the wrong order is chosen.
"""

# ╔═╡ b3f1dd6f-1e5a-4f13-96e4-7df86b59540a
md"""
### Issues with Type Declarations

Was it necessary to manually declare the types `a::Float64` in the above struct?

The answer, in practice, is usually yes.

Without a declaration of the type, the compiler is unable to generate efficient code, and the use of a `struct` declared without types could drop performance by orders of magnitude.

Moreover, it is very easy to use the wrong type, or unnecessarily constrain the types.

The first example, which is usually just as low-performance as no declaration of types at all, is to accidentally declare it with an abstract type
"""

# ╔═╡ 7fe1cf97-a65f-446f-927f-ab90a07c731e
struct Foo2
    a::Float64
    b::Integer  # BAD! Not a concrete type
    c::Vector{Real}  # BAD! Not a concrete type
end

# ╔═╡ c56be32e-d57d-4d4f-b03e-ed1f314bd1c0
md"""
The second issue is that by choosing a type (as in the `Foo` above), you may
be unnecessarily constraining what is allowed
"""

# ╔═╡ 01cc6a25-7c25-4276-a00f-4dcf7dbb6c6f
f(x) = x.a + x.b + sum(x.c) # use the type

# ╔═╡ 7e0365f6-172c-4f0e-b570-d51d36ca65f3
let
    f(y) = 2y # define some function


    x = [1, 2, 3]
    z = f(x) # call with an integer array - compiler deduces type
end

# ╔═╡ 4c14a0eb-94ee-44f1-8ca3-a06dc991b3d0
with_terminal() do
    function f(x)
        if x > 0
            return 1.0
        else
            return 0  # probably meant `0.0`
        end
    end

    @show f(1)
    @show f(-1);
end

# ╔═╡ a614ee6e-1871-43bf-8f96-207f82844f5e
f([0.1; 2.0], [1 2; 3 4])

# ╔═╡ 3c481c55-2dc5-48f2-83bf-69d50908e5b8
with_terminal() do
    a = 2.0
    b = 3
    c = [1.0, 2.0, 3.0]
    foo = Foo(a, b, c)
    @show f(foo)   # call with the foo, no problem

    # some other typed for the values
    a = 2   # not a floating point but `f()` would work
    b = 3
    c = [1.0, 2.0, 3.0]'   # transpose is not a `Vector` but `f()` would work
    # foo = Foo(a, b, c)   # fails to compile

    # works with `NotTyped` version, but low performance
    foo_nt = FooNotTyped(a, b, c)
    @show f(foo_nt);
end

# ╔═╡ 6e2a9f70-f5da-4b29-b6d0-55fb7f14061a
md"""
### Declaring Parametric Types (Advanced)

(See [type parametric types documentation](https://docs.julialang.org/en/v1/manual/types/#Parametric-Types-1))

Motivated by the above, we can create a type which can adapt to holding fields of different types.
"""

# ╔═╡ 4bc96799-d29c-4f4a-bf97-c13a2f50ad1c
struct Foo3{T1,T2,T3}
	a::T1   # could be any type
	b::T2
	c::T3
end

# ╔═╡ 1d8bb850-8f49-4d58-9057-2a34037e8615
with_terminal() do 
	# works fine0
	a = 2
	b = 3
	c = [1.0, 2.0, 3.0]'    # transpose is not a `Vector` but `f()` would work
	foo = Foo3(a, b, c)
	@show typeof(foo)
	f(foo)
end

# ╔═╡ ff886c74-6757-4e83-9fc7-ec193fab3986
md"""
Of course, this is probably too flexible, and the `f` function might not work on an arbitrary set of `a, b, c`.

You could constrain the types based on the abstract parent type using the `<:` operator
"""

# ╔═╡ 094727df-7a85-490e-90aa-d25f75db8333
struct Foo4{T1 <: Real,T2 <: Real,T3 <: AbstractVecOrMat{<:Real}}
    a::T1
    b::T2
    c::T3  # should check dimensions as well
end

# ╔═╡ e7e523d5-1f96-4794-906a-206b3c29f048
with_terminal() do
	a = 2
	b = 3
	c = [1.0, 2.0, 3.0]'    # transpose is not a `Vector` but `f()` would work
	foo = Foo4(a, b, c)  # no problem, and high performance
	@show typeof(foo)
	f(foo)
end

# ╔═╡ 740006d6-4449-4dd5-a80b-0e2f112084de
md"""
This ensures that

- `a` and `b` are a subtype of `Real`, and `+` in the definition of `f` works
- `c` is a one dimensional abstract array of `Real` values


The code works, and is equivalent in performance to a `NamedTuple`, but is more verbose and error prone.
"""

# ╔═╡ 579d1573-f1f3-478a-9519-097e52da8bc1
md"""
### Keyword Argument Constructors (Advanced)

There is no way to avoid learning parametric types to achieve high performance code.

However, the other issue where constructor arguments are error-prone, can be remedied with the `Parameters.jl` library.
"""

# ╔═╡ 7df21cc4-a591-44e7-9924-5b17a901fd66
@with_kw  struct Foo5
    a::Float64 = 2.0     # adds default value
    b::Int64
    c::Vector{Float64}
end

# ╔═╡ 44d17bac-023d-4e7f-9214-cca839e4d58f
with_terminal() do 
	foo = Foo5(a=0.1, b=2, c=[1.0, 2.0, 3.0])
	foo2 = Foo5(c=[1.0, 2.0, 3.0], b=2)  # rearrange order, uses default values

	@show foo
	@show foo2

	function f(x)
		@unpack a, b, c = x     # can use `@unpack` on any struct
		return a + b + sum(c)
	end

	f(foo)
end

# ╔═╡ 3b7d4e02-88b2-4f54-9cbf-9545ec1194df
md"""
### Tips and Tricks for Writing Generic Functions

As discussed in the previous sections, there is major advantage to never declaring a type unless it is absolutely necessary.

The main place where it is necessary is designing code around [multiple dispatch](#intro-multiple-dispatch).

If you are careful to write code that doesn’t unnecessarily assume types,
you will both achieve higher performance and allow seamless use of a
number of powerful libraries such as
[auto-differentiation](https://github.com/JuliaDiff/ForwardDiff.jl),
[static arrays](https://github.com/JuliaArrays/StaticArrays.jl),
[GPUs](https://github.com/JuliaGPU/CuArrays.jl),
[interval arithmetic and root finding](https://github.com/JuliaIntervals/IntervalRootFinding.jl),
[arbitrary precision numbers](https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/index.html#Arbitrary-Precision-Arithmetic-1),
and many more packages – including ones that have not even been written yet.

A few simple programming patterns ensure that this is possible

- Do not declare types when declaring variables or functions unless necessary.
"""

# ╔═╡ c0c365f7-7227-419b-b668-c2c0d34d06a7
let
	# BAD
	x = [5.0, 6.0, 2.1]

	function g(x::Array{Float64,1})   # not generic!
		y = zeros(length(x))   # not generic, hidden float!
		z = Diagonal(ones(length(x)))  # not generic, hidden float!
		q = ones(length(x))
		y .= z * x + q
		return y
	end

	g(x)

	# GOOD
	function g2(x)  # or `x::AbstractVector`
		y = similar(x)
		z = I
		q = ones(eltype(x), length(x))  # or `fill(one(x), length(x))`
		y .= z * x + q
		return y
	end

	g2(x)
end

# ╔═╡ 3d47df6d-3d28-4fd0-9d09-69b5764a95f5
md"""

- Preallocate related vectors with `similar` where possible, and use `eltype` or `typeof`. This is important when using Multiple Dispatch given the different input types the function can call
"""

# ╔═╡ 4c192cf9-0be8-47b4-9e92-328109b31851
let
	function g(x)
		y = similar(x)
		for i in eachindex(x)
			y[i] = x[i]^2      # could broadcast
		end
		return y
	end

	g([BigInt(1), BigInt(2)])
end

# ╔═╡ 02597c6a-47d8-498a-b43a-544143103406
md"""

- Use `typeof` or `eltype` to declare a type
"""

# ╔═╡ ca3e5e66-27be-4eb5-9cdc-46a746612c67
typeof([1.0, 2.0, 3.0])

# ╔═╡ 461d1738-7097-4aaa-9c26-72370aa598e6
eltype([1.0, 2.0, 3.0])

# ╔═╡ 67bd2c52-0303-4b68-815b-18738d020528
md"""

- Beware of hidden floating points
"""

# ╔═╡ 78aa7140-aa1d-41c4-bfee-d2b093c1040b
typeof(ones(3))

# ╔═╡ abe3c90e-1974-479a-99e9-bd0732e392b5
typeof(ones(Int64, 3))

# ╔═╡ 09731d3d-28d6-438b-ba78-235372c4b153
typeof(zeros(3))

# ╔═╡ 90d7cef9-69f5-4e34-8c29-96d36bb3c4eb
typeof(zeros(Int64, 3))

# ╔═╡ 5c65a637-ff3e-4464-925d-f6eff9a34ebc
md"""

- Use `one` and `zero` to write generic code
"""

# ╔═╡ 46fb85cb-ac3f-48b9-8362-48972cd6a4eb
with_terminal() do
	@show typeof(1)
	@show typeof(1.0)
	@show typeof(BigFloat(1.0))
	@show typeof(one(BigFloat))  # gets multiplicative identity, passing in type
	@show typeof(zero(BigFloat))

	x = BigFloat(2)

	@show typeof(one(x))  # can call with a variable for convenience
	@show typeof(zero(x));
end

# ╔═╡ e0465942-2c9c-4c36-b6d5-ca2b51ba79b8
md"""



This last example is a subtle, because of something called [type promotion](https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#Promotion-1)

- Assume reasonable type promotion exists for numeric types
"""

# ╔═╡ adc52660-fd13-4d6f-8c87-47c1211ebb8e
with_terminal() do 
	# ACCEPTABLE
	function g(x::AbstractFloat)
		return x + 1.0   # assumes `1.0` can be converted to something compatible with `typeof(x)`
	end

	x = BigFloat(1.0)

	@show typeof(g(x));  # this has "promoted" the `1.0` to a `BigFloat`
end

# ╔═╡ eb247237-e420-4f11-a384-461bf1f031f8
md"""
But sometimes assuming promotion is not enough
"""

# ╔═╡ fc34cc18-3aa7-4431-8ae8-32d6012698b5
with_terminal() do 
	# BAD
	function g2(x::AbstractFloat)
		if x > 0.0   # can't efficiently call with `x::Integer`
			return x + 1.0   # OK - assumes you can promote `Float64` to `AbstractFloat`
		otherwise
			return 0   # BAD! Returns a `Int64`
		end
	end

	x = BigFloat(1.0)
	x2 = BigFloat(-1.0)

	@show typeof(g2(x))
	@show typeof(g2(x2))  # type unstable

	# GOOD
	function g3(x) #
		if x > zero(x)   # any type with an additive identity
			return x + one(x)  # more general but less important of a change
		otherwise
			return zero(x)
		end
	end

	@show typeof(g3(x))
	@show typeof(g3(x2));  # type stable
end

# ╔═╡ e3c76c6d-47ae-42c5-bfff-491a29b74338
md"""


These patterns are relatively straightforward, but generic programming can be thought of
as a Leontief production function:  if *any* of the functions you write or call are not
precise enough, then it may break the chain.

This is all the more reason to exploit carefully designed packages rather than “do-it-yourself”.
"""

# ╔═╡ 183b404a-5a2d-4634-b22a-98584e1f7c0b
md"""
### A Digression on Style and Naming

The previous section helps to establish some of the reasoning behind the style
choices in these lectures: “be aware of types, but avoid declaring them”.

The purpose of this is threefold:

- Provide easy to read code with minimal “syntactic noise” and a clear correspondence to the math.
- Ensure that code is sufficiently generic to exploit other packages and types.
- Avoid common mistakes and unnecessary performance degradations.


This is just one of many decisions and patterns to ensure that your code is consistent and clear.

The best resource is to carefully read other peoples code, but a few sources to review are

- [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/).
- [Invenia Blue Style Guide](https://github.com/invenia/BlueStyle).
- [Julia Praxis Naming Guides](https://github.com/JuliaPraxis/Naming/tree/master/guides).
- [QuantEcon Style Guide](https://github.com/QuantEcon/lecture-source-jl/blob/master/style.md) used in these lectures.


Now why would we emphasize naming and style as a crucial part of the lectures?

Because it is an essential tool for creating research that is
**reproducible** and [**correct**](https://en.wikipedia.org/wiki/Correctness_%28computer_science%29).

Some helpful ways to think about this are

- **Clearly written code is easier to review for errors**: The first-order
  concern of any code is that it correctly implements the whiteboard math.
- **Code is read many more times than it is written**: Saving a few keystrokes
  in typing a variable name is never worth it, nor is a divergence from the
  mathematical notation where a single symbol for a variable name would map better to the model.
- **Write code to be read in the future, not today**: If you are not sure
  anyone else will read the code, then write it for an ignorant future version
  of yourself who may have forgotten everything, and is likely to misuse the code.
- **Maintain the correspondence between the whiteboard math and the code**:
  For example, if you change notation in your model, then immediately update
  all variables in the code to reflect it.
"""

# ╔═╡ 68e66604-3c20-4be1-9900-2dad79c7eb57
md"""
#### Commenting Code

One common mistake people make when trying to apply these goals is to add in a large number of comments.

Over the years, developers have found that excess comments in code (and *especially* big comment headers used before every function declaration) can make code *harder* to read.

The issue is one of syntactic noise: if most of the comments are redundant given clear variable and function names, then the comments make it more difficult to mentally parse and read the code.

If you examine Julia code in packages and the core language, you will see a great amount of care taken in function and variable names, and comments are only added where helpful.

For creating packages that you intend others to use, instead of a comment header, you should use [docstrings](https://docs.julialang.org/en/v1/manual/documentation/index.html#Syntax-Guide-1).
"""

# ╔═╡ cc94811f-f7e4-4a9e-8012-873c30f11d8b
md"""
## Introduction to Multiple Dispatch

One of the defining features of Julia is **multiple dispatch**, whereby the same function name can do different things depending on the underlying types.

Without realizing it, in nearly every function call within packages or the standard library you have used this feature.

To see this in action, consider the absolute value function `abs`
"""

# ╔═╡ ef2bd101-fa0c-465e-aab9-f6bff49ef475
with_terminal() do 
	@show abs(-1)   # `Int64`
	@show abs(-1.0)  # `Float64`
	@show abs(0.0 - 1.0im)  # `Complex{Float64}`
end

# ╔═╡ fc047b8c-1181-4b0b-9a46-8f1c24aa5de7
md"""
In all of these cases, the `abs` function has specialized code depending on the type passed in.

To do this, a function specifies different **methods** which operate on a particular set of types.

Unlike most cases we have seen before, this requires a type annotation.

To rewrite the `abs` function
"""

# ╔═╡ 78ee0c54-26b0-4db2-a50a-8b6848d4bbd2
function ourabs(x::Real)
	if x > zero(x)   # note, not 0!
		return x
	else
		return -x
	end
end

# ╔═╡ e7af2cd8-a091-4187-8de7-3daf07f48e07
function ourabs(x::Complex)
	sqrt(real(x)^2 + imag(x)^2)
end

# ╔═╡ 1831ad29-3517-4bcc-a0de-e2c8ba957b97
with_terminal() do 
	@show ourabs(-1)   # `Int64`
	@show ourabs(-1.0) # `Float64`
	@show ourabs(1.0 - 2.0im);  # `Complex{Float64}`
end

# ╔═╡ 2e9f8220-b243-4fc8-8ffc-8e48992acb4e
md"""
Note that in the above, `x` works for any type of `Real`, including `Int64`, `Float64`, and ones you may not have realized exist
"""

# ╔═╡ 1a637203-6094-45a8-93d7-d1263a507162
with_terminal() do 
	x = -2 // 3  # `Rational` number, -2/3
	@show typeof(x)
	@show ourabs(x)
end

# ╔═╡ d761a0e7-f3ec-47ac-b5a9-27ee73411f14
md"""
You will also note that we used an abstract type, `Real`, and an incomplete
parametric type, `Complex`, when defining the above functions.

Unlike the creation of `struct` fields, there is no penalty in using abstract
types when you define function parameters, as they are used purely to determine which version of a function to use.
"""

# ╔═╡ b1cb7b79-1500-414f-8c02-6312d22a2362
md"""
### Multiple Dispatch in Algorithms (Advanced)

If you want an algorithm to have specialized versions when given different input types, you need to declare the types for the function inputs.

As an example where this could come up, assume that we have some grid `x` of values, the results of a function `f` applied at those values, and want to calculate an approximate derivative using forward differences.

In that case, given $ x_n, x_{n+1}, f(x_n) $ and $ f(x_{n+1}) $, the forward-difference approximation of the derivative is

$$f'(x_n) \approx \frac{f(x_{n+1}) - f(x_n)}{x_{n+1} - x_n}$$

To implement this calculation for a vector of inputs, we notice that there is a specialized implementation if the grid is uniform.

The uniform grid can be implemented using an `AbstractRange`, which we can analyze with
`typeof`, `supertype` and `show_supertypes`.
"""

# ╔═╡ 7a21c4da-26ce-4964-86aa-7a9a71b523cd
v1 = range(0.0, 1.0, length=20)

# ╔═╡ 3cae6311-cd8d-40b8-b651-acb42b0d2208
v2 = 1:1:20

# ╔═╡ c35f8c11-a015-4223-9b95-7d6eb41476a5
with_terminal() do 
	@show typeof(v1)
	@show typeof(v2)
	@show supertype(typeof(v1))
end

# ╔═╡ cedb6183-5ec5-416e-9f6a-e1a20fe6fed2
md"""
To see the entire tree about a particular type, use `show_supertypes`.
"""

# ╔═╡ dfce0b85-9e85-4d0f-8cdd-9a78b338d405
with_terminal() do
	show_supertypes(typeof(v2))
end

# ╔═╡ a6085106-930d-428d-87a8-70702f265c17
md"""
The types of the range objects can be very complicated, but are both subtypes of `AbstractRange`.
"""

# ╔═╡ af3ae116-a525-48f9-a2ec-786ed50a3afc
with_terminal() do 
	@show typeof(v1) <: AbstractRange
	@show typeof(v2) <: AbstractRange;
end

# ╔═╡ c31f8512-3dc6-46e8-bc15-35209241cbf4
md"""
While you may not know the exact concrete type, any `AbstractRange` has an informal set of operations that are available.
"""

# ╔═╡ ce96ea2b-c350-4504-ae82-1e7d39ae0f4b
with_terminal() do
	@show minimum(v1)
	@show maximum(v1)
	@show length(v1)
	@show step(v1)
end

# ╔═╡ b053a166-85c9-495f-9abd-3fa0c10834b6
md"""
Similarly, there are a number of operations available for any `AbstractVector`, such as `length`.
"""

# ╔═╡ b7afc892-6b17-4f58-8897-7f3d86cb4f7b
with_terminal() do 
	f(x) = x^2
	f_x = f.(x)  # calculating at the range values

	@show typeof(f_x)
	@show supertype(typeof(f_x))
	@show supertype(supertype(typeof(f_x)))  # walk up tree again!
	@show length(f_x);   # and many more
	
	show_supertypes(typeof(f_x))
end

# ╔═╡ 1e420454-a44b-4f8c-9d30-0c699e84d30d
md"""
There are also many functions that can use any `AbstractArray`, such as `diff`.
"""

# ╔═╡ 72ee4fca-ab36-4ee4-9089-850ed8d6e995
md"""
```julia
?diff

search: diff symdiff setdiff symdiff! setdiff! Cptrdiff_t

diff(A::AbstractVector) # finite difference operator of matrix or vector A

# if A is a matrix, specify the dimension over which to operate with the dims keyword argument
diff(A::AbstractMatrix; dims::Integer)
```

"""

# ╔═╡ 507f706b-9e39-4de7-850b-b38c64302445
md"""
Hence, we can call this function for anything of type `AbstractVector`.

Finally, we can make a high performance specialization for any `AbstractVector` and `AbstractRange`.
"""

# ╔═╡ f5b144e8-4bf7-4918-bffe-8c1c103f23fb
slopes(f_x::AbstractVector, x::AbstractRange) = diff(f_x) / step(x)

# ╔═╡ 33a052ce-fee1-4547-b3ec-138747e53740
md"""
We can use auto-differentiation to compare the results.
"""

# ╔═╡ 444db70c-7f92-40a7-b4cc-ecb4ad6e61b8
# operator to get the derivative of this function using AD
D(f) = x -> ForwardDiff.derivative(f, x)

# ╔═╡ 299b8de5-c012-4dfe-95a6-c62c70b36f68
q(x) = sin(x)

# ╔═╡ 3572e479-1135-4240-a5bb-fe53191f1db8
md"""
Consider a variation where we pass a function instead of an `AbstractArray`
"""

# ╔═╡ 232d1d98-342c-4919-a594-5f0ab7398982
slopes(f::Function, x::AbstractRange) = diff(f.(x)) / step(x)  # broadcast function

# ╔═╡ c9514ffd-08c2-4216-a0fc-7143fd74adfd
md"""
Finally, if `x` was an `AbstractArray` and not an `AbstractRange` we can no longer use a uniform step.

For this, we add in a version calculating slopes with forward first-differences
"""

# ╔═╡ 592d8023-42c0-4f26-bdb6-68ef4b76c29d
# broadcasts over the diff
slopes(f::Function, x::AbstractArray) = diff(f.(x)) ./ diff(x)

# ╔═╡ 740ca2c3-681e-46cd-990d-e56cd11b1097
# compare slopes with AD for sin(x)
let
	x = 0.0:0.1:4.0
	q_x = q.(x)
	q_slopes_x = slopes(q_x, x)

	D_q_x = D(q).(x)  # broadcasts AD across vector
	Plot([
		scatter(x=x[1:end - 1], y=D_q_x[1:end - 1], name="q with AD"),
		scatter(x=x[1:end - 1], y=q_slopes_x, name="q slopes"),
	], Layout(height=500))
end

# ╔═╡ 13912601-7f54-46ea-a6d2-f34a93968f94
with_terminal() do 
	@show typeof(q) <: Function
	@show typeof(v1) <: AbstractRange
	q_slopes_x = slopes(q, v1)  # use slopes(f::Function, x)
	@show q_slopes_x[1];
end

# ╔═╡ 9598f2bb-d3ad-42ec-84d7-8797e903fb84
with_terminal() do
	x_array = Array(v1)  # convert range to array
	@show typeof(x_array) <: AbstractArray
	q_slopes_x = slopes(q, x_array)
	@show q_slopes_x[1]
end

# ╔═╡ 3c24d9ba-174e-419b-8ffe-be3190f5fe94
md"""
In the final example, we see that it is able to use specialized implementations over both the `f` and the `x` arguments.

This is the “multiple” in multiple dispatch.
"""

# ╔═╡ 5238dcf1-ae8c-47f2-b263-b3a26b20bb14
md"""
## Exercises
"""

# ╔═╡ 5f4a3153-000a-4ac4-8a38-1237757e681f
md"""
### Exercise 1

Explore the package [StaticArrays.jl](https://github.com/JuliaArrays/StaticArrays.jl).

- Describe two abstract types and the hierarchy of three different concrete types.
- Benchmark the calculation of some simple linear algebra with a static array
  compared to the following for a dense array for `N = 3` and `N = 15`.
"""

# ╔═╡ decd7e32-6efe-41a8-9cf5-ed9a33882181
SVector

# ╔═╡ c2a02b23-3518-4057-b2e7-fafae8ec619d
typeof(SVector(1, 2, 3))

# ╔═╡ 860d469d-9d57-48ef-9d8d-92c01f4ff822
SMatrix

# ╔═╡ ab99e6bf-5ae0-465f-91cb-7631a2fa7ef2
typeof(@SMatrix rand(2, 2))

# ╔═╡ 03212b3a-97ab-4d7e-87b4-a36e7c6c057f
Number

# ╔═╡ c4b44f52-6e07-40f0-a3f1-157e926c5ca0
supertype(Int64)

# ╔═╡ 38348553-6a6d-43c9-a325-08d26429653f
supertype(Integer)

# ╔═╡ b94cbd00-6663-4062-8a49-b1b8d2fc105b
supertype(Real)

# ╔═╡ 6e8f2013-5ec1-45fe-8feb-e20cc536cf25
supertype(Number)

# ╔═╡ 6744aa05-ea30-4067-b7c8-813ee495d2b6
1 isa Number

# ╔═╡ 3de822ef-d58f-4435-b602-e9218c4859b1
1 isa Integer

# ╔═╡ 29991e49-bc91-45ff-b2da-0e3cb2facf13
1 isa Real

# ╔═╡ d161a739-137a-49e9-acf7-ec13a090cad8
1 isa Int64

# ╔═╡ d986a18e-5b98-4105-8eca-a55d01bc3f64
let
	N = 3
	A = rand(N, N)
	x = rand(N)

	b1 = @benchmark $A * $x  # the $ in front of variable names is sometimes important
	b2 = @benchmark inv($A)
	b1, b2
end

# ╔═╡ 6872e879-6340-44a6-b20f-5308d634338b
let
	N = 3
	A = @SMatrix rand(N, N)
	x = @SVector rand(N)

	b1 = @benchmark $A * $x  # the $ in front of variable names is sometimes important
	b2 = @benchmark inv($A)
	b1, b2
end

# ╔═╡ 2cfa2480-c872-4edc-94e7-1bcf037d4936
md"""
### Exercise 2

A key step in the calculation of the Kalman Filter is calculation of the Kalman gain, as can be seen with the following example using dense matrices from [the Kalman lecture](https://julia.quantecon.org/../tools_and_techniques/kalman.html).

Using what you learned from Exercise 1, benchmark this using Static Arrays
"""

# ╔═╡ bc2d129c-91bb-4085-baf3-50fad486deb0
let
	Σ = @SMatrix[0.4  0.3;
		 0.3  0.45]
	G = I
	R = 0.5 * Σ

	gain(Σ, G, R) = Σ * G' * inv(G * Σ * G' + R)
	@benchmark $gain($Σ, $G, $R)
end

# ╔═╡ 2db0c550-01bd-4077-bdda-9d82229b9104
let
	Σ = [0.4  0.3;
		 0.3  0.45]
	G = I
	R = 0.5 * Σ

	gain(Σ, G, R) = Σ * G' * inv(G * Σ * G' + R)
	@benchmark $gain($Σ, $G, $R)
end

# ╔═╡ c8d0430d-36d7-483a-b9e0-00a63747308a
md"""
How many times faster are static arrays in this example?
"""

# ╔═╡ 7ede61f4-cf93-40bc-9e87-f5e653888202
md"""
### Exercise 3

The [Polynomial.jl](https://github.com/JuliaMath/Polynomials.jl) provides a package for simple univariate Polynomials.
"""

# ╔═╡ e7a0f3d3-5988-4f0b-9310-cdec0b040931
p = Polynomial([2, -5, 2], :x)  # :x just gives a symbol for display

# ╔═╡ 26c70eb1-5c9a-4d58-9cfb-fcaae6372ee5
with_terminal() do
	p′ = derivative(p)   # gives the derivative of p, another polynomial
	@show p(0.1), p′(0.1)  # call like a function
	@show roots(p);   # find roots such that p(x) = 0
end

# ╔═╡ bc43d9c2-66bd-4282-a8b1-dd4646c1e47f
md"""
Plot both `p(x)` and `p′(x)` for $x \in [-2, 2]$.
"""

# ╔═╡ 4f82143d-15bc-40af-9ba0-90a3a7ffc725
begin
	fig = plot(p, -2, 2)
	plot!(derivative(p), -2, 2)
	fig
end

# ╔═╡ 4ac167bc-1891-4475-a17b-0b7d4cdc3e91
typeof(p)

# ╔═╡ 8395fb27-25f0-49fb-9d5b-373a4180532b
md"""
# Dependencies
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
BenchmarkTools = "~1.1.4"
ForwardDiff = "~0.10.19"
Parameters = "~0.12.2"
PlotlyBase = "~0.8.13"
Plots = "~1.21.3"
PlutoUI = "~0.7.9"
Polynomials = "~2.0.14"
StaticArrays = "~1.2.12"
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

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

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
git-tree-sha1 = "7eb4ec38e1c4e00fea999256e9eb11ee7ede0c69"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.16"

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
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "0bbfdcd8cda81b8144de4be8a67f5717e959a005"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.14"

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

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "1700b86ad59348c0f9f68ddc95117071f947072d"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.1"

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
# ╟─6c95c3e6-ee1f-4269-a2a0-be4fed0a2b9a
# ╟─4a5d7fdc-0283-4e75-b8c1-32a392333996
# ╟─d878fc00-93e2-4c2c-908c-5e5039cbe9e6
# ╟─800990bf-7e9d-419b-bb80-8147ef03c012
# ╠═834ca983-bb32-4426-b122-9be9a821a645
# ╟─5bb8f3ec-8e76-4f15-b590-d768cd21fb2c
# ╟─4236d872-1be6-4581-8b26-deea4984bf02
# ╠═37e08965-ae8d-41cc-898c-649f5acdcae1
# ╟─b3608ad2-8c2f-4ebe-bcd9-70821b856da8
# ╠═7a5b374d-8355-4525-95f6-6c97648fec09
# ╟─616ebea1-8136-4789-b439-e21887bb01d9
# ╟─e959da83-9d66-48b9-9ed8-3c936240d823
# ╠═c4365cec-3ff8-4ad0-a891-4eb4b4573f42
# ╟─dba322cd-240c-49a9-8f74-de1bf1749bb7
# ╠═7570163b-e47f-4a1e-aad8-8376b7276617
# ╟─f8884394-b5f2-4a0b-a71e-d4dfa73bfb3b
# ╠═8297b497-08bf-4973-9e27-cdac9ae06adf
# ╟─7b08e82d-29c9-4873-bb24-e6313275c11b
# ╠═479c76f7-af2f-4ec5-ae2c-3cdaade896fd
# ╟─dcfd7014-81a3-4ffc-9bab-7388ee5cb4b5
# ╟─c2127863-d10d-45cd-84fa-e001a8d0aacd
# ╠═e576cb0f-1ad6-46bb-9a87-237a43df74cd
# ╟─fa17a200-5e33-40cb-be19-40a878817af6
# ╟─f483e5b4-e984-4be7-82e2-2c1426e084dc
# ╟─d1b3fb64-eca4-4286-91ff-8c0f8219c2f6
# ╟─b1aeb00b-756a-4edf-9a6c-2bb1f09aecb1
# ╠═41a1b28a-f602-4df3-ba6b-302773642a54
# ╟─8ad1b3d9-71f5-492b-a00b-34afe903a8a2
# ╠═959d0a0a-df82-4503-9778-de8a3914b1d2
# ╟─54ea88d4-125a-4dc4-958c-c3978f3b862c
# ╠═01ac6c62-a6b1-4bc0-ae1f-cd274b5405c7
# ╟─69cc5e4a-715b-4689-9f30-25aaf222fc68
# ╠═19f75cac-89ba-4f53-b528-f3e6f7811589
# ╟─d4b6ac90-6677-4e1f-a260-003a8332c22e
# ╠═772a082e-c279-425d-ab34-f114ea013446
# ╟─f5a182f4-daad-422d-812a-7b9dc58ebc86
# ╠═0bdb3cce-919d-4fbe-9504-ef893b1b59d2
# ╟─6ab88815-bd0c-435d-8cbb-022ba5a3abf5
# ╠═7e0365f6-172c-4f0e-b570-d51d36ca65f3
# ╟─ace5dbad-7dcb-452d-a73c-c5756291fe36
# ╠═fc23c125-2751-4fc8-829f-f763f27a8219
# ╟─a5feac12-69e7-4d68-ad4a-ece589394010
# ╠═4c14a0eb-94ee-44f1-8ca3-a06dc991b3d0
# ╟─0654c732-5eb2-4c8c-ab2b-9774d6e0bc2f
# ╟─547d4df4-ece6-4ba7-8f57-fd08f1f615ed
# ╠═c9de02da-091b-4b23-9973-d0d13cdf697d
# ╠═c7187fae-d148-4899-9be1-d0c012b4cad9
# ╟─ae1d5137-819b-4153-94b5-5917257d72d4
# ╠═a614ee6e-1871-43bf-8f96-207f82844f5e
# ╟─f70b7fb2-0e9c-4f39-b986-d3ff20acddc5
# ╟─e967ba4d-8cb9-417d-9ded-454ca9303683
# ╠═7d27a06e-782d-453a-be56-567786704e61
# ╟─cf33c56c-0ef5-4d82-9ef2-2d43810a835f
# ╠═244ef85e-7ac6-4fe1-8cba-dc2b768bed11
# ╟─9118ee77-ae6d-490a-9886-665464721fcd
# ╠═8a3fe30c-1591-44f9-ab29-adbef2ac9b3f
# ╟─9a7e1775-688f-4822-82f0-1581c0515be5
# ╟─b3f1dd6f-1e5a-4f13-96e4-7df86b59540a
# ╠═7fe1cf97-a65f-446f-927f-ab90a07c731e
# ╟─c56be32e-d57d-4d4f-b03e-ed1f314bd1c0
# ╠═01cc6a25-7c25-4276-a00f-4dcf7dbb6c6f
# ╠═3c481c55-2dc5-48f2-83bf-69d50908e5b8
# ╟─6e2a9f70-f5da-4b29-b6d0-55fb7f14061a
# ╠═4bc96799-d29c-4f4a-bf97-c13a2f50ad1c
# ╠═1d8bb850-8f49-4d58-9057-2a34037e8615
# ╟─ff886c74-6757-4e83-9fc7-ec193fab3986
# ╠═094727df-7a85-490e-90aa-d25f75db8333
# ╠═e7e523d5-1f96-4794-906a-206b3c29f048
# ╟─740006d6-4449-4dd5-a80b-0e2f112084de
# ╟─579d1573-f1f3-478a-9519-097e52da8bc1
# ╠═0686f351-3506-4fa1-b3bd-cd1e34a6e9d3
# ╠═7df21cc4-a591-44e7-9924-5b17a901fd66
# ╠═44d17bac-023d-4e7f-9214-cca839e4d58f
# ╟─3b7d4e02-88b2-4f54-9cbf-9545ec1194df
# ╠═c0c365f7-7227-419b-b668-c2c0d34d06a7
# ╟─3d47df6d-3d28-4fd0-9d09-69b5764a95f5
# ╠═4c192cf9-0be8-47b4-9e92-328109b31851
# ╟─02597c6a-47d8-498a-b43a-544143103406
# ╠═ca3e5e66-27be-4eb5-9cdc-46a746612c67
# ╠═461d1738-7097-4aaa-9c26-72370aa598e6
# ╟─67bd2c52-0303-4b68-815b-18738d020528
# ╠═78aa7140-aa1d-41c4-bfee-d2b093c1040b
# ╠═abe3c90e-1974-479a-99e9-bd0732e392b5
# ╠═09731d3d-28d6-438b-ba78-235372c4b153
# ╠═90d7cef9-69f5-4e34-8c29-96d36bb3c4eb
# ╟─5c65a637-ff3e-4464-925d-f6eff9a34ebc
# ╠═46fb85cb-ac3f-48b9-8362-48972cd6a4eb
# ╟─e0465942-2c9c-4c36-b6d5-ca2b51ba79b8
# ╠═adc52660-fd13-4d6f-8c87-47c1211ebb8e
# ╟─eb247237-e420-4f11-a384-461bf1f031f8
# ╠═fc34cc18-3aa7-4431-8ae8-32d6012698b5
# ╟─e3c76c6d-47ae-42c5-bfff-491a29b74338
# ╟─183b404a-5a2d-4634-b22a-98584e1f7c0b
# ╟─68e66604-3c20-4be1-9900-2dad79c7eb57
# ╟─cc94811f-f7e4-4a9e-8012-873c30f11d8b
# ╠═ef2bd101-fa0c-465e-aab9-f6bff49ef475
# ╟─fc047b8c-1181-4b0b-9a46-8f1c24aa5de7
# ╠═78ee0c54-26b0-4db2-a50a-8b6848d4bbd2
# ╠═e7af2cd8-a091-4187-8de7-3daf07f48e07
# ╠═1831ad29-3517-4bcc-a0de-e2c8ba957b97
# ╟─2e9f8220-b243-4fc8-8ffc-8e48992acb4e
# ╠═1a637203-6094-45a8-93d7-d1263a507162
# ╟─d761a0e7-f3ec-47ac-b5a9-27ee73411f14
# ╟─b1cb7b79-1500-414f-8c02-6312d22a2362
# ╠═7a21c4da-26ce-4964-86aa-7a9a71b523cd
# ╠═3cae6311-cd8d-40b8-b651-acb42b0d2208
# ╠═c35f8c11-a015-4223-9b95-7d6eb41476a5
# ╟─cedb6183-5ec5-416e-9f6a-e1a20fe6fed2
# ╠═dfce0b85-9e85-4d0f-8cdd-9a78b338d405
# ╟─a6085106-930d-428d-87a8-70702f265c17
# ╠═af3ae116-a525-48f9-a2ec-786ed50a3afc
# ╟─c31f8512-3dc6-46e8-bc15-35209241cbf4
# ╠═ce96ea2b-c350-4504-ae82-1e7d39ae0f4b
# ╟─b053a166-85c9-495f-9abd-3fa0c10834b6
# ╠═b7afc892-6b17-4f58-8897-7f3d86cb4f7b
# ╟─1e420454-a44b-4f8c-9d30-0c699e84d30d
# ╟─72ee4fca-ab36-4ee4-9089-850ed8d6e995
# ╟─507f706b-9e39-4de7-850b-b38c64302445
# ╠═f5b144e8-4bf7-4918-bffe-8c1c103f23fb
# ╟─33a052ce-fee1-4547-b3ec-138747e53740
# ╠═58f1fb96-85bb-4936-97cb-ab2c696ae09e
# ╠═444db70c-7f92-40a7-b4cc-ecb4ad6e61b8
# ╠═299b8de5-c012-4dfe-95a6-c62c70b36f68
# ╠═740ca2c3-681e-46cd-990d-e56cd11b1097
# ╟─3572e479-1135-4240-a5bb-fe53191f1db8
# ╠═232d1d98-342c-4919-a594-5f0ab7398982
# ╠═13912601-7f54-46ea-a6d2-f34a93968f94
# ╟─c9514ffd-08c2-4216-a0fc-7143fd74adfd
# ╠═592d8023-42c0-4f26-bdb6-68ef4b76c29d
# ╠═9598f2bb-d3ad-42ec-84d7-8797e903fb84
# ╟─3c24d9ba-174e-419b-8ffe-be3190f5fe94
# ╟─5238dcf1-ae8c-47f2-b263-b3a26b20bb14
# ╟─5f4a3153-000a-4ac4-8a38-1237757e681f
# ╠═c47b72a8-4ae4-4c31-bedc-70f3bfcb3fab
# ╠═decd7e32-6efe-41a8-9cf5-ed9a33882181
# ╠═c2a02b23-3518-4057-b2e7-fafae8ec619d
# ╠═860d469d-9d57-48ef-9d8d-92c01f4ff822
# ╠═ab99e6bf-5ae0-465f-91cb-7631a2fa7ef2
# ╠═03212b3a-97ab-4d7e-87b4-a36e7c6c057f
# ╠═c4b44f52-6e07-40f0-a3f1-157e926c5ca0
# ╠═38348553-6a6d-43c9-a325-08d26429653f
# ╠═b94cbd00-6663-4062-8a49-b1b8d2fc105b
# ╠═6e8f2013-5ec1-45fe-8feb-e20cc536cf25
# ╠═6744aa05-ea30-4067-b7c8-813ee495d2b6
# ╠═3de822ef-d58f-4435-b602-e9218c4859b1
# ╠═29991e49-bc91-45ff-b2da-0e3cb2facf13
# ╠═d161a739-137a-49e9-acf7-ec13a090cad8
# ╠═77faa48c-0d35-4d3f-8473-aacdc1ee3eec
# ╠═d986a18e-5b98-4105-8eca-a55d01bc3f64
# ╠═6872e879-6340-44a6-b20f-5308d634338b
# ╟─2cfa2480-c872-4edc-94e7-1bcf037d4936
# ╠═bc2d129c-91bb-4085-baf3-50fad486deb0
# ╠═2db0c550-01bd-4077-bdda-9d82229b9104
# ╟─c8d0430d-36d7-483a-b9e0-00a63747308a
# ╟─7ede61f4-cf93-40bc-9e87-f5e653888202
# ╠═b22743f6-b735-4869-8417-634d2246c572
# ╠═e7a0f3d3-5988-4f0b-9310-cdec0b040931
# ╠═26c70eb1-5c9a-4d58-9cfb-fcaae6372ee5
# ╟─bc43d9c2-66bd-4282-a8b1-dd4646c1e47f
# ╠═867ffdd5-cdeb-43dc-95a4-bca4cfa067b7
# ╠═4f82143d-15bc-40af-9ba0-90a3a7ffc725
# ╠═4ac167bc-1891-4475-a17b-0b7d4cdc3e91
# ╟─8395fb27-25f0-49fb-9d5b-373a4180532b
# ╠═522abd65-175d-4a6c-960b-d8bf3cc5ceed
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
