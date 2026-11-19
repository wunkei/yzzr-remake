package src.npc
{
   import com.hotpoint.braveManIII.views.equipShopPanel.*;
   import com.hotpoint.braveManIII.views.skillPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.*;
   
   public class 村长任务界面 extends MovieClip
   {
      
      private static var only:村长任务界面;
      
      public var close1:SimpleButton;
      
      public var close2:SimpleButton;
      
      public var temp_btn:SimpleButton;
      
      public var temp2_btn:SimpleButton;
      
      public var getObj_mc:MovieClip;
      
      public var song_btn:SimpleButton;
      
      public var close:SimpleButton;
      
      public var jieMian2:MovieClip;
      
      public var ling_btn:SimpleButton;
      
      public var quxiao_btn:SimpleButton;
      
      public var A_mc:MovieClip;
      
      public var numUP_btn:SimpleButton;
      
      public var numDOWN_btn:SimpleButton;
      
      public var jindutiao_mc:MovieClip;
      
      public var qinMiDu_txt:TextField;
      
      public function 村长任务界面()
      {
         super();
         this.close1.addEventListener(MouseEvent.CLICK,CloseXX);
         this.close2.addEventListener(MouseEvent.CLICK,CloseXX);
         this.temp_btn.addEventListener(MouseEvent.CLICK,getObj_mc_Open);
         this.temp2_btn.addEventListener(MouseEvent.CLICK,jieMian2_Open);
         this.getObj_mc.song_btn.addEventListener(MouseEvent.CLICK,GetNpc_Obj);
         this.getObj_mc.close.addEventListener(MouseEvent.CLICK,getObj_mc_Close);
         this.getObj_mc.A_mc.numUP_btn.addEventListener(MouseEvent.CLICK,SongNumUP);
         this.getObj_mc.A_mc.numDOWN_btn.addEventListener(MouseEvent.CLICK,SongNumDOWN);
         this.jieMian2.ling_btn.addEventListener(MouseEvent.CLICK,GetPlayer_Obj);
         this.jieMian2.quxiao_btn.addEventListener(MouseEvent.CLICK,jieMian2_Close);
      }
      
      public static function Open(param1:int = 0, param2:int = 0) : *
      {
         var _loc3_:Class = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         MusicBox.MusicPlay2("m5");
         if(!only)
         {
            _loc3_ = All_Npc.loadData.getClass("src.npc.村长任务界面") as Class;
            only = new _loc3_();
            _loc4_ = 1;
            while(_loc4_ < 8)
            {
               _loc5_ = new Shop_picNEW();
               _loc6_ = int(only.jieMian2["s1_" + _loc4_].getChildIndex(only.jieMian2["s1_" + _loc4_].pic_xx));
               _loc5_.x = only.jieMian2["s1_" + _loc4_].pic_xx.x;
               _loc5_.y = only.jieMian2["s1_" + _loc4_].pic_xx.y;
               _loc5_.name = "pic_xx";
               only.jieMian2["s1_" + _loc4_].removeChild(only.jieMian2["s1_" + _loc4_].pic_xx);
               only.jieMian2["s1_" + _loc4_].pic_xx = _loc5_;
               only.jieMian2["s1_" + _loc4_].addChild(_loc5_);
               only.jieMian2["s1_" + _loc4_].setChildIndex(_loc5_,_loc6_);
               _loc4_++;
            }
         }
         Main._stage.addChild(only);
         only.x = param1;
         only.y = param2;
         only.visible = true;
         only.ShowJinDu();
         only.xiaoLiDaiNum();
         only.LingQuYN();
      }
      
      public static function Close() : *
      {
         if(only)
         {
            only.x = 5000;
            only.y = 5000;
            only.visible = false;
         }
      }
      
      private function GetNpc_Obj(param1:*) : *
      {
         getObj_mc_Open();
         Use_xiaoLiDaiNum(int(getObj_mc.A_mc._txt.text));
         ShowJinDu();
         TaskData.isOk();
      }
      
      private function GetPlayer_Obj(param1:*) : *
      {
         All_Npc.NpcGetPlayerObj(1);
         LingQuYN();
         ShowJinDu();
      }
      
      private function CloseXX(param1:*) : *
      {
         Close();
      }
      
      private function ShowJinDu() : *
      {
         qinMiDu_txt.text = InitData.qinMiDu_Arr[1].getValue() + "/" + InitData.qinMiDu_Max_Arr[1].getValue();
         if(InitData.qinMiDu_Arr[1].getValue() <= InitData.qinMiDu_Max_Arr[1].getValue())
         {
            jindutiao_mc.XX_mc.scaleX = InitData.qinMiDu_Arr[1].getValue() / InitData.qinMiDu_Max_Arr[1].getValue();
         }
         else
         {
            jindutiao_mc.XX_mc.scaleX = 1;
         }
      }
      
      private function getObj_mc_Open(param1:* = null) : *
      {
         getObj_mc.x = 0;
         getObj_mc.y = 0;
         getObj_mc.visible = true;
         jieMian2_Close();
      }
      
      private function getObj_mc_Close(param1:* = null) : *
      {
         getObj_mc.x = 5000;
         getObj_mc.y = 5000;
         getObj_mc.visible = false;
      }
      
      private function jieMian2_Open(param1:* = null) : *
      {
         jieMian2.x = 242;
         jieMian2.y = 166;
         jieMian2.visible = true;
         getObj_mc_Close();
         ShowPicAndNum();
         if(InitData.qinMiDu_Arr[1].getValue() < InitData.qinMiDu_Max_Arr[1].getValue())
         {
            jieMian2.ling_btn.visible = false;
         }
         else if(LingQuYN())
         {
            jieMian2.ling_btn.visible = true;
         }
      }
      
      private function jieMian2_Close(param1:* = null) : *
      {
         jieMian2.x = 5000;
         jieMian2.y = 5000;
         jieMian2.visible = false;
      }
      
      private function SongNumUP(param1:* = null) : *
      {
         if(int(getObj_mc.A_mc._txt.text) < 20)
         {
            getObj_mc.A_mc._txt.text = int(getObj_mc.A_mc._txt.text) + 1;
         }
         else
         {
            getObj_mc.A_mc._txt.text = 1;
         }
      }
      
      private function SongNumDOWN(param1:* = null) : *
      {
         if(int(getObj_mc.A_mc._txt.text) > 1)
         {
            getObj_mc.A_mc._txt.text = int(getObj_mc.A_mc._txt.text) - 1;
         }
         else
         {
            getObj_mc.A_mc._txt.text = 20;
         }
      }
      
      private function xiaoLiDaiNum() : int
      {
         var _loc1_:int = int(Main.player1.getBag().getOtherobjNum(63102));
         var _loc2_:int = 0;
         if(Main.P1P2)
         {
            _loc2_ = int(Main.player2.getBag().getOtherobjNum(63102));
         }
         var _loc3_:int = _loc1_ + _loc2_;
         if(_loc3_ >= 1)
         {
            temp_btn.visible = true;
         }
         return _loc3_;
      }
      
      private function Use_xiaoLiDaiNum(param1:int) : *
      {
         var _loc5_:int = 0;
         var _loc2_:int = int(Main.player1.getBag().getOtherobjNum(63102));
         var _loc3_:int = 0;
         if(Main.P1P2)
         {
            _loc3_ = int(Main.player2.getBag().getOtherobjNum(63102));
         }
         var _loc4_:int = _loc2_ + _loc3_;
         if(_loc4_ >= param1)
         {
            if(_loc2_ <= param1)
            {
               Main.player1.getBag().getAndUseOtherobj(63102,_loc2_);
               if(Main.P1P2)
               {
                  Main.player2.getBag().getAndUseOtherobj(63102,param1 - _loc2_);
               }
               else
               {
                  trace("扣除小礼袋数量 #出现异常！");
               }
            }
            else
            {
               Main.player1.getBag().getAndUseOtherobj(63102,param1);
            }
            _loc5_ = param1 * 3;
            InitData.qinMiDu_Arr[1].setValue(InitData.qinMiDu_Arr[1].getValue() + _loc5_);
         }
         else
         {
            NewMC.Open("文字提示",this,480,290,30,0,true,2,"小礼袋不足");
         }
      }
      
      private function LingQuYN() : Boolean
      {
         if(InitData.qinMiDu_Time[1].getValue() >= Main.serverTime.getValue())
         {
            jieMian2.ling_btn.visible = false;
            return false;
         }
         return true;
      }
      
      private function ShowPicAndNum() : *
      {
         var _loc1_:Array = All_Npc.get_AllObj_Pic_And_Num(1);
         trace("InitData.qinMiDu_num[1] = " + InitData.qinMiDu_num[1].getValue());
         var _loc2_:* = InitData.qinMiDu_num[1].getValue() % 7;
         if(_loc2_ == 0)
         {
            _loc2_ = 7;
         }
         var _loc3_:int = 1;
         while(_loc3_ < 8)
         {
            trace("!!!!!!!!!!!!~~~~~~~~~~~xxx = " + _loc2_ + ",arr[xxx][1] = " + _loc1_[_loc2_][1]);
            jieMian2["s1_" + _loc3_].pic_xx.gotoAndStop(_loc1_[_loc2_][1]);
            jieMian2["s1_" + _loc3_].howNum.text = "";
            if(_loc3_ < 2)
            {
               jieMian2["_txt" + _loc3_].text = "x " + _loc1_[_loc2_][0];
            }
            _loc2_++;
            if(_loc2_ > 7)
            {
               _loc2_ = 1;
            }
            _loc3_++;
         }
      }
   }
}

