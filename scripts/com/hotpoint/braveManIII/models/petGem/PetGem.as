package com.hotpoint.braveManIII.models.petGem
{
   import src.*;
   
   public class PetGem
   {
      
      private var _xingge:Array = [];
      
      public function PetGem()
      {
         super();
      }
      
      public static function creatPetGem(param1:Number) : PetGem
      {
         var _loc2_:PetGem = new PetGem();
         if(param1 != 0)
         {
            _loc2_._xingge.push(param1);
         }
         return _loc2_;
      }
      
      public function getName() : String
      {
         if(_xingge.length == 0)
         {
            return "未知血脉";
         }
         if(_xingge.length == 1)
         {
            return "未知血脉石";
         }
         if(_xingge.length == 2)
         {
            return "血脉精华";
         }
         if(_xingge.length == 3)
         {
            return "血精石";
         }
         if(_xingge.length == 4)
         {
            return "血精珠";
         }
         if(_xingge.length == 5)
         {
            return "爆裂石";
         }
         if(_xingge.length == 6)
         {
            return "爆裂精华";
         }
         if(_xingge.length == 7)
         {
            return "血耀石";
         }
         if(_xingge.length == 8)
         {
            return "血耀精华";
         }
         if(_xingge.length == 9)
         {
            return "远古圣血";
         }
         if(_xingge.length == 10)
         {
            return "远古圣血精华";
         }
         if(_xingge.length == 11)
         {
            return "神兽之精";
         }
         if(_xingge.length == 12)
         {
            return "神兽血脉";
         }
         return undefined;
      }
      
      public function getFrame() : Number
      {
         if(_xingge.length > 0)
         {
            return _xingge.length + 81;
         }
         if(_xingge.length == 0)
         {
            return 94;
         }
         return undefined;
      }
      
      public function getType() : Number
      {
         return _xingge.length;
      }
      
      public function getPrice() : Number
      {
         return 1000;
      }
      
      public function getColor() : Number
      {
         if(_xingge.length == 0)
         {
            return 1;
         }
         if(_xingge.length == 1)
         {
            return 1;
         }
         if(_xingge.length == 2)
         {
            return 1;
         }
         if(_xingge.length == 3)
         {
            return 1;
         }
         if(_xingge.length == 4)
         {
            return 2;
         }
         if(_xingge.length == 5)
         {
            return 2;
         }
         if(_xingge.length == 6)
         {
            return 2;
         }
         if(_xingge.length == 7)
         {
            return 3;
         }
         if(_xingge.length == 8)
         {
            return 3;
         }
         if(_xingge.length == 9)
         {
            return 3;
         }
         if(_xingge.length == 10)
         {
            return 4;
         }
         if(_xingge.length == 11)
         {
            return 4;
         }
         if(_xingge.length == 12)
         {
            return 4;
         }
         return undefined;
      }
      
      public function getSkillDescript() : String
      {
         return "无";
      }
      
      public function getDescript() : String
      {
         if(_xingge.length == 0)
         {
            return "尚未拥有血脉能量，可在排行榜勇者宝箱中兑换";
         }
         if(_xingge.length == 1)
         {
            return "由不知名的野兽所留下的血液化石";
         }
         if(_xingge.length == 2)
         {
            return "提取不知名野兽血液熔炼而成的精华";
         }
         if(_xingge.length == 3)
         {
            return "熔炼集成血液精华而成珍贵之石";
         }
         if(_xingge.length == 4)
         {
            return "熔炼锻铸血精石而成的血精珠";
         }
         if(_xingge.length == 5)
         {
            return "过多能量充斥于血精珠内爆裂而成的珍贵之物";
         }
         if(_xingge.length == 6)
         {
            return "取至爆裂珍贵之物内精华熔炼提纯而出";
         }
         if(_xingge.length == 7)
         {
            return "在爆裂精华内添加不知名野兽血液所成功反应的血耀之石";
         }
         if(_xingge.length == 8)
         {
            return "血耀之石经由绝望之焰粹取出的精华";
         }
         if(_xingge.length == 9)
         {
            return "经由伽妮雅成功辨别出来的远古血脉的血液";
         }
         if(_xingge.length == 10)
         {
            return "由各种远古血脉纷乱复杂的结合精华";
         }
         if(_xingge.length == 11)
         {
            return "至高神兽遗留下的一滴血液精华";
         }
         if(_xingge.length == 12)
         {
            return "至高神兽遗留下无穷力量的血脉";
         }
         return undefined;
      }
      
      public function getXingge() : Array
      {
         return _xingge;
      }
      
      public function getXinggeSX() : String
      {
         return undefined;
      }
      
      public function isHaveSX(param1:int) : *
      {
         var _loc2_:* = undefined;
         for(_loc2_ in _xingge)
         {
            if(_xingge[_loc2_] == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function chongSuXueMai() : *
      {
         var _loc2_:int = 0;
         var _loc1_:* = 0;
         while(_loc1_ < 1)
         {
            _loc2_ = int(Math.random() * 12) + 1;
            if(_loc2_ != _xingge[0])
            {
               _xingge[0] = _loc2_;
            }
            else
            {
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      public function RongLianXueMai(param1:PetGem) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc2_:Boolean = true;
         var _loc3_:Array = param1.getXingge();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            for(_loc5_ in _xingge)
            {
               if(_xingge[_loc5_] == _loc3_[_loc4_])
               {
                  _loc2_ = false;
               }
            }
            if(_loc2_)
            {
               _loc6_ = int(Math.random() * 12);
               if(!_xingge[_loc6_])
               {
                  _xingge.push(_loc3_[_loc4_]);
               }
               else
               {
                  _xingge[_loc6_] = _loc3_[_loc4_];
               }
            }
            _loc4_++;
         }
      }
      
      public function isRongLian(param1:PetGem) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc2_:Array = param1.getXingge();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            for(_loc4_ in _xingge)
            {
               if(_xingge[_loc4_] == _loc2_[_loc3_])
               {
                  return false;
               }
            }
            _loc3_++;
         }
         return true;
      }
      
      public function get xingge() : Array
      {
         return _xingge;
      }
      
      public function set xingge(param1:Array) : void
      {
         _xingge = param1;
      }
   }
}

