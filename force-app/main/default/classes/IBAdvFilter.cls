/**
 * @description       : Wrapper class for IBAdvSearch Filter
 * @author            : nagendra.mylavarapu@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-12-29   nagendra.mylavarapu@tetrad.co.za   	Initial Version
 **/

public class IBAdvFilter {
	public class Options {
		public String label;
		public String value;
	}

	public class Value {
	}

	public String name;
	public List<String> value;
	public List<Options> options;

	
	public static List<IBAdvFilter> parse(String json) {
		return (List<IBAdvFilter>) System.JSON.deserialize(json, List<IBAdvFilter>.class);
	}
}