package src._data
{
   import com.hotpoint.braveManIII.Tool.*;
   import com.hotpoint.braveManIII.models.common.*;
   import src.*;
   import src.tool.*;
   
   public class ShopFactory
   {
      
      public static var myXml:XML = new XML();
      
      public static var AllData:Array = new Array();
      
      public function ShopFactory()
      {
         super();
      }
      
      public static function creatFactory() : *
      {
         myXml = XMLAsset.createXML(Data2.shopData);
         InitDataX();
      }
      
      private static function InitDataX() : *
      {
         var _loc1_:XML = null;
         var _loc2_:uint = 0;
         for each(_loc1_ in myXml.点券商城)
         {
            _loc2_ = uint(_loc1_.排序);
            Shop4399.ShopArr[_loc2_] = new Array();
            Shop4399.ShopArr[_loc2_][0] = VT.createVT(Number(_loc1_.点券));
            Shop4399.ShopArr[_loc2_][1] = String(_loc1_.类型);
            Shop4399.ShopArr[_loc2_][2] = VT.createVT(Number(_loc1_.物品ID));
            Shop4399.ShopArr[_loc2_][3] = int(_loc1_.图标);
            Shop4399.ShopArr[_loc2_][4] = String(_loc1_.说明);
            Shop4399.ShopArr[_loc2_][5] = String(_loc1_.名称);
            Shop4399.ShopArr[_loc2_][6] = VT.createVT(_loc1_.商城ID);
            Shop4399.ShopArr[_loc2_][7] = VT.createVT(uint(_loc1_.ID));
            Shop4399.ShopArr[_loc2_][8] = uint(_loc1_.品质);
         }
      }
      
      public static function GetObjData_AllNum() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 1;
         while(_loc2_ < Shop4399.ShopArr.length)
         {
            if(Shop4399.ShopArr[_loc2_])
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function GetObjData(param1:uint, param2:uint = 1) : Object
      {
         var _loc4_:Object = null;
         var _loc3_:uint = 1;
         while(_loc3_ < Shop4399.ShopArr.length)
         {
            if(Boolean(Shop4399.ShopArr[_loc3_]) && (Shop4399.ShopArr[_loc3_][7] as VT).getValue() == param1)
            {
               _loc4_ = new Object();
               _loc4_.propId = "" + (Shop4399.ShopArr[_loc3_][6] as VT).getValue();
               _loc4_.count = param2;
               _loc4_.price = (Shop4399.ShopArr[_loc3_][0] as VT).getValue();
               _loc4_.idx = Main.saveNum;
               _loc4_.tag = "BuyObj_" + _loc4_.propId;
               TiaoShi.txtShow(">>>>>>>>>>>>>>>> GetObjData id = " + _loc4_.propId + ", dataObj.price = " + _loc4_.price);
               return _loc4_;
            }
            _loc3_++;
         }
         NewMC.Open("文字提示",Main._stage,400,400,30,0,true,2,"商城数据出错");
         return null;
      }
   }
}

