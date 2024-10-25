import { BusinessError } from '@ohos.base';
import dataPreferences from '@ohos.data.preferences';

export class DataPersistence {
  //定义存储路径
  private static readonly PREFERENCES_PATH: string = 'DataPersistence';
  //定义存储键
  private static readonly KEY_BOOL_ARRAY: string = 'boolArray';
  private static readonly KEY_IS_LOGIN: string = 'isLogin';
  //定义存储对象
  private static preferences: dataPreferences.Preferences | undefined = undefined;
  //存储bool数组
  public static async putBoolArray(boolArray: boolean[], context: Context): Promise<void> {
    try {
      DataPersistence.preferences = await dataPreferences.getPreferences(context, DataPersistence.PREFERENCES_PATH);
      await DataPersistence.preferences.put(DataPersistence.KEY_BOOL_ARRAY, boolArray);
      await DataPersistence.preferences.flush();
      console.info('putBoolArray success');
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.error(`Failed to put boolArray. Code:${error.code}, message:${error.message}`);
    }
  }
  //获取bool数组
  public static async getBoolArray(context: Context): Promise<boolean[]> {
    try {
      DataPersistence.preferences = await dataPreferences.getPreferences(context, DataPersistence.PREFERENCES_PATH);
      let boolArray  = await DataPersistence.preferences.get(DataPersistence.KEY_BOOL_ARRAY, new Array(14).fill(true)) as boolean[];
      console.info('getBoolArray success');
      return boolArray;
    } catch (err) {
      let error:BusinessError = err as BusinessError;
      console.error(`Failed to get boolArray. Code:${error.code}, message:${error.message}`);
      return [];
    }
  }
  //存储是否登录
  public static async putIsLogin(isLogin: boolean, context: Context): Promise<void> {
    try {
      DataPersistence.preferences = await dataPreferences.getPreferences(context, DataPersistence.PREFERENCES_PATH);
      await DataPersistence.preferences.put(DataPersistence.KEY_IS_LOGIN, isLogin);
      await DataPersistence.preferences.flush();
      console.info('putIsLogin success');
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.error(`Failed to put isLogin.Code:${error.code}, message:${error.message}`);
    }
  }
  //获取是否登录
  public static async getIsLogin(context: Context): Promise<boolean> {
    try {
      DataPersistence.preferences = await dataPreferences.getPreferences(context, DataPersistence.PREFERENCES_PATH);
      let isLogin = await DataPersistence.preferences.get(DataPersistence.KEY_IS_LOGIN, true) as boolean;
      console.info('getIsLogin success');
      return isLogin;
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.error(`Failed to get isLogin. Code:${error.code}, message:${error.message}`);
      return false;
    }
  }
}
export default DataPersistence;