import haxe.macro.ExprTools;
import haxe.macro.Expr;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Field;
import haxe.macro.Context;

/**
 * Python增强宏实现
 */
class PythonMacro {
	/**
	 * 通过`@:build(PythonMacro.build())`
	 * @return Array<Field>
	 */
	macro public static function build():Array<Field> {
		var array = Context.getBuildFields();
		if (array == null)
			return array;
		for (item in array) {
			parser(item);
		}
		return array;
	}

	/**
	 * 解析Field
	 * @param item 
	 */
	public static function parser(item:Field) {
		parserFieldType(item.kind);
	}

	/**
	 * 解析FieldType
	 * @param t 
	 */
	public static function parserFieldType(t:FieldType):Void {
		switch (t) {
			case FVar(t, e):
				parserExprIter(e);
			case FFun(f):
				parserExprIter(f.expr);
			case FProp(get, set, t, e):
				parserExprIter(e);
		}
	}

	/**
	 * 递归处理Expr
	 * @param expr 
	 */
	public static function parserExprIter(expr:Expr):Void {
		parserExpr(expr);
		ExprTools.iter(expr, function(e) {
			parserExprIter(e);
		});
	}

	/**
	 * 元数据实现
	 * @param e 
	 */
	public static function parserExpr(e:Expr):Void {
		switch (e.expr) {
			case ECall(e, params):
				// 方法调用中，实现param=value的处理
				for (item in params) {
					switch (item.expr) {
						case EMeta(s, e):
							var paramName = s.name;
							var code = ExprTools.toString(e);
							e.expr = (macro PythonUtils.param($v{paramName}, $v{code})).expr;
						default:
					}
				}
			default:
		}
	}
}
