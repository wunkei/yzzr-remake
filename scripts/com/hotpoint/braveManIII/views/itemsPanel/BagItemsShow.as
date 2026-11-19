package com.hotpoint.braveManIII.views.itemsPanel
{
   import flash.utils.*;
   import src.*;
   
   public class BagItemsShow
   {
      
      internal var timeOut:int;
      
      public function BagItemsShow()
      {
         super();
      }
      
      public static function allHide() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 24)
         {
            ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = "";
            ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.visible = true;
            ItemsPanel.itemsPanel["s1_" + _loc1_].visible = false;
            ItemsPanel.itemsPanel["s1_" + _loc1_]["diKuang"].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            ItemsPanel.itemsPanel["z1_" + _loc1_].t_txt.text = "";
            ItemsPanel.itemsPanel["z1_" + _loc1_].visible = false;
            ItemsPanel.itemsPanel["k1_" + _loc1_].visible = false;
            ItemsPanel.itemsPanel["z1_" + _loc1_]["diKuang"].visible = false;
            _loc1_++;
         }
         ItemsPanel.itemsPanel["g1_0"].visible = false;
         ItemsPanel.itemsPanel["g1_1"].visible = false;
      }
      
      public static function skillSlotShow() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 2)
         {
            if(ItemsPanel.myplayer.data.getEquipSkillSlot().getGemFromSkillSlot(_loc1_) != null)
            {
               ItemsPanel.itemsPanel["g1_" + _loc1_].visible = true;
            }
            else
            {
               ItemsPanel.itemsPanel["g1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      public static function clearTimeout() : void
      {
         if(timeOut > 0)
         {
            clearTimeout(timeOut);
         }
      }
      
      public static function informationShow() : void
      {
         timeOut = setTimeout(show1P,100);
      }
      
      private static function showLV(param1:Number) : *
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 < 10)
         {
            ItemsPanel.itemsPanel["shiwei"].gotoAndStop(param1);
            ItemsPanel.itemsPanel["gewei"].visible = false;
         }
         else
         {
            ItemsPanel.itemsPanel["gewei"].visible = true;
            _loc2_ = param1.toString();
            _loc3_ = int(_loc2_.substring(0,1));
            _loc4_ = int(_loc2_.substring(1,2));
            ItemsPanel.itemsPanel["shiwei"].gotoAndStop(_loc3_);
            if(_loc4_ == 0)
            {
               ItemsPanel.itemsPanel["gewei"].gotoAndStop(10);
            }
            else
            {
               ItemsPanel.itemsPanel["gewei"].gotoAndStop(_loc4_);
            }
         }
      }
      
      public static function zyShow(param1:int) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            if(_loc2_ == 3)
            {
               ItemsPanel.itemsPanel["ZY_txt"].text = "新手";
               return "新手";
            }
            if(Main["player" + param1]._transferArr[_loc2_])
            {
               if(_loc2_ == 0)
               {
                  ItemsPanel.itemsPanel["ZY_txt"].text = "杀戮战神";
                  return "杀戮战神";
               }
               if(_loc2_ == 1)
               {
                  ItemsPanel.itemsPanel["ZY_txt"].text = "汲魂术士";
                  return "汲魂术士";
               }
               ItemsPanel.itemsPanel["ZY_txt"].text = "毁灭拳神";
               return "毁灭拳神";
            }
            _loc2_++;
         }
         return undefined;
      }
      
      public static function QiangHuaJiaChengP1() : *
      {
         var _loc1_:int = int(ItemsPanel.myplayer.data.getEquipSlot().getSuitStrength());
         if(_loc1_ < 4)
         {
            ItemsPanel.itemsPanel["strengthen"].gotoAndStop(1);
            return;
         }
         ItemsPanel.itemsPanel["strengthen"].gotoAndStop(_loc1_ - 2);
      }
      
      public static function QiangHuaJiaChengP2() : *
      {
         var _loc1_:int = int(Main.player2.getEquipSlot().getSuitStrength());
         if(_loc1_ < 4)
         {
            ItemsPanel.itemsPanel["strengthen"].gotoAndStop(1);
            return;
         }
         ItemsPanel.itemsPanel["strengthen"].gotoAndStop(_loc1_ - 2);
      }
      
      public static function show1P() : *
      {
         if(ItemsPanel.myplayer.data.skinArr[ItemsPanel.myplayer.data.skinNum] == 0)
         {
            ItemsPanel.itemsPanel["p_mc"].gotoAndStop(1);
         }
         else if(ItemsPanel.myplayer.data.skinArr[ItemsPanel.myplayer.data.skinNum] == 1)
         {
            ItemsPanel.itemsPanel["p_mc"].gotoAndStop(3);
         }
         else
         {
            ItemsPanel.itemsPanel["p_mc"].gotoAndStop(2);
         }
         if(ItemsPanel.yeshu == 0)
         {
            ItemsPanel.itemsPanel["yeshu_1"].gotoAndStop(2);
            ItemsPanel.itemsPanel["yeshu_2"].gotoAndStop(1);
         }
         else
         {
            ItemsPanel.itemsPanel["yeshu_1"].gotoAndStop(1);
            ItemsPanel.itemsPanel["yeshu_2"].gotoAndStop(2);
         }
         zyShow(1);
         ItemsPanel.itemsPanel["id_txt"].htmlText = Main.logName;
         ItemsPanel.itemsPanel["name_txt"].htmlText = Main.logName2;
         ItemsPanel.itemsPanel["mkPoint"].text = int(ItemsPanel.myplayer.use_fangyu2.getValue());
         ItemsPanel.itemsPanel["pmPoint"].text = int(ItemsPanel.myplayer.use_gongji2.getValue());
         ItemsPanel.itemsPanel["hpPoint"].text = int(ItemsPanel.myplayer.use_hp_Max.getValue());
         ItemsPanel.itemsPanel["mpPoint"].text = int(ItemsPanel.myplayer.use_mp_Max.getValue());
         ItemsPanel.itemsPanel["attackPoint"].text = int(ItemsPanel.myplayer.use_gongji.getValue());
         ItemsPanel.itemsPanel["defensePoint"].text = int(ItemsPanel.myplayer.use_fangyu.getValue());
         ItemsPanel.itemsPanel["critPoint"].text = Math.pow(Number(ItemsPanel.myplayer.use_baoji.getValue() / 70),0.8).toFixed(1) + "%";
         ItemsPanel.itemsPanel["duckPoint"].text = Math.pow(Number(ItemsPanel.myplayer.use_sanbi.getValue() / 100),0.8).toFixed(1) + "%";
         ItemsPanel.itemsPanel["gold1"].text = ItemsPanel.myplayer.data.getGold();
         ItemsPanel.itemsPanel["djPoint"].text = Shop4399.moneyAll.getValue();
         ItemsPanel.itemsPanel["kill_txt"].text = ItemsPanel.myplayer.data.killPoint.getValue();
         ItemsPanel.itemsPanel["expPoint"].text = ItemsPanel.myplayer.data.getEXP() + " / " + ItemsPanel.myplayer.nextExp.getValue();
         ItemsPanel.itemsPanel["jyt"]["zd"].scaleX = ItemsPanel.myplayer.data.getEXP() / ItemsPanel.myplayer.nextExp.getValue();
         if(ItemsPanel.myplayer.data.getTitleSlot().getTitleView())
         {
            ItemsPanel.itemsPanel["chenghao"].gotoAndStop(ItemsPanel.myplayer.data.getTitleSlot().getTitleView().getFrame());
         }
         else
         {
            ItemsPanel.itemsPanel["chenghao"].gotoAndStop(1);
         }
         if(ItemsPanel.myplayer.data.playerJL_Data)
         {
            ItemsPanel.itemsPanel["jingling"].gotoAndStop(ItemsPanel.myplayer.data.playerJL_Data.getFrame() + 1);
         }
         else
         {
            ItemsPanel.itemsPanel["jingling"].gotoAndStop(1);
         }
         if(ItemsPanel.myplayer.data.getElvesSlot().backElvesNum() == 0)
         {
            ItemsPanel.itemsPanel["jingling_btn"].visible = true;
         }
         else
         {
            ItemsPanel.itemsPanel["jingling_btn"].visible = true;
         }
         showLV(ItemsPanel.myplayer.data.getLevel());
         QiangHuaJiaChengP1();
      }
      
      public static function equipShow() : void
      {
         var _loc1_:uint = 0;
         ItemsPanel.myplayer.data.getBag().zhengliBag();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = "";
            if(ItemsPanel.myplayer.data.getBag().getEquipFromBag(_loc1_ + ItemsPanel.yeshu * 24))
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getBag().getEquipFromBag(_loc1_ + ItemsPanel.yeshu * 24).getFrame());
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = true;
            }
            else
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(ItemsPanel.yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitE() >= 28)
            {
               ItemsPanel.itemsPanel["bagLock0"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitE() >= 32)
            {
               ItemsPanel.itemsPanel["bagLock1"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitE() >= 36)
            {
               ItemsPanel.itemsPanel["bagLock2"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitE() >= 40)
            {
               ItemsPanel.itemsPanel["bagLock3"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitE() >= 44)
            {
               ItemsPanel.itemsPanel["bagLock4"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitE() >= 48)
            {
               ItemsPanel.itemsPanel["bagLock5"].visible = false;
            }
         }
      }
      
      public static function gemShow() : void
      {
         var _loc1_:uint = 0;
         ItemsPanel.myplayer.data.getBag().zhengliBagG();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = "";
            if(ItemsPanel.myplayer.data.getBag().getGemFromBag(_loc1_ + ItemsPanel.yeshu * 24) != null)
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getBag().getGemFromBag(_loc1_ + ItemsPanel.yeshu * 24).getFrame());
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = true;
               if(ItemsPanel.myplayer.data.getBag().getGemFromBag(_loc1_ + ItemsPanel.yeshu * 24).getIsPile() == true)
               {
                  ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = ItemsPanel.myplayer.data.getBag().getGemFromBag(_loc1_ + ItemsPanel.yeshu * 24).getTimes();
               }
            }
            else
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(ItemsPanel.yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitG() >= 28)
            {
               ItemsPanel.itemsPanel["bagLock0"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitG() >= 32)
            {
               ItemsPanel.itemsPanel["bagLock1"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitG() >= 36)
            {
               ItemsPanel.itemsPanel["bagLock2"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitG() >= 40)
            {
               ItemsPanel.itemsPanel["bagLock3"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitG() >= 44)
            {
               ItemsPanel.itemsPanel["bagLock4"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitG() >= 48)
            {
               ItemsPanel.itemsPanel["bagLock5"].visible = false;
            }
         }
      }
      
      public static function suppliesShow() : void
      {
         var _loc1_:uint = 0;
         if(ItemsPanel.myplayer)
         {
            ItemsPanel.myplayer.data.getBag().zhengliBagS();
            if(ItemsPanel.boolFlag == false)
            {
               return;
            }
            ItemsPanel.menuTooltip.visible = false;
            _loc1_ = 0;
            while(_loc1_ < 24)
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = "";
               if(ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(_loc1_ + ItemsPanel.yeshu * 24) != null)
               {
                  ItemsPanel.itemsPanel["s1_" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(_loc1_ + ItemsPanel.yeshu * 24).getFrame());
                  ItemsPanel.itemsPanel["s1_" + _loc1_].visible = true;
                  if(ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(_loc1_ + ItemsPanel.yeshu * 24).getTimes() > 1)
                  {
                     ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = ItemsPanel.myplayer.data.getBag().getSuppliesFromBag(_loc1_ + ItemsPanel.yeshu * 24).getTimes();
                  }
               }
               else
               {
                  ItemsPanel.itemsPanel["s1_" + _loc1_].visible = false;
               }
               _loc1_++;
            }
            if(ItemsPanel.yeshu == 0)
            {
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = false;
                  _loc1_++;
               }
            }
            else
            {
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = true;
                  _loc1_++;
               }
               if(ItemsPanel.myplayer.data.getBag().getLimitS() >= 28)
               {
                  ItemsPanel.itemsPanel["bagLock0"].visible = false;
               }
               if(ItemsPanel.myplayer.data.getBag().getLimitS() >= 32)
               {
                  ItemsPanel.itemsPanel["bagLock1"].visible = false;
               }
               if(ItemsPanel.myplayer.data.getBag().getLimitS() >= 36)
               {
                  ItemsPanel.itemsPanel["bagLock2"].visible = false;
               }
               if(ItemsPanel.myplayer.data.getBag().getLimitS() >= 40)
               {
                  ItemsPanel.itemsPanel["bagLock3"].visible = false;
               }
               if(ItemsPanel.myplayer.data.getBag().getLimitS() >= 44)
               {
                  ItemsPanel.itemsPanel["bagLock4"].visible = false;
               }
               if(ItemsPanel.myplayer.data.getBag().getLimitS() >= 48)
               {
                  ItemsPanel.itemsPanel["bagLock5"].visible = false;
               }
            }
         }
      }
      
      public static function slotShow() : void
      {
         var _loc2_:int = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = int(_loc1_);
            if(Main.water.getValue() != 1 && (_loc1_ == 0 || _loc1_ == 1 || _loc1_ == 3 || _loc1_ == 4))
            {
               _loc2_ += 8;
            }
            ItemsPanel.itemsPanel["z1_" + _loc1_].t_txt.text = "";
            if(ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(_loc2_) != null)
            {
               ItemsPanel.itemsPanel["z1_" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getEquipSlot().getEquipFromSlot(_loc2_).getFrame());
               ItemsPanel.itemsPanel["z1_" + _loc1_].visible = true;
               ItemsPanel.itemsPanel["z1_" + _loc1_]["diKuang"].visible = true;
            }
            else
            {
               ItemsPanel.itemsPanel["z1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      public static function badgeSlotShow() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 6)
         {
            if(ItemsPanel.myplayer.data.getBadgeSlot().getBadgeFromSlot(_loc1_) != null)
            {
               ItemsPanel.itemsPanel["hz" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getBadgeSlot().getBadgeFromSlot(_loc1_).getFrame());
               ItemsPanel.itemsPanel["hz" + _loc1_].visible = true;
            }
            else
            {
               ItemsPanel.itemsPanel["hz" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      public static function questShow() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = "";
            if(ItemsPanel.myplayer.data.getBag().getQuestFromBag(_loc1_) != null)
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getBag().getQuestFromBag(_loc1_).getFrame());
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = true;
               if(ItemsPanel.myplayer.data.getBag().getQuestFromBag(_loc1_).isMany() == true)
               {
                  ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = ItemsPanel.myplayer.data.getBag().getQuestFromBag(_loc1_).getTimes();
               }
            }
            else
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public static function otherobjShow() : void
      {
         var _loc1_:uint = 0;
         ItemsPanel.myplayer.data.getBag().zhengliBagO();
         _loc1_ = 0;
         while(_loc1_ < 24)
         {
            ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = "";
            if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(_loc1_ + ItemsPanel.yeshu * 24) != null)
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].gotoAndStop(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(_loc1_ + ItemsPanel.yeshu * 24).getFrame());
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = true;
               if(ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(_loc1_ + ItemsPanel.yeshu * 24).getTimes() > 1)
               {
                  ItemsPanel.itemsPanel["s1_" + _loc1_].t_txt.text = ItemsPanel.myplayer.data.getBag().getOtherobjFromBag(_loc1_ + ItemsPanel.yeshu * 24).getTimes();
               }
            }
            else
            {
               ItemsPanel.itemsPanel["s1_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         if(ItemsPanel.yeshu == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = false;
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               ItemsPanel.itemsPanel["bagLock" + _loc1_].visible = true;
               _loc1_++;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitO() >= 28)
            {
               ItemsPanel.itemsPanel["bagLock0"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitO() >= 32)
            {
               ItemsPanel.itemsPanel["bagLock1"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitO() >= 36)
            {
               ItemsPanel.itemsPanel["bagLock2"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitO() >= 40)
            {
               ItemsPanel.itemsPanel["bagLock3"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitO() >= 44)
            {
               ItemsPanel.itemsPanel["bagLock4"].visible = false;
            }
            if(ItemsPanel.myplayer.data.getBag().getLimitO() >= 48)
            {
               ItemsPanel.itemsPanel["bagLock5"].visible = false;
            }
         }
      }
   }
}

