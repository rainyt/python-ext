import python.Syntax;

class Test extends Python {
	static function main() {
		TestApi.call(@path "paramvalue");
        var data = {};
        trace(@:ss data);
        trace(@:s data);
	}
}

extern class TestApi {
	public static function call(a:Dynamic, b:Dynamic = null):Void;
}
