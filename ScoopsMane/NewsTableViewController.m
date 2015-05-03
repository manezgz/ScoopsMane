//
//  NewsTableViewController.m
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 2/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

//
//  CROLibraryTableViewController.h
//  Library
//
//  Created by Jose Manuel Franco on 29/3/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsViewController.h"
#import "AzureHandler.h"

@interface NewsTableViewController (){
    AzureHandler *azureHandler;
    CROUser *userLogged;
    NSMutableArray *arrayOfStates;
}

@end

@implementation NewsTableViewController

-(id)initWithDictionaryOfNews:(NSMutableDictionary*)dictionary
               withStyle:(UITableViewStyle) aStyle
          withUserLogged:(CROUser*)user{
    
    if(self=[super initWithStyle:aStyle]){
        _dictionaryOfNews=dictionary;
        arrayOfStates=[dictionary allKeys];
        self.tableView.delegate=self;
        self.delegate=self;
        azureHandler=[AzureHandler getInstance];
        userLogged=user;
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newsDidChange:)
                                                     name:NEWS_CHANGED
                                                   object:nil];
    }
    return self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNews:)];
    self.navigationItem.rightBarButtonItem = add;
    
}

-(void)dealloc{
    // Baja en notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [arrayOfStates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *state=[arrayOfStates objectAtIndex:section];
    return [[self.dictionaryOfNews objectForKey:(state)] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    return [arrayOfStates objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section{
    NSString *state=[arrayOfStates objectAtIndex:section];
    int items=[[self.dictionaryOfNews objectForKey:(state)]count];
    return [NSString stringWithFormat:@"%d items",items];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BookCell";
    
    CRONews *news = [self newsForIndexPath:(indexPath)];
    // Creamos una celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // La creamos de cero
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Sincronizamos modelo con vista (celda)
    cell.imageView.image = news.image;
    cell.textLabel.text =news.title;
    cell.detailTextLabel.text=news.author;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CRONews*)newsForIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *state=[arrayOfStates objectAtIndex:(indexPath.section)];
    NSArray *array=[self.dictionaryOfNews objectForKey:state];
    
    return [array objectAtIndex:indexPath.row];
}

#pragma mark -Table View Delegate
- (void)newsTableViewController:(NewsTableViewController *)tableVC
                 didSelectANews:(CRONews *)news
                    atIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"News Selected");
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected ROW");
    // Avisar al delegado
    CRONews *news=[self newsForIndexPath:(indexPath)];
    
    NewsViewController *newsVC=[[NewsViewController alloc]initWithNews:news
                                                               andUser:userLogged];
    
    [self.navigationController pushViewController:newsVC
                                         animated:true];
    
}

-(void) addNews:(id) sender{
    
    NewsViewController *newsVC=[[NewsViewController alloc]initNewNewsWithUser:userLogged];
    [self.navigationController pushViewController:newsVC
                                         animated:true];
    
}

-(BOOL) findNews:(CRONews*)news InArray:(NSMutableArray*)array{
    BOOL found=false;
    for(CRONews *newsInArray in array){
        if(news.idAzure==newsInArray.idAzure){
            [array removeObject:newsInArray];
            found=true;
            break;
        }
    }
    return found;
}

- (void) newsDidChange:(NSNotification *)aNotification{
    CRONews *news = [aNotification.userInfo objectForKey:NEWS_KEY];
    //Buscamos la news en los 3 arrays sino lo añadimos
    //Buscamos por key de azure
    BOOL found=false;
    
    //Primer Array
    found=[self findNews:news InArray:[self.dictionaryOfNews objectForKey:[arrayOfStates firstObject]]];
    
    //Segundo Array
    if(!found){
        found=[self findNews:news InArray:[self.dictionaryOfNews objectForKey:[arrayOfStates objectAtIndex:1]]];
    }
    
    //Tercer Array
    if(!found){
        found=[self findNews:news InArray:[self.dictionaryOfNews objectForKey:[arrayOfStates lastObject]]];
    }
    

    //Pillamos el array que toca del diccionari
    NSMutableArray *array=[self.dictionaryOfNews objectForKey:news.state];
    [array addObject:news];
    [self.tableView reloadData];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
