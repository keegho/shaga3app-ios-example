# SHAGA3APP SAMPLE iOS

This is the iOS sample code snippet for swift iOS native app users who need to embed the SHAGA3APP competition `webview` to their iOS native apps.

## Installation

You need first to contact [SHAGA3APP](https://www.shaga3aapp.com) institution to prepare the deal and send them your primary and secondary colors, logos and competition rules and prize logos for each winner. 

Then you will receive a private key where your company will use to create signatures to their users using the app to use the embedded `webview` in your app in an authorized manner and be able to upload videos and join the your own competition.

For generating HMAC signature using your app existing users on your *PHP* backend use [hash_hmac](https://www.php.net/manual/en/function.hash-hmac.php).

### Using *PHP*:

```php
$sig = hash_hmac('sha256', $string, $secret)
```
### Using *Node*:

```node
//Loading the crypto module in node.js
var crypto = require('crypto');
//creating hmac object 
var hmac = crypto.createHmac('sha256', 'secret');
//passing the data to be hashed
data = hmac.update('string');
//Creating the hmac in the required format
sig = data.digest('hex');
//Printing the output on the console
console.log("hmac : " + sig);
```

* Where `string` is your app username + id combined
* And the `secret` is the private key
* This will generate the `sig` which is the signature where it will be used in the link header of the embedded `webview` using the name and id of the user in the link to be able to connect to shaga3app webview and join the competition.

So actually what will happen is that the user trying to open the `webview` send a call to your server with their name and id and receive in return a signature that will be used in the header of the link.

### Example in *swift*:

```swift
let url = URL(string: "https://backend.shaga3app.com/api/authorize?user_name=\(user.name)&user_uuid=\(user.uuid)")
               
var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
               
request.setValue(user.signature, forHTTPHeaderField:"x-auth-signature")
               request.setValue(key, forHTTPHeaderField:"x-shaga3app-id")

webView.load(request)
```

## Usage
Embedding the `webview` to your app is a piece of cake. Just add a `WKWebView` to your `UIViewController` call its delegate functions and request the link above using the correct username, id and signature.

```swift
import UIKit
import WebKit

override func viewDidLoad() {

     super.viewDidLoad()
     let url = URL(string:  "https://backend.shaga3app.com/api/authorize?user_name=\(user.name)&user_uuid=\(user.uuid)")
               
     var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
               
     request.setValue(user.signature, forHTTPHeaderField:"x-auth-signature")
               request.setValue(key, forHTTPHeaderField:"x-shaga3app-id") //key

     webView.load(request)
}
```

Regarding the `key` in the code above will be your own app id in SHAGA3APP that will be generated to you also with the private key *that you will use to generate the signature with in the backend* and will be used with the generated signature in the link headers.

### Extensions
Will need to use as mentioned above the delegate functions as an extension in the `UIViewController` to redirect users to your websites and to safari and to show `javascript` alerts as native alerts etc...

```php
   //Check the example code file for more code snippets and details. 
```

## Contributing
No contributions are needed at this stage

## License
[MIT](https://choosealicense.com/licenses/mit/)
