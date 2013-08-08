# Reactive Cocoa Workshop

## Basics

### RACAble and RACAbleWithStart

	[RACAble(self.username) subscribeNext:^(NSString *newName) {
	    NSLog(@"%@", newName);
	}];

### Chaining and operating on signals

	[[RACAble(self.username)
		filter:^(NSString *newName) {
		    return [newName hasPrefix:@"j"];
		}]
		subscribeNext:^(NSString *newName) {
		    NSLog(@"%@", newName);
	}];



### RACCommand

### Also a possible SHPFlowControl replacement
Parallel operations

	[[RACSignal
		merge:@[ [client fetchUserRepos], [client fetchOrgRepos] ]]
		subscribeCompleted:^{
		    NSLog(@"They're both done!");
	 }];

Serial operations

	[[[[client
		logInUser]
		flattenMap:^(User *user) {
		    // Return a signal that loads cached messages for the user.
		    return [client loadCachedMessagesForUser:user];
		}]
		flattenMap:^(NSArray *messages) {
		    // Return a signal that fetches any remaining messages.
		    return [client fetchMessagesAfterMessage:messages.lastObject];
		}]
		subscribeNext:(NSArray *newMessages) {
		    NSLog(@"New messages: %@", newMessages);
		}
		completed:^{
		    NSLog(@"Fetched all messages.");
	}];

Asynchronous operations

	RAC(self.imageView, image) = [[[[client
		fetchUserWithUsername:@"joshaber"]
		deliverOn:[RACScheduler scheduler]]
		map:^(User *user) {
		    return [[NSImage alloc] initWithContentsOfURL:user.avatarURL];
		}]
	deliverOn:RACScheduler.mainThreadScheduler];


## Versions
Use version 1.9.4 right now.

	pod 'ReactiveCocoa', '1.9.4'

Version 2.0 will son be released with many improvements, but renamed methods and breaking changes.

## Exercises

### Excercise 1

Create a simple a simple signup form with a username field, a password field, a repeat password field, and a submit button. The submit button should be enabled when the form is filled out correctly:

+	Username has a minimum length of 3 chars.
+	Password is minimum 6 chars long.
+	Both passwords are equal.

You can use the -[RACSignal combineLatest:reduce:] method to combine several signals into one and bind its value to the submit buttons enabled property.

Bonus task: make a filter so the username only can contan [a-z]|[A-Z]|[0-9].

### Excercise 2



## Model View ViewModel (MVVM)

