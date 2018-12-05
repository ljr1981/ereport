note
	description: "Representation of a {PDF_CONTENT_STREAM}."
	example: "[
5 0 obj
	<< /Length 35 >>
stream
	... Page-marking operators ...
endstream
endobj
]"

class
	PDF_CONTENT_STREAM

inherit
	PDF_INDIRECT_OBJECT
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
			-- `dictionary' creation and basic /Type /Catalog setting.
		do
			Precursor
			create dictionary
			dictionary.add_object (Length)
			add_object (dictionary)
			create stream
			add_object (stream)
			set_length (0)
		end

feature -- Access

	stream: PDF_STREAM_OBJECT
			-- stream ... endstream container

	length: PDF_KEY_VALUE_INTEGER
			-- Key (Length) Value (count) pair.
		attribute
			create Result.make ("Type", count)
		end

	count: INTEGER

	dictionary: PDF_DICTIONARY_GENERAL
			-- Contains a `dictionary'.

feature -- Adders

	add_stream_object (a_object: PDF_OBJECT [detachable ANY])
		do
			stream.add_object (a_object)
		ensure
			added: attached stream.objects as al_objects and then al_objects.has (a_object)
		end

feature -- Settings

	set_length (a_length: INTEGER)
			-- `set_length' of `a_length' into `length'
		local
			l_value: TUPLE [PDF_NAME, PDF_INTEGER]
		do
			l_value := [create {PDF_NAME}.make ("Length"), create {PDF_INTEGER}.make_with_integer (a_length)]
			length.set_value (l_value)
		ensure
			set: attached {PDF_INTEGER} length.value as al_length_value and then al_length_value.value = a_length
		end

end
