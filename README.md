# 数据模拟
1. 配置JAVA环境
2. 启动data-node
```shell
./start.sh --start
```
3. 编写mock规则调用`mock`接口生成模拟数据
4. 调用`/insert`数据入库。

# api


## 生成模拟数据
**URL:** http://{server}/mock

**Type:** POST

**Content-Type:** application/json


**Body-parameters:**

Parameter | Type|Description|Required
---|---|---|---
script|string|JS脚本|true



**Request-example:**
```
http://localhost:1701/mock
body-parameters:
{
	"script":"function main(){return Mock.mock({'string|1-10':'★'})}"
}
```

**Response-example:**
```
{
    "data": {
        "string": "★★★"
    },
    "code": 0,
    "msg": "success"
}
```

## 批量插入数据
**URL:** http://{server}/insert

**Type:** POST

**Content-Type:** application/json


**Body-parameters:**

Parameter | Type|Description|Required
---|---|---|---
type|string|类型(mysql)|true
url|string|url|true
user|string|数据库账号|true
password|string|数据库密码|true
sqlConfig|object|sql配置|true

**sqlConfig-parameters:**

Parameter | Type|Description|Required
---|---|---|---
sql|string|sql模板|true
data|List<List>|数据|true
strData|String(List<List>)|数据,data和strData必选一个|false
type|string|sql类型(insert)|true




**Request-example:**
```
http://localhost:1701/insert
body-parameters:
{
	"type":"mysql",
	"url":"jdbc:mysql://localhost:3306/test?characterEncoding=utf8&useSSL=true&serverTimezone=UTC",
	"user":"root",
	"password":"123456",
	"sqlConfig":{
		"sql":"insert into `user`(`name`,`user`)values(?,?)",
		"data":[
			["a",23],
			["b",25],
			["c",26]
		],
		"type":"insert"
	}
}
```

**Response-example:**
```
{
    "data": [
        1,
        1,
        1
    ],
    "code": 0,
    "msg": "success"
}
```

# examples
1.mock.js中`mockRule`函数mock规则，mock规则参考(http://mockjs.com/examples.html),如下
```js
function mockRule() {
    return data = Mock.mock({
        'data|100':[{//修改规则
            name:'@name',
            email:'@email'
        }]
    }).data
}
```
接口会自定调用main函数。
2.调用mock接口
java调用示例
```java
        
        File mockJs = new File("C:\\Users\\Rocky0428\\Desktop\\qiye\\data-cloud\\data-cloud\\data-node\\scripts\\test.js");
        // 读取js文件内容为字符串
        String script = FileUtil.readFileAsString(mockJs);
        Map<String,String> param = new HashMap<>();
        param.put("script",script);
        // 调用mock模拟数据接口
        String result = HttpUtil.doPostJson("http://localhost:1701/mock",JsonUtil.toJson(param));
        R r = com.jsctool.json.JsonUtil.jsonToPojo(result,R.class);


        // 插入数据
        // 数据库连接信息配置
        Map<String,Object> dbParam = new HashMap<>();
        dbParam.put("type","mysql");
        dbParam.put("url","jdbc:mysql://localhost:3306/test?characterEncoding=utf8&useSSL=false&serverTimezone=UTC");
        dbParam.put("user","root");
        dbParam.put("password","123456");
        Map<String,Object> sqlConfig = new HashMap<>();
        dbParam.put("sqlConfig",sqlConfig);
        sqlConfig.put("type","insert");
        // data 数据为List<List>或者为strDate的String(List<List>)类型
        sqlConfig.put("data", com.jsctool.json.JsonUtil.jsonToList(r.getData().toString(),List.class));
        sqlConfig.put("sql","INSERT INTO `user`(`name`,`user`)VALUES(?,?)");
        String api = "http://localhost:1701/excute";
        Object rst = HttpUtil.doPostJson(api,JsonUtil.toJson(dbParam));
        System.out.println(rst);
```
说明：
1. 一个数据库表的模拟数据为一个单独的文件。
2. 可以使用postman，python等调用接口进行数据模拟，本质是接口调用。