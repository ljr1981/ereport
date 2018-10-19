note
	description: "Summary description for {PDF_DOCS}."

	high_level_documentation: "[
		Project is laid out per the ISO-32000:1 v2008 Specification (see EIS PDF)
		
		Project folder structure roughly follows the specification outline, where
		each section and subsection are folders and subfolders.
		
		For example: There are two basic structures for a PDF: 
			- Logical (document structure)
			- Physical (file structure)

		See the corresponding "spec_nn_nn" folder in the Groups view (to right in ES IDE).
		
		A current example of how to create (generate) a working PDF file can be found here:
		
		{PDF_TEST_SET}.sample_pdf_generation_test
		
		See the general notes for the test routine (above).
		]"

	EIS: "name=pdf_spec", "protocol=pdf", "src=.\docs\spec\PDF32000_2008.pdf"

deferred class
	PDF_DOCS

end
