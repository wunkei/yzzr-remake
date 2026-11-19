package com.hotpoint.braveManIII.models.elves
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.equip.Equip;
   import com.hotpoint.braveManIII.repository.elves.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import flash.utils.*;
   
   public class Elves
   {
      
      internal var a:uint;
      
      private var _id:VT;
      
      private var _level:VT;
      
      private var _exp:VT;
      
      private var _blueEquip:Equip = null;
      
      private var _pinkEquip:Equip = null;
      
      private var _goldEquip:Equip = null;
      
      private var _blueEquipNum:VT;
      
      private var _pinkEquipNum:VT;
      
      private var _goldEquipNum:VT;
      
      private var _blueCD:VT;
      
      private var _pinkCD:VT;
      
      private var _goldCD:VT;
      
      private var _blueTT:VT = VT.createVT(0);
      
      private var _pinkTT:VT = VT.createVT(0);
      
      private var _goldTT:VT = VT.createVT(0);
      
      private var _allPoint:VT;
      
      private var _hp:VT;
      
      private var _mp:VT;
      
      private var _att:VT;
      
      private var _def:VT;
      
      private var _crit:VT;
      
      private var _skill1:VT = VT.createVT(0);
      
      private var _skill2:VT = VT.createVT(0);
      
      private var _skill3:VT = VT.createVT(0);
      
      private var _flagLV:VT = VT.createVT(0);
      
      private var _newBOOL:VT = VT.createVT(0);
      
      public function Elves()
      {
         super();
         a = setInterval(timeStart,1000);
      }
      
      public static function creatElves(param1:Number, param2:Number, param3:Number, param4:Number) : Elves
      {
         var _loc5_:Elves = new Elves();
         _loc5_._id = VT.createVT(param1);
         _loc5_._level = VT.createVT(1);
         _loc5_._blueCD = VT.createVT(-1);
         _loc5_._pinkCD = VT.createVT(-1);
         _loc5_._goldCD = VT.createVT(-1);
         _loc5_._exp = VT.createVT(0);
         _loc5_._blueEquipNum = VT.createVT(param2);
         _loc5_._pinkEquipNum = VT.createVT(param3);
         _loc5_._goldEquipNum = VT.createVT(param4);
         _loc5_._allPoint = VT.createVT(5);
         _loc5_._hp = VT.createVT(0);
         _loc5_._mp = VT.createVT(0);
         _loc5_._att = VT.createVT(0);
         _loc5_._def = VT.createVT(0);
         _loc5_._crit = VT.createVT(0);
         _loc5_._newBOOL.setValue(1);
         return _loc5_;
      }
      
      public function get id() : VT
      {
         return _id;
      }
      
      public function set id(param1:VT) : void
      {
         _id = param1;
      }
      
      public function get level() : VT
      {
         return _level;
      }
      
      public function set level(param1:VT) : void
      {
         _level = param1;
      }
      
      public function get blueEquip() : Equip
      {
         return _blueEquip;
      }
      
      public function set blueEquip(param1:Equip) : void
      {
         _blueEquip = param1;
      }
      
      public function get pinkEquip() : Equip
      {
         return _pinkEquip;
      }
      
      public function set pinkEquip(param1:Equip) : void
      {
         _pinkEquip = param1;
      }
      
      public function get goldEquip() : Equip
      {
         return _goldEquip;
      }
      
      public function set goldEquip(param1:Equip) : void
      {
         _goldEquip = param1;
      }
      
      public function get blueCD() : VT
      {
         return _blueCD;
      }
      
      public function set blueCD(param1:VT) : void
      {
         _blueCD = param1;
      }
      
      public function get pinkCD() : VT
      {
         return _pinkCD;
      }
      
      public function set pinkCD(param1:VT) : void
      {
         _pinkCD = param1;
      }
      
      public function get goldCD() : VT
      {
         return _goldCD;
      }
      
      public function set goldCD(param1:VT) : void
      {
         _goldCD = param1;
      }
      
      public function get allPoint() : VT
      {
         return _allPoint;
      }
      
      public function set allPoint(param1:VT) : void
      {
         _allPoint = param1;
      }
      
      public function get hp() : VT
      {
         return _hp;
      }
      
      public function set hp(param1:VT) : void
      {
         _hp = param1;
      }
      
      public function get mp() : VT
      {
         return _mp;
      }
      
      public function set mp(param1:VT) : void
      {
         _mp = param1;
      }
      
      public function get att() : VT
      {
         return _att;
      }
      
      public function set att(param1:VT) : void
      {
         _att = param1;
      }
      
      public function get def() : VT
      {
         return _def;
      }
      
      public function set def(param1:VT) : void
      {
         _def = param1;
      }
      
      public function get crit() : VT
      {
         return _crit;
      }
      
      public function set crit(param1:VT) : void
      {
         _crit = param1;
      }
      
      public function get exp() : VT
      {
         return _exp;
      }
      
      public function set exp(param1:VT) : void
      {
         _exp = param1;
      }
      
      public function get blueEquipNum() : VT
      {
         return _blueEquipNum;
      }
      
      public function set blueEquipNum(param1:VT) : void
      {
         _blueEquipNum = param1;
      }
      
      public function get pinkEquipNum() : VT
      {
         return _pinkEquipNum;
      }
      
      public function set pinkEquipNum(param1:VT) : void
      {
         _pinkEquipNum = param1;
      }
      
      public function get goldEquipNum() : VT
      {
         return _goldEquipNum;
      }
      
      public function set goldEquipNum(param1:VT) : void
      {
         _goldEquipNum = param1;
      }
      
      public function get flagLV() : VT
      {
         return _flagLV;
      }
      
      public function set flagLV(param1:VT) : void
      {
         _flagLV = param1;
      }
      
      public function get blueTT() : VT
      {
         return _blueTT;
      }
      
      public function set blueTT(param1:VT) : void
      {
         _blueTT = param1;
      }
      
      public function get pinkTT() : VT
      {
         return _pinkTT;
      }
      
      public function set pinkTT(param1:VT) : void
      {
         _pinkTT = param1;
      }
      
      public function get goldTT() : VT
      {
         return _goldTT;
      }
      
      public function set goldTT(param1:VT) : void
      {
         _goldTT = param1;
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
      
      public function get newBOOL() : VT
      {
         return _newBOOL;
      }
      
      public function set newBOOL(param1:VT) : void
      {
         _newBOOL = param1;
      }
      
      public function getId() : Number
      {
         return _id.getValue();
      }
      
      public function getName() : String
      {
         return ElvesFactory.getName(_id.getValue());
      }
      
      public function getClassName() : String
      {
         return ElvesFactory.getClassName(_id.getValue());
      }
      
      public function getFrame() : Number
      {
         return ElvesFactory.getFrame(_id.getValue());
      }
      
      public function getColor() : Number
      {
         return ElvesFactory.getColor(_id.getValue());
      }
      
      public function getIntroduction() : String
      {
         return ElvesFactory.getIntroduction(_id.getValue());
      }
      
      public function getBlueLV() : Number
      {
         return ElvesFactory.getBlueLV(_id.getValue());
      }
      
      public function getPinkLV() : Number
      {
         return ElvesFactory.getPinkLV(_id.getValue());
      }
      
      public function getGoldLV() : Number
      {
         return ElvesFactory.getGoldLV(_id.getValue());
      }
      
      public function getBlueNum() : Number
      {
         return ElvesFactory.getBlueNum(_id.getValue());
      }
      
      public function getPinkNum() : Number
      {
         return ElvesFactory.getPinkNum(_id.getValue());
      }
      
      public function getGoldNum() : Number
      {
         return ElvesFactory.getGoldNum(_id.getValue());
      }
      
      public function getBlueNumOLD() : Number
      {
         return ElvesFactory.getBlueNumOLD(_id.getValue());
      }
      
      public function getPinkNumOLD() : Number
      {
         return ElvesFactory.getPinkNumOLD(_id.getValue());
      }
      
      public function getGoldNumOLD() : Number
      {
         return ElvesFactory.getGoldNumOLD(_id.getValue());
      }
      
      public function getTimeX() : Number
      {
         return ElvesFactory.getTimeX(_id.getValue());
      }
      
      public function getTimeBuff() : Number
      {
         return getTimeX() * _level.getValue();
      }
      
      public function getLevel() : Number
      {
         return _level.getValue();
      }
      
      public function setLevel(param1:Number) : *
      {
         _level.setValue(param1);
      }
      
      public function getEXP() : Number
      {
         return _exp.getValue();
      }
      
      public function setEXP(param1:Number) : *
      {
         _exp.setValue(param1);
      }
      
      public function addExp(param1:Number) : *
      {
         _exp.setValue(_exp.getValue() + param1);
         while(_flagLV.getValue() < _level.getValue())
         {
            if(getColor() == 2)
            {
               setAllPoint(2);
            }
            else if(getColor() == 3)
            {
               setAllPoint(3);
            }
            else if(getColor() == 4)
            {
               setAllPoint(5);
            }
            _flagLV.setValue(_flagLV.getValue() + 1);
         }
         if(getLevel() * 15 < _exp.getValue() && getLevel() < 10)
         {
            this.setLevel(getLevel() + 1);
            this.setEXP(0);
            return true;
         }
         return false;
      }
      
      public function getHP() : Number
      {
         return _hp.getValue();
      }
      
      public function setHP(param1:Number = 1) : *
      {
         _hp.setValue(_hp.getValue() + param1);
      }
      
      public function getMP() : Number
      {
         return _mp.getValue();
      }
      
      public function setMP(param1:Number = 1) : *
      {
         _mp.setValue(_mp.getValue() + param1);
      }
      
      public function getATT() : Number
      {
         return _att.getValue();
      }
      
      public function setATT(param1:Number = 1) : *
      {
         _att.setValue(_att.getValue() + param1);
      }
      
      public function getDEF() : Number
      {
         return _def.getValue();
      }
      
      public function setDEF(param1:Number = 1) : *
      {
         _def.setValue(_def.getValue() + param1);
      }
      
      public function getCRIT() : Number
      {
         return _crit.getValue();
      }
      
      public function setCRIT(param1:Number = 1) : *
      {
         _crit.setValue(_crit.getValue() + param1);
      }
      
      public function getAllPoint() : Number
      {
         return _allPoint.getValue();
      }
      
      public function setAllPoint(param1:Number = -1) : *
      {
         _allPoint.setValue(_allPoint.getValue() + param1);
      }
      
      public function resetAllPoint() : *
      {
         _allPoint.setValue(_allPoint.getValue() + _hp.getValue() + _mp.getValue() + _att.getValue() + _def.getValue() + _crit.getValue());
         _hp.setValue(0);
         _mp.setValue(0);
         _att.setValue(0);
         _def.setValue(0);
         _crit.setValue(0);
      }
      
      public function resetPoints() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(_newBOOL.getValue() == 0)
         {
            _hp.setValue(0);
            _mp.setValue(0);
            _att.setValue(0);
            _def.setValue(0);
            _crit.setValue(0);
            _allPoint.setValue(_level.getValue() * 5);
            _loc1_ = getBlueNumOLD() - getBlueEquipNum();
            _loc2_ = getPinkNumOLD() - getPinkEquipNum();
            _loc3_ = getGoldNumOLD() - getGoldEquipNum();
            if(_loc1_ >= getBlueNum())
            {
               _allPoint.setValue(_allPoint.getValue() + 3 * getBlueNum());
               _blueEquipNum.setValue(0);
            }
            else
            {
               _allPoint.setValue(_allPoint.getValue() + 3 * _loc1_);
               _blueEquipNum.setValue(getBlueNum() - _loc1_);
            }
            if(_loc2_ >= getPinkNum())
            {
               _allPoint.setValue(_allPoint.getValue() + 6 * getPinkNum());
               _pinkEquipNum.setValue(0);
            }
            else
            {
               _allPoint.setValue(_allPoint.getValue() + 6 * _loc2_);
               _pinkEquipNum.setValue(getPinkNum() - _loc2_);
            }
            if(_loc3_ >= getGoldNum())
            {
               _allPoint.setValue(_allPoint.getValue() + 10 * getGoldNum());
               _goldEquipNum.setValue(0);
            }
            else
            {
               _allPoint.setValue(_allPoint.getValue() + 10 * _loc3_);
               _goldEquipNum.setValue(getGoldNum() - _loc3_);
            }
            _newBOOL.setValue(1);
         }
      }
      
      public function setBlueEquip(param1:Equip) : *
      {
         _blueEquip = param1;
         _blueCD.setValue(180 - getTimeBuff());
         _blueTT.setValue(180 - getTimeBuff());
      }
      
      public function setPinkEquip(param1:Equip) : *
      {
         _pinkEquip = param1;
         _pinkCD.setValue(240 - getTimeBuff());
         _pinkTT.setValue(240 - getTimeBuff());
      }
      
      public function setGoldEquip(param1:Equip) : *
      {
         _goldEquip = param1;
         _goldCD.setValue(300 - getTimeBuff());
         _goldTT.setValue(300 - getTimeBuff());
      }
      
      public function getBlueEquip() : Equip
      {
         return _blueEquip;
      }
      
      public function getPinkEquip() : Equip
      {
         return _pinkEquip;
      }
      
      public function getGoldEquip() : Equip
      {
         return _goldEquip;
      }
      
      public function delBlueEquip() : *
      {
         _blueEquip = null;
         _blueCD.setValue(-1);
      }
      
      public function delPinkEquip() : *
      {
         _pinkEquip = null;
         _pinkCD.setValue(-1);
      }
      
      public function delGoldEquip() : *
      {
         _goldEquip = null;
         _goldCD.setValue(-1);
      }
      
      public function overBlueEquip() : *
      {
         if(_blueEquipNum.getValue() > 0)
         {
            _blueCD.setValue(-1);
            _allPoint.setValue(_allPoint.getValue() + 3);
            _blueEquipNum.setValue(_blueEquipNum.getValue() - 1);
            _blueEquip = null;
         }
      }
      
      public function overPinkEquip() : *
      {
         if(_pinkEquipNum.getValue() > 0)
         {
            _pinkCD.setValue(-1);
            _allPoint.setValue(_allPoint.getValue() + 6);
            _pinkEquipNum.setValue(_pinkEquipNum.getValue() - 1);
            _pinkEquip = null;
         }
      }
      
      public function overGoldEquip() : *
      {
         if(_goldEquipNum.getValue() > 0)
         {
            _goldCD.setValue(-1);
            _allPoint.setValue(_allPoint.getValue() + 10);
            _goldEquipNum.setValue(_goldEquipNum.getValue() - 1);
            _goldEquip = null;
         }
      }
      
      public function getBlueCD() : Number
      {
         return _blueCD.getValue();
      }
      
      public function getPinkCD() : Number
      {
         return _pinkCD.getValue();
      }
      
      public function getGoldCD() : Number
      {
         return _goldCD.getValue();
      }
      
      public function getBlueTT() : Number
      {
         return _blueTT.getValue();
      }
      
      public function getPinkTT() : Number
      {
         return _pinkTT.getValue();
      }
      
      public function getGoldTT() : Number
      {
         return _goldTT.getValue();
      }
      
      public function getBlueEquipNum() : Number
      {
         return _blueEquipNum.getValue();
      }
      
      public function getPinkEquipNum() : Number
      {
         return _pinkEquipNum.getValue();
      }
      
      public function getGoldEquipNum() : Number
      {
         return _goldEquipNum.getValue();
      }
      
      public function getBlueEquipNumOVER() : Number
      {
         return getPinkNumOLD() - getBlueEquipNum();
      }
      
      public function getPinkEquipNumOVER() : Number
      {
         return getPinkNumOLD() - getPinkEquipNum();
      }
      
      public function getGoldEquipNumOVER() : Number
      {
         return getPinkNumOLD() - getGoldEquipNum();
      }
      
      private function timeStart() : *
      {
         if(_blueCD.getValue() >= 0)
         {
            if(_blueCD.getValue() < 1)
            {
               overBlueEquip();
            }
            _blueCD.setValue(_blueCD.getValue() - 1);
         }
         if(_pinkCD.getValue() >= 0)
         {
            if(_pinkCD.getValue() < 1)
            {
               overPinkEquip();
            }
            _pinkCD.setValue(_pinkCD.getValue() - 1);
         }
         if(_goldCD.getValue() >= 0)
         {
            if(_goldCD.getValue() < 1)
            {
               overGoldEquip();
            }
            _goldCD.setValue(_goldCD.getValue() - 1);
         }
      }
      
      public function getSID1() : Number
      {
         return ElvesFactory.getSkill1(_id.getValue());
      }
      
      public function getSID2() : Number
      {
         return ElvesFactory.getSkill2(_id.getValue());
      }
      
      public function getSID3() : Number
      {
         return ElvesFactory.getSkill3(_id.getValue());
      }
      
      public function getSKILL1() : Number
      {
         if(_skill1.getValue() == 0)
         {
            if(getSID1() > 0)
            {
               _skill1 = VT.createVT(getSID1());
            }
         }
         return _skill1.getValue();
      }
      
      public function getSKILL2() : Number
      {
         if(_skill2.getValue() == 0)
         {
            if(getSID2() > 0)
            {
               _skill2 = VT.createVT(getSID2());
            }
         }
         return _skill2.getValue();
      }
      
      public function getSKILL3() : Number
      {
         if(_skill3.getValue() == 0)
         {
            if(getSID3() > 0)
            {
               _skill3 = VT.createVT(getSID3());
            }
         }
         return _skill3.getValue();
      }
      
      public function upSKILL1() : Number
      {
         if(_skill1.getValue() != 0)
         {
            _skill1.setValue(SkillFactory.getSkillById(_skill1.getValue()).getMp());
         }
         return undefined;
      }
      
      public function upSKILL2() : Number
      {
         if(_skill2.getValue() != 0)
         {
            _skill2.setValue(SkillFactory.getSkillById(_skill2.getValue()).getMp());
         }
         return undefined;
      }
      
      public function upSKILL3() : Number
      {
         if(_skill3.getValue() != 0)
         {
            _skill3.setValue(SkillFactory.getSkillById(_skill3.getValue()).getMp());
         }
         return undefined;
      }
   }
}

