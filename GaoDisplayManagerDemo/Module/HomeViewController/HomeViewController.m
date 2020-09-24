//
//  HomeViewController.m
//  GaoDisplayManagerDemo
//
//  Created by Gikki Ares on 2020/8/5.
//  Copyright © 2020 vgemv. All rights reserved.
//

#import "HomeViewController.h"
#import "GaoTvcLl.h"
#import "GaoDisplayManager.h"

@interface HomeViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) NSArray * mArray;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.mTableView.delegate = self;
	self.mTableView.dataSource = self;
	self.mArray = @[@"定时消失的提示,点击背景也可以消失",@"定时消失的提示,点击背景不可以消失"];
	[self.mTableView registerNib:[UINib nibWithNibName:@"GaoTvcLl" bundle:nil] forCellReuseIdentifier:@"cell"];
}



//MARK 4 Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch(indexPath.row) {
		case 0: {
			GaoToastViewIl * toastView = [GaoToastViewIl newInstanceWithMessage:@"Hello,World!!!"];
//			[toastView displayInView:self.view withMask:YES isMaskCancellable:YES position:GaDisplayPositionRight displayAnimationType:GaDisplayAnimationTypeMoveFromRight undisplayAnimationType:GaUndisplayAnimationTypeMoveToRight cancelBlock:nil displayInterval:3];
		}
		case 1:{
			GaoToastViewIl * toastView = [GaoToastViewIl newInstanceWithMessage:@"Hello,World!!!"];
			GaoDisplayStyle * style = [GaoDisplayStyle defaulStyle];
			style.mf_maskAlpha = 0;
			[toastView displayInView:self.view withDisplayStyle:style completionHandler:nil];
		}
		default: {
			break;
		}
	}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.mArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GaoTvcLl * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	NSString * str_title = self.mArray[indexPath.row];
	NSString * str_index = [NSString stringWithFormat:@"%zi",indexPath.row];
	NSArray * arr = @[str_index,str_title];
	[cell displayContent:arr];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}



@end
