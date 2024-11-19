export class Calculation {
  private ops: string[] = ["+", "-", "×", "÷"];
  private operatorSeq: string[] = []; // 操作符处理顺序
  private dataSeq: number[][] = []; // 数据处理顺序
  private results: string[] = []; // 计算结果
  private data: number[] = [];
  // 获取数据处理顺序
  private getData(): number[][] {
    const permutations = (arr: number[], m: number[] = []) => {
      if (arr.length === 0) {
        this.dataSeq.push(m);
      } else {
        for (let i = 0; i < arr.length; i++) {
          const curr = arr.slice();
          const next = curr.splice(i, 1);
          permutations(curr.slice(), m.concat(next));
        }
      }
    };
    permutations(this.data);
    return this.dataSeq;
  }
  // 获取操作符处理顺序
  private getOperator(): string[] {
    const generateCombinations = (arr: string[], length: number, prefix: string = "") => {
      if (length === 0) {
        this.operatorSeq.push(prefix);
      } else {
        for (let i = 0; i < arr.length; i++) {
          generateCombinations(arr, length - 1, prefix + arr[i]);
        }
      }
    };
    generateCombinations(this.ops, 3);
    return this.operatorSeq;
  }
  // 根据操作符计算两个数字间的运算结果
  private NumCalculate(x: number, y: number, op: string): number {
    switch (op) {
      case '+':
        return x + y;
      case '-':
        return x - y;
      case '×':
        return x * y;
      case '÷':
        return y === 0 || x % y !== 0 ? -100000 : x / y;
      default:
        return -100000;
    }
  }
  // 计算是否满足24点的要求
  private doCalculate(data: number[], op: string): boolean {
    const calculate = (expr: string, result: number) => {
      if (result === 24) {
        this.results.push(`${expr}=24`);
        return true;
      }
      return false;
    };
    const a = data[0], b = data[1], c = data[2], d = data[3];
    const op1 = op[0], op2 = op[1], op3 = op[2];
    let success = false;
    // ((a op b) op c) op d
    let result1 = this.NumCalculate(this.NumCalculate(this.NumCalculate(a, b, op1), c, op2), d, op3);
    success = success || calculate(`((${a}${op1}${b})${op2}${c})${op3}${d}`, result1);
    // (a op (b op c)) op d
    let result2 = this.NumCalculate(this.NumCalculate(a, this.NumCalculate(b, c, op2), op1), d, op3);
    success = success || calculate(`(${a}${op1}(${b}${op2}${c}))${op3}${d}`, result2);
    // a op ((b op c) op d)
    let result3 = this.NumCalculate(a, this.NumCalculate(this.NumCalculate(b, c, op2), d, op3), op1);
    success = success || calculate(`${a}${op1}((${b}${op2}${c})${op3}${d})`, result3);
    // a op (b op (c op d))
    let result4 = this.NumCalculate(a, this.NumCalculate(b, this.NumCalculate(c, d, op3), op2), op1);
    success = success || calculate(`${a}${op1}(${b}${op2}(${c}${op3}${d}))`, result4);
    // (a op b) op (c op d)
    let result5 = this.NumCalculate(this.NumCalculate(a, b, op1), this.NumCalculate(c, d, op3), op2);
    success = success || calculate(`(${a}${op1}${b})${op2}(${c}${op3}${d})`, result5);
    return success;
  }
  // 通过遍历的方式计算所有组合是否满足24点要求
  private Calculate24() {
    this.results = [];
    for (const temp of this.dataSeq) {
      for (const op of this.operatorSeq) {
        this.doCalculate(temp, op);
      }
    }
  }
  // 计算，将上述步骤组合成一个方法
  public Calculate(nums: number[]): void {
    this.data = nums;
    this.getData();
    this.getOperator();
    this.Calculate24();
    this.data = [];
  }
  //获取计算结果
  public getResult(): string[] {
    return this.results;
  }
  // 重置数据
}
export default new Calculation();
