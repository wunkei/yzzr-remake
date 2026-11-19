package com.hotpoint.braveManIII.repository.gem
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.gem.*;
   import flash.utils.*;
   
   public class GemBaseData
   {
      
      private var _id:VT;
      
      private var _frame:VT;
      
      private var _className:String;
      
      private var _name:String;
      
      private var _times:VT;
      
      private var _type:VT;
      
      private var _isPile:Boolean;
      
      private var _isStrengthen:Boolean;
      
      private var _isCompound:Boolean;
      
      private var _dropLevel:VT;
      
      private var _useLevel:VT;
      
      private var _strengthenLevel:VT;
      
      private var _pileLimit:VT;
      
      private var _price:VT;
      
      private var _color:VT;
      
      private var _probability:VT;
      
      private var _descript:String;
      
      private var _addSkill:VT;
      
      private var _addAttrib:Array = [];
      
      public function GemBaseData()
      {
         super();
      }
      
      public static function cteateGemBaseData(param1:Number, param2:Number, param3:String, param4:String, param5:String, param6:Number, param7:int, param8:Boolean, param9:Boolean, param10:Boolean, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:Number, param17:Number, param18:Array, param19:Number) : GemBaseData
      {
         var _loc20_:GemBaseData = new GemBaseData();
         _loc20_._id = VT.createVT(param1);
         _loc20_._frame = VT.createVT(param2);
         _loc20_._className = param4;
         _loc20_._name = param3;
         _loc20_._descript = param5;
         _loc20_._times = VT.createVT(param6);
         _loc20_._type = VT.createVT(param7);
         _loc20_._isPile = param8;
         _loc20_._isStrengthen = param9;
         _loc20_._isCompound = param10;
         _loc20_._dropLevel = VT.createVT(param11);
         _loc20_._useLevel = VT.createVT(param12);
         _loc20_._strengthenLevel = VT.createVT(param13);
         _loc20_._pileLimit = VT.createVT(param14);
         _loc20_._price = VT.createVT(param15);
         _loc20_._color = VT.createVT(param16);
         _loc20_._probability = VT.createVT(param17);
         _loc20_._addAttrib = param18;
         _loc20_._addSkill = VT.createVT(param19);
         return _loc20_;
      }
      
      public function get id() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _id;
      }
      
      public function set id(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _id = param1;
      }
      
      public function get frame() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _frame;
      }
      
      public function set frame(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _frame = param1;
      }
      
      public function get name() : String
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _name = param1;
      }
      
      public function get times() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _times;
      }
      
      public function set times(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _times = param1;
      }
      
      public function get type() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _type;
      }
      
      public function set type(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _type = param1;
      }
      
      public function get isPile() : Boolean
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _isPile;
      }
      
      public function set isPile(param1:Boolean) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _isPile = param1;
      }
      
      public function get isStrengthen() : Boolean
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _isStrengthen;
      }
      
      public function set isStrengthen(param1:Boolean) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _isStrengthen = param1;
      }
      
      public function get isCompound() : Boolean
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _isCompound;
      }
      
      public function set isCompound(param1:Boolean) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _isCompound = param1;
      }
      
      public function get dropLevel() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _dropLevel;
      }
      
      public function set dropLevel(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _dropLevel = param1;
      }
      
      public function get useLevel() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _useLevel;
      }
      
      public function set useLevel(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _useLevel = param1;
      }
      
      public function get pileLimit() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _pileLimit;
      }
      
      public function set pileLimit(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _pileLimit = param1;
      }
      
      public function get price() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _price;
      }
      
      public function set price(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _price = param1;
      }
      
      public function get color() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _color;
      }
      
      public function set color(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _color = param1;
      }
      
      public function get probability() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _probability;
      }
      
      public function set probability(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _probability = param1;
      }
      
      public function get descript() : String
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _descript;
      }
      
      public function set descript(param1:String) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _descript = param1;
      }
      
      public function get addSkill() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _addSkill;
      }
      
      public function set addSkill(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _addSkill = param1;
      }
      
      public function get addAttrib() : Array
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _addAttrib;
      }
      
      public function set addAttrib(param1:Array) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _addAttrib = param1;
      }
      
      public function get strengthenLevel() : VT
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _strengthenLevel;
      }
      
      public function set strengthenLevel(param1:VT) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _strengthenLevel = param1;
      }
      
      public function get className() : String
      {
         trace("禁止get:",getQualifiedClassName(this));
         return _className;
      }
      
      public function set className(param1:String) : void
      {
         trace("禁止get:",getQualifiedClassName(this));
         _className = param1;
      }
      
      public function getId() : Number
      {
         return _id.getValue();
      }
      
      public function getFrame() : Number
      {
         return _frame.getValue();
      }
      
      public function getName() : String
      {
         return _name;
      }
      
      public function getClassName() : String
      {
         return _className;
      }
      
      public function getIsStrengthen() : Boolean
      {
         return _isStrengthen;
      }
      
      public function getDropLevel() : Number
      {
         return _dropLevel.getValue();
      }
      
      public function getUseLevel() : Number
      {
         return _useLevel.getValue();
      }
      
      public function getStrengthenLevel() : Number
      {
         return _strengthenLevel.getValue();
      }
      
      public function getPrice() : Number
      {
         return _price.getValue();
      }
      
      public function getIsCompound() : Boolean
      {
         return _isCompound;
      }
      
      public function getColor() : Number
      {
         return _color.getValue();
      }
      
      public function getDescript() : String
      {
         return _descript;
      }
      
      public function getTimes() : Number
      {
         return _times.getValue();
      }
      
      public function getType() : int
      {
         return _type.getValue();
      }
      
      public function getIsPile() : Boolean
      {
         return _isPile;
      }
      
      public function getPileLimit() : Number
      {
         return _pileLimit.getValue();
      }
      
      public function getProbability() : Number
      {
         return _probability.getValue();
      }
      
      public function getAddSkill() : Number
      {
         return _addSkill.getValue();
      }
      
      private function getRandomType() : uint
      {
         var _loc1_:* = Math.random() * 100;
         if(_loc1_ >= 0 && _loc1_ < 16)
         {
            return 0;
         }
         if(_loc1_ >= 16 && _loc1_ < 33)
         {
            return 1;
         }
         if(_loc1_ >= 33 && _loc1_ < 50)
         {
            return 2;
         }
         if(_loc1_ >= 50 && _loc1_ < 67)
         {
            return 3;
         }
         if(_loc1_ >= 67 && _loc1_ < 84)
         {
            return 4;
         }
         return 5;
      }
      
      public function createGem() : Gem
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Attribute = null;
         var _loc4_:Attribute = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:Attribute = null;
         var _loc9_:* = 0;
         var _loc10_:int = 0;
         var _loc11_:Attribute = null;
         if(_type.getValue() == GemTypeConst.ATTRIBSTONE)
         {
            _loc1_ = [];
            _loc2_ = [];
            for each(_loc3_ in _addAttrib)
            {
               _loc1_.push(_loc3_.getClone());
            }
            if(_color.getValue() == 1 && _loc1_.length > 0)
            {
               if(_isPile == true)
               {
                  _loc4_ = _loc1_[0];
                  _loc2_.push(_loc4_);
               }
               else
               {
                  _loc5_ = int(getRandomType());
                  _loc4_ = _loc1_[_loc5_] as Attribute;
                  _loc2_.push(_loc4_);
               }
            }
            if(_color.getValue() == 2 && _loc1_.length > 0)
            {
               _loc6_ = 2;
               while(_loc6_ > 0)
               {
                  _loc7_ = int(getRandomType());
                  _loc8_ = _loc1_[_loc7_] as Attribute;
                  _loc2_.push(_loc8_);
                  _loc6_--;
               }
            }
            if(_color.getValue() == 3 && _loc1_.length > 0)
            {
               _loc9_ = 3;
               while(_loc9_ > 0)
               {
                  _loc10_ = int(getRandomType());
                  _loc11_ = _loc1_[_loc10_] as Attribute;
                  _loc2_.push(_loc11_);
                  _loc9_--;
               }
            }
            return Gem.creatGem(_id.getValue(),_times.getValue(),_loc2_);
         }
         _loc2_ = [];
         return Gem.creatGem(_id.getValue(),_times.getValue(),_loc2_);
      }
      
      public function composeGem(param1:Array) : Gem
      {
         return Gem.creatGem(_id.getValue(),_times.getValue(),param1);
      }
      
      public function upLevelGem() : Gem
      {
         return Gem.creatGem(_id.getValue(),_times.getValue(),[]);
      }
   }
}

