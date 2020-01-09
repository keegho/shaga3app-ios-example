![Imgur Image](https://i.imgur.com/PuGTPGT.png)

</p>
<p align="left">
    <a href="" alt="Version">
        <img src="https://img.shields.io/badge/version-1.0-blue" /></a>
    <a href="" alt="swift">
        <img src="https://img.shields.io/badge/Swift-5.1-orange"
            alt="Swift"></a>
</p>

# SHAGA3APP SAMPLE iOS

This is the iOS sample code snippet for swift iOS native app users who need to embed the SHAGA3APP competition `webview` to their iOS native apps.

## Installation

You need first to contact [SHAGA3APP](https://www.shaga3aapp.com) institution to prepare the deal and send them your primary and secondary colors, logos and competition rules and prize logos for each winner. 

Then you will receive a private key where your company will use to create signatures to their users using the app to use the embedded `webview` in your app in an authorized manner and be able to upload videos and join the your own competition.

For generating HMAC signature using your app existing users on your *PHP* backend use [hash_hmac](https://www.php.net/manual/en/function.hash-hmac.php).

### Using *PHP*:

```php
<?php
// We will use the key that is generated from the admin panel.
$secret = "KEY_GENERATED_FROM_THE_BACKEND_ADMIN_PANEL";
// The string here represents the url we will visit for the authorization.
// Where username should represent the user name of the logged in user in the mother app.
// And the uuid should be a unique value within the mother app.
// This is in the case of a normal authorized user.
$string = "/api/authorize?user_name=username&user_uuid=useruuid"
// If this user is a guest and not authorized we will have to do it so:
// $string = "/api/authorize?user_name=guest&user_uuid=guest&salt=enter_a_random_string_here"
$sig = hash_hmac('sha256', $string, $secret);
```
### Using *Node*:

```node
const crypto = require("crypto");
// We will use the key that is generated from the admin panel.
const secret = "KEY_GENERATED_FROM_THE_BACKEND_ADMIN_PANEL";
// The string here represents the url we will visit for the authorization.
// Where username should represent the user name of the logged in user in the mother app.
// And the uuid should be a unique value within the mother app.
// This is in the case of a normal authorized user.
const string = "/api/authorize?user_name=username&user_uuid=useruuid"
// If this user is a guest and not authorized we will have to do it so:
// const string = "/api/authorize?user_name=guest&user_uuid=guest&salt=enter_a_random_string_here"
const signer = crypto.createHmac("sha256", secret);
signer.update(string);
const sig = signer.digest("hex");
// And the variable signature will hold our signature value that we will be using in the header.
```

* Where `string` is your app username + id combined in the api link as sample above.
* And the `secret` is the private key :key:
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
Embedding the `webview` to your app is a piece of cake :simple_smile:

Just add a `WKWebView` to your `UIViewController` call its delegate functions and request the link above using the correct username, id and signature.

```swift
import UIKit
import WebKit

override func viewDidLoad() {

     super.viewDidLoad()
     let url = URL(string:  "https://backend.shaga3app.com/api/authorize?user_name=\(user.name)&user_uuid=\(user.uuid)")
               
     var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
               
     request.setValue(user.signature, forHTTPHeaderField:"x-auth-signature")
               request.setValue(key, forHTTPHeaderField:"x-shaga3app-id") //key id

     webView.load(request)
}
```

Regarding the `key` :key: in the code above will be your own app id in SHAGA3APP that will be generated to you also with the private key *that you will use to generate the signature with in the backend* and will be used with the generated signature in the link headers.

### Extensions
Will need to use as mentioned above the delegate functions as an extension in the `UIViewController` to redirect users to your websites and to safari and to show `javascript` alerts as native alerts etc...

```php
   //Check the example code file for more code snippets and details. 
```

## Contributing
No contributions are needed at this stage

## License
[MIT](https://choosealicense.com/licenses/mit/)
