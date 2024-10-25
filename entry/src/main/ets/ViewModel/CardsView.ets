import { Cards } from "../Model/CardsModel";
//构建图片展示组件
@Component
export default struct CardsView{
  public Card:Cards=new Cards(0,$r("app.media.ImageSparkleQ"))
  build() {
    Column(){
      Image(this.Card.CardImage)
        .objectFit(ImageFit.Cover)
        .width(70)
        .height(110)
        .margin(2)
        .borderRadius(8)
        .border({width:2,color:0x997e63})
    }
    .borderRadius(24)
    .margin({left:2,right:2})
  }
}