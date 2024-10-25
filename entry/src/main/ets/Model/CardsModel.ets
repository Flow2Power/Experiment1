export class Cards{
  public CardNum: number;
  public CardImage:Resource;

  constructor(CardNum: number, CardImage: Resource) {
    this.CardNum = CardNum;
    this.CardImage = CardImage;
  }
}
export class CardsModel{
  //数据定义
  CardsHF:Array<Cards>=[]//红方
  CardsHT:Array<Cards>=[]//黑桃
  CardsHX:Array<Cards>=[]//红心
  CardsMH:Array<Cards>=[]//黑梅
  CardsTarot:Array<Cards>=[]//塔罗牌
  ShowCards:Array<Cards>=[]//被选中的卡牌默认界面
  //数据获取函数
  //获取红方卡牌
  getCardsHF():Array<Cards>{
    for (let item = 1; item <= 13; item++) {
      this.CardsHF.push(new Cards(item,$r(`app.media.ImageHF${item}`)))
    }
    return this.CardsHF
  }
  //获取黑桃卡牌
  getCardsHT():Array<Cards>{
    for (let item = 1; item <= 13; item++) {
      this.CardsHT.push(new Cards(item,$r(`app.media.ImageHT${item}`)))
    }
    return this.CardsHT
  }
  //获取红心卡牌
  getCardsHX():Array<Cards>{
    for (let item = 1; item <= 13; item++) {
      this.CardsHX.push(new Cards(item,$r(`app.media.ImageHX${item}`)))
    }
    return this.CardsHX
  }
  //获取黑梅卡牌
  getCardsMH():Array<Cards>{
    for (let item = 1; item <= 13; item++) {
      this.CardsMH.push(new Cards(item,$r(`app.media.ImageMH${item}`)))
    }
    return this.CardsMH
  }
  //获取塔罗牌
  getCardsTarot():Array<Cards>{
    for (let item = 1; item <= 14; item++) {
      this.CardsTarot.push(new Cards(item,$r(`app.media.Image${item}`)))
    }
    return this.CardsTarot
  }
  //获取显示的卡牌
  getShowCards(num:number):Array<Cards>{
    for(let i=0;i<num;i++){
      this.ShowCards.push(new Cards(i+1,$r("app.media.CardsBackground")))
    }
    return this.ShowCards
  }
}
export default new CardsModel()