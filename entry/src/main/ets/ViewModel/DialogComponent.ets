//相关接口参数
class Params {
  ImageResource: Resource;
  constructor(ImageResource: Resource) {
    this.ImageResource = ImageResource;
  }
}
class ResultsParams {
  ResultsResource: Array<string>;
  constructor(ResultsResource: Array<string>) {
    this.ResultsResource = ResultsResource;
  }
}
class LimitationParams {
  ParamsTime: number
  LimitTime: number
  LimitScore: number
  constructor(ParamsTime: number,LimitTime: number, LimitScore: number) {

    this.ParamsTime = ParamsTime;
    this.LimitTime = LimitTime;
    this.LimitScore = LimitScore;
  }
}
class ChallengeResultParams {
  Message: string;
  Image: Resource;
  constructor(Message: string, Image: Resource) {
    this.Message = Message;
    this.Image = Image;
  }
}
class StartParams {
  Message: string;
  Image: Resource;
  constructor(Message: string, Image: Resource) {
    this.Message = Message;
    this.Image = Image;
  }
}
//计算结果
@Builder
export function buildResults(params: ResultsParams){
  Column({ space: 5}){
    Text('计算结果')
      .fontColor(0xdbdce1)
      .fontWeight(400)
      .width('60%')
      .height(50)
      .fontSize(35)
      .borderWidth(2)
      .borderColor(0x997e63)
      .borderRadius(24)
      .backgroundColor(0x7160a7)
      .textAlign(TextAlign.Center)
    if (params.ResultsResource.length == 0) {
      Image($r('app.media.ImageSparkle'))
        .width('90%')
        .height('70%')
        .borderWidth(3)
        .borderColor(0x9d8268)
      Text('这里什么都没有呢~小灰毛~')
        .fontColor(0x9d8268)
        .fontWeight(400)
        .width('70%')
        .height('10%')
        .fontSize(25)
        .textAlign(TextAlign.Center)
    } else {
      List({ space: 10, initialIndex: 0 }) {
        ForEach(params.ResultsResource, (item: string) => {
          ListItem() {
            Row() {
              Text('' + item)
                .width('100%')
                .height(20)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .backgroundColor(0xffffff)
                .margin({ top: 5, bottom: 5 })
            }
            .alignItems(VerticalAlign.Center)
          }
        })
      }
      .height('75%')
      .width('90%')
      .backgroundColor(0xcccccc)
      .border({ width: 2, color: 0x997e63 })
      .borderRadius(15)
      Text('一共有 ' + params.ResultsResource.length + ' 种组合')
        .fontColor(0x9d8268)
        .fontWeight(400)
        .width('70%')
        .height('10%')
        .fontSize(20)
        .textAlign(TextAlign.Center)
    }
  }
  .width('90%')
  .height('50%')
  .justifyContent(FlexAlign.Start)
  .alignItems(HorizontalAlign.Center)
  .backgroundImage($r("app.media.CardsBackground"))
  .backgroundImageSize(ImageSize.Cover)
  .backgroundImagePosition(Alignment.Center)
  .borderWidth(5)
  .borderColor(0x9d8268)
}
//限制条件
@Builder
export function buildLimitation(params: LimitationParams){
  Column({ space: 5}){
    Text('挑战目标')
      .fontColor(0xdbdce1)
      .fontWeight(400)
      .width('60%')
      .height('10%')
      .fontSize(35)
      .borderWidth(2)
      .borderColor(0x997e63)
      .borderRadius(24)
      .backgroundColor(0x7160a7)
      .textAlign(TextAlign.Center)
    Column(){
      Text('时间限制：' + params.LimitTime + '秒')
        .fontColor(0x9d8268)
        .fontWeight(400)
        .width('95%')
        .height('50%')
        .fontSize(25)
        .textAlign(TextAlign.Start)
      Text('通关分数：' + params.LimitScore + '分')
        .fontColor(0x9d8268)
        .fontWeight(400)
        .width('95%')
        .height('50%')
        .fontSize(25)
        .textAlign(TextAlign.Start)
    }
    .width('90%')
    .height('70%')
    .backgroundColor(0xcccccc)
    .border({ width: 2, color: 0x997e63 })
    .borderRadius(15)
    .borderColor(0x9d8268)
    Row(){
      Text(params.ParamsTime+'秒后自动关闭')
        .fontColor(0x9d8268)
        .fontWeight(400)
        .width('60%')
        .textAlign(TextAlign.Center)
    }
    .height('20%')
  }
  .width('80%')
  .height('55%')
  .justifyContent(FlexAlign.Start)
  .alignItems(HorizontalAlign.Center)
  .backgroundImage($r("app.media.CardsBackground"))
  .backgroundImageSize(ImageSize.FILL)
  .backgroundImagePosition(Alignment.Center)
  .borderWidth(5)
  .borderColor(0x9d8268)
}
//游戏说明
@Builder
export function buildExplanation(){
  Column({ space: 5}){
    Text('游戏说明')
      .fontColor(0xdbdce1)
      .fontWeight(400)
      .width('60%')
      .height('10%')
      .fontSize(35)
      .borderWidth(2)
      .borderColor(0x997e63)
      .borderRadius(24)
      .backgroundColor(0x7160a7)
      .textAlign(TextAlign.Center)
    Scroll(){
      Text(
        '一、游戏简介'+'\n'+
        '     24点游戏是一种数学益智游戏，目标是通过加、减、乘、除四种基本运算以及括号的使用，使得从一副扑克牌中随机抽取的4张牌（点数1至13，其中A代表1，J、Q、K分别代表11、12、13）的计算结果为24。\n' +
        '\n'+
          '二、经典模式'+'\n'+
      '     玩家需在“可选择卡片区域”点击卡牌，每次限选一张，将其添加至“已选择的卡片区域”，最多可选四张。若已达四张，再次点击将无效，并显示“已选4张牌，无法继续选择”。在“已选择的卡片区域”，玩家可查看当前已选的四张卡牌，点击卡牌虽暂无详细信息显示，但系统会自动记录已选数量。操作按钮包括返回、清空、撤销和确定。返回按钮用于返回上一级页面；清空按钮可清除所有已选卡牌，重置状态；撤销按钮仅能撤销最后一次选择的卡牌，若无卡牌可选则显示“当前未选择卡牌，无法撤销”；确定按钮在已选四张卡牌时开始计算24点，否则提示“请选择4张卡牌”。计算完成后，系统会弹出对话框显示所有符合条件的计算公式，若无则显示“这里什么都没有呢~”。撤销操作仅限最后一次选择，不能撤销多次。\n'+
      '三、闯关模式'+'\n' +
          '     玩家可以选择挑战十四个不同的关卡。玩家需先选择关卡，然后从可选择卡片区域中点击卡牌添加到已选择的卡片区域，每次限选一张，最多四张。选满四张后，点击确定按钮开始计算24点，卡组不符合要求扣一分，符合要求则加一分。未选满则会有提示。操作按钮包括返回上一级、清空已选、撤销最后一次选择和确定开始计算。每个关卡有时间限制和最低得分要求，倒计时结束后游戏自动返回主界面，达到要求则卡面解锁。玩家可以重新挑战未解锁的关卡。\n')
        .fontColor(0x9d8268)
        .fontWeight(400)
        .fontSize(20)
        .textAlign(TextAlign.Start)
    }
    .width('90%')
    .height('85%')
    .backgroundColor(0xcccccc)
    .border({ width: 2, color: 0x997e63 })
    .borderRadius(15)
    .borderColor(0x9d8268)
  }
  .width('80%')
  .height('70%')
  .justifyContent(FlexAlign.Start)
  .alignItems(HorizontalAlign.Center)
  .backgroundImage($r("app.media.CardsBackground"))
  .backgroundImageSize(ImageSize.FILL)
  .backgroundImagePosition(Alignment.Center)
  .borderWidth(5)
  .borderColor(0x9d8268)
}
//挑战结果
@Builder
export function buildChallengeResult(params: ChallengeResultParams){
  Column({ space: 5}){
    Text('挑战结果')
      .fontColor(0xdbdce1)
      .fontWeight(400)
      .width('60%')
      .height(50)
      .fontSize(35)
      .borderWidth(2)
      .borderColor(0x997e63)
      .borderRadius(24)
      .backgroundColor(0x7160a7)
      .textAlign(TextAlign.Center)
      Image(params.Image)
        .width('90%')
        .height('80%')
        .borderWidth(3)
        .borderColor(0x9d8268)
        .backgroundColor(Color.Black)
      Text(params.Message)
        .fontColor(0x9d8268)
        .fontWeight(400)
        .width('70%')
        .height(20)
        .fontSize(20)
        .textAlign(TextAlign.Center)
  }
  .width('80%')
  .height('60%')
  .justifyContent(FlexAlign.Start)
  .alignItems(HorizontalAlign.Center)
  .backgroundImage($r("app.media.CardsBackground"))
  .backgroundImageSize(ImageSize.Cover)
  .backgroundImagePosition(Alignment.Center)
  .borderWidth(5)
  .borderColor(0x9d8268)
}
//图片弹窗
@Builder
export function buildImage(params: Params) {
  Column() {
    Image(params.ImageResource)
      .objectFit(ImageFit.Contain)
      .width(500)
      .height(500)
  }
}
//首页弹窗
@Builder
export function buildStart(params: StartParams) {
  Column({ space: 5}){
    Image(params.Image)
      .width('95%')
      .height('80%')
      .borderWidth(3)
      .borderColor(0x9d8268)
      .backgroundColor(Color.Black)
    Text(params.Message)
      .fontColor(0x9d8268)
      .fontWeight(400)
      .width('70%')
      .height('20%')
      .fontSize(25)
      .textAlign(TextAlign.Center)
  }
  .width('90%')
  .height('60%')
  .justifyContent(FlexAlign.Start)
  .alignItems(HorizontalAlign.Center)
  .backgroundImage($r("app.media.CardsBackground"))
  .backgroundImageSize(ImageSize.FILL)
  .backgroundImagePosition(Alignment.Center)
  .borderWidth(5)
  .borderColor(0x9d8268)
}

