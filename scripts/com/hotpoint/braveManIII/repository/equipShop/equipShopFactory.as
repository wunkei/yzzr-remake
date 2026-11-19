package com.hotpoint.braveManIII.repository.equipShop
{
   import com.hotpoint.braveManIII.Tool.*;
   import src.*;
   
   public class equipShopFactory
   {
      
      public static var allData:Array = [];
      
      public static var myXml:XML = new XML();
      
      public function equipShopFactory()
      {
         super();
      }
      
      public static function creatEquipShopFactory() : *
      {
         var _loc1_:equipShopFactory = new equipShopFactory();
         myXml = XMLAsset.createXML(Data2.eShop);
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
         var _loc7_:Array = null;
         for each(_loc1_ in myXml.装备商店)
         {
            _loc2_ = Number(_loc1_.编号);
            _loc3_ = Number(_loc1_.帧数);
            _loc4_ = Number(_loc1_.价格);
            _loc5_ = Number(_loc1_.点卷编号);
            _loc6_ = Number(_loc1_.点卷价格);
            _loc7_ = [_loc2_,_loc3_,_loc4_,_loc5_,_loc6_];
            allData.push(_loc7_);
         }
      }
   }
}

