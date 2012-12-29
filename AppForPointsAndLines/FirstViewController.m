//
//  FirstViewController.m
//  AppForPointsAndLines
//
//  Created by Developer C on 12/11/12.
//  Copyright (c) 2012 Developer C. All rights reserved.
//

#import "FirstViewController.h"
#import "PointButton.h"
#include "Cutline.h"
#include "CutPoint.h"

@interface FirstViewController (){
    NSString *head;
    NSString *foot;
    CGPoint firstPoint;
    CGPoint lastPoint;
}

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

@property (strong, nonatomic) NSMutableDictionary *savePoints;
@property (strong, nonatomic) NSMutableDictionary *lines;
@property (strong, nonatomic) NSMutableDictionary *points;
@property (strong, nonatomic) NSMutableDictionary *cutLines;
@property (strong, nonatomic) NSMutableArray *saveNib;

@property (strong, nonatomic) IBOutlet UIImageView *tempImageView;
@property (strong, nonatomic) IBOutlet UIImageView *finalImageView;
@property (strong, nonatomic) NSString *naviTitle;
@property (strong, nonatomic) IBOutlet UILabel *modeLabel;

@end

@implementation FirstViewController
@synthesize startPoint,endPoint;
@synthesize savePoints,lines,points,cutLines;
@synthesize tempImageView,finalImageView;
@synthesize naviTitle;
@synthesize modeLabel;
@synthesize saveNib;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init entities
    savePoints=[[NSMutableDictionary alloc]init];
    lines=[[NSMutableDictionary alloc]init];
    points=[[NSMutableDictionary alloc]init];
    cutLines=[[NSMutableDictionary alloc]init];
    saveNib=[[NSMutableArray alloc]initWithObjects:@"init", nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Delegate 

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    startPoint=[touch locationInView:self.view];
    endPoint=[touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isPoint) {
        ++count;
        PointButton *point=[[PointButton alloc]initWithFrame:CGRectMake(endPoint.x, endPoint.y, 33, 33) Title:[NSString stringWithFormat:@"◎"] font:[UIFont fontWithName:@"Marker Felt" size:25] andFontColor:[UIColor whiteColor] atLoaction:endPoint];
        [self.view addSubview:point];
        UILabel *label=[[UILabel alloc]init];
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"v%d",count];
        label.font=[UIFont fontWithName:@"Marker Felt" size:13];
        label.textAlignment=NSTextAlignmentCenter;
        
        if (endPoint.x<self.tempImageView.frame.size.width/2 &&
            endPoint.y<self.tempImageView.frame.size.height/2) {
            label.frame=CGRectMake(endPoint.x-30, endPoint.y-24, 25, 12);
        }
        else if (endPoint.x>self.tempImageView.frame.size.width/2 &&
                 endPoint.y<self.tempImageView.frame.size.height/2){
            label.frame=CGRectMake(endPoint.x+8, endPoint.y-24, 25, 12);
        }
        else if (endPoint.x>self.tempImageView.frame.size.width/2 &&
                 endPoint.y>self.tempImageView.frame.size.height/2){
            label.frame=CGRectMake(endPoint.x+8, endPoint.y+8, 25, 12);
        }
        else if (endPoint.x<self.tempImageView.frame.size.width/2 &&
                 endPoint.y>self.tempImageView.frame.size.height/2){
            label.frame=CGRectMake(endPoint.x-30, endPoint.y+8, 25, 12);
        }
        [self.view addSubview:label];
        point.tag=count;
        [point addTarget:self action:@selector(eachButtonPress:)
                    forControlEvents:UIControlStateHighlighted];
        [self.savePoints setValue:point forKey:label.text];
        [self.points setValue:label forKey:label.text];
    }
    else if (isLine){
        //draw line.......
    }
}

