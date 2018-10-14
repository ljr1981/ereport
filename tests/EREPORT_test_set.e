note
	description: "Tests of {EREPORT}."
	testing: "type/manual"

class
	EREPORT_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
			on_prepare
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	FW_PROCESS_HELPER
		undefine
			default_create
		end

feature {NONE} -- Initialization

	on_prepare
			-- <Precursor>
		local
			l_file: PLAIN_TEXT_FILE
			l_utf_converter: UTF_CONVERTER
		do
			create l_utf_converter

			create l_file.make_create_read_write (".\tests\assets\invoice.html")
			l_file.put_string (l_utf_converter.string_32_to_utf_8_string_8 (invoice_html))
			l_file.close

			create l_file.make_create_read_write (".\tests\assets\data.json")
			l_file.put_string (l_utf_converter.string_32_to_utf_8_string_8 (data_json))
			l_file.close

			create l_file.make_create_read_write (".\tests\assets\invoice.css")
			l_file.put_string (l_utf_converter.string_32_to_utf_8_string_8 (invoice_css))
			l_file.close
		end

feature -- Test routines

	ereport_tests
			-- `ereport_tests'
		local
			l_result: STRING
		do
			l_result := output_of_command (jsreport_cmd, jsreport_directory)
			assert_strings_equal ("jsreport_cli_result", jsreport_cli_result, l_result)
		end

feature {NONE} -- Implementation: Test Support

	jsreport_cmd: STRING = "[
.\jsreport\jsreport.exe render --template.engine=handlebars --template.recipe=chrome-pdf --template.content="invoice.html" --data="data.json" --out="out.pdf"
]"

	jsreport_directory: STRING = ".\tests\assets"

	jsreport_cli_result: STRING = "[

]"

	invoice_html: STRING = "[
<!-- 
Invoice dynamically rendered into html using handlebars and converted into pdf
using chrome-pdf recipe. The styles are extracted into separate asset for 
better readability and later reuse.

Data to this sample are mocked at the design time and should be filled on the 
incoming API request.
!-->

<html>
    <head>
        <meta content="text/html" http-equiv="Content-Type">
        <style>
            {#asset invoice.css}
        </style>        
    </head>
    <body>
        <div class="invoice-box">
            <table cellpadding="0" cellspacing="0">
                <tr class="top">
                    <td colspan="2">
                        <table>
                            <tr>
                                <td class="title">
                                    <img src="{#asset logo.png @encoding=dataURI}" style="width:100%; max-width:300px;" />
                                </td>
                                <td>
                                    Invoice #: {{number}}
                                    <br> Created: {{now}}
                                    <br> Due: {{nowPlus20Days}}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="information ">
                    <td colspan="2 ">
                        <table>
                            <tr>
                                <td>
                                    {{seller.name}}<br>
                                    {{seller.road}}<br>
                                    {{seller.country}}
                                </td>
                                <td>
                                    {{buyer.name}}<br>
                                    {{buyer.road}}<br>
                                    {{buyer.country}}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="heading ">
                    <td>
                        Item
                    </td>
                    <td>
                        Price
                    </td>
                </tr>
                {{#each items}}
                <tr class="item">
                    <td>
                        {{name}}
                    </td>
                    <td>
                        $ {{price}}
                    </td>
                </tr>
                {{/each}}
                <tr class="total ">
                    <td></td>
                    <td>
                        Total: ${{total items}}
                    </td>
                </tr>
            </table>
        </div>
    </body>
    <script text=javascript>
		function now() {
		    return new Date().toLocaleDateString();
		}

		function nowPlus20Days() {
		    var date = new Date();
		    date.setDate(date.getDate() + 20);
		    return date.toLocaleDateString();
		}

		function total(items) {
		    var sum = 0;
		    items.forEach(function (i) {
		        console.log('Calculating item ' + i.name + '; you should see this message in debug run');
		        sum += i.price;
		    });
		    return sum;
		}
    </script>
</html>
]"

	data_json: STRING = "[
{
    "number": "123",
    "seller": {
        "name": "Next Step Webs, Inc.",
        "road": "12345 Sunny Road",
        "country": "Sunnyville, TX 12345"
    },
    "buyer": {
        "name": "Acme Corp.",
        "road": "16 Johnson Road",
        "country": "Paris, France 8060"
    },
    "items": [{
        "name": "Website design",
        "price": 300
    }]
}
]"

	invoice_css: STRING = "[
.invoice-box {
    max-width: 800px;
    margin: auto;
    padding: 30px;
    border: 1px solid #eee;
    box-shadow: 0 0 10px rgba(0, 0, 0, .15);
    font-size: 16px;
    line-height: 24px;
    font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
    color: #555;
}
.invoice-box table {
    width: 100%;
    line-height: inherit;
    text-align: left;
}
.invoice-box table td {
    padding: 5px;
    vertical-align: top;
}
.invoice-box table tr td:nth-child(2) {
    text-align: right;
}
.invoice-box table tr.top table td {
    padding-bottom: 20px;
}
.invoice-box table tr.top table td.title {
    font-size: 45px;
    line-height: 45px;
    color: #333;
}
.invoice-box table tr.information table td {
    padding-bottom: 40px;
}
.invoice-box table tr.heading td {
    background: #eee;
    border-bottom: 1px solid #ddd;
    font-weight: bold;
}
.invoice-box table tr.details td {
    padding-bottom: 20px;
}
.invoice-box table tr.item td {
    border-bottom: 1px solid #eee;
}
.invoice-box table tr.item.last td {
    border-bottom: none;
}
.invoice-box table tr.total td:nth-child(2) {
    border-top: 2px solid #eee;
    font-weight: bold;
}
@media only screen and (max-width: 600px) {
    .invoice-box table tr.top table td {
        width: 100%;
        display: block;
        text-align: center;
    }
    .invoice-box table tr.information table td {
        width: 100%;
        display: block;
        text-align: center;
    }
}
]"

end
