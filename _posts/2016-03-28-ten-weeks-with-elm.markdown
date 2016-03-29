---
layout: post
title:  "Ten Weeks With Elm"
subtitle: "Some Vague Unsolicited Thoughts"
date:   2016-3-28 
categories: technical
tags: elm
---

This past quarter, I had the opportunity to take a class entitled "Functional Programming", which I thought would be in Haskell, but ended up being in Elm--you know, that trendy new functional language that was built as a thesis project in 2012 and compiles to HTML, CSS, and JavaScript.

At the end of the class, I ended up with [this Monte Carlo pi approximator](http://catmores.co/static/Pi.html), [this interactive introduction to Fourier transforms](http://catmores.co/static/fourier-elm/Fourier.html), and [this Fourier transform game](http://catmores.co/static/fourier-elm/FFTDemo.html) that I don't recommend trying unless you have a very good knowledge of common FTs and a very steady hand. The latter two of these are built on a *very* barebones graphing library that I had to write myself (that I hope to polish up a bit soon and put on GitHub).

I also left the class with some opinions on Elm, which I figured I'd write down somewhere. 

## The Good
- *Elm forces you to be organized when you write code*. This, for me, was probably the biggest positive aspect of developing with Elm; writing in a functional language and letting the compiler take care of the JavaScript means that you're writing code with minimal side effects, working with strict types and immutable values. The state is all kept in one place and is built directly from well-defined inputs and mutation of a fixed initial state. As a result, runtime errors are far, far more infrequent in Elm that JavaScript.

- *Functional programming is fun*. Seriously, slapping together some maps and foldrs to solve a problem is like a puzzle; it's a totally different way of thinking than imperative programming, and can be refreshing.

- *Some parts of Elm are especially elegant, like creating layouts*. The way Elm handles HTML and CSS is nicer than I expected; someone once mentionted an Elm demo to me where someone vertically centered a div with a single line of Elm, to thunderous applause. (Whether this is a poor reflection on the current state of CSS/HTML, rather than a triumph of Elm, is a valid question.)

## The Parts I Wasn't Impressed With

- *It can, at times, feel like overkill*. I ended up writing most of the Fourier introduction above in HTML/CSS, and just embedding the Elm widgets; since the basic layout is so straightforward and done easily in HTML and CSS, creating it functionally in Elm (especially with the somewhat clumsy styling in pure Elm) seemed like a pointless and arduous exercise (the game, though, is almost entirely pure Elm).

- *It doesn't have typeclasses*. Pardon my momentary, wistful gaze at Haskell.

- *Pure Elm can be very slow, and not-pure Elm feels to me like cheating*. In Elm, state is built up from an initial state over time--conceptually, current state is computed by re-executing all past computations, although the compiler obviously optimizes this. However, Elm can still be much slower than standard hand-written HTML/CSS/JS, especially where graphics involving a lot of elements are involved. Libraries like the elm-html library attempt to solve this problem, but at some points I did find myself wondering where the marginal benefit to using Elm was as I found myself building each individual HTML element, setting attributes, etc. exactly as I would with normal HTML/CSS.



## Overall

On the whole, Elm was fun and different, if not particularly challenging (if you already have some functional programming experience). Would I recommend you try to build a heavy-duty web application with it? No, probably not. At least, not yet. If you enjoy functional programming, you should definitely play around with it, though; there's something really compelling and elegant about functional reactive programming, even if I'm not yet entirely convinced I'd want to use it to build any larger, more complex applications.

