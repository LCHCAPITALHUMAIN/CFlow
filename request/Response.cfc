/*
   Copyright 2012 Neo Neo

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

component Response {

	include "../static/content.cfm"; // include the content() function, that calls cfcontent to set the content type

	public void function init() {

		variables.type = "HTML";
		variables.contentTypes = {
			HTML = "text/html",
			JSON = "application/json",
			TEXT = "text/plain"
		};
		variables.contents = [];
		variables.keys = [];

	}

	public void function setType(required string type) {
		variables.type = arguments.type;
	}

	public string function getType() {
		return variables.type;
	}

	public void function write(required any content, string key = "") {

		ArrayAppend(variables.contents, arguments.content);
		ArrayAppend(variables.keys, arguments.key);

	}

	/**
	 * Default implementation for rendering HTML and JSON.
	 **/
	public void function render(string key = "") {

		var result = "";
		var contents = variables.contents;

		if (Len(arguments.key) > 0) {
			contents = [];
			var index = ArrayFind(variables.keys, arguments.key);
			if (index > 0) {
				ArrayAppend(contents, variables.contents[index]);
			}
		}

		// set the content header
		content(variables.contentTypes[getType()]);

		switch (getType()) {
			case "HTML":
			case "TEXT":
				for (var content in contents) {
					if (IsSimpleValue(content)) {
						result &= content;
					}
				}
				break;
			case "JSON":
				// if there is 1 element in the content, serialize that
				// if there are more, serialize the whole array
				if (ArrayLen(contents) == 1) {
					result = SerializeJSON(contents[1]);
				} else {
					result = SerializeJSON(contents);
				}
				break;
		}

		//clear(arguments.key);

		WriteOutput(result);
	}

	public void function clear(string key = "") {

		if (Len(arguments.key) == 0) {
			ArrayClear(variables.contents);
			ArrayClear(variables.keys);
		} else {
			// the key doesn't have to exist, or it can appear more than once
			var index = 0;
			while (true) {
				index = ArrayFind(variables.keys, arguments.key);
				if (index > 0) {
					ArrayDeleteAt(variables.contents, index);
					ArrayDeleteAt(variables.keys, index);
				} else {
					break;
				}
			}
		}

	}

}