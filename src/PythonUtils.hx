import haxe.macro.ExprTools;
import haxe.macro.Expr;

class PythonUtils {
	macro public static function param(name:String, value:Expr):Expr {
		var data = name + '=' + ExprTools.getValue(value);
		return macro Syntax.code($v{data});
	}
}
