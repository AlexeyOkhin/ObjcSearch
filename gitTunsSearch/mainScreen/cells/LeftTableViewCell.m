//
//  LeftTableViewCell.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 27.06.2023.
//

#import "LeftTableViewCell.h"
#import "ImageTappedDelegate.h"

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.imageAvatar = [[UIImageView alloc] init];
        self.imageAvatar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview: self.imageAvatar];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview: self.titleLabel];

        self.linkLabel = [[UILabel alloc] init];
        self.linkLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.linkLabel.numberOfLines = 2;
        [self.contentView addSubview: self.linkLabel];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [self.imageAvatar addGestureRecognizer:tapGesture];
        self.imageAvatar.userInteractionEnabled = YES;
    }
    [self setLayout];
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageAvatar.image = nil;
    self.linkLabel.text = nil;
    self.titleLabel.text = nil;
}

- (void)setLayout {
    [NSLayoutConstraint activateConstraints:@[
           [self.imageAvatar.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
           [self.imageAvatar.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
           [self.imageAvatar.heightAnchor constraintEqualToConstant:80],
           [self.imageAvatar.widthAnchor constraintEqualToConstant:80],

           [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.imageAvatar.trailingAnchor constant:10],
           [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
           [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],

           [self.linkLabel.leadingAnchor constraintEqualToAnchor:self.imageAvatar.trailingAnchor constant:10],
           [self.linkLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:16],
           [self.linkLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],

       ]];
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    UIImageView *tappedImageView = (UIImageView *)gesture.view;
    [self.delegate imageTappedWithImage:tappedImageView.image];
}

@end
