//
//  Created by Ole Gammelgaard Poulsen on 08/08/13.
//  Copyright (c) 2012 SHAPE A/S. All rights reserved.
//

#import "SignupViewModel.h"


static const int kUsernameMinimumLength = 3;
static const int kPasswordMinimumLength = 6;

@interface SignupViewModel()

@property(nonatomic, assign) BOOL submitting;
@property(nonatomic, strong) RACCommand *submitCommand;

@end

@implementation SignupViewModel {

}

- (id)init {
	self = [super init];
	if (self) {
		RACSignal *allCriteriaTrueSignal = [[RACSignal combineLatest:@[[self usernameValidSignal], [self passwordLongEnoughSignal], [self passwordsMatchSignal]]] map:^id(RACTuple *tuple) {
			BOOL allYes = [tuple.rac_sequence all:^(NSNumber *num) {
				return num.boolValue;
			}];
			return @(allYes);
		}];
		RAC(self.formValid) = allCriteriaTrueSignal;
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

- (RACSignal *)passwordsMatchSignal {
	return [RACSignal combineLatest:@[RACAbleWithStart(self.password), RACAbleWithStart(self.repeatPassword)] reduce:^id(NSString *password, NSString *repeatPassword) {
		return @([password isEqualToString:repeatPassword]);
	}];
}


- (RACCommand *)submitCommand {
	if (!_submitCommand) {
		RACSignal *canExecuteSignal = [RACSignal combineLatest:@[RACAbleWithStart(self.formValid), RACAbleWithStart(self.submitting)] reduce:^id(NSNumber *formValidNum, NSNumber *isSubmittingNum) {
			return @(formValidNum.boolValue && !isSubmittingNum.boolValue);
		}];
		_submitCommand = [RACCommand commandWithCanExecuteSignal:canExecuteSignal];

		[_submitCommand addSignalBlock:^RACSignal *(id value) {
			return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
				self.submitting = YES;
				NSTimeInterval delay = 2.0f;
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
					self.submitting = NO;
					[subscriber sendNext:@"Hello"];
					[subscriber sendCompleted];
				});

				return nil;
			}];
		}];

	}
	return _submitCommand;
}

@end