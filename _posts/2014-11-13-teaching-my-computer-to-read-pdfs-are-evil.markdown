---
layout: post
title:  "Teaching my Computer to Read, Part 1: Struggles with PDFs and Short-Sightedness"
date:   2014-11-13 5:11:00
categories: cv pdf
---


My favorite computer science classes are the ones that let you build whatever you want. My Introduction to Programming class consisted of a class wiki with student-posted problems, that you could complete whenever you wanted, however you wanted, in whatever language you wanted. It was awesome. 

My class this quarter, Software Construction, has a similar setup, though slightly more structured; working in teams of six, we get to present a proposal, complete with UML use case, class, and activity diagrams, and then implement it and test it rigorously.

I enjoy messing around with computer vision (that is, after all, why I [taught my fish to play Pokemon that one time](http://catherinemoresco.github.io/projects/)), so I decided to do a project that would involve some sweet OpenCV action.
 I also had a lot of readings to do for my philosophy class. Most of these were PDFs of poorly scanned documents. Even when the text lines were miraculously not affected by page curvature, they were often skewed. This is fine for reading, but since they're just scans they can't be highlighted in Preview for Mac, so I always have to resort to awkwardly drawing straight boxes around my skewed areas of interest, or spending minutes drawing individual lines under whole paragraphs and minutes more making them consistent in length and width.

<p align="center">
<img src="/img/2014-11-13/Nonideal_page.png">
<img src="/img/2014-11-13/Nonideal_boxed.png">
<img src="/img/2014-11-13/Nonideal_underlined.png">
</p>

*How hard could it be,* I thought, *to detect the lines and draw the highlights on myself?*

And, in the meantime, split pages in which there are two book-pages per PDF-page? And maybe rotate the pages ever-so-slightly so that they're straight again? 

And so my project was born.

It wasn't about teaching my computer to read, so much as to teach it the small accessory functions to reading, like straightening a page or laying it flat, without having to go through the trouble of OCR-ing the whole damn thing.

My first issue, through, was that image processing techniques are (tautologically) meant to process images, and PDFs are not images. In the moment of optimisim upon my conception of the project, this struck me as a trivial problem. After all, scans are just images, right? It can't be that hard to extract them from their barely-there PDF shell.


Except it can. Taking apart PDFs is hard. Extracting JPGs from PDFs *can* be easy (for example, take a look at [Ned Batchelder's code snippet](http://nedbatchelder.com/blog/200712/extracting_jpgs_from_pdfs.html) that accomplishes this in 20-ish lines of Python), but it can also be hard. As I discovered when I tried to run that same snippet on a few different documents and, to my horror, discovered that there are some images it just doesn't pick up on. It was then, and only then, (after I had gotten my project proposal approved and convinced some poor souls to hop on board with me) that I stumbled upon this [lovely soul-crushing article](https://blog.idrsolutions.com/2010/04/understanding-the-pdf-file-format-how-are-images-stored/), that kindly broke the news that "if you want to extract images from a PDF, you need to assemble the image from all the raw data – it is not stored as a complete image file you can just rip out."

Oops.

Luckily, there are PDF rendering libraries out there. I spent about eight hours researching them and then four trying to get the one that I decided on, [ImageMagick](http://www.imagemagick.org/), installed properly. That adds up to about twelve hours of seriously considering renaming our endeavor from "The PDF Project" to "Who Needs PDFs Anyway", and pivoting to work exclusively with tried and true image formats: JPG, PNG. Old friends.

So...we ended up with something that looks like this.

```python
	def extractImages(pdf):
	    images = []

	    pdf_im = PyPDF2.PdfFileReader(pdf)
	    npage = pdf_im.getNumPages()

	    for p in range(0, npage):
	        img = PythonMagick.Image()
	        blob = PythonMagick.Blob()
	        img.density("75")
	        ## read in pdf
	        img.read(pdf+"[" + str(p) + "]") 

	        ## write to buffer
	        img.write(blob, 'RGB', 16)
	        rawdata =  base64.b64decode(blob.base64())

	        ## convert raw data to np array
	        img = np.ndarray((img.rows(), img.columns(), 3),dtype='uint16', buffer=rawdata)
	        images.append(img)
	    return images
```

It's simple, and slow, and a little ugly, and it brings another third-party dependency into our cobbled-together little app, but it works.

And that's my punishment for not doing my research and fully expecting to be able to build a PDF renderer in a week.

Lesson learned.

*Next Time:* We delve into some *actual* document analysis with **skew detection!**

<div style="background:#fadbd7;margin:5px -10px 5px -10px;border-radius:4px;padding:10px;">
<span style="font-family:Raleway, Open Sans, sans-serif;">Edit 11/19/14:</span>
<br>I have since created a considerably improved implementation of rasterizing PDF documents, this time without PythonMagick; it's described in my next post, <a href="http://catmores.co/pdf/2014/11/19/teaching-my-computer-to-read-not-good-enough.html">Teaching My Computer to Read, Part 2: Converting PDF to JPG, Again</a>.
</div>
<br>

