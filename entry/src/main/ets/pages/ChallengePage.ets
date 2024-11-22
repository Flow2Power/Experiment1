import { ComponentContent, promptAction, router } from '@kit.ArkUI';
import { CardsModel, Cards } from '../Model/CardsModel';
import CardsView from '../ViewModel/CardsView';
import { buildChallengeResult, buildLimitation } from '../ViewModel/DialogComponent';
import {Calculation} from '../Model/Calculation';
interface PageParams {
  Index: number
  LimitTime: number
  LimitScore: number
}
interface LimitationParams {
  ParamsTime: number
  LimitTime: number
  LimitScore: number
}
interface ChallengeResultParams {
  Message: string;
  Image: Resource;
}
@Entry
@Component
struct ChallengePage {
  @State ChosenCardsNum: number = 0
  @State ChosenCards: Array<Cards> = []
  @State Scores:number = 0
  @State counter: number = 0
  @StorageLink("Locks")Locks: Array<boolean>=new Array(14).fill(true)
  @State CardsHF:Array<Cards>=[]
  @State CardsHT:Array<Cards>=[]
  @State CardsHX:Array<Cards>=[]
  @State CardsMH:Array<Cards>=[]
  ShowCards:Array<Cards>=[]
  scrollerHF:Scroller=new Scroller();
  scrollerHT:Scroller=new Scroller();
  scrollerHX:Scroller=new Scroller();
  scrollerMH:Scroller=new Scroller();
  //页面参数
  PageNum:number=0
  limitTime:number=0
  limitScore:number=0
  aboutToAppear(): void {
    //获取页面参数
    const params = router.getParams() as PageParams
    this.PageNum=params.Index
    this.limitTime=params.LimitTime
    this.limitScore=params.LimitScore
    let cardsModel=new CardsModel()
    this.CardsHF=cardsModel.getCardsHF()
    this.CardsHT=cardsModel.getCardsHT()
    this.CardsHX=cardsModel.getCardsHX()
    this.CardsMH=cardsModel.getCardsMH()
    this.ShowCards=cardsModel.getShowCards(4)
    this.ChosenCards=this.ShowCards.slice()
    this.counter = this.limitTime+5
    //挑战要求弹窗
    const promptAction1 = this.getUIContext().getPromptAction();
    const contentNode = new ComponentContent(this.getUIContext(), wrapBuilder(buildLimitation),
      { ParamsTime:5,LimitTime: this.limitTime, LimitScore:this.limitScore} as LimitationParams);
    promptAction1.openCustomDialog(contentNode, { alignment: DialogAlignment.Center })
    promptAction1.openCustomDialog(contentNode, { alignment: DialogAlignment.Center })
    // 设置定时器，在 5 秒后关闭弹窗
    setTimeout(() => {
      promptAction1.closeCustomDialog(contentNode);
    }, 5000); // 5000 毫秒 = 5 秒
    let timer = setInterval(() => {
      if (this.counter > 0) {
        this.counter--
      } else {
        // 挑战结束，判定结果
        this.Locks[this.PageNum-1]=this.Scores<this.limitScore
        let message = this.Scores<this.limitScore?"通过了？嘿，才怪~":"恭喜你，通过了呢~"
        let image=this.Scores<this.limitScore?$r("app.media.ImageSparkleQ"):$r("app.media.ImageSwanQ")
        clearInterval(timer)
        const contentNode2 = new ComponentContent(this.getUIContext(), wrapBuilder(buildChallengeResult),
          { Message:message,Image:image} as ChallengeResultParams);
        promptAction1.openCustomDialog(contentNode2, { alignment: DialogAlignment.Center })
        // 设置定时器，在 5 秒后关闭弹窗
        setTimeout(() => {
          promptAction1.closeCustomDialog(contentNode2);
          router.back({
            url: 'pages/StoryPage'
          })
        }, 5000); // 5000 毫秒 = 5 秒
        console.log("返回挑战模式")
      }
    }, 1000)
  }
  aboutToDisappear(): void {
    this.ChosenCards=[]
    this.ShowCards=[]
    this.CardsHF=[]
    this.CardsHT=[]
    this.CardsHX=[]
    this.CardsMH=[]
    this.counter=0
    this.Scores=0
  }
  My24calculation(){
    if(this.ChosenCardsNum<4){
      promptAction.showToast({
        message: '请选择4张卡牌',
        duration: 2000
      })
      return
    }
    let CardsNum:Array<number>=[]
    for(let i=0;i<4;i++){
      CardsNum.push(this.ChosenCards[i].CardNum)
    }
    console.log('CardsNum:'+JSON.stringify(CardsNum))
    let calculation=new Calculation()
    calculation.Calculate(CardsNum)
    this.Scores+=(calculation.getResult().length==0)?-1:1
    this.ChosenCards=this.ShowCards.slice()
    this.ChosenCardsNum=0
  }
  //构建可选择卡片列表
  @Builder BuildCardRow1(scroller:Scroller){
    Scroll(scroller){
      Row(){
        ForEach(this.CardsHF,(item:Cards,index:number)=>{
          CardsView({Card:item})
            .onClick(()=>{
              if(this.ChosenCardsNum<4&&item.CardNum!=0){
                this.ChosenCards[this.ChosenCardsNum]=item;
                this.ChosenCardsNum++
                console.log('ChosenCard:'+JSON.stringify(item.CardNum))
                this.CardsHF[index]=this.ShowCards[0]
              }
              else{
                promptAction.showToast({
                  message: '已选4张牌，无法继续选择',
                  duration: 2000
                })
              }
            })
        })
      }
      .margin({bottom:3,top:3})
      .width('auto')
    }
    .width('88%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(5)
    .edgeEffect(EdgeEffect.Spring)
  }
  @Builder BuildCardRow2(scroller:Scroller){
    Scroll(scroller){
      Row(){
        ForEach(this.CardsHT,(item:Cards,index:number)=>{
          CardsView({Card:item})
            .onClick(()=>{
              if(this.ChosenCardsNum<4){
                this.ChosenCards[this.ChosenCardsNum]=item;
                this.ChosenCardsNum++
                console.log('ChosenCard:'+JSON.stringify(item.CardNum))
                this.CardsHT[index]=this.ShowCards[0]
              }
              else{
                promptAction.showToast({
                  message: '已选4张牌，无法继续选择',
                  duration: 2000
                })
              }
            })
        })
      }
      .margin({bottom:3,top:3})
      .width('auto')
    }
    .width('88%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(5)
    .edgeEffect(EdgeEffect.Spring)
  }
  @Builder BuildCardRow3(scroller:Scroller){
    Scroll(scroller){
      Row(){
        ForEach(this.CardsHX,(item:Cards,index:number)=>{
          CardsView({Card:item})
            .onClick(()=>{
              if(this.ChosenCardsNum<4){
                this.ChosenCards[this.ChosenCardsNum]=item;
                this.ChosenCardsNum++
                console.log('ChosenCard:'+JSON.stringify(item.CardNum))
                this.CardsHX[index]=this.ShowCards[0]
              }
              else{
                promptAction.showToast({
                  message: '已选4张牌，无法继续选择',
                  duration: 2000
                })
              }
            })
        })
      }
      .margin({bottom:3,top:3})
      .width('auto')
    }
    .width('88%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(5)
    .edgeEffect(EdgeEffect.Spring)
  }
  @Builder BuildCardRow4(scroller:Scroller){
    Scroll(scroller){
      Row(){
        ForEach(this.CardsMH,(item:Cards,index:number)=>{
          CardsView({Card:item})
            .onClick(()=>{
              if(this.ChosenCardsNum<4){
                this.ChosenCards[this.ChosenCardsNum]=item;
                this.ChosenCardsNum++
                console.log('ChosenCard:'+JSON.stringify(item.CardNum))
                this.CardsMH[index]=this.ShowCards[0]
              }
              else{
                promptAction.showToast({
                  message: '已选4张牌，无法继续选择',
                  duration: 2000
                })
              }
            })
        })
      }
      .margin({bottom:3,top:3})
      .width('auto')
    }
    .width('88%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(5)
    .edgeEffect(EdgeEffect.Spring)
  }
  build() {
    Column({ space: 25}){
      //标题
      Button('难题'+this.PageNum)
        .type(ButtonType.Capsule)
        .backgroundColor(0x110b27)
        .fontColor(0xaaa6ca)
        .fontWeight(800)
        .width(100)
        .height(20)
        .fontSize(11)
        .borderWidth(2)
        .borderColor(0x997e63)
      //显示已选择的卡片
      Row(){
        ForEach(this.ChosenCards,(item:Cards)=>{
          CardsView({Card:item})
        })
      }
      .height(120)
      .width('88%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({bottom:5})
      .borderWidth(2)
      .borderRadius(10)
      .borderColor(0x997e63)
      .backgroundColor(0x41395f)
      //显示倒计时与得分
      Row({ space: 40}){
        SymbolGlyph($r('sys.symbol.clock'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(30)
          .effectStrategy(1)
          .onClick(() => {
            console.log('back')
            router.back()
          })
        Text(`${this.counter}`)
          .fontColor(0xaaa6ca)
          .fontWeight(400)
          .width('auto')
          .fontSize(30)
          .textAlign(TextAlign.Center)
        SymbolGlyph($r('sys.symbol.grid'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(30)
          .effectStrategy(1)
          .onClick(() => {
            console.log('back')
            router.back()
          })
        Text(`${this.Scores}`)
          .fontColor(0xaaa6ca)
          .fontWeight(400)
          .width('auto')
          .fontSize(30)
          .textAlign(TextAlign.Center)
      }
      .width('88%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderWidth(2)
      .borderRadius(10)
      .borderColor(0x997e63)
      .backgroundColor(0x41395f)
      //显示4个花色的卡牌
      Column(){
        this.BuildCardRow1(this.scrollerHF)
        this.BuildCardRow2(this.scrollerHT)
        this.BuildCardRow3(this.scrollerHX)
        this.BuildCardRow4(this.scrollerMH)
      }
      .borderRadius(15)
      .border({width:2,color:0x997e63})
      //返回按钮
      Row({ space: 40}){
        SymbolGlyph($r('sys.symbol.arrow_left_circle'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            router.back()
            console.log("返回挑战模式")
          })
        //清空按钮
        SymbolGlyph($r('sys.symbol.trash'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            console.log('clear')
            this.ChosenCards=this.ShowCards.slice()
            this.ChosenCardsNum=0
          })
        //撤销按钮
        SymbolGlyph($r('sys.symbol.undo'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            console.log('undo')
            if(this.ChosenCardsNum==0){
              promptAction.showToast({
                message: '当前未选择卡牌，无法撤销',
                duration: 2000
              })
            }
            else{
              this.ChosenCardsNum--
              this.ChosenCards[this.ChosenCardsNum]=this.ShowCards[0]
            }
          })
        //确定按钮
        SymbolGlyph($r('sys.symbol.checkmark_circle'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            console.log('confirm');
            this.My24calculation()
          })
      }
      .alignItems(VerticalAlign.Center)
    }
    .height('100%')
    .width('100%')
    .backgroundColor(0x181428)
    .backgroundImage($r('app.media.StartBackground'))
    .backgroundImageSize(ImageSize.Contain)
    .backgroundImagePosition(Alignment.Center)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}