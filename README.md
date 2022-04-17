## Python扩展宏
可以为Python目标提供扩展支持

## Python with as语法
```haxe
import Python;

public static function main(){
    with(Sync_api.sync_playwright(), function(data:PlaywrightManager) {
        //... ...
    }
}
```

## Python传参支持（param=value）
```haxe
pythonApi.call(@name("path") "paramvalue");
```