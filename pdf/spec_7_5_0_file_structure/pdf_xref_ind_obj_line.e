note
	description: "Summary description for {PDF_XREF_IND_OBJ_LINE}."

class
	PDF_XREF_IND_OBJ_LINE

inherit
	PDF_ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			Precursor
			line.do_nothing
		end

feature -- Access

	line_offset_value: INTEGER

	line_offset_string: STRING
			-- `line_offset_string' of Current.
		do
			Result := line_offset_value.out
			Result.prepend (create {STRING}.make_filled ('0', Line_offset_width - line_offset_value.out.count))
		ensure
			valid_count: Result.count = Line_offset_width
		end

	generation_value: INTEGER

	generation_string: STRING
			-- `generation_string' of Current.
		do
			Result := generation_value.out
			Result.prepend (create {STRING}.make_filled ('0', Generation_number_width - generation_value.out.count))
		ensure
			valid_count: Result.count = Generation_number_width
		end

	line: STRING
			-- `line' of Current
		do
			Result := line_offset_string
			Result.append_character (' ')
			Result.append_string_general (generation_string)
			Result.append_character (' ')
			if is_free then
				Result.append_character (Free_char)
			else
				Result.append_character (In_use_char)
			end
			Result.append_string_general (EOL_marker)
		ensure
			is_valid_result: is_valid_format (Result)
		end

	first_line: STRING
		do
			create Result.make_empty
			Result.append_string_general ("0000000000")
			check Result.count = 10 end
			Result.append_character (' ')
			check Result.count = 11 end
			Result.append_string_general ("65535")
			check Result.count = 16 end
			Result.append_character (' ')
			check Result.count = 17 end
			Result.append_character ('f')
			check Result.count = 18 end
			Result.append_string_general (EOL_marker)
		ensure
			Result.count = Fixed_line_width
		end

feature -- Queries

	is_free: BOOLEAN
			-- Current is "Free" (f) (see `Free_char')

	is_in_use: BOOLEAN
			-- Current is "In-use" (n) (see `In_use_char')
		do
			Result := not is_free
		end

feature -- Settings

	set_line_offset (i: INTEGER)
			--
		do
			line_offset_value := i
		end

	set_generation_value (i: INTEGER)
			--
		require
			i_in_range: (0 |..| 65535).has (i)
		do
			generation_value := i
		end

	set_free
			--
		do
			is_free := True
		end

	set_in_use
			--
		do
			is_free := False
		end

feature -- Output

	pdf_out: STRING
			-- <Precursor>
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation: Status Report

	is_valid_format (a_line: like line): BOOLEAN
			--
		do
			Result := line.count = Fixed_line_width
			Result := Result and then (a_line [19].code = {ASCII}.carriage_return and then a_line [20].code = {ASCII}.line_feed implies
				a_line.substring (19, 20).same_string (EOL_marker))
			Result := Result and then (a_line [11].code = {ASCII}.sp and then a_line [17].code = {ASCII}.sp)
			Result := Result and then (a_line [18] = Free_char xor a_line [18] = In_use_char)
		end

feature {NONE} -- Constants

	Fixed_line_width: INTEGER = 20

	Line_offset_width: INTEGER = 10

	Generation_number_width: INTEGER = 5

	Free_char: CHARACTER = 'f'
	In_use_char: CHARACTER = 'n'

	EOL_marker: STRING
			--
		once
			create Result.make_empty
			Result.append_character ('%R') -- CR
			Result.append_character ('%N') -- LF
		ensure
			Result.count = 2
		end

invariant
	mutex: (is_free implies not is_in_use) and then (not is_free implies is_in_use)
	is_valid_format: is_valid_format (line)
	is_valid_first: is_valid_format (First_line)
	First_line: First_line.count = 20 and then ( attached {STRING} ("0000000000 65535 f" + EOL_marker) as al_first_line and then First_line.same_string (al_first_line) )

	line_offset_width: line_offset_string.count = Line_offset_width
	in_range: (0 |..| 65535).has (generation_value)

;note
	main_spec: "7.5.4 Cross-Reference Table"
	other_specs: ""
	specifications: "[
		Each of Current (as a line) is 20 characters precisely.
		]"
	legend: "[
		nnnnnnnnnn		10-digit number representing offset value
		ggggg			5-digit number representing ...
		n|f				where n=in-use and f=free
		oel				2-digit EOL (end-of-line) marker consisting of: SP CR | SP LF | CR LF
		]"
	in_use_entry_format: "[
nnnnnnnnnn ggggg n eol
]"
	glossary: "[
		Free vs In-use: 	
			Refers to a line entry which references a PDF_INDIRECT_OBJECT. When
			an indirect object is deleted from the pdf, it is no longer
			"in-use", but is now "free". Thus, IND_OBJs in a freshly generated
			PDF are always marked as 'n' (in-use) and one marked 'f' (free).
		
		First Entry:
			The first entry in a xref table is always a free 'f' entry. Therefore,
			it is marked with 'f' and has a generation number of 65535, which is
			the max generation number.
			
			ex: 0000000000 65535 f eol
		]"

end
