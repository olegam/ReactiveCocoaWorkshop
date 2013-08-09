//
//  Created by Ole Gammelgaard Poulsen on 08/08/13.
//  Copyright (c) 2012 SHAPE A/S. All rights reserved.
//

#import "SignupViewController.h"
#import "SignupViewModel.h"


@interface SignupViewController ()

@property(nonatomic, strong) UITextField *usernameTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField *repeatPasswordTextField;
@property(nonatomic, strong) UIButton *submitButton;
@property(nonatomic, strong) UIBarButtonItem *submitBarButton;

@property(nonatomic, strong) SignupViewModel *viewModel;
@end


@implementation SignupViewController {

}

- (id)init {
	self = [super init];
	if (self) {
		self.viewModel = [SignupViewModel new];
	}

	return self;
}


- (void)loadView {
	[super loadView];

	[self.view addSubview:self.usernameTextField];
	[self.view addSubview:self.passwordTextField];
	[self.view addSubview:self.repeatPasswordTextField];
	[self.view addSubview:self.submitButton];

	[self.navigationItem setRightBarButtonItem:self.submitBarButton];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setupLayout];
	[self setupViewModelConnections];
}

- (void)setupViewModelConnections {
	RAC(self.viewModel.username) = self.usernameTextField.rac_textSignal;
	RAC(self.viewModel.password) = self.passwordTextField.rac_textSignal;
	RAC(self.viewModel.repeatPassword) = self.repeatPasswordTextField.rac_textSignal;

	// easy to hook up with bar button item
	self.submitBarButton.rac_command = self.viewModel.submitCommand;

	// To connect command with UIButton we must connect both the action and the enabled state
	RAC(self.submitButton.enabled) = RACAbleWithStart(self.viewModel.submitCommand.canExecute);
	SignupViewModel *viewModel = self.viewModel;
	[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[viewModel.submitCommand execute:nil];
	}];
}

- (void)setupLayout {
	[self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).with.offset(70.f);
		make.centerX.equalTo(self.view);
		make.width.equalTo(self.view).with.offset(-40.f);
		make.height.equalTo(@30.f);
	}];

	[self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.equalTo(self.usernameTextField);
		make.centerX.equalTo(self.usernameTextField);
		make.top.equalTo(self.usernameTextField.mas_bottom).offset(10.f);
	}];

	[self.repeatPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.equalTo(self.usernameTextField);
		make.centerX.equalTo(self.usernameTextField);
		make.top.equalTo(self.passwordTextField.mas_bottom).offset(10.f);
	}];

	[self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.equalTo(self.usernameTextField);
		make.centerX.equalTo(self.usernameTextField);
		make.top.equalTo(self.repeatPasswordTextField.mas_bottom).offset(30.f);
	}];
}

#pragma mark - Views

- (UITextField *)usernameTextField {
	if (!_usernameTextField) {
		_usernameTextField = [UITextField new];
		_usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
		_usernameTextField.placeholder = @"Username";
	}
	return _usernameTextField;
}

- (UITextField *)passwordTextField {
	if (!_passwordTextField) {
		_passwordTextField = [UITextField new];
		_passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
		_passwordTextField.placeholder = @"Password";
	}
	return _passwordTextField;
}

- (UITextField *)repeatPasswordTextField {
	if (!_repeatPasswordTextField) {
		_repeatPasswordTextField = [UITextField new];
		_repeatPasswordTextField.translatesAutoresizingMaskIntoConstraints = NO;
		_repeatPasswordTextField.placeholder = @"Repeat password";
	}
	return _repeatPasswordTextField;
}

- (UIButton *)submitButton {
	if (!_submitButton) {
		_submitButton = [UIButton new];
		_submitButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
		[_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	}
	return _submitButton;
}

- (UIBarButtonItem *)submitBarButton {
	if (!_submitBarButton) {
		_submitBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:nil action:nil];
	}
	return _submitBarButton;
}

@end