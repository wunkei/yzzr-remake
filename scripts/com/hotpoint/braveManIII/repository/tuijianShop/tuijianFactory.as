package com.hotpoint.braveManIII.repository.tuijianShop
{
   import com.hotpoint.braveManIII.Tool.*;
   import src.*;
   
   public class tuijianFactory
   {
      
      public static var allData:Array = [];
      
      public static var myXml:XML = new XML();
      
      public function tuijianFactory()
      {
         super();
      }
      
      public static function creatTuiJianFactory() : *
      {
         var _loc1_:tuijianFactory = new tuijianFactory();
         myXml = XMLAsset.createXML(Data2.tjShop);
         _loc1_.creatFactory();
      }
      
      private function creatFactory() : *
      {
         xmlLoaded();
      }
      
      private function xmlLoaded() : *
      {
         var _loc1_:XML = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         for each(_loc1_ in myXml.推荐商店)
         {
            _loc2_ = Number(_loc1_.编号);
            _loc3_ = Number(_loc1_.级别);
            _loc4_ = Number(_loc1_.套装号);
            _loc5_ = Number(_loc1_.价格);
            _loc6_ = Number(_loc1_.点卷编号);
            _loc7_ = Number(_loc1_.点卷价格);
            _loc8_ = Number(_loc1_.类型);
            _loc9_ = Number(_loc1_.职业);
            _loc10_ = String(_loc1_.描述);
            _loc11_ = [_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_];
            allData.push(_loc11_);
         }
      }
   }
}

