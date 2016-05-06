1) This app makes use of a framework (SMCoreLib) developed by CGP. It is available separately on the web, open-source, through another project (https://bitbucket.org/SpasticMuffin/smsyncserver/). I really need to repo it as a separate open-source project!

2) SMCoreLib includes AFNetworking. Hence, I've not linked that in separately.

3) This project targets iOS8 both because Apple recommends supporting one version back of the system and because the SMCoreLib uses UIAlertView's, and we'd get warnings otherwise :).

4) I've added the following key/value into Info.plist because the URL uses HTTP not HTTPS. For a production app, for security purposes, Apple recommends dropping this key and using HTTPS.

	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
	
5) While Core Data was not called for in the requirements, I've used it for several reasons: 1) I've got a standard (SMCoreLib) collection of methods to provide a data source for a table view using Core Data, and so this simplifies the problem of populating the table view, 2) Core Data provides some standard means of sorting data, which is needed in the problem, and 3) Core Data abstracts out some common data management problems. Because I don't specifically need the persistence aspect of Core Data, all Core Data objects are flushed at launch.

6) From what I can tell, the linker warning "embedded dylibs/frameworks only run on iOS 8 or later" is an Xcode bug.