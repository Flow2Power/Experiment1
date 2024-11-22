import { ComponentContent, promptAction, router } from '@kit.ArkUI';
import  CardsModel,{ Cards } from '../Model/CardsModel';
import CardsView from '../ViewModel/CardsView';
import { buildResults } from '../ViewModel/DialogComponent';
import {Calculation} from '../Model/Calculation';

interface ResultsParams{
  ResultsResource: Array<string>;
}
@Entry
@Component
struct ClassicPage {
  ChosenCardsNum: number = 0
  @State ChosenCards: Array<Cards> = []
  CardsHF:Array<Cards>=[]
  CardsHT:Array<Cards>=[]
  CardsHX:Array<Cards>=[]
  CardsMH:Array<Cards>=[]
  ShowCards:Array<Cards>=[]
  scrollerHF:Scroller=new Scroller();
  scrollerHT:Scroller=new Scroller();
  scrollerHX:Scroller=new Scroller();
  scrollerMH:Scroller=new Scroller();
  aboutToAppear(): void {
    this.CardsHF=CardsModel.getCardsHF()
    this.CardsHT=CardsModel.getCardsHT()
    this.CardsHX=CardsModel.getCardsHX()
    this.CardsMH=CardsModel.getCardsMH()
    this.ShowCards=CardsModel.getShowCards(4)
    this.ChosenCards=this.ShowCards.slice()
  }
  //计算24点
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
    console.log("CardsNum:"+JSON.stringify(CardsNum))
    let calculation=new Calculation()
    calculation.Calculate(CardsNum)
    console.log("ansNum:"+JSON.stringify(calculation.getResult().length))
    const promptAction1 = this.getUIContext().getPromptAction();
    const contentNode = new ComponentContent(this.getUIContext(), wrapBuilder(buildResults),
      { ResultsResource: calculation.getResult()} as ResultsParams);
    promptAction1.openCustomDialog(contentNode, { alignment: DialogAlignment.Center })
    console.log("showCustomDialog")
    this.ChosenCards=this.ShowCards.slice()
    this.ChosenCardsNum=0
  }
  //构建可选择卡片列表
  @Builder BuildCardRow(cards:Array<Cards>,scroller:Scroller){
    Scroll(scroller){
      Row(){
        ForEach(cards,(item:Cards)=>{
          CardsView({Card:item})
            .onClick(()=>{
              if(this.ChosenCardsNum<4){
                this.ChosenCards[this.ChosenCardsNum]=item;
                this.ChosenCardsNum++
                console.log('ChosenCard:'+JSON.stringify(item.CardNum))
                console.log('ChosenCards:'+JSON.stringify(this.ChosenCards))
                console.log('ShownCards:'+JSON.stringify(this.ShowCards))
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
    Column({ space: 50}){
      //标题
      Button("经典模式")
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
            .onClick(
              () => {
                console.log('Card'+JSON.stringify(item))
              }
            )
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
      //显示4个花色的卡牌
      Column(){
        this.BuildCardRow(this.CardsHF,this.scrollerHF)
        this.BuildCardRow(this.CardsHT,this.scrollerHT)
        this.BuildCardRow(this.CardsHX,this.scrollerHX)
        this.BuildCardRow(this.CardsMH,this.scrollerMH)
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
              console.log('back')
              router.back()
            })
        //清空按钮
        SymbolGlyph($r('sys.symbol.trash'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            console.log('clear')
            this.ChosenCards.splice(0)
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