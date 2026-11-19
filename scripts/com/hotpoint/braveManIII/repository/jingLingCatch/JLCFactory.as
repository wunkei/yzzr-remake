package com.hotpoint.braveManIII.repository.jingLingCatch
{
   import com.hotpoint.braveManIII.Tool.*;
   import src.*;
   
   public class JLCFactory
   {
      
      public static var allData:Array = [];
      
      public static var myXml:XML = new XML();
      
      public function JLCFactory()
      {
         super();
      }
      
      public static function creatJLCFactory() : *
      {
         var _loc1_:JLCFactory = new JLCFactory();
         myXml = XMLAsset.createXML(Data2.jinglingbuzhuo);
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
         for each(_loc1_ in myXml.精灵捕捉)
         {
            _loc2_ = Number(_loc1_.编号);
            _loc3_ = Number(_loc1_.精灵编号);
            _loc4_ = Number(_loc1_.概率);
            _loc5_ = Number(_loc1_.关卡);
            _loc6_ = Number(_loc1_.增加概率);
            _loc7_ = [_loc2_,_loc3_,_loc4_,_loc5_,_loc6_];
            allData.push(_loc7_);
         }
      }
   }
}

