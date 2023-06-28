//
//  ViewController.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

#import "ViewController.h"
#import "LeftTableViewCell.h"
#import "GitHubAPIService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmenedControl;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) GitHubAPIService *networkService;
@property (nonatomic) NSString *searchString;
//@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkService = [[GitHubAPIService alloc] init];
    [self.networkService fetchRepositoriesForUser:@"hello" completion: ^(NSArray *repositories, NSError *error) {
        NSLog(@"%@", repositories);
        self.data = repositories;
    }];

    self.tableView = [[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain];
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];

    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchBar.delegate = self;
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.navigationItem.searchController.hidesNavigationBarDuringPresentation = NO;

    self.data = @[
        @{@"title": @"Заголовок 1", @"link": @"www.example1.com", @"image": @"image1"},
        @{@"title": @"Заголовок 2", @"link": @"www.example2.com", @"image": @"image2"},
        @{@"title": @"Заголовок 3", @"link": @"www.example3.com", @"image": @"image3"}
    ];

    [self.view addSubview:self.tableView];

    [self.tableView registerClass: [LeftTableViewCell class] forCellReuseIdentifier: @"ImageCellIdentifier"];
}

- (void)searchBar: (UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    NSLog(@"%@", searchText);
    _searchString = searchText;
}

- (void)searchBarCancelButtonClicked: (UISearchBar *)searchBar {
    _searchString = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.networkService fetchRepositoriesForUser:_searchString completion: ^(NSArray *repositories, NSError *error) {
        NSLog(@"%@", repositories);
        self.data = repositories;
    }];
}

//MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageCellIdentifier" forIndexPath:indexPath];

    NSDictionary *cellData = self.data[indexPath.row];
    cell.titleLabel.text = cellData[@"title"];
    cell.linkLabel.text = cellData[@"link"];
    cell.imageView.image = [UIImage imageNamed:cellData[@"image"]];

    return cell;
}

@end
