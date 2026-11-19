package com.hotpoint.braveManIII.models.petEquip
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.repository.petEquip.*;
   import src.*;
   
   public class PetEquip
   {
      
      private var _id:VT;
      
      public function PetEquip()
      {
         super();
      }
      
      public static function creatPetEquip(param1:Number) : PetEquip
      {
         var _loc2_:PetEquip = new PetEquip();
         _loc2_._id = VT.createVT(param1);
         return _loc2_;
      }
      
      public function getId() : Number
      {
         return _id.getValue();
      }
      
      public function getName() : String
      {
         return PetEquipFactory.findName(_id.getValue());
      }
      
      public function getFrame() : Number
      {
         return PetEquipFactory.findFrame(_id.getValue());
      }
      
      public function getType() : Number
      {
         return PetEquipFactory.findType(_id.getValue());
      }
      
      public function getPrice() : Number
      {
         return PetEquipFactory.findPrice(_id.getValue());
      }
      
      public function getColor() : Number
      {
         return PetEquipFactory.findColor(_id.getValue());
      }
      
      public function getSkillDescript() : String
      {
         return PetEquipFactory.findSkillDescript(_id.getValue());
      }
      
      public function getDescript() : String
      {
         return PetEquipFactory.findDescript(_id.getValue());
      }
      
      public function getAffect() : Array
      {
         return PetEquipFactory.findAffect(_id.getValue());
      }
      
      public function getXingge() : Array
      {
         return PetEquipFactory.findXingge(_id.getValue());
      }
      
      public function getXinggeTxT() : String
      {
         var _loc1_:String = "";
         var _loc2_:Array = PetEquipFactory.findXingge(_id.getValue());
         if(_loc2_.length < 12)
         {
            for(i in _loc2_)
            {
               if(_loc2_[i] == 1)
               {
                  _loc1_ += "热血 ";
               }
               if(_loc2_[i] == 2)
               {
                  _loc1_ += "坚韧 ";
               }
               if(_loc2_[i] == 3)
               {
                  _loc1_ += "领袖 ";
               }
               if(_loc2_[i] == 4)
               {
                  _loc1_ += "狂傲 ";
               }
               if(_loc2_[i] == 5)
               {
                  _loc1_ += "倔强 ";
               }
               if(_loc2_[i] == 6)
               {
                  _loc1_ += "敏锐 ";
               }
               if(_loc2_[i] == 7)
               {
                  _loc1_ += "激进 ";
               }
               if(_loc2_[i] == 8)
               {
                  _loc1_ += "聪慧 ";
               }
               if(_loc2_[i] == 9)
               {
                  _loc1_ += "暴躁 ";
               }
               if(_loc2_[i] == 10)
               {
                  _loc1_ += "稳重 ";
               }
               if(_loc2_[i] == 11)
               {
                  _loc1_ += "邪恶 ";
               }
               if(_loc2_[i] == 12)
               {
                  _loc1_ += "睿智 ";
               }
            }
         }
         else
         {
            _loc1_ = "全部性格";
         }
         return _loc1_;
      }
      
      public function get id() : VT
      {
         return _id;
      }
      
      public function set id(param1:VT) : void
      {
         _id = param1;
      }
   }
}

