//
//  SelectItemView.m
//  NewWallet
//
//  Created by mac1 on 14-10-28.
//  Copyright (c) 2014年 BNDK. All rights reserved.
//

#import "SelectItemView.h"

#import "OneCardNumCell.h"

#import "XifuLoginAccount.h"

#import "RechargePhoneNumer.h"
#import "RechargeNetId.h"
#import "RechargeNetId+CoreDataProperties.h"
@interface SelectItemView ()<UITableViewDataSource, UITableViewDelegate, OneCardNumCellDelegate>

@property (nonatomic) CGRect relateViewFrameRect;
@end

@implementation SelectItemView


@synthesize dataSourceArray = _dataSourceArray;

@synthesize useStyle = _useStyle;

@synthesize delegate = _delegate;

- (id)initWithDataSource:(NSArray *)dataArray relateView:(UIView *)relateView style:(SelectItemViewUseStyle) style delegate:(id) theDelegate
{
    CGRect frame = relateView.frame;
    self.relateViewFrameRect = frame;

    if ([dataArray count] > 4) {
        frame = CGRectMake(0, frame.origin.y + frame.size.height - 2, SCREEN_WIDTH, frame.size.height * 4);
    }else{
        frame = CGRectMake(0, frame.origin.y + frame.size.height - 2, SCREEN_WIDTH, frame.size.height * [dataArray count]);
    }
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
    if (self) {
        // Initialization code
        self.useStyle = style;
        [self initTableView];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.dataSourceArray = [[NSMutableArray alloc] init];
        [self.dataSourceArray addObjectsFromArray:dataArray];
        
        self.delegate = theDelegate;
    }
    
    return self;
}

- (id)initWithRelateView:(UIView *)relateView style:(SelectItemViewUseStyle) style delegate:(id) theDelegate
{
    CGRect frame = relateView.frame;
    self.relateViewFrameRect = frame;

    frame = CGRectMake(0, frame.origin.y + 80, SCREEN_WIDTH, 0);
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.useStyle = style;
        
        [self initTableView];
        
        self.dataSourceArray = [[NSMutableArray alloc] init];
        
        self.delegate = theDelegate;
    }
    
    return self;
}

