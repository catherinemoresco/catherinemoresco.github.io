---
layout: post
title:  "Converting PDF to JPG, Again"
subtitle: "Teaching My Computer to Read, Part 2"
date:   2014-11-19 22:52:30
categories: technical
tags: pdf
---

In my [last post](http://0.0.0.0:4000/cv/pdf/2014/11/12/teaching-my-computer-to-read-pdfs-are-evil.html), I talked about how I frantically searched for ways to get my PDFs into JPGs, and how in a caffiene-fueled 4 AM haze I stumbled upon PythonMagick and decided to use it. 

In my last post, I called it "slow" and "ugly" but I didn't realize how true those words were until I tried to use my image-extracting module into the rest of our application, and started getting outputs like this:

<p align="center">
<img src="/img/2014-11-19/imagemagicksucks.jpg">
</p>

This is very bad. I don't think I need to point that out. It's especially bad when you consider the fact that this level of resolution takes over one second of processing per page to happen (as calculated by my highly scientific, "one-Mississippi-two-Mississippi" counting benchmark method. I would love to run actual tests on performance, but unfortunately this is a project I'm expected to finish within the week.).

Increasing the image DPI helps, but the result still isn't antialiased at all, so any result that can be achieved in a reasonable amount of time is going to look pretty bad.

I figured there might be something in PythonMagick to help me out, so I looked for documentation, only to realize (to my horror) that there actually isn't a whole lot of it.

There's some in the package's [readme](http://www.imagemagick.org/download/python/README.txt), but it doesn't seem to be particularly comprehensive; some of the methods I had already been using from some example code I had found on the internet weren't even there. My alternatives were to try to infer what was going on from the documentation for [Magick++](http://www.imagemagick.org/Magick++/Documentation.html), the C++ API, or to figure it out myself by running

```python
	import PythonMagick
	dir(PythonMagick.Image())
```
and seeing what it spat out. I tried this, and there was (Ah-HAH!) a method called antiAlias--but I gave that a shot, and it didn't seem capable of operating on PDFs being read; my guess it that is meant for use with drawing functions.

And that's where I gave up on ImageMagick. I realized I could either keep on trying to hack togther something with it that would inevitably only increase runtime further, or I could go back to the drawing board.

I went back to the drawing board. As it turns out, ImageMagick performs its PDF rendering functions with calls to Ghostscript, anyway; I decided to do away with ImageMagick and escape from slow, poorly-documented, impossible-to-install PythonMagick hell by working with Ghostscript directly. Bertan Guven did some [more scientific comparisons of Ghostscript and ImageMagick performance](http://bertanguven.com/faster-conversions-from-pdf-to-pngjpeg-imagemagick-vs-ghostscript/), and his results indicate that Ghostscript is significantly faster.

Ghostscript doesn't have Python bindings, so I ran it as a subprocess--and, since we need to process the images after they are extracted (and writing each file and then reading it and then writing it again is definitely not the most efficient way to go about things), I redirected the file output to a buffer.

```python
	def getStream(filename):
	    ## run ghostscript command as a subprocess and get output
	    pipe = subprocess.Popen("gs -dNOPAUSE -sDEVICE=jpeg -sOutputFile=%stdout -dJPEGQ=100 -r300 -q "+ filename + " -c quit", stdout=subprocess.PIPE, shell=True)
	    out, err = pipe.communicate()

	    bytes = io.BytesIO(out)
	    stream = bytes.read()

	    return stream
```

I only want to make one call to Ghostscript, but I also have multiple images to extract, so we have to parse the resulting byte stream to separate them, and then decode them using OpenCv.

All JPGs start with `b'\xff\xd8'` and end with `b'\xff\xd9'`.

```python
	def extractImages(filename): 
	    stream = getStream(filename)

	    imgstart = 0
	    imgend = 0
	    i = 0

	    ## parse for jpgs
	    decoded_images = []
	    while True:
	        next_img_start = stream.find(b'\xff\xd8', i)
	        if next_img_start < 0:
	            break
	        next_img_end = stream.find(b'\xff\xd9', i)
	        if next_img_end < 0:
	            break

	        ## get and decode image bytes
	        decoded_image = cv2.imdecode(np.fromstring(stream[next_img_start:next_img_end+2], np.uint8), cv2.CV_LOAD_IMAGE_COLOR)
	        decoded_images.append(decoded_image)
	        i = next_img_end + 2
	    return decoded_images
```

This returns a list of images, which is exactly what my previous implementation did--only this is significantly faster, and doesn't rely on PythonMagick. 

Here's a sample result image, rendered at 300 DPI and which ran in a comparable amount of time to our original PythonMagick implementation:

<p align="center">
<img src="/img/2014-11-19/ghostscriptisawesome.jpg" style="height:500px">
</p>

I am happy.

*Next Time:* [Skew detection](http://catmores.co/technical/2014/12/15/teaching-my-computer-to-read-skew-detection.html)! (For real this time, I promise. Sorry for the digression.)

