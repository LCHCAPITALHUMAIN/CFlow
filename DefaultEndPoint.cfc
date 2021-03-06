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

component DefaultEndPoint implements="EndPoint" {

	public string function createURL(required string target, required string event, struct parameters) {

		var queryString = "";
		if (Len(arguments.target) > 0) {
			queryString = "target=" & UrlEncodedFormat(arguments.target);
		}
		if (Len(arguments.event) > 0) {
			queryString = ListAppend(queryString, "event=" & UrlEncodedFormat(arguments.event), "&");
		}

		if (StructKeyExists(arguments, "parameters")) {
			for (var name in arguments.parameters) {
				queryString = ListAppend(queryString, name & "=" & UrlEncodedFormat(arguments.parameters[name]), "&");
			}
		}

		return "index.cfm" & (Len(queryString) > 0 ? "?" & queryString : "");
	}

	/**
	 * The parameter values in the url and form scopes are collected as properties for the event.
	 **/
	public struct function collectParameters() {

		var parameters = StructCopy(url);
		StructAppend(parameters, form, false);

		return parameters;
	}

}