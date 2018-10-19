# ereport
Eiffel Report Generator based on PDF library code.

See the PDF_DOC class for recent changes to this readme.

##		PROJECT STRUCTURE
		Project is laid out per the ISO-32000:1 v2008 Specification (see EIS PDF above).
		
		Project folder structure roughly follows the specification outline, where
		each section and subsection are folders and subfolders.
		
		For example: There are two basic structures for a PDF: 
			- Logical (document structure)
			- Physical (file structure)

		See the corresponding "spec_nn_nn" folder in the Groups view (to right in ES IDE).
		
##		EXAMPLE PDF GENERATION
		A current example of how to create (generate) a working PDF file can be found here:
		
		{PDF_TEST_SET}.sample_pdf_generation_test
		
		See the general notes for the test routine (above). You will have to open the
		"test target" in order to see the test code (above).
		
		FUTURE WORK
		===========
		The current understand I have (as a library producer) is how to create simple
		Text-based PDF files and this library currently reflects that knowledge. An
		additional bit of understanding has to do with how to position and control the
		size of the page (through sizing of media-box) and then how to position text as
		a stream in said box.
		
		From this basis, I plan to do the following immediately to make this library a
		usuable contribution, where it is simple enough for you (as a library consumer)
		to quickly and easily utilize it to produce output from Eiffel programs directly
		into Text-based PDF documents.
		
###		Planned Work
		- Pages:		A simple class to collect and hold pages (not just PDF_PAGE_TREE).
		- Lines:		A simple class that takes a collection of text lines and writes
						top-to-bottom on a single page.
		- Paragraphs:	A simple class that can paint paragraphs of text (not just lines),
						wrapping said paragraph text between the margins (bounding box) of
						the media-box.
		- Tables:		A simple class that can take a 2-dim array of text items (cells)
						and paint them into a tabular layout on the page with respect to
						the bounding box of the media box.
		- Headers: 		A simple class to add page headers, titles, dates, times, etc.
		- Footers: 		A simple class to add page footers, page numbers, totals, etc.
		
		NOTE: When it comes to tables, the code will be very simple (to start). You will need
				to provide your own computations like totals, grand totals, sub totals and
				so on. This generator is not intended to make that provision. That is the
				job of your code, not this library.
				
###		Much Later Work
		- Graphics:		For example: Adding lines for tables and perhaps logos for report
						headers or even graphs (there is a basic graphing library written
						completely in Eiffel that produces PNG graphs, which can then be
						added to the report).
		- Text-opts:	Fine control of text transformations and other matters (see spec 8.x)
		
##		WHAT LIBRARY WILL NOT YET DO
		Graphics!
		Encryption!
		Compression!

