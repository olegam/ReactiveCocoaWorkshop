//
//  Created by Ole Gammelgaard Poulsen on 08/08/13.
//  Copyright (c) 2012 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SignupViewModel : NSObject

// Properties to be set from the view
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *repeatPassword;

// properties to be read from the view
@property(nonatomic, assign) BOOL formValid;

- (RACCommand *)submitCommand;

@end