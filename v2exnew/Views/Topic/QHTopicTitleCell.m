//
//  QHTopicTitleCell.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/16.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicTitleCell.h"

static CGFloat const kAvatarHeight = 30.0f;
static CGFloat const kTitleFontSize = 18.0f;

#define kTitleLabelWidth (kScreenWidth - 20)

@interface QHTopicTitleCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton    *avatarButton;
@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, assign) NSInteger   titleHeight;

@end

@implementation QHTopicTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBackgroundColorWhite;
        
        self.titleLabel                         = [[UILabel alloc] init];
        self.titleLabel.backgroundColor         = [UIColor clearColor];
        self.titleLabel.textColor               = kFontColorBlackDark;
        self.titleLabel.font                    = [UIFont boldSystemFontOfSize:kTitleFontSize];;
        self.titleLabel.numberOfLines           = 0;
        self.titleLabel.lineBreakMode           = NSLineBreakByCharWrapping;
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.frame   = (CGRect){kScreenWidth - 10 - kAvatarHeight, 0, kAvatarHeight, kAvatarHeight};
    self.avatarButton.frame   = (CGRect){kScreenWidth - 10 - kAvatarHeight - 10, 0, kAvatarHeight + 20, kAvatarHeight + 20};
    self.titleLabel.frame        = CGRectMake(10, 15, kTitleLabelWidth, self.titleHeight);
    self.avatarImageView.centerY = self.height / 2.0;
    self.avatarButton.centerY = self.height / 2.0;
    
    self.avatarImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
}

- (void)setModel:(QHTopicModel *)model {
    _model = model;
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:model.topicCreator.memberAvatarNormal] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:0];
    
    self.titleLabel.text = model.topicTitle;
    self.titleHeight = [V2Helper getTextHeightWithText:model.topicTitle Font:[UIFont systemFontOfSize:kTitleFontSize] Width:kTitleLabelWidth] + 1;
}


#pragma mark - Class Methods
+ (CGFloat)getCellHeightWithTopicModel:(QHTopicModel *)model {
    
    NSInteger titleHeight = [V2Helper getTextHeightWithText:model.topicTitle Font:[UIFont systemFontOfSize:kTitleFontSize] Width:kTitleLabelWidth] + 1;
    if (model.topicTitle.length > 0) {
        return titleHeight + 25;
    } else {
        return 0;
    }
}

@end
