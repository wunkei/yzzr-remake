package com.hotpoint.braveManIII.repository.elves
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.elves.*;
   
   public class ElvesBasicData
   {
      
      private var _id:VT;
      
      private var _name:String;
      
      private var _className:String;
      
      private var _frame:VT;
      
      private var _introduction:String;
      
      private var _color:VT;
      
      private var _blueLV:VT;
      
      private var _pinkLV:VT;
      
      private var _goldLV:VT;
      
      private var _blueNum:VT;
      
      private var _pinkNum:VT;
      
      private var _goldNum:VT;
      
      private var _timeX:VT;
      
      private var _skill1:VT;
      
      private var _skill2:VT;
      
      private var _skill3:VT;
      
      private var _blueNumOLD:VT;
      
      private var _pinkNumOLD:VT;
      
      private var _goldNumOLD:VT;
      
      public function ElvesBasicData()
      {
         super();
      }
      
      public static function creatElvesBasicData(param1:Number, param2:String, param3:String, param4:Number, param5:String, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number, param15:Number, param16:Number, param17:Number, param18:Number, param19:Number) : ElvesBasicData
      {
         var _loc20_:ElvesBasicData = new ElvesBasicData();
         _loc20_._id = VT.createVT(param1);
         _loc20_._name = param2;
         _loc20_._className = param3;
         _loc20_._introduction = param5;
         _loc20_._frame = VT.createVT(param4);
         _loc20_._color = VT.createVT(param6);
         _loc20_._blueLV = VT.createVT(param7);
         _loc20_._blueNum = VT.createVT(param10);
         _loc20_._blueNumOLD = VT.createVT(param17);
         _loc20_._pinkLV = VT.createVT(param8);
         _loc20_._pinkNum = VT.createVT(param11);
         _loc20_._pinkNumOLD = VT.createVT(param18);
         _loc20_._goldLV = VT.createVT(param9);
         _loc20_._goldNum = VT.createVT(param12);
         _loc20_._goldNumOLD = VT.createVT(param19);
         _loc20_._timeX = VT.createVT(param13);
         _loc20_._skill1 = VT.createVT(param14);
         _loc20_._skill2 = VT.createVT(param15);
         _loc20_._skill3 = VT.createVT(param16);
         return _loc20_;
      }
      
      public function get id() : VT
      {
         return _id;
      }
      
      public function set id(param1:VT) : void
      {
         _id = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get className() : String
      {
         return _className;
      }
      
      public function set className(param1:String) : void
      {
         _className = param1;
      }
      
      public function get frame() : VT
      {
         return _frame;
      }
      
      public function set frame(param1:VT) : void
      {
         _frame = param1;
      }
      
      public function get introduction() : String
      {
         return _introduction;
      }
      
      public function set introduction(param1:String) : void
      {
         _introduction = param1;
      }
      
      public function get blueLV() : VT
      {
         return _blueLV;
      }
      
      public function set blueLV(param1:VT) : void
      {
         _blueLV = param1;
      }
      
      public function get pinkLV() : VT
      {
         return _pinkLV;
      }
      
      public function set pinkLV(param1:VT) : void
      {
         _pinkLV = param1;
      }
      
      public function get goldLV() : VT
      {
         return _goldLV;
      }
      
      public function set goldLV(param1:VT) : void
      {
         _goldLV = param1;
      }
      
      public function get blueNum() : VT
      {
         return _blueNum;
      }
      
      public function set blueNum(param1:VT) : void
      {
         _blueNum = param1;
      }
      
      public function get pinkNum() : VT
      {
         return _pinkNum;
      }
      
      public function set pinkNum(param1:VT) : void
      {
         _pinkNum = param1;
      }
      
      public function get goldNum() : VT
      {
         return _goldNum;
      }
      
      public function set goldNum(param1:VT) : void
      {
         _goldNum = param1;
      }
      
      public function get color() : VT
      {
         return _color;
      }
      
      public function set color(param1:VT) : void
      {
         _color = param1;
      }
      
      public function get timeX() : VT
      {
         return _timeX;
      }
      
      public function set timeX(param1:VT) : void
      {
         _timeX = param1;
      }
      
      public function get skill1() : VT
      {
         return _skill1;
      }
      
      public function set skill1(param1:VT) : void
      {
         _skill1 = param1;
      }
      
      public function get skill2() : VT
      {
         return _skill2;
      }
      
      public function set skill2(param1:VT) : void
      {
         _skill2 = param1;
      }
      
      public function get skill3() : VT
      {
         return _skill3;
      }
      
      public function set skill3(param1:VT) : void
      {
         _skill3 = param1;
      }
      
      public function get blueNumOLD() : VT
      {
         return _blueNumOLD;
      }
      
      public function set blueNumOLD(param1:VT) : void
      {
         _blueNumOLD = param1;
      }
      
      public function get pinkNumOLD() : VT
      {
         return _pinkNumOLD;
      }
      
      public function set pinkNumOLD(param1:VT) : void
      {
         _pinkNumOLD = param1;
      }
      
      public function get goldNumOLD() : VT
      {
         return _goldNumOLD;
      }
      
      public function set goldNumOLD(param1:VT) : void
      {
         _goldNumOLD = param1;
      }
      
      public function getId() : Number
      {
         return _id.getValue();
      }
      
      public function getName() : String
      {
         return _name;
      }
      
      public function getClassName() : String
      {
         return _className;
      }
      
      public function getFrame() : Number
      {
         return _frame.getValue();
      }
      
      public function getColor() : Number
      {
         return _color.getValue();
      }
      
      public function getIntroduction() : String
      {
         return _introduction;
      }
      
      public function getBlueLV() : Number
      {
         return _blueLV.getValue();
      }
      
      public function getPinkLV() : Number
      {
         return _pinkLV.getValue();
      }
      
      public function getGoldLV() : Number
      {
         return _goldLV.getValue();
      }
      
      public function getBlueNum() : Number
      {
         return _blueNum.getValue();
      }
      
      public function getPinkNum() : Number
      {
         return _pinkNum.getValue();
      }
      
      public function getGoldNum() : Number
      {
         return _goldNum.getValue();
      }
      
      public function getBlueNumOLD() : Number
      {
         return _blueNumOLD.getValue();
      }
      
      public function getPinkNumOLD() : Number
      {
         return _pinkNumOLD.getValue();
      }
      
      public function getGoldNumOLD() : Number
      {
         return _goldNumOLD.getValue();
      }
      
      public function getTimeX() : Number
      {
         return _timeX.getValue();
      }
      
      public function getSkill1() : Number
      {
         return _skill1.getValue();
      }
      
      public function getSkill2() : Number
      {
         return _skill2.getValue();
      }
      
      public function getSkill3() : Number
      {
         return _skill3.getValue();
      }
      
      public function creatElves() : Elves
      {
         return Elves.creatElves(_id.getValue(),_blueNum.getValue(),_pinkNum.getValue(),_goldNum.getValue());
      }
   }
}

