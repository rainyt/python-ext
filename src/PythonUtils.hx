import haxe.macro.ExprTools;
import haxe.macro.Expr;

/**
 * Python工具
 */
class PythonUtils {
	

	/**
	 * 返回param=value的实现
	 * @param name 
	 * @param value 
	 * @return Expr
	 */
	macro public static function param(name:String, value:Expr):Expr {
		var value:Dynamic = ExprTools.getValue(value);
		var data = name + '=' + value;
		return macro Syntax.code($v{data});
	}
}
