import haxe.macro.ExprTools;
import haxe.macro.Expr;

class PythonUtils {
	macro public static function param(name:String, value:Expr):Expr {
		var value:Dynamic = ExprTools.getValue(value);
		var data = name + '=' + value;
		return macro Syntax.code($v{data});
	}
}
