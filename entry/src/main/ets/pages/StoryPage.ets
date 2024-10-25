import { ComponentContent, router } from '@kit.ArkUI';
import { Cards } from '../Model/CardsModel';
import CardsView from '../ViewModel/CardsView';
import {CardsModel} from '../Model/CardsModel'
import { buildImage } from '../ViewModel/DialogComponent';
import DataPersistence from '../ViewModel/DataPersistence';

interface Params {
  ImageResource: Resource;
}
@Entry
@Component
struct StoryPage {
  @State ShownCards:Array<Cards>=new Array(14)
  @StorageLink("Locks")@Watch("Change") Locks:Array<boolean>=[]
  Change(){
    //根据locks更新ShownCards
    this.ShownCards = this.Locks.map((lock, i) => lock ? this.CardsBackground[i] : this.Tarot[i]);
  }
  context: Context=getContext(this)
  CardsBackground:Array<Cards>=[]
  Tarot:Array<Cards>=[]
  LimitTime:Array<number>=[5,60,60,50,50,50,40,40,40,30,30,30,20,10]
  LimitScore:Array<number>=[1,5,5,10,10,10,15,15,15,20,20,20,30,40]
  aboutToAppear(): void {
    //读取Locks
    DataPersistence.getBoolArray(this.context).then((boolArray: boolean[])=>{
      this.Locks=boolArray
      console.log("Locks:"+this.Locks)
    })
    let cardsModel=new CardsModel()
    this.Tarot=cardsModel.getCardsTarot()
    this.CardsBackground=cardsModel.getShowCards(14)
    this.ShownCards = this.Locks.map((lock, i) => lock ? this.CardsBackground[i] : this.Tarot[i]);
  }
  aboutToDisappear(): void {
    this.Tarot=[]
    this.ShownCards=[]
    this.CardsBackground=[]
    DataPersistence.putBoolArray(this.Locks,this.context)
  }
  @Builder BuildCardRow(){
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      wrap: FlexWrap.Wrap,
      alignItems: ItemAlign.Center,
      alignContent: FlexAlign.SpaceAround
    }){
      ForEach(this.ShownCards,(item:Cards,index:number)=> {
        CardsView({Card:item})
          .onClick(()=>{
            if(this.Locks[index]){
              router.pushUrl({
                url: 'pages/ChallengePage',
                params: {
                  Index: item.CardNum,
                  LimitTime: this.LimitTime[item.CardNum-1],
                  LimitScore: this.LimitScore[item.CardNum-1]
                }
              })
              console.log('点击了卡牌'+JSON.stringify(this.ShownCards[index].CardImage))
              console.log('进入了难题'+this.ShownCards[index].CardNum)
            }
            else{
              const promptAction = this.getUIContext().getPromptAction();
              const contentNode = new ComponentContent(this.getUIContext(), wrapBuilder(buildImage),
                { ImageResource: item.CardImage} as Params);
              promptAction.openCustomDialog(contentNode, { alignment: DialogAlignment.Center });
              console.log("showCustomDialog")
            }
          })
      })
    }
    .width('88%')
    .height('80%')
    .borderRadius(15)
    .border({width:2,color:0x997e63})
  }
  build() {
    Column({ space: 30}){
      //标题
      Button("闯关模式")
        .type(ButtonType.Capsule)
        .backgroundColor(0x110b27)
        .fontColor(0xaaa6ca)
        .fontWeight(800)
        .width(100)
        .height(20)
        .fontSize(11)
        .borderWidth(2)
        .borderColor(0x997e63)
      //关卡图片展示
      this.BuildCardRow()
      //返回按钮
      Row({ space: 40}){
        SymbolGlyph($r('sys.symbol.arrow_left_circle'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            router.back()
          })
        SymbolGlyph($r('sys.symbol.lock_open_fill'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            this.Locks=new Array(14).fill(false)
            this.ShownCards=this.Tarot.slice()
            DataPersistence.putBoolArray(this.Locks,this.context)
          })
        SymbolGlyph($r('sys.symbol.lock_fill'))
          .fontColor([0x99816c])
          .fontWeight(400)
          .fontSize(40)
          .effectStrategy(1)
          .onClick(() => {
            this.Locks=new Array(14).fill(true)
            this.ShownCards=this.CardsBackground.slice()
            DataPersistence.putBoolArray(this.Locks,this.context)
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