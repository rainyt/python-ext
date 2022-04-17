import haxe.Exception;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import haxe.macro.Expr;
import haxe.macro.Expr.FieldType;
import haxe.macro.Type.FieldKind;
import haxe.Json;
import sys.io.File;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.macro.Type;

class PythonMacro {
	macro public static function build():Array<Field> {
		var array = Context.getBuildFields();
		if (array == null)
			return array;
		for (item in array) {
			parser(item);
		}
		return array;
	}

	public static function parser(item:Field) {
		parserFieldType(item.kind);
	}

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

	public static function parserExprIter(expr:Expr):Void {
		parserExpr(expr);
		ExprTools.iter(expr, function(e) {
			parserExprIter(e);
		});
	}

	public static function parserExpr(e:Expr):Void {
		switch (e.expr) {
			case EMeta(s, e):
				if (s.name == "name") {
					var paramName = ExprTools.getValue(s.params[0]);
					var code = ExprTools.toString(e);
					e.expr = (macro PythonUtils.param($v{paramName}, $v{code})).expr;
				}
			default:
		}
	}
}
