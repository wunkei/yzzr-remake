package src
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   
   public class TempData extends MovieClip
   {
      
      private static var infoArr:Array = ["1.增加三月份手机签到礼包","2.关闭时装、充值、特卖、年兽大作战活动","3.修复宠物冰原虎技能秒杀怪物BUG"];
      
      public function TempData()
      {
         super();
      }
      
      public static function Init() : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         Main.varX = 932;
         Strat.说明1 = "勇士的信仰【v9.32】版本更新内容:";
         Strat.说明2 = "";
         var _loc1_:int = 0;
         while(_loc1_ < infoArr.length)
         {
            _loc2_ = infoArr[_loc1_];
            _loc3_ = _loc2_.length / 38;
            if(_loc3_ > 0)
            {
               _loc4_ = "";
               _loc5_ = 0;
               while(_loc5_ <= _loc3_)
               {
                  if(_loc5_ > 0)
                  {
                     _loc4_ += "  ";
                  }
                  _loc4_ += _loc2_.substr(_loc5_ * 38,38) + "\n";
                  _loc5_++;
               }
               Strat.说明2 += _loc4_;
            }
            else
            {
               Strat.说明2 += _loc2_ + "\n";
            }
            _loc1_++;
         }
         Strat.说明3 = "勇士的信仰团队 2015.3.2";
         Strat.VarXX();
         Load.otherArr = ["DataX_v932.swf","PlayerMc_X0_v930.swf","PlayerMc_X1_v930.swf","PlayerMc_X2_v930.swf","ZhuangBei_X0_v6.swf","ZhuangBei_X1_v6.swf","ZhuangBei_X2_v6.swf","WuQi_X0_v930.swf","WuQi_X1_v930.swf","WuQi_X2_v930.swf","Data2X_v19.swf","Music_v5.swf","Jingling_v870.swf","ShiZhuang_X0_v5.swf","ShiZhuang_X1_v5.swf","ShiZhuang_X2_v5.swf"];
         Load.otherArr[16] = "ChongWu2.swf";
         Load.otherArr[17] = "SelMap_v930.swf";
         Load.otherArr[18] = "Npc_v2.swf";
         Load.mapArr = ["Map0_v920.swf","Map1_v2.swf","Map2_v2.swf","Map3_v2.swf","Map4.swf","Map5.swf","Map6.swf","Map7.swf","Map8.swf","Map9_v4.swf","Map10.swf","Map11_v2.swf","Map12_v6.swf","Map13.swf","Map14.swf","Map15.swf","Map16.swf","Map17.swf","Map18_v2.swf"];
         Load.mapArr[101] = "Map101.swf";
         Load.mapArr[102] = "Map102.swf";
         Load.mapArr[103] = "Map103.swf";
         Load.mapArr[104] = "Map104.swf";
         Load.mapArr[105] = "Map105.swf";
         Load.mapArr[888] = "Map888.swf";
         Load.mapArr[999] = "Map999.swf";
         Load.mapArr[1000] = "Map1000.swf";
         Load.mapArr[2015] = "Map2015.swf";
         Load.mapArr[51] = "Map51.swf";
         Load.mapArr[52] = "Map52.swf";
         Load.mapArr[53] = "Map53.swf";
         Load.mapArr[54] = "Map54.swf";
         Load.mapArr[55] = "Map55.swf";
         Load.mapArr[56] = "Map56.swf";
         Load.mapArr[57] = "Map57.swf";
         Load.mapArr[58] = "Map58.swf";
         Load.mapArr[59] = "Map59.swf";
         Load.mapArr[60] = "Map60_v2.swf";
         Load.mapArr[61] = "Map61.swf";
         Load.mapArr[62] = "Map62.swf";
         Load.mapArr[81] = "Map81_v2.swf";
         Load.mapArr[82] = "Map82.swf";
         Load.mapArr[83] = "Map83.swf";
         Load.mapArr[84] = "Map84.swf";
         Load.enemyArr = ["","Enemy1.swf","Enemy2_v2.swf","Enemy3.swf","Enemy4.swf","Enemy5_v2.swf","Enemy6_v2.swf","Enemy7_v2.swf","Enemy8_v6.swf","Enemy9.swf","Enemy10_v7.swf","Enemy11_v2.swf","Enemy12.swf","Enemy13_v3.swf","Enemy14_v2.swf","Enemy15_v910.swf","Enemy16.swf","Enemy17.swf","Enemy18_v2.swf","Enemy19_v3.swf","Enemy20.swf","Enemy21.swf","Enemy22.swf","Enemy23_v2.swf","Enemy24.swf","Enemy25.swf","Enemy26.swf","Enemy27_v2.swf"];
         Load.enemyArr[101] = "Enemy101_v5.swf";
         Load.enemyArr[102] = "Enemy102.swf";
         Load.enemyArr[103] = "Enemy103_v5.swf";
         Load.enemyArr[104] = "Enemy104_v2.swf";
         Load.enemyArr[105] = "Enemy105_v870.swf";
         Load.enemyArr[201] = "Enemy201_v3.swf";
         Load.enemyArr[202] = "Enemy202.swf";
         Load.enemyArr[203] = "Enemy203_v3.swf";
         Load.enemyArr[204] = "Enemy204_v2.swf";
         Load.enemyArr[205] = "Enemy205_v2.swf";
         Load.enemyArr[206] = "Enemy206_v2.swf";
         Load.enemyArr[207] = "Enemy207_v2.swf";
         Load.enemyArr[208] = "Enemy207_v2.swf";
         Load.enemyArr[209] = "Enemy207_v2.swf";
         Load.enemyArr[210] = "Enemy210.swf";
         Load.enemyArr[211] = "Enemy210.swf";
         Load.enemyArr[212] = "Enemy210.swf";
         Load.enemyArr[213] = "Enemy213.swf";
         Load.enemyArr[214] = "Enemy213.swf";
         Load.enemyArr[215] = "Enemy213.swf";
         Load.enemyArr[216] = "Enemy216.swf";
         Load.enemyArr[217] = "Enemy216.swf";
         Load.enemyArr[218] = "Enemy216.swf";
         Load.enemyArr[222] = "Enemy222.swf";
         Load.enemyArr[223] = "Enemy222.swf";
         Load.enemyArr[224] = "Enemy222.swf";
         Load.enemyArr[234] = "Enemy225.swf";
         Load.enemyArr[235] = "Enemy225.swf";
         Load.enemyArr[236] = "Enemy225.swf";
         Load.enemyArr[51] = "Enemy51.swf";
         Load.enemyArr[52] = "Enemy52_v3.swf";
         Load.enemyArr[53] = "Enemy53_v2.swf";
         Load.enemyArr[54] = "Enemy54_v3.swf";
         Load.enemyArr[55] = "Enemy55_v3.swf";
         Load.enemyArr[56] = "Enemy56_v2.swf";
         Load.enemyArr[57] = "Enemy57.swf";
         Load.enemyArr[58] = "Enemy58.swf";
         Load.enemyArr[59] = "Enemy59_v2.swf";
         Load.enemyArr[60] = "Enemy60_v900.swf";
         Load.enemyArr[61] = "Enemy61.swf";
         Load.enemyArr[62] = "Enemy62.swf";
         Load.enemyArr[81] = "Enemy81_v4.swf";
         Load.enemyArr[82] = "Enemy82.swf";
         Load.enemyArr[83] = "Enemy83.swf";
         Load.enemyArr[84] = "Enemy84.swf";
         Load.enemyArr[888] = "Enemy888.swf";
         Load.enemyArr[1000] = "Enemy1000_v921.swf";
         Load.enemyArr[2015] = "CW26.swf";
      }
   }
}

