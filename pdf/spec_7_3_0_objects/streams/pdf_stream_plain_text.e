note
	description: "Summary description for {PDF_STREAM_PLAIN_TEXT}."
	example: "[
<</Length 48
>>
stream
BT
/F1 20 Tf
120 120 Td
(Hello from Steve) Tj
ET
endstream
]"

class
	PDF_STREAM_PLAIN_TEXT

inherit
	PDF_STREAM_GENERAL [STRING]
		rename
			content as text,
			set_content as set_text
		end

feature -- Access

	text: attached like value
		do
			check has_value: attached value as al_value then
				Result := al_value.out
			end
		end

feature -- Settings

	set_text (a_text: attached like value)
			-- <Precursor>
		do
			set_value (a_text)
		end

end
