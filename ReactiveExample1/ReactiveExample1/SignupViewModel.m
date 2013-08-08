//
//  Created by Ole Gammelgaard Poulsen on 08/08/13.
//  Copyright (c) 2012 SHAPE A/S. All rights reserved.
//

#import "SignupViewModel.h"


static const int kUsernameMinimumLength = 3;
static const int kPasswordMinimumLength = 6;

@implementation SignupViewModel {

}

- (id)init {
	self = [super init];
	if (self) {

		RACSignal *allCriteriaTrueSignal = [[RACSignal combineLatest:@[[self usernameValidSignal], [self passwordLongEnoughSignal], [self passwordsMatch]]] map:^id(RACTuple *tuple) {
			BOOL allYes = [tuple.rac_sequence all:^(NSNumber *num) {
				return num.boolValue;
			}];
			return @(allYes);
		}];
		RAC(self.canSubmit) = allCriteriaTrueSignal;
	}

	return self;
}


- (RACSignal *)usernameValidSignal {
	return [RACAbleWithStart(self.username) map:^id(NSString *username) {
		return @(username.length >= kUsernameMinimumLength);
	}];
}

- (RACSignal *)passwordLongEnoughSignal {
	return [RACAbleWithStart(self.password) map:^id(NSString *password) {
		return @(password.length >= kPasswordMinimumLength);
	}];
}

- (RACSignal *)passwordsMatch {
	return [RACSignal combineLatest:@[RACAbleWithStart(self.password), RACAbleWithStart(self.repeatPassword)] reduce:^id(NSString *password, NSString *repeatPassword) {
		return @([password isEqualToString:repeatPassword]);
	}];
}


@end