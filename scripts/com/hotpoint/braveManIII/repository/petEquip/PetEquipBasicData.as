package com.hotpoint.braveManIII.repository.petEquip
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.petEquip.*;
   
   public class PetEquipBasicData
   {
      
      private var _id:VT;
      
      private var _frame:VT;
      
      private var _name:String;
      
      private var _type:VT;
      
      private var _price:VT;
      
      private var _color:VT;
      
      private var _skilldescript:String;
      
      private var _descript:String;
      
      private var _xingge:Array = [];
      
      private var _affect:Array = [];
      
      public function PetEquipBasicData()
      {
         super();
      }
      
      public static function createPetEquipBasicData(param1:Number, param2:Number, param3:String, param4:Number, param5:Number, param6:Number, param7:String, param8:String, param9:Array, param10:Array) : PetEquipBasicData
      {
         var _loc11_:PetEquipBasicData = new PetEquipBasicData();
         _loc11_._id = VT.createVT(param1);
         _loc11_._frame = VT.createVT(param2);
         _loc11_._name = param3;
         _loc11_._type = VT.createVT(param4);
         _loc11_._price = VT.createVT(param5);
         _loc11_._color = VT.createVT(param6);
         _loc11_._skilldescript = param7;
         _loc11_._descript = param8;
         _loc11_._xingge = param9;
         _loc11_._affect = param10;
         return _loc11_;
      }
      
      public function getId() : Number
      {
         return _id.getValue();
      }
      
      public function getName() : String
      {
         return _name;
      }
      
      public function getFrame() : Number
      {
         return _frame.getValue();
      }
      
      public function getType() : Number
      {
         return _type.getValue();
      }
      
      public function getPrice() : Number
      {
         return _price.getValue();
      }
      
      public function getColor() : Number
      {
         return _color.getValue();
      }
      
      public function getSkillDescript() : String
      {
         return _skilldescript;
      }
      
      public function getDescript() : String
      {
         return _descript;
      }
      
      public function getAffect() : Array
      {
         return _affect;
      }
      
      public function getXingge() : Array
      {
         return _xingge;
      }
      
      public function createPetEquip() : PetEquip
      {
         return PetEquip.creatPetEquip(_id.getValue());
      }
      
      public function get id() : VT
      {
         return _id;
      }
      
      public function set id(param1:VT) : void
      {
         _id = param1;
      }
      
      public function get frame() : VT
      {
         return _frame;
      }
      
      public function set frame(param1:VT) : void
      {
         _frame = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get type() : VT
      {
         return _type;
      }
      
      public function set type(param1:VT) : void
      {
         _type = param1;
      }
      
      public function get color() : VT
      {
         return _color;
      }
      
      public function set color(param1:VT) : void
      {
         _color = param1;
      }
      
      public function get skilldescript() : String
      {
         return _skilldescript;
      }
      
      public function set skilldescript(param1:String) : void
      {
         _skilldescript = param1;
      }
      
      public function get descript() : String
      {
         return _descript;
      }
      
      public function set descript(param1:String) : void
      {
         _descript = param1;
      }
      
      public function get xingge() : Array
      {
         return _xingge;
      }
      
      public function set xingge(param1:Array) : void
      {
         _xingge = param1;
      }
      
      public function get affect() : Array
      {
         return _affect;
      }
      
      public function set affect(param1:Array) : void
      {
         _affect = param1;
      }
      
      public function get price() : VT
      {
         return _price;
      }
      
      public function set price(param1:VT) : void
      {
         _price = param1;
      }
   }
}

