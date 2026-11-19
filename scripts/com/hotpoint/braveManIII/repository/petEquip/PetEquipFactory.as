package com.hotpoint.braveManIII.repository.petEquip
{
   import com.hotpoint.braveManIII.Tool.*;
   import com.hotpoint.braveManIII.models.petEquip.PetEquip;
   import flash.events.*;
   import src.*;
   
   public class PetEquipFactory
   {
      
      public static var allData:Array = [];
      
      public static var myXml:XML = new XML();
      
      public function PetEquipFactory()
      {
         super();
      }
      
      public static function creatpetEquipFactory() : *
      {
         var _loc1_:PetEquipFactory = new PetEquipFactory();
         myXml = XMLAsset.createXML(Data2.petEquip);
         _loc1_.creatpetEquipData();
      }
      
      public static function getPetEquipById(param1:Number) : PetEquipBasicData
      {
         var _loc2_:PetEquipBasicData = null;
         var _loc3_:PetEquipBasicData = null;
         for each(_loc3_ in allData)
         {
            if(_loc3_.getId() == param1)
            {
               _loc2_ = _loc3_;
            }
         }
         if(_loc2_ == null)
         {
            trace("找不到");
         }
         return _loc2_;
      }
      
      public static function findFrame(param1:Number) : Number
      {
         return getPetEquipById(param1).getFrame();
      }
      
      public static function findName(param1:Number) : String
      {
         return getPetEquipById(param1).getName();
      }
      
      public static function findType(param1:Number) : Number
      {
         return getPetEquipById(param1).getType();
      }
      
      public static function findPrice(param1:Number) : Number
      {
         return getPetEquipById(param1).getPrice();
      }
      
      public static function findColor(param1:Number) : Number
      {
         return getPetEquipById(param1).getColor();
      }
      
      public static function findSkillDescript(param1:Number) : String
      {
         return getPetEquipById(param1).getSkillDescript();
      }
      
      public static function findDescript(param1:Number) : String
      {
         return getPetEquipById(param1).getDescript();
      }
      
      public static function findXingge(param1:Number) : Array
      {
         return getPetEquipById(param1).getXingge();
      }
      
      public static function findAffect(param1:Number) : Array
      {
         return getPetEquipById(param1).getAffect();
      }
      
      public static function creatPetEquip(param1:Number) : PetEquip
      {
         return getPetEquipById(param1).createPetEquip();
      }
      
      private function creatpetEquipData() : *
      {
         xmlLoaded();
      }
      
      private function xmlLoaded() : *
      {
         var _loc1_:XML = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:XMLList = null;
         var _loc11_:Array = null;
         var _loc12_:XMLList = null;
         var _loc13_:Array = null;
         var _loc14_:XML = null;
         var _loc15_:XML = null;
         var _loc16_:PetEquipBasicData = null;
         for each(_loc1_ in myXml.宠物装备)
         {
            _loc2_ = Number(_loc1_.编号);
            _loc3_ = Number(_loc1_.帧数);
            _loc4_ = String(_loc1_.名字);
            _loc5_ = Number(_loc1_.类型);
            _loc6_ = Number(_loc1_.价格);
            _loc7_ = Number(_loc1_.品质);
            _loc8_ = String(_loc1_.技能描述);
            _loc9_ = String(_loc1_.描述);
            _loc10_ = _loc1_.性格数组;
            _loc11_ = [];
            _loc12_ = _loc1_.数值数组;
            _loc13_ = [];
            for each(_loc14_ in _loc10_)
            {
               if(_loc14_.热血 != "null")
               {
                  _loc11_.push(1);
               }
               if(_loc14_.坚韧 != "null")
               {
                  _loc11_.push(2);
               }
               if(_loc14_.领袖 != "null")
               {
                  _loc11_.push(3);
               }
               if(_loc14_.狂傲 != "null")
               {
                  _loc11_.push(4);
               }
               if(_loc14_.倔强 != "null")
               {
                  _loc11_.push(5);
               }
               if(_loc14_.敏锐 != "null")
               {
                  _loc11_.push(6);
               }
               if(_loc14_.激进 != "null")
               {
                  _loc11_.push(7);
               }
               if(_loc14_.聪慧 != "null")
               {
                  _loc11_.push(8);
               }
               if(_loc14_.暴躁 != "null")
               {
                  _loc11_.push(9);
               }
               if(_loc14_.稳重 != "null")
               {
                  _loc11_.push(10);
               }
               if(_loc14_.邪恶 != "null")
               {
                  _loc11_.push(11);
               }
               if(_loc14_.睿智 != "null")
               {
                  _loc11_.push(12);
               }
            }
            for each(_loc15_ in _loc12_)
            {
               if(_loc15_.预留1 != "null")
               {
                  _loc13_.push(Number(_loc15_.预留1));
               }
               if(_loc15_.预留2 != "null")
               {
                  _loc13_.push(Number(_loc15_.预留2));
               }
               if(_loc15_.预留3 != "null")
               {
                  _loc13_.push(Number(_loc15_.预留3));
               }
               if(_loc15_.预留4 != "null")
               {
                  _loc13_.push(Number(_loc15_.预留4));
               }
               if(_loc15_.预留5 != "null")
               {
                  _loc13_.push(Number(_loc15_.预留5));
               }
            }
            _loc16_ = PetEquipBasicData.createPetEquipBasicData(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc11_,_loc13_);
            allData.push(_loc16_);
         }
      }
   }
}