- (void)eachButtonPress:(UIButton*)sender{
    CAAnimationGroup *group=[self buttonPressAnimation:sender];
    ++begin;
    if ([[self.savePoints allKeys]count]>1) {
        if (begin==1) {
            head=[NSString stringWithFormat:@"v%d",sender.tag];
            firstPoint=sender.frame.origin;
            sender.highlighted=YES;
            for (int i=1; i<=[[self.savePoints allKeys]count]; i++) {
                if (i!=sender.tag) {
                    NSString *vPoint=[NSString stringWithFormat:@"v%d",i];
                    UIButton *button=[self.savePoints objectForKey:vPoint];
                    [button.layer addAnimation:group forKey:@"begin"];
                }
            }
            
            //[sender.layer addAnimation:group forKey:@"begin"];
            lastTouch=sender;
        }
        else{
            ++lCount;
            foot=[NSString stringWithFormat:@"v%d",sender.tag];
            //NSString *final=[self sortStringWith:head andLast:foot];
            NSString *final=[NSString stringWithFormat:@"%@%@",head,foot];
            lastPoint=sender.frame.origin;
            
        
            //draw line
            UIGraphicsBeginImageContext(self.tempImageView.frame.size);
            [tempImageView.image drawInRect:CGRectMake(tempImageView.frame.origin.x,
                                                       tempImageView.frame.origin.y,
                                                       tempImageView.frame.size.width,
                                                       tempImageView.frame.size.height)];
            CGContextRef context=UIGraphicsGetCurrentContext();
            //CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetLineWidth(context, 2);
            CGContextMoveToPoint(context, firstPoint.x+15, firstPoint.y+15);
            CGContextAddLineToPoint(context, lastPoint.x+15, lastPoint.y+15);
            CGContextFlush(context);
            CGContextStrokePath(context);
            tempImageView.image=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [self.lines setObject:final forKey:final];
            [self.saveNib addObject:final];
            
            begin=0;
            head=nil;
            foot=nil;
            firstPoint=CGPointZero;
            lastPoint=CGPointZero;
            
            CAAnimationGroup *group=[self selectEndPointAnimation:lastTouch toEnd:sender];
            
            for (int i=1; i<=[[self.savePoints allKeys]count]; i++) {
                NSString *vPoint=[NSString stringWithFormat:@"v%d",i];
                UIButton *button=[self.savePoints objectForKey:vPoint];
                [button.layer removeAllAnimations];
            }
            [sender.layer addAnimation:group forKey:@"end"];
            lastTouch=nil;
            NSLog(@"%@",[[self.lines objectForKey:final]description]);
        }
    }
    [self.view setNeedsDisplay];
}

#pragma mark - Data Analyse Method

- (NSArray*)analyseTheLine:(NSString*)aLine{
    NSArray *array;
    NSRange firstRange,lastRange;
    if ([aLine length]==4) {
        firstRange=NSMakeRange(1, 1);
        lastRange=NSMakeRange(3, 1);
    }
    else if ([aLine length]==5){
        if ([[aLine substringWithRange:NSMakeRange(2, 1)]isEqualToString:@"v"]) {
            firstRange=NSMakeRange(1, 1);
            lastRange=NSMakeRange(3, 2);
        }
        else{
            firstRange=NSMakeRange(1, 2);
            lastRange=NSMakeRange(4, 1);
        }
    }
    else if ([aLine length]==6){
        firstRange=NSMakeRange(1, 2);
        lastRange=NSMakeRange(4, 2);
    }
    NSString *firstStr=[aLine substringWithRange:firstRange];
    NSString *lastStr=[aLine substringWithRange:lastRange];
    array=[NSArray arrayWithObjects:firstStr,lastStr, nil];
    return array;
}
 
#pragma mark - Show Cut Line Method

- (void)original:(NSString*)target{
   
    NSString *firstKey=[NSString stringWithFormat:@"v%@",[[self analyseTheLine:target]objectAtIndex:0]];
    NSString *endKey=[NSString stringWithFormat:@"v%@",[[self analyseTheLine:target]objectAtIndex:1]];
    
    CGPoint first=((UIButton*)[self.savePoints objectForKey:firstKey]).frame.origin;
    CGPoint end=((UIButton*)[self.savePoints objectForKey:endKey]).frame.origin;
    
    [self showCutLineFrom:first toEnd:end];
}

- (void)showCutLineFrom:(CGPoint)first toEnd:(CGPoint)end{
    UIGraphicsBeginImageContext(self.tempImageView.frame.size);
    [tempImageView.image drawInRect:CGRectMake(tempImageView.frame.origin.x,
                                               tempImageView.frame.origin.y,
                                               tempImageView.frame.size.width,
                                               tempImageView.frame.size.height)];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, first.x+15, first.y+15);
    CGContextAddLineToPoint(context, end.x+15, end.y+15);
    CGContextFlush(context);
    CGContextStrokePath(context);
    tempImageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Figure Cut Edge Method

- (void)obtainCutLine{
    int i, j, k;
    pointCount=[[self.savePoints allKeys]count];
    lineCount=[self.saveNib count];
    
    printf("%d %d\n",pointCount,lineCount);
    memp=0; nid=0; clr(e);
    
    for (k=0; k<lineCount; k++,nid++) {
        NSString *key=[self.saveNib objectAtIndex:k];
        NSString *value=[self.lines objectForKey:key];
        i=[[[self analyseTheLine:value]objectAtIndex:0]intValue];
        j=[[[self analyseTheLine:value]objectAtIndex:1]intValue];
        printf("v%dv%d\n",i,j);
        
        addEdge(e, i-1, j-1);
        addEdge(e, j-1, i-1);
        bridge[nid]=0;
    }
    
    nbridge=0; clr(visited);
    DFS(0, -1, 1);
    printf("%d\n",nbridge);
    for (i=0, k=nbridge; i<lineCount; i++) {
        if (bridge[i]) {
            printf("%d",i+1);
            //NSLog(@"%d",i+1);
            NSString *temp=[self.saveNib objectAtIndex:i];
            NSLog(@"%@",temp);
            [self original:temp];
            if (--k) {
                printf(" ");
            }
        }
    }
    if (nbridge) {
        puts("");
    }
}

