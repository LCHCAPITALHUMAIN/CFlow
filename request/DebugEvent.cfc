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

component DebugEvent extends="Event" {

	public void function init(required string target, required string type, struct properties = {}) {
		super.init(argumentCollection = arguments);
		// create an array for recording debugging messages
		variables.messages = [];
	}

	public void function cancel() {

		record("cflow.eventcanceled");
		super.cancel();

	}

	/**
	 * Records a debugging message. This message will be displayed in debug output.
	 **/
	public void function record(required any metadata, string message = "") {

		// if metadata is a simple value and message is not defined, we interpret metadata as the message
		local.message = arguments.message;
		if (IsSimpleValue(arguments.metadata) && Len(arguments.message) == 0) {
			local.message = arguments.metadata;
		} else {
			local.metadata = arguments.metadata;
			if (Len(arguments.message) == 0) {
				local.message = "Dump";
			}
		}
		var transport = {
			message = local.message,
			target = getTarget(),
			event = getType(),
			tickcount = GetTickCount()
		};
		if (StructKeyExists(local, "metadata")) {
			transport.metadata = local.metadata;
		}
		ArrayAppend(variables.messages, transport);

	}

	package array function getMessages() {
		return variables.messages;
	}

}