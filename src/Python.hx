package;

import python.Syntax;

/**
 * with ... as ... ret:语法
 * @param withObj 
 * @param cb 
 */
function with(withObj:Dynamic, cb:Dynamic->Void) {
	Syntax.code("with {0} as obj:{1}(obj)", withObj, cb);
}

@:autoBuild(PythonMacro.build())
class Python {}