#pragma mark - Figure Cut Point Method

- (void)obtainCutPoint{
    int i;
    int u, v;
    int find;
    if (runPress) {
        NSString *value=[self.lines objectForKey:[self.saveNib objectAtIndex:0]];
        memset(Edge, 0, sizeof(Edge));
        nodes=0;
        u=[[[self analyseTheLine:value]objectAtIndex:0]intValue];
        v=[[[self analyseTheLine:value]objectAtIndex:1]intValue];
        
        NSLog(@" First:%d %d",u,v);
        if (u>nodes) {nodes=u;}
        if (v>nodes) {nodes=v;}
        Edge[u][v]=Edge[v][u]=1;
        
        for (int j=1; j<[self.saveNib count]; j++) {
            NSString *subValue=[self.lines objectForKey:[self.saveNib objectAtIndex:j]];
            u=[[[self analyseTheLine:subValue]objectAtIndex:0]intValue];
            v=[[[self analyseTheLine:subValue]objectAtIndex:1]intValue];
            if (u>nodes) {nodes=u;}
            if (v>nodes) {nodes=v;}
            Edge[u][v]=Edge[v][u]=1;
            NSLog(@"Second:%d %d",u,v);
        }
    }
        init();
        DFS_Points(1);
        if (son>1) {
            subnets[1]=son-1;
        }
        //find=0;
        for (i=1; i<=nodes; i++) {
            if (subnets[i]) {
                find=1;
                NSString *cutPointTag=[NSString stringWithFormat:@"v%d",i];
                [((UIButton*)[self.savePoints objectForKey:cutPointTag]).layer addAnimation:[self showCutPointsAnimation] forKey:@"cut point"];
            }
        }
        if (!find) {
            printf("No SPF node\n");
        }
    
}

#pragma mark - Point Animations Method

- (CAAnimationGroup*)buttonPressAnimation:(UIButton*)sender{
    CABasicAnimation *animation_1=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation_1.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *animation_2=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation_2.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations=[NSArray arrayWithObjects:animation_1,animation_2, nil];
    group.duration=0.5;
    group.repeatCount=100;
    return group;
}

- (CAAnimationGroup*)selectEndPointAnimation:(UIButton*)lastButton toEnd:(UIButton*)endButton{
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, lastButton.frame.origin.x+15, lastButton.frame.origin.y+15);
    CGPathAddLineToPoint(path, NULL, endButton.frame.origin.x+15, endButton.frame.origin.y+15);
    animation.path=path;
    CGPathRelease(path);
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations=[NSArray arrayWithObjects:animation, nil];
    group.duration=0.5;
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.delegate=self;
    group.removedOnCompletion=YES;
    return group;
}

- (CAAnimationGroup*)showCutPointsAnimation{
    
    CABasicAnimation *animation_1=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation_1.toValue=[NSNumber numberWithFloat:5];
    animation_1.duration=0.5;
    animation_1.autoreverses=YES;
    
    CABasicAnimation *animation_2=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation_2.fromValue=[NSNumber numberWithFloat:1.0f];
    animation_2.toValue=[NSNumber numberWithFloat:0.0f];
    animation_2.duration=0.2;
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    group.animations=[NSArray arrayWithObjects:animation_1, animation_2, nil];
    group.duration=0.4;
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.fillMode=kCAFillModeForwards;
    group.repeatCount=100;
    group.autoreverses=YES;
    
    return group;
}

#pragma mark - Button Interaction Method

- (IBAction)point:(id)sender {
    naviTitle=@"point";
    isPoint=YES;
    isLine=NO;
    modeLabel.text=naviTitle;
    runPress=NO;
}

- (IBAction)line:(id)sender {
    naviTitle=@"line";
    isPoint=NO;
    isLine=YES;
    modeLabel.text=naviTitle;
    [self.saveNib removeAllObjects];
    runPress=NO;
}

- (IBAction)run:(id)sender {
    runPress=YES;
    [self obtainCutLine];
    [self obtainCutPoint];
}

- (IBAction)clean:(id)sender {
    for(NSString *key in [self.savePoints allKeys]){
        UIButton *button=[self.savePoints objectForKey:key];
        [button removeFromSuperview];
    }
    for(NSString *key in [self.points allKeys]){
        UILabel *label=[self.points objectForKey:key];
        [label removeFromSuperview];
    }
    [self.lines removeAllObjects];
    [self.savePoints removeAllObjects];
    [self.points removeAllObjects];
    [self.saveNib removeAllObjects];
    count=0;
    lCount=0;
    self.tempImageView.image=nil;
    runPress=NO;
}

@end
