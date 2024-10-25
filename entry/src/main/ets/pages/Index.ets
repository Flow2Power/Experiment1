import { ComponentContent, router } from '@kit.ArkUI'
import { buildExplanation, buildStart } from '../ViewModel/DialogComponent'
import DataPersistence from '../ViewModel/DataPersistence';
interface ChallengeResultParams {
  Message: string;
  Image: Resource;
}
@Entry
@Component
struct Index {
  context=getContext(this)
  aboutToAppear(): void {
    let IS_FIRST_LAUNCH: boolean = false
    // 判断是否为第一次进入
    DataPersistence.getIsLogin(this.context).then((isLogin: boolean)=>{
      IS_FIRST_LAUNCH =isLogin
      console.log("是否首次进入："+IS_FIRST_LAUNCH)
      const promptAction1 = this.getUIContext().getPromptAction();
      let message = IS_FIRST_LAUNCH?"初次见面，开拓者，愿你旅途顺利~":"欢迎回来，开拓者，愿此行终抵群星~"
      let image=IS_FIRST_LAUNCH?$r("app.media.ImageQ2"):$r("app.media.ImageQ1")
      const contentNode2 = new ComponentContent(this.getUIContext(), wrapBuilder(buildStart),
        { Message:message,Image:image} as ChallengeResultParams);
      promptAction1.openCustomDialog(contentNode2, { alignment: DialogAlignment.Center })
      DataPersistence.putIsLogin(false,this.context)
    })
  }
  aboutToDisappear(): void {
    // 保存是否为第一次进入
    DataPersistence.putIsLogin(false,this.context)
  }
  build() {
    Column({ space: 30 }){
      Button("24点")
        .type(ButtonType.Capsule)
        .backgroundColor(0x342774)
        .fontColor(0xaaa6ca)
        .fontWeight(800)
        .fontFamily('Trebuchet MS')
        .width("80%")
        .height(100)
        .fontSize(80)
        .borderWidth(5)
        .borderColor(0x9d8268)
      Button("经典模式")
        .type(ButtonType.Capsule)
        .backgroundColor(0x342774)
        .fontColor(0xaaa6ca)
        .fontWeight(800)
        .width(100)
        .height(50)
        .fontSize(16)
        .borderWidth(2)
        .borderColor(0x9d8268)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/ClassicPage',
          })
          console.log("点击了经典模式")
        })
      Button("闯关模式")
        .type(ButtonType.Capsule)
        .backgroundColor(0x342774)
        .fontColor(0xaaa6ca)
        .fontWeight(800)
        .width(100)
        .height(50)
        .fontSize(16)
        .borderWidth(2)
        .borderColor(0x9d8268)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/StoryPage',
          })
          console.log("点击了闯关模式")
        })
      Button("游戏说明")
        .type(ButtonType.Capsule)
        .backgroundColor(0x342774)
        .fontColor(0xaaa6ca)
        .fontWeight(800)
        .width(100)
        .height(50)
        .fontSize(16)
        .borderWidth(2)
        .borderColor(0x9d8268)
        .onClick(()=>{
          const promptAction1 = this.getUIContext().getPromptAction();
          const contentNode = new ComponentContent(this.getUIContext(), wrapBuilder(buildExplanation));
          promptAction1.openCustomDialog(contentNode, { alignment: DialogAlignment.Center })
        })
      Text('').height('10%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor(0x181428)
    .backgroundImage($r('app.media.StartBackground'))
    .backgroundImageSize(ImageSize.Contain)
    .backgroundImagePosition(Alignment.Center)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
  }
}