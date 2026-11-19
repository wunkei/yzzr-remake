package com.hotpoint.braveManIII.models.container
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.models.elves.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   
   public class ElvesSlot
   {
      
      private var _slot:Array = new Array();
      
      private var _slotLimit:VT = VT.createVT(5);
      
      public function ElvesSlot()
      {
         super();
      }
      
      public static function createElvesSlot() : ElvesSlot
      {
         var _loc1_:ElvesSlot = new ElvesSlot();
         var _loc2_:int = 0;
         while(_loc2_ < 20)
         {
            _loc1_._slot[_loc2_] = null;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get slot() : Array
      {
         return _slot;
      }
      
      public function set slot(param1:Array) : void
      {
         _slot = param1;
      }
      
      public function get slotLimit() : VT
      {
         return _slotLimit;
      }
      
      public function set slotLimit(param1:VT) : void
      {
         _slotLimit = param1;
      }
      
      public function getElvesFromSlot(param1:Number) : Elves
      {
         if(_slot[param1] != null)
         {
            return _slot[param1];
         }
         return null;
      }
      
      public function getSlotNum() : int
      {
         return _slotLimit.getValue();
      }
      
      public function addElvesSlot(param1:Elves) : Boolean
      {
         var _loc2_:uint = 0;
         while(_loc2_ < _slotLimit.getValue())
         {
            if(_slot[_loc2_] == null)
            {
               _slot[_loc2_] = param1;
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function delElvesSlot(param1:int) : Elves
      {
         var _loc2_:Elves = null;
         if(_slot[param1] != null)
         {
            _loc2_ = _slot[param1];
            _slot[param1] = null;
         }
         return _loc2_;
      }
      
      public function backElvesSlotNum() : int
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < _slotLimit.getValue())
         {
            if(_slot[_loc2_] == null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function backElvesNum() : int
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < _slotLimit.getValue())
         {
            if(_slot[_loc2_] != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addSlotNum(param1:int) : *
      {
         _slotLimit.setValue(_slotLimit.getValue() + param1);
      }
      
      public function backElvesId() : int
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 20)
         {
            if(_slot[_loc1_] != null)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function backChoseElvesId(param1:Elves) : int
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 20)
         {
            if(_slot[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function backElvesSkill2() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1003)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[0].getValue();
         }
         return 0;
      }
      
      public function backElvesSkill3() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1004)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[0].getValue();
         }
         return 0;
      }
      
      public function backElvesSkill3_2() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1004)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[1].getValue();
         }
         return 0;
      }
      
      public function backElvesSkill1() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1006)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[0].getValue();
         }
         return 0;
      }
      
      public function backElvesSkill4() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1008)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[0].getValue();
         }
         return 0;
      }
      
      public function backElvesSkill5() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1011)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[0].getValue();
         }
         return 0;
      }
      
      public function backElvesSkill6() : Number
      {
         var _loc2_:Elves = null;
         var _loc1_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 20)
         {
            if(_slot[_loc3_])
            {
               if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillActOn() == 1013)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _slot[_loc3_];
                  }
                  if(SkillFactory.getSkillById((_slot[_loc3_] as Elves).getSKILL1()).getSkillLevel() > SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillLevel())
                  {
                     _loc2_ = _slot[_loc3_];
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc1_ = SkillFactory.getSkillById(_loc2_.getSKILL1()).getSkillValueArray();
            return _loc1_[0].getValue();
         }
         return 0;
      }
      
      public function plan3_13(param1:int) : int
      {
         var _loc2_:uint = 0;
         while(_loc2_ < _slotLimit.getValue())
         {
            if(_slot[_loc2_] != null)
            {
               if((_slot[_loc2_] as Elves).getLevel() >= param1)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
   }
}

