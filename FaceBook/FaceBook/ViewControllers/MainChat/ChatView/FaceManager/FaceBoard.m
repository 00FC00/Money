//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"


//#define FACE_COUNT_ALL  85

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  35


@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (id)init {

    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];

        
      _emojiArray = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"f001@2x.png"],
                       [UIImage imageNamed:@"f002@2x.png"],
                       [UIImage imageNamed:@"f003@2x.png"],
                       [UIImage imageNamed:@"f004@2x.png"],
                       [UIImage imageNamed:@"f005@2x.png"],
                       [UIImage imageNamed:@"f006@2x.png"],
                       [UIImage imageNamed:@"f007@2x.png"],
                       [UIImage imageNamed:@"f008@2x.png"],
                       [UIImage imageNamed:@"f009@2x.png"],
                       [UIImage imageNamed:@"f010@2x.png"],
                       [UIImage imageNamed:@"f011@2x.png"],
                       [UIImage imageNamed:@"f012@2x.png"],
                       [UIImage imageNamed:@"f013@2x.png"],
                       [UIImage imageNamed:@"f014@2x.png"],
                       [UIImage imageNamed:@"f015@2x.png"],
                       [UIImage imageNamed:@"f016@2x.png"],
                       [UIImage imageNamed:@"f017@2x.png"],
                       [UIImage imageNamed:@"f018@2x.png"],
                       [UIImage imageNamed:@"f019@2x.png"],
                       [UIImage imageNamed:@"f020@2x.png"],
                       [UIImage imageNamed:@"f021@2x.png"],
                       [UIImage imageNamed:@"f022@2x.png"],
                       [UIImage imageNamed:@"f023@2x.png"],
                       [UIImage imageNamed:@"f024@2x.png"],
                       [UIImage imageNamed:@"f025@2x.png"],
                       [UIImage imageNamed:@"f026@2x.png"],
                       [UIImage imageNamed:@"f027@2x.png"],
                       [UIImage imageNamed:@"f028@2x.png"],
                       [UIImage imageNamed:@"f029@2x.png"],
                       [UIImage imageNamed:@"f030@2x.png"],
                     [UIImage imageNamed:@"f031@2x.png"],
                     [UIImage imageNamed:@"f032@2x.png"],
                     [UIImage imageNamed:@"f033@2x.png"],
                     [UIImage imageNamed:@"f034@2x.png"],
                     [UIImage imageNamed:@"f035@2x.png"],
                     [UIImage imageNamed:@"f036@2x.png"],
                     [UIImage imageNamed:@"f037@2x.png"],
                     [UIImage imageNamed:@"f038@2x.png"],
                     [UIImage imageNamed:@"f039@2x.png"],
                     [UIImage imageNamed:@"f040@2x.png"],
                     [UIImage imageNamed:@"f041@2x.png"],
                     [UIImage imageNamed:@"f042@2x.png"],
                     [UIImage imageNamed:@"f043@2x.png"],
                     [UIImage imageNamed:@"f044@2x.png"],
                     [UIImage imageNamed:@"f045@2x.png"],
                     [UIImage imageNamed:@"f046@2x.png"],
                     [UIImage imageNamed:@"f047@2x.png"],
                     [UIImage imageNamed:@"f048@2x.png"],
                     [UIImage imageNamed:@"f049@2x.png"],
                     [UIImage imageNamed:@"f050@2x.png"],
                     [UIImage imageNamed:@"f051@2x.png"],
                     [UIImage imageNamed:@"f052@2x.png"],
                     [UIImage imageNamed:@"f053@2x.png"],
                     [UIImage imageNamed:@"f054@2x.png"],
                     [UIImage imageNamed:@"f055@2x.png"],
                     [UIImage imageNamed:@"f056@2x.png"],
                     [UIImage imageNamed:@"f057@2x.png"],
                     [UIImage imageNamed:@"f058@2x.png"],
                     [UIImage imageNamed:@"f059@2x.png"],
                     [UIImage imageNamed:@"f060@2x.png"],
                     [UIImage imageNamed:@"f061@2x.png"],
                     [UIImage imageNamed:@"f062@2x.png"],
                     [UIImage imageNamed:@"f063@2x.png"],
                     [UIImage imageNamed:@"f064@2x.png"],
                     [UIImage imageNamed:@"f065@2x.png"],
                     [UIImage imageNamed:@"f066@2x.png"],
                     [UIImage imageNamed:@"f067@2x.png"],
                     [UIImage imageNamed:@"f068@2x.png"],
                     [UIImage imageNamed:@"f069@2x.png"],
                     [UIImage imageNamed:@"f070@2x.png"],
                     [UIImage imageNamed:@"f071@2x.png"],
                     [UIImage imageNamed:@"f072@2x.png"],
                    
                       nil];
        
        
        
        
        _symbolArray = [[NSArray alloc]initWithObjects:
                        @"[微笑]",@"[撇嘴]",@"[色色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[难过]",@"[大哭]",@"[尴尬]",@"[发怒]",@"[调皮]",@"[呲牙]",@"[惊讶]",@"[难过]",@"[酷酷]",@"[冷汗]",@"[抓狂]",@"[吐了]",@"[偷笑]",@"[愉快]",@"[白眼]",@"[傲慢]",@"[饥饿]",@"[困了]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[悠闲]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘嘘]",@"[晕了]",@"[疯了]",@"[衰了]",@"[骷髅]",@"[敲打]",@"[再见]",@"[擦汗]",@"[抠鼻]",@"[鼓掌]",@"[出糗]",@"[坏笑]",@"[左哼]",@"[右哼]",@"[哈欠]",@"[鄙视]",@"[委屈]",@"[快哭]",@"[阴险]",@"[亲亲]",@"[吓吓]",@"[可怜]",@"[菜刀]",@"[西瓜]",@"[啤酒]",@"[篮球]",@"[乒乓]",@"[咖啡]",@"[饭饭]",@"[猪头]",@"[玫瑰]",@"[凋谢]",@"[嘴唇]",@"[爱心]",@"[心碎]",@"[蛋糕]",@"[闪电]",@"[炸弹]",@"[刀刀]", nil];
       

        


        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((_emojiArray.count / FACE_COUNT_PAGE + 1) * 320, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i <= _emojiArray.count; i++) {

            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 6 + ((i - 1) / FACE_COUNT_PAGE * 320)+(((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU)*(320-FACE_ICON_SIZE*7)/8;
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 12;
            faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
            
            [faceButton setImage:[_emojiArray objectAtIndex:i-1] forState:UIControlStateNormal];

            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 170, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = _emojiArray.count / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"发送" forState:UIControlStateNormal];
        [back setBackgroundImage:[UIImage imageNamed:@"senditem.png"] forState:UIControlStateNormal];
        back.titleLabel.font = [UIFont systemFontOfSize:15];
        [back setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [back setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
//        [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(252, 178, 58, 28);
        [self addSubview:back];
    }

    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [facePageControl setCurrentPage:faceView.contentOffset.x / 320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * 320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {

//    int i = ((FaceButton*)sender).buttonIndex;
//    if (self.inputTextField) {
//
//        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
//        [faceString appendString:[_symbolArray objectAtIndex:i]];
//                self.inputTextField.text = faceString;
//    }
//
//    if (self.inputTextView) {
//
//        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
//        [faceString appendString:[_symbolArray objectAtIndex:i]];
//        self.inputTextView.text = faceString;
//
//        [delegate textViewDidChange:self.inputTextView];
//    }
    
    int i = ((FaceButton*)sender).buttonIndex;
    
    [delegate faceWithBoardView:self andFaceText:[_symbolArray objectAtIndex:i-1]];
    
}

- (void)backFace{

//    NSString *inputString;
//    inputString = self.inputTextField.text;
//    if ( self.inputTextView ) {
//
//        inputString = self.inputTextView.text;
//    }
//
//    if ( inputString.length ) {
//        
//        NSString *string = nil;
//        NSInteger stringLength = inputString.length;
//        if ( stringLength >= FACE_NAME_LEN ) {
//            
//            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
//            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
//            if ( range.location == 0 ) {
//                
//                string = [inputString substringToIndex:
//                          [inputString rangeOfString:FACE_NAME_HEAD
//                                             options:NSBackwardsSearch].location];
//            }
//            else {
//                
//                string = [inputString substringToIndex:stringLength - 1];
//            }
//        }
//        else {
//            
//            string = [inputString substringToIndex:stringLength - 1];
//        }
//        
//        if ( self.inputTextField ) {
//            
//            self.inputTextField.text = string;
//        }
//        
//        if ( self.inputTextView ) {
//            
//            self.inputTextView.text = string;
//            
//            [delegate textViewDidChange:self.inputTextView];
//        }
//    }
    
    
    [delegate sendFaceBoard];
}



@end
