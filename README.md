1) This app makes use of a framework (SMCoreLib) developed by CGP. It is available separately on the web, open-source, through another project (https://bitbucket.org/SpasticMuffin/smsyncserver/). I really need to repo it as a separate open-source project!

2) SMCoreLib includes AFNetworking. Hence, I've not linked that in separately.

3) There are several warnings regarding UIAlertView's. I need to update SMCoreLib to using UIAlertController's. (I can't target below iOS9 in this app because in some cases I'm using UIStackView's).

4) I've added the following key/value into Info.plist because the server URL I was given uses HTTP not HTTPS. For a production app, for security purposes, Apple recommends dropping this key and using HTTPS.

	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
	
5) While Core Data was not called for in the requirements, I've used it for several reasons: 1) I've got a standard (SMCoreLib) collection of methods to provide a data source for a table view using Core Data, and so this simplifies the problem of populating the table view, 2) Core Data provides some standard means of sorting data, which is needed in the problem, and 3) Core Data abstracts out some common data management problems. Also, 4) if the network is unavailable when the app launches, I'm giving the user the old service provider objects from Core Data.

6) From what I can tell, the linker warning "embedded dylibs/frameworks only run on iOS 8 or later" is an Xcode bug. I've targeted iOS9. Why should it complain?

7) I laid out the views in the detail view controller using code both to illustrate that I can do this and because the rotation was annoying with constraints/autolayout. It seemed simpler to do it in code. See also https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/LayoutandAppearance.html for the fact that on iPad both landscape and portrait are "regular".