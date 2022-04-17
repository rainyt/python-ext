## Python扩展宏
可以为Python目标提供扩展支持

## Python传参支持（param=value）
在使用Python的args传参时，有两种方式：
```haxe
// 继承Python
class Main extends Python{}

// 或者使用@:build
@:build(PythonMacro.build())
class Main {}
```
然后使用：
```haxe
pythonApi.call(@path "paramvalue");
```
结果等于：
```python
pythonApi.call(path="paramvalue")
```

## Python with as语法
```haxe
import Python;

public static function main(){
    with(Sync_api.sync_playwright(), function(data:PlaywrightManager) {
        //... ...
    }
}
```
结果等于：
```python
with playwright_sync_api_Sync_api_Module.sync_playwright() as p:
```

