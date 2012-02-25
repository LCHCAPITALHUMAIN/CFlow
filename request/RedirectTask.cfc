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

component RedirectTask implements="Task" {

	public void function init(required string url, boolean permanent = false) {

		variables.url = arguments.url;
		if (arguments.permanent) {
			variables.statusCode = 301;
		} else {
			variables.statusCode = 302;
		}

	}

	public boolean function run(required Event event) {

		Location(variables.url, false, variables.statusCode);

		return true;
	}

}