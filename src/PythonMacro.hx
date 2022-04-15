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
			parser(item, null);
		}
		return array;
	}

	public static function parser(item:Field, array:Array<Expr>):Void {
		parserKind(item.kind, array);
	}

	public static function parserKind(kind:FieldType, array:Array<Expr>):Void {
		switch (kind) {
			case FFun(func):
				parserExpr(func.expr, func.expr.expr, array);
			case FVar(t, e):

			case FProp(get, set, t, e):
		}
	}

	public static function findField(expr:ExprDef, field:String):ClassField {
		trace("findField", expr, field);
		switch (expr) {
			case EConst(c):
				var className = c.getParameters()[0];
				trace("find", className, field);
				switch (Context.getType("PythonClass")) {
					case TInst(t, params):
						return TypeTools.findField(t.get(), field, true);
					default:
				}
			default:
		}
		return null;
	}

	public static function parserExpr(parentExpr:Expr, expr:ExprDef, array:Array<Expr>):Void {
		switch (expr) {
			case EField(e, field):
			case ECall(e, params):
				trace(e, params);
				var expr:Expr = e.expr.getParameters()[0];
				var call:String = e.expr.getParameters()[1];
				var className = findField(expr.expr, call);
				trace(className);
				if (className.meta.get().filter((data) -> return data.name == ":pythonArgs").length > 0) {
					trace("参数：", params);
					// python参数转化
					var types = className.type.getParameters()[0];
					for (index => item in params) {
						var code = ExprTools.toString(item);
						var expr = macro {
							PythonUtils.param($v{types[index].name}, $v{code});
						}
						item.expr = expr.expr;
					}
				}
			// parserExpr(e.expr);
			case EBlock(exprs):
				// trace(exprs);
				for (item in exprs) {
					parserExpr(item, item.expr, exprs);
				}
			default:
		}
	}
}
