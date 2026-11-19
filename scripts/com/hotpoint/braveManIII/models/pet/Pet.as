package com.hotpoint.braveManIII.models.pet
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.petEquip.PetEquip;
   import com.hotpoint.braveManIII.models.skill.Skill;
   import com.hotpoint.braveManIII.repository.pet.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import src.*;
   
   public class Pet
   {
      
      private var _equip:PetEquip;
      
      public var time_fh:int = 2400;
      
      public var _id:VT;
      
      private var _xingge:VT;
      
      private var _lv:VT;
      
      private var _lvlimit:VT;
      
      private var _food:VT;
      
      private var _exp:VT;
      
      private var _wuxing:VT = VT.createVT(0);
      
      private var _skill:Array = [-1,-1,-1,-1];
      
      public function Pet()
      {
         super();
      }
      
      public static function creatPet(param1:*) : Pet
      {
         var _loc2_:Pet = new Pet();
         _loc2_._id = VT.createVT(param1);
         _loc2_._lvlimit = VT.createVT(20);
         _loc2_._lv = VT.createVT(1);
         _loc2_._food = VT.createVT(500);
         _loc2_._exp = VT.createVT(0);
         if(_loc2_.getWXLV() > 0)
         {
            _loc2_._wuxing = VT.createVT(Math.round(Math.random() * 3) + 1);
         }
         else
         {
            _loc2_._wuxing = VT.createVT(0);
         }
         _loc2_.setXingge();
         return _loc2_;
      }
      
      public function getLv() : Number
      {
         return _lv.getValue();
      }
      
      public function setLv(param1:Number) : *
      {
         _lv.setValue(param1);
         addSkill();
      }
      
      public function addLvLimit(param1:Number = 1) : *
      {
         _lvlimit.setValue(_lvlimit.getValue() + param1);
      }
      
      public function setFood(param1:Number) : *
      {
         _food.setValue(_food.getValue() + param1);
         if(_food.getValue() < 0)
         {
            _food.setValue(0);
         }
         if(_food.getValue() > 500)
         {
            _food.setValue(500);
         }
      }
      
      public function getLvLimit() : Number
      {
         return _lvlimit.getValue();
      }
      
      public function getFood() : Number
      {
         return _food.getValue();
      }
      
      public function getAtt() : Number
      {
         if(getLv() < 21)
         {
            return getAttX() + getAttup() * getLv();
         }
         return getAttX() + getAttup() * 20 + (getLv() - 20) * 0.002;
      }
      
      public function getDef() : Number
      {
         if(getLv() < 21)
         {
            return getDefX() + getDefup() * getLv();
         }
         return getDefX() + getDefup() * 20 + (getLv() - 20) * 0.002;
      }
      
      public function getCrit() : Number
      {
         if(getLv() < 21)
         {
            return getCritX() + getCritup() * getLv();
         }
         return getCritX() + getCritup() * 20 + (getLv() - 20) * 0.002;
      }
      
      public function getLife() : Number
      {
         if(getLv() < 21)
         {
            return getLifeX() + getLifeup() * getLv();
         }
         return getLifeX() + getLifeup() * 20 + (getLv() - 20) * 0.002;
      }
      
      public function getExp() : Number
      {
         return _exp.getValue();
      }
      
      public function setExp(param1:Number) : *
      {
         _exp.setValue(param1);
      }
      
      public function setWX() : *
      {
         if(getWXLV() > 0)
         {
            _wuxing.setValue(Math.round(Math.random() * 3) + 1);
         }
         addSkill();
      }
      
      public function getWX() : Number
      {
         return _wuxing.getValue();
      }
      
      public function addExp(param1:Number) : *
      {
         param1 *= 2;
         _exp.setValue(_exp.getValue() + param1);
         if(PetFactory.all_LVData_vt[this.getLv() - 1].getValue() < _exp.getValue() && this.getLv() < this.getLvLimit())
         {
            this.setLv(this.getLv() + 1);
            this.setExp(0);
            return true;
         }
         return false;
      }
      
      public function testSkill() : *
      {
         _skill = [1,1,1,1];
      }
      
      public function addSkill() : *
      {
         if(getWX() == 4)
         {
            if(getLv() >= 5 && _skill[0] == -1)
            {
               _skill[0] = 0;
            }
            if(getLv() >= 10 && _skill[1] == -1)
            {
               _skill[1] = 0;
            }
            if(getLv() >= 15 && _skill[2] == -1)
            {
               _skill[2] = 0;
            }
            if(getLv() >= 20 && _skill[3] == -1)
            {
               _skill[3] = 0;
            }
         }
         if(getWX() == 3)
         {
            if(getLv() >= 5 && _skill[0] == -1)
            {
               _skill[0] = 0;
            }
            if(getLv() >= 10 && _skill[1] == -1)
            {
               _skill[1] = 0;
            }
            if(getLv() >= 15 && _skill[2] == -1)
            {
               _skill[2] = 0;
            }
         }
         if(getWX() == 2)
         {
            if(getLv() >= 5 && _skill[0] == -1)
            {
               _skill[0] = 0;
            }
            if(getLv() >= 10 && _skill[1] == -1)
            {
               _skill[1] = 0;
            }
         }
         if(getWX() == 1)
         {
            if(getLv() >= 5 && _skill[0] == -1)
            {
               _skill[0] = 0;
            }
         }
      }
      
      public function setSkill(param1:Number) : *
      {
         _skill[param1] = SkillFactory.getSkillByPet(_id.getValue());
      }
      
      public function getPetSkill() : Array
      {
         return _skill;
      }
      
      public function getPetSkillType() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = DeepCopyUtil.clone(_skill);
         for(_loc2_ in _loc1_)
         {
            if(_loc1_[_loc2_] > 0)
            {
               _loc1_[_loc2_] = SkillFactory.getSkillById(_loc1_[_loc2_]).getTypeId();
            }
         }
         return _loc1_;
      }
      
      public function getPetSkillNum(param1:Number) : Skill
      {
         return SkillFactory.getSkillById(_skill[param1]);
      }
      
      public function getXingge() : Number
      {
         if(!_xingge)
         {
            setXingge();
         }
         return _xingge.getValue();
      }
      
      public function setXingge(param1:int = 0) : Number
      {
         var _loc2_:int = 0;
         if(!_xingge)
         {
            _xingge = VT.createVT(0);
         }
         if(param1 == 0)
         {
            if(getType() == 1)
            {
               _xingge.setValue(0);
            }
            _xingge.setValue(Math.ceil(Math.random() * 12));
            if(_xingge.getValue() == 3)
            {
               _loc2_ = 0;
               while(_loc2_ < Main.player1.getTitleSlot().getListLength())
               {
                  if(Main.player1.getTitleSlot().getTitleFromSlot(_loc2_).getId() == 25)
                  {
                     return undefined;
                  }
                  _loc2_++;
               }
               _xingge.setValue(3 + Math.ceil(Math.random() * 9));
            }
         }
         else
         {
            _xingge.setValue(param1);
         }
         Main.Save();
         return undefined;
      }
      
      public function getName() : String
      {
         return PetFactory.getName(_id.getValue());
      }
      
      public function getFrame() : Number
      {
         return PetFactory.getFrame(_id.getValue());
      }
      
      public function getType() : Number
      {
         return PetFactory.getType(_id.getValue());
      }
      
      public function getClassName() : String
      {
         return PetFactory.getClassName(_id.getValue());
      }
      
      public function getIntroduction() : String
      {
         return PetFactory.getIntroduction(_id.getValue());
      }
      
      public function getEvolution() : Number
      {
         return PetFactory.getEvolution(_id.getValue());
      }
      
      public function getEvolutionLV() : Number
      {
         return PetFactory.getEvolutionLV(_id.getValue());
      }
      
      public function getAttX() : Number
      {
         return PetFactory.getAtt(_id.getValue());
      }
      
      public function getDefX() : Number
      {
         return PetFactory.getDef(_id.getValue());
      }
      
      public function getCritX() : Number
      {
         return PetFactory.getCrit(_id.getValue());
      }
      
      public function getLifeX() : Number
      {
         return PetFactory.getLife(_id.getValue());
      }
      
      public function getAttup() : Number
      {
         return PetFactory.getAttup(_id.getValue());
      }
      
      public function getDefup() : Number
      {
         return PetFactory.getDefup(_id.getValue());
      }
      
      public function getCritup() : Number
      {
         return PetFactory.getCritup(_id.getValue());
      }
      
      public function getLifeup() : Number
      {
         return PetFactory.getLifeup(_id.getValue());
      }
      
      public function getLink() : Number
      {
         return PetFactory.getLink(_id.getValue());
      }
      
      public function getPetCD() : Array
      {
         return PetFactory.getPetCD(_id.getValue());
      }
      
      public function getWXLV() : Number
      {
         return PetFactory.getWuxingLV(_id.getValue());
      }
      
      public function getPetEquip() : PetEquip
      {
         return _equip;
      }
      
      public function setPetEquip(param1:PetEquip = null) : *
      {
         _equip = param1;
      }
      
      public function get id() : VT
      {
         return _id;
      }
      
      public function set id(param1:VT) : void
      {
         _id = param1;
      }
      
      public function get lv() : VT
      {
         return _lv;
      }
      
      public function set lv(param1:VT) : void
      {
         _lv = param1;
      }
      
      public function get lvlimit() : VT
      {
         return _lvlimit;
      }
      
      public function set lvlimit(param1:VT) : void
      {
         _lvlimit = param1;
      }
      
      public function get food() : VT
      {
         return _food;
      }
      
      public function set food(param1:VT) : void
      {
         _food = param1;
      }
      
      public function get exp() : VT
      {
         return _exp;
      }
      
      public function set exp(param1:VT) : void
      {
         _exp = param1;
      }
      
      public function get wuxing() : VT
      {
         return _wuxing;
      }
      
      public function set wuxing(param1:VT) : void
      {
         _wuxing = param1;
      }
      
      public function get skill() : Array
      {
         return _skill;
      }
      
      public function set skill(param1:Array) : void
      {
         _skill = param1;
      }
      
      public function get xingge() : VT
      {
         return _xingge;
      }
      
      public function set xingge(param1:VT) : void
      {
         _xingge = param1;
      }
      
      public function get equip() : PetEquip
      {
         return _equip;
      }
      
      public function set equip(param1:PetEquip) : void
      {
         _equip = param1;
      }
   }
}