- (void)initTableView
{
    self.userInteractionEnabled = YES;
    self.layer.borderColor = UIColorFromRGB(0xe7e7e7).CGColor;
    self.layer.borderWidth = 1;
    UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    [self addSubview:tbView];
    self.tableView = tbView;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (IOS_VERSION >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    _tableView.separatorColor = UIColorFromRGB(0xe7e7e7);
    if (self.useStyle == SelectItemViewUseStyleSelectMobileRechrgeNum) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}
- (void)loaDataArray
{
    NSArray *dataArray = [Tools getIdRecordArrayWithUserId:shareAppDelegateInstance.boenUserInfo.userid];
    if ([dataArray count] > 4) {
        self.frame = CGRectMake(0, _relateViewFrameRect.origin.y + 45 * BILI_WIDTH, SCREEN_WIDTH, 45 * BILI_WIDTH * 4);
    }else{
        self.frame = CGRectMake(0, _relateViewFrameRect.origin.y + 45 * BILI_WIDTH, SCREEN_WIDTH, 45 * BILI_WIDTH * [dataArray count]);
    }
    
    CGRect rect = self.frame;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (IOS_VERSION >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
    }

    
    [_dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:dataArray];
    
    [self.tableView reloadData];
}

- (void)loadLoginAccountData
{
    NSArray *loginedAccounts = [XifuLoginAccount MR_findAll];
    if ([loginedAccounts count] > 4) {
        self.frame = CGRectMake(0, _relateViewFrameRect.origin.y + 45 * BILI_WIDTH - 1, SCREEN_WIDTH, 45 * BILI_WIDTH * 4);
    }else{
        self.frame = CGRectMake(0, _relateViewFrameRect.origin.y + 45 * BILI_WIDTH - 1, SCREEN_WIDTH, 45 * BILI_WIDTH * [loginedAccounts count]);
    }
   
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [_dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:loginedAccounts];
    
    [self.tableView reloadData];
}

- (void)loadMobileRechargeData
{
    NSArray *loginedAccounts = [RechargePhoneNumer MR_findAll];
    if ([loginedAccounts count] > 4) {
        self.frame = CGRectMake(0, _relateViewFrameRect.origin.y  + 60, SCREEN_WIDTH, 45 * BILI_WIDTH * 4);
    }else{
        self.frame = CGRectMake(0, _relateViewFrameRect.origin.y  + 60, SCREEN_WIDTH, 45 * BILI_WIDTH * [loginedAccounts count]);
    }
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [_dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:loginedAccounts];
    NSString *bindNum = [shareAppDelegateInstance.boenUserInfo.phoneNumber copy];
    
    [self.dataSourceArray insertObject:bindNum atIndex:0];
    [self.tableView reloadData];

}
- (void)loadNetFeesRechargeData
{
    NSArray *netIds = [RechargeNetId MR_findAll];
    if ([netIds count] > 3) {
        self.frame = CGRectMake(89 * NEW_BILI, _relateViewFrameRect.origin.y  + 60, SCREEN_WIDTH - 89 * NEW_BILI, 45 * BILI_WIDTH * 3);
        self.backgroundColor = [UIColor redColor];
    }else{
        self.frame = CGRectMake(89 * NEW_BILI, _relateViewFrameRect.origin.y  + 60, SCREEN_WIDTH - 89 * NEW_BILI, 45 * BILI_WIDTH * [netIds count]);
    }
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [_dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:netIds];
    [self.tableView reloadData];

}
#pragma mark - table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"selectCell";
    
    UITableViewCell *cell = nil;
    
    switch (self.useStyle) {
        case SelectItemViewUseStyleSelectSchool:
        {
            
            UITableViewCell *schoolCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (schoolCell == nil) {
                schoolCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSDictionary *schoolInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
            
            schoolCell.textLabel.font = [UIFont systemFontOfSize:15];
            schoolCell.textLabel.textColor = [UIColor lightGrayColor];
            schoolCell.textLabel.text = [schoolInfo valueForKey:@"name"];
            cell = schoolCell;
        }
            break;
            
        case SelectItemViewUseStyleSelectOneCardNumber:
        {
            OneCardNumCell *numCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (numCell == nil) {
                numCell = [[OneCardNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            numCell.delegate = self;
            numCell.row = indexPath.row;
            numCell.cellTitleLabel.frame = CGRectMake(100, 0, SCREEN_WIDTH - 45 * BILI_WIDTH - 100, 45 * BILI_WIDTH);
            numCell.cellTitleLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];
            cell = numCell;
        }
            break;
        case SelectItemViewUseStyleSelectXiFuAccount:
        {
            OneCardNumCell *numCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (numCell == nil) {
                numCell = [[OneCardNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            numCell.delegate = self;
            numCell.row = indexPath.row;
            numCell.cellTitleLabel.frame = CGRectMake(45 * BILI_WIDTH, 0, SCREEN_WIDTH - 45 * BILI_WIDTH * 2, 45 * BILI_WIDTH);
            XifuLoginAccount *account = [self.dataSourceArray objectAtIndex:indexPath.row];
            numCell.cellTitleLabel.text = account.xifuLoginAccount;
            cell = numCell;
        }
            break;
        case SelectItemViewUseStyleSelectMobileRechrgeNum:
        {
            OneCardNumCell *numCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (numCell == nil) {
                numCell = [[OneCardNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                [numCell.deleteButton setImage:[UIImage imageNamed:@"phonenumber_delete"] forState:UIControlStateNormal];
            }
            numCell.delegate = self;
            numCell.row = indexPath.row;
            numCell.textLabel.font = [UIFont systemFontOfSize:[BNTools sizeFit:15 six:15 sixPlus:17]];
            numCell.textLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH - 45 * BILI_WIDTH * 2, 45 * BILI_WIDTH);
            numCell.textLabel.textColor = [UIColor lightGrayColor];
            
            id objct = [self.dataSourceArray objectAtIndex:indexPath.row];
            if ([objct isKindOfClass:[RechargePhoneNumer class]]) {
                RechargePhoneNumer *rechargeNum = (RechargePhoneNumer *)objct;
                numCell.textLabel.text = rechargeNum.phoneNumber;
                numCell.bindStrLabel.text = nil;
                numCell.deleteButton.hidden = NO;
            }else{
                numCell.textLabel.text = (NSString *)objct;
                numCell.bindStrLabel.text = @"账号绑定号码";
                //numCell.bindStrLabel.frame = CGRectMake(SCREEN_WIDTH - 45 * BILI_WIDTH - 12, 0, 120, 45 * BILI_WIDTH);
                numCell.deleteButton.hidden = YES;
            }
            cell = numCell;
        }
            break;
        case SelectItemViewUseStyleSelectNetFees:{
            OneCardNumCell *numCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (numCell == nil) {
                numCell = [[OneCardNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            numCell.delegate = self;
            numCell.row = indexPath.row;
            numCell.cellTitleLabel.frame = CGRectMake(10 * BILI_WIDTH, 0, (SCREEN_WIDTH - 150 * NEW_BILI), 45 * BILI_WIDTH);
            numCell.deleteButton.frame = CGRectMake(SCREEN_WIDTH - 135 * NEW_BILI, 0, 45 * BILI_WIDTH, 45 * BILI_WIDTH);
            RechargeNetId *netId = [self.dataSourceArray objectAtIndex:indexPath.row];
            numCell.cellTitleLabel.text = netId.netId;
            cell = numCell;
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.useStyle) {
        case SelectItemViewUseStyleSelectSchool:
            //
            if ([self.delegate respondsToSelector:@selector(selectSchoolName:schoolNumber:)]) {
                NSDictionary *schoolInfo = [self.dataSourceArray objectAtIndex:indexPath.row];
                NSString *name = [schoolInfo valueForKey:@"name"];
                NSString *num  = [NSString stringWithFormat:@"%i",[[schoolInfo valueForKey:@"id"] intValue]];
                [self.delegate selectSchoolName:name schoolNumber:num];
                
                [self dismiss];
            }
            
            break;
           
        case SelectItemViewUseStyleSelectOneCardNumber:
            if ([self.delegate respondsToSelector:@selector(selectOneCardNum:password:)]) {
                [self.delegate selectOneCardNum:[self.dataSourceArray objectAtIndex:indexPath.row] password:@"55555"];
                self.hidden = YES;
            }
            
            break;
            
        case SelectItemViewUseStyleSelectXiFuAccount:
            if ([self.delegate respondsToSelector:@selector(selectLoginedAccount:)]) {
                XifuLoginAccount *account = [self.dataSourceArray objectAtIndex:indexPath.row];
                [self.delegate selectLoginedAccount:account.xifuLoginAccount];
                self.hidden = YES;
            }
        case SelectItemViewUseStyleSelectMobileRechrgeNum:
            if ([self.delegate respondsToSelector:@selector(selectMobileRechargeNumber:)]) {
                if (indexPath.row == 0) {
                    [self.delegate selectMobileRechargeNumber:[self.dataSourceArray objectAtIndex:indexPath.row]];
                }else{
                    RechargePhoneNumer *rechargeMobile = [self.dataSourceArray objectAtIndex:indexPath.row];
                    [self.delegate selectMobileRechargeNumber:rechargeMobile.phoneNumber];
                    self.hidden = YES;
                }
            }
        case SelectItemViewUseStyleSelectNetFees:
            if ([self.delegate respondsToSelector:@selector(selectRechargedNetId:)]) {
                RechargeNetId *netId = [self.dataSourceArray objectAtIndex:indexPath.row];
                [self.delegate selectRechargedNetId:netId.netId];
                self.hidden = YES;
            }

            break;
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*BILI_WIDTH;
}

- (void)showInView:(UIView *)inView
{
    
    [inView addSubview:self];
    
}

- (void)dismiss
{
    [self removeFromSuperview];
//    self.hidden = YES;
}
#pragma mark - OneCardNumCellDelegate
-(void)deleteButtonTapedAtRow:(NSInteger)row
{
    switch (self.useStyle) {
        case SelectItemViewUseStyleSelectOneCardNumber:
            [Tools deleteIdFromRecordArray:_dataSourceArray[row] withUserId:shareAppDelegateInstance.boenUserInfo.userid];
            [self loaDataArray];
            break;
        case SelectItemViewUseStyleSelectXiFuAccount:
        {
            XifuLoginAccount *account = [self.dataSourceArray objectAtIndex:row];
            [account MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            
            [self loadLoginAccountData];
        }
            break;
        case SelectItemViewUseStyleSelectMobileRechrgeNum:
        {
            if (row != 0) {
                RechargePhoneNumer *rechargeNum = [self.dataSourceArray objectAtIndex:row];
                [rechargeNum MR_deleteEntity];
                [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            }
            [self loadMobileRechargeData];
        }
            break;
        case SelectItemViewUseStyleSelectNetFees:
        {
            RechargeNetId *rechargeNetId = [self.dataSourceArray objectAtIndex:row];
            [rechargeNetId MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            
            [self loadNetFeesRechargeData];
        }
            break;
            
            
        default:
            break;
    }

    
}
@end
