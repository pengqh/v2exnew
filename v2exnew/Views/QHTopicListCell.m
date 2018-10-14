//
//  QHTopicListCell.m
//  v2exnew
//
//  Created by pengquanhua on 2018/10/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHTopicListCell.h"

static CGFloat const kAvatarHeight          = 26.0f;
static CGFloat const kTitleFontSize         = 17.0f;
//static CGFloat const kDescriptionFontSize   = 14.0f;
static CGFloat const kBottomFontSize        = 12.0f;

#define kTitleLabelWidth (kScreenWidth - 56)

@interface QHTopicListCell ()

@property (nonatomic, strong) UILabel     *stateLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel     *descriptionLabel;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *replyCountLabel;

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *nodeLabel;
@property (nonatomic, strong) UILabel     *timeLabel;

@property (nonatomic, strong) UIView      *topLineView;
@property (nonatomic, strong) UIView      *borderLineView;

@property (nonatomic, assign) NSInteger   titleHeight;
@property (nonatomic, assign) NSInteger   descriptionHeight;

@end

@implementation QHTopicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = kBackgroundColorWhite;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topLineView.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    self.topLineView.hidden = !self.isTop;
    
    self.avatarImageView.frame = (CGRect){kScreenWidth-10-kAvatarHeight, 13, kAvatarHeight, kAvatarHeight};
    self.titleLabel.frame = CGRectMake(10, 15, kTitleLabelWidth, self.titleHeight);
    self.nodeLabel.origin = CGPointMake(kScreenWidth-10-self.nodeLabel.width, self.height-27);
    self.nameLabel.origin = CGPointMake(self.nodeLabel.x - self.nameLabel.width - 3, self.height - 27);
    self.timeLabel.origin = CGPointMake(10, self.height - 27);
    
    self.borderLineView.frame = CGRectMake(0, self.frame.size.height-0.5, kScreenWidth, 0.5);
}

#pragma mark - Configure Views

- (void)configureViews {
    self.stateLabel = [[UILabel alloc] initWithFrame:(CGRect){-7.5, -7.5, 15, 15}];
    self.stateLabel.clipsToBounds = YES;
    self.stateLabel.transform = CGAffineTransformMakeRotation(M_PI_4);
    self.stateLabel.font = [UIFont systemFontOfSize:4];
    self.stateLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.stateLabel];
    
    self.avatarImageView                    = [[UIImageView alloc] init];
    self.avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
    //    self.avatarImageView.layer.cornerRadius = 3; //kAvatarHeight/2.0;
    //    self.avatarImageView.clipsToBounds      = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.avatarImageView];
    
    self.titleLabel                         = [[UILabel alloc] init];
    self.titleLabel.backgroundColor         = [UIColor clearColor];
    self.titleLabel.font                    = [UIFont systemFontOfSize:kTitleFontSize];;
    self.titleLabel.numberOfLines           = 0;
    self.titleLabel.lineBreakMode           = NSLineBreakByTruncatingTail|NSLineBreakByCharWrapping;
    [self addSubview:self.titleLabel];
    
    self.replyCountLabel                    = [[UILabel alloc] init];
    self.replyCountLabel.backgroundColor    = [UIColor clearColor];
    self.replyCountLabel.textColor          = [UIColor whiteColor];
    self.replyCountLabel.font               = [UIFont systemFontOfSize:8];;
    self.replyCountLabel.textAlignment      = NSTextAlignmentCenter;
    [self addSubview:self.replyCountLabel];
    
    self.timeLabel                          = [[UILabel alloc] init];
    self.timeLabel.backgroundColor          = [UIColor clearColor];
    self.timeLabel.font                     = [UIFont systemFontOfSize:kBottomFontSize];;
    self.timeLabel.textAlignment            = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    
    self.nameLabel                          = [[UILabel alloc] init];
    self.nameLabel.backgroundColor          = [UIColor clearColor];
    self.nameLabel.font                     = [UIFont boldSystemFontOfSize:kBottomFontSize];
    self.nameLabel.textAlignment            = NSTextAlignmentRight;
    //    self.nameLabel.layer.cornerRadius       = 3.0;
    //    self.nameLabel.clipsToBounds            = YES;
    [self addSubview:self.nameLabel];
    
    self.nodeLabel                          = [[UILabel alloc] init];
    self.nodeLabel.backgroundColor          = [UIColor clearColor];
    self.nodeLabel.font                     = [UIFont systemFontOfSize:kBottomFontSize];
    self.nodeLabel.textAlignment            = NSTextAlignmentCenter;
    self.nodeLabel.lineBreakMode            = NSLineBreakByTruncatingTail;
    self.nodeLabel.backgroundColor          = [UIColor colorWithWhite:0.000 alpha:0.040];
    //    self.nodeLabel.layer.cornerRadius       = 3.0;
    //    self.nodeLabel.clipsToBounds            = YES;
    [self addSubview:self.nodeLabel];
    
    self.topLineView                        = [[UIView alloc] init];
    [self addSubview:self.topLineView];
    
    self.borderLineView                     = [[UIView alloc] init];
    [self addSubview:self.borderLineView];
    
    self.timeLabel.alpha = 1.0;
    
    self.titleLabel.textColor               = kFontColorBlackDark;
    self.timeLabel.textColor                = kFontColorBlackLight;
    self.nameLabel.textColor                = kFontColorBlackBlue;
    self.nodeLabel.textColor                = kFontColorBlackLight;
    self.topLineView.backgroundColor        = kLineColorBlackDark;
    self.borderLineView.backgroundColor     = kLineColorBlackDark;
}

#pragma mark - Data Methods

- (void)setModel:(QHTopicModel *)model {
    _model = model;
    
    @weakify(self);
    //self.avatarImageView
}

@end
