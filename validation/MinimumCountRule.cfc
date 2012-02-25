component MinimumCountRule extends="NumericRule" {

	public boolean function test(required struct data, required string fieldName) {
		return ListLen(arguments.data[arguments.fieldName]) >= getParameterValue();
	}

}