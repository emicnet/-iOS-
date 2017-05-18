## 云总机API调用Demo


## Introduction


### 开发工具

> **Xcode**

### 使用语言

> **Swift3.1**

----

## 目录
* [项目整体结构](#structure)
* [使用指南](#Getting_started_guide)  
  1.[账户配置](#Account_setting)  
  2.[Router.swift](#Router)  
  3.[APIRequest.swift](#APIRequest)  
  4.[AlaRequest.swift](#AlaRequest)  
  5.[TaskRequest.swift](#TaskRequest)  
* [用到的第三方库](#Third_Part)  
  1.[Alamofire](#Alamofire)  
  2.[SwiftyBeaver](#SwiftyBeaver)  
  3.[Eureka](#Eureka)  
  4.[PKHUD](#PKHUD)  

### <A NAME="structure"></A>项目整体结构
1. 项目使用cocoapod管理第三库。
2. Xcode工程里的**Main** Group是代码的核心部分。其中Router/APIRequest是具体发起网络请求的核心代码，
3. **DemoUI** Group示例如何使用Router/APIRequest发起api调用，以及如何处理调用结果。
4. WebApiTests 子项目演示常见测试用例。

### <A NAME="Getting_started_guide"></A>使用指南
#### <A NAME="Account_setting"></A>账户配置
修改AccountInfo.swift文件，将如下值替换为本企业的授权信息。配置完后运行WebApi target即可体验API调用效果。
	
    static let serverAddress = "apitest.emic.com.cn"  
    static let apiVersion = "20161021"  
    static let accountSid = "881a2a670fb4fc72fbff8f02435b2bca"
    static let authToken = "1dc6f46357d0a7d99947402c8fa7f73a"
    static let subAccountSid = "09b97c28df7c8374576f7f3b75f10515"
    static let subAuthToken = "ef434c78128c642a8fcc7195f2efb4f8"
    static let appID = "589920c51bbcc9eacac56325c9d48edc"
	
#### <A NAME="RESP 调用"></A> web API 调用实现
Demo示例提供两种实现来调用云总机 web api <1> 使用 Alamofire的AlaRequest  <2> 使用iOS的URLSessionDataTask的TaskRequest. 

实际使用哪种实现，需要在AppDelegate 设置一个全局变量，比如 let apiRequest = AlaRequest.self //Or TaskRequest.self 

**Router/APIRequest** 是Demo的核心代码。Router用于生成各api调用的URLRequest，APIRequest用于发送Router生成的URLRequest，并对web调用的返回值做检查。 
 
```
enum Router {	
	func myURLRequest() -> (URLRequest,[String:[String:String]]) {   
	 ... 接收api调用输入参数，生成相应URLRequest  
	 //相应输入参数处理参见api文档  
	}
}
```
web api输入参数可以使用json和xml格式。代码示例只使用json格式，如果需要xml格式，可以通过**NSXMLDocument** 生成xml输入参数。发起api调用还要注意该api是使用主账户还是子账户认证，具体调用代码参见Router实现。	

APIRequest定义调用request所遵循的协议。目前web api只支持http post方法；异步调用的返回结果CallResult已经统一处理，UI层可以根据CallResult进一步更新UI  

		
	protocol APIRequest {
    static func request(_ requestRouter: Router,completionHandler: @escaping (CallResult)->Void) -> Void
    }
  
	
#### <A NAME="APIRequest"></A> APIRequest.swift
APIRequest中实现API调用后response的处理，返回处理JSON相应的结果。

	static func verify(_ responseJSON:[String: Any], request:Router) -> CallResult {
	//api返回结果统一在这里处理
	}

#### <A NAME="AlaRequest"></A> AlaRequest.swift
AlaRequest扩展Router，实现Alamofire定义的URLRequestConvertible，通过Alamofire.request 发送请求

	func request(_ urlRequest: URLRequestConvertible) -> DataRequest


#### <A NAME="TaskRequest"></A> TaskRequest.swift
TaskRequest扩展Router,直接使用iOS URLSession，实现API的Http调用, URLSessionTask 发送 web 请求

	URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
	...
	}
	

### <A NAME="Third_Part"></A>第三方库
#### <A NAME="Alamofire"></A> Alamofire
[Alamofire](https://github.com/Alamofire/Alamofire/)主要用于网络编程的第三方库，方便建立网络请求、下载、上传、验证等功能。
#### <A NAME="SwiftyBeaver"></A> SwiftyBeaver
[SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver)记录日志。在AppDelegte定义一个全局变量log，然后就可以调用print一样方便打印日志
#### <A NAME="Eureka"></A> Eureka
[Eureka](https://github.com/xmartlabs/Eureka)方便创建表单。
#### <A NAME="PKHUD"></A> PKHUD
[PKHUD](https://github.com/pkluz/PKHUD) Demo 中用于调用结果的展示。

### 已知问题&注意事项  
1.目前Demo使用的账号创建企业用户（/Enterprises/createUser）不成功，调用呼叫中心的接口不成功  
2.Enterprises/createNumberPair 接口返回跟文档不一致  
3.调用接口参数的大小写敏感，请参照请求示例，以防调用失败  
4.目前web api只支持http，所以代码示例使用http方式  
5. WebApiTests 测试打电话的用例，需要把输入参数from改成本机实际号码，不然测试不通过。如果这时候恰好有别的电话打进来，程序无法区分，就会认为测试通过  
6.字符串的md5算法需要设置swift编译选项 Bridging-Header file
```
 #import <CommonCrypto/CommonCrypto.h> 
```
