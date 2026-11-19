package src
{
   import com.hotpoint.braveManIII.models.common.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.achPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import src.tool.*;
   
   public class WinShow2 extends MovieClip
   {
      
      public static var skin:MovieClip;
      
      public static var _this:MovieClip;
      
      public function WinShow2()
      {
         super();
         _this = this;
         addChild(skin);
         GameData.GuanKaXX();
         TextShow();
         Main._stage.addChild(this);
         Main._stage.frameRate = 0;
         if(Main.gameNum.getValue() == 2015 || Main.gameNum.getValue() == 1000 || Main.gameNum.getValue() == 888 || Main.gameNum.getValue() > 16 && Main.gameNum.getValue() < 50 || Main.gameNum.getValue() > 80 && Main.gameNum.getValue() < 100)
         {
            skin.re_btn.visible = false;
         }
         else
         {
            skin.re_btn.visible = true;
         }
         skin.re_btn.addEventListener(MouseEvent.CLICK,重开);
         skin.back_btn.addEventListener(MouseEvent.CLICK,回村);
         AchData.setTg();
         AchData.gkOk();
         TaskData.setTg();
         TaskData.isOk();
         JingLing.QingChuLengQue();
      }
      
      private static function 回村(param1:*) : *
      {
         Main._stage.frameRate = 27;
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(0);
         Load.loadGameNum = 1;
         Load.loadGameNum2 = 1;
         Player.一起信春哥();
         _this.removeEventListener(MouseEvent.CLICK,回村);
         _this.removeEventListener(MouseEvent.CLICK,重开);
         Main._this.Loading();
         GameData.deadMcYN = false;
         GameData.deadTime = 5;
         Main.allClosePanel();
         _this.parent.removeChild(_this);
         WinShow.All_0();
         PaiHang_Data.All_0();
         Main.Save();
      }
      
      private static function 重开(param1:*) : *
      {
         var _loc2_:int = 1;
         if(Main.gameNum.getValue() <= 9)
         {
            _loc2_ = 1;
         }
         else if(Main.gameNum.getValue() <= 16)
         {
            _loc2_ = 2;
         }
         else if(Main.gameNum.getValue() <= 70)
         {
            _loc2_ = 3;
         }
         Player.skillYAO = 0;
         Main._stage.frameRate = 27;
         Main.gameNum.setValue(0);
         Main.gameNum2.setValue(0);
         Load.loadGameNum = 1;
         Load.loadGameNum2 = 1;
         Player.一起信春哥();
         GameData.deadMcYN = false;
         GameData.deadTime = 5;
         Main.allClosePanel();
         _this.parent.removeChild(_this);
         WinShow.All_0();
         PaiHang_Data.All_0();
         Main.Save();
         SelMap.Open(0,0,3,_loc2_);
      }
      
      private function TextShow() : *
      {
         var _loc5_:int = 0;
         var _loc1_:Array = PaiHang_Data.Show();
         skin.time1_txt.text = _loc1_[0];
         skin.time2_txt.text = _loc1_[1];
         skin.qiu1_txt.text = _loc1_[2];
         skin.qiu2_txt.text = _loc1_[3];
         skin.Bj1_txt.text = _loc1_[4];
         skin.Bj2_txt.text = _loc1_[5];
         skin.fenshu1.text = _loc1_[6];
         skin.fenshu2.text = _loc1_[7];
         if(_loc1_[8])
         {
            skin.jiLu_mc.visible = true;
         }
         else
         {
            skin.jiLu_mc.visible = false;
         }
         NewMC.Open("文字提示",Main._stage,470,400,30,0,true,2,"成绩已提交");
         if(Main.gameNum.getValue() <= 9)
         {
            _loc5_ = int((PaiHang_Data.jiFenArr[1] as VT).getValue());
            PaiHang_Data.jiFenArr[1] = VT.createVT(_loc5_ + InitData.tiaoZhanJF_1.getValue());
            if(PaiHang_Data.jiFenArr[1].getValue() > InitData.tiaoZhanJF_500.getValue())
            {
               PaiHang_Data.jiFenArr[1] = VT.createVT(InitData.tiaoZhanJF_500.getValue());
            }
            skin.JL_mc.gotoAndStop(1);
            skin.JL_txt.text = 1;
         }
         else if(Main.gameNum.getValue() <= 16)
         {
            _loc5_ = int((PaiHang_Data.jiFenArr[2] as VT).getValue());
            PaiHang_Data.jiFenArr[2] = VT.createVT(_loc5_ + InitData.tiaoZhanJF_1.getValue());
            if(PaiHang_Data.jiFenArr[2].getValue() > InitData.tiaoZhanJF_500.getValue())
            {
               PaiHang_Data.jiFenArr[2] = VT.createVT(InitData.tiaoZhanJF_500.getValue());
            }
            skin.JL_mc.gotoAndStop(2);
            skin.JL_txt.text = 1;
         }
         else if(Main.gameNum.getValue() <= 62)
         {
            _loc5_ = int((PaiHang_Data.jiFenArr[3] as VT).getValue());
            PaiHang_Data.jiFenArr[3] = VT.createVT(_loc5_ + InitData.tiaoZhanJF_1.getValue());
            if(PaiHang_Data.jiFenArr[3].getValue() > InitData.tiaoZhanJF_500.getValue())
            {
               PaiHang_Data.jiFenArr[3] = VT.createVT(InitData.tiaoZhanJF_500.getValue());
            }
            skin.JL_mc.gotoAndStop(3);
            skin.JL_txt.text = 1;
         }
         var _loc2_:String = " / 1P等级" + Main.player_1.data.getLevel();
         if(Main.P1P2)
         {
            _loc2_ += " / 2P等级" + Main.player_2.data.getLevel();
         }
         var _loc3_:String = " / 关卡:" + Main.gameNum.getValue();
         if(Main.gameNum.getValue() > 100 && Main.gameNum.getValue() < 200)
         {
            _loc3_ = " / 关卡:副本" + (Main.gameNum.getValue() - 100);
         }
         else if(Main.gameNum.getValue() == 17)
         {
            _loc3_ = "/ 挑关卡:" + (Main.gameNum.getValue() - 16);
         }
         else if(Main.gameNum.getValue() > 17 && Main.gameNum.getValue() < 50)
         {
            _loc3_ = "/ 星灵擂台:" + (Main.gameNum.getValue() - 17);
         }
         else if(Main.gameNum.getValue() > 50 && Main.gameNum.getValue() < 81)
         {
            _loc3_ = "/ 海底:" + (Main.gameNum.getValue() - 50);
         }
         else if(Main.gameNum.getValue() > 80 && Main.gameNum.getValue() < 100)
         {
            _loc3_ = "/ 海底副本:" + (Main.gameNum.getValue() - 80);
         }
         else
         {
            _loc3_ = "/ 关卡:" + Main.gameNum.getValue();
         }
         var _loc4_:String = " / 难度:★";
         if(GameData.gameLV == 2)
         {
            _loc4_ = " / 难度:★★";
         }
         else if(GameData.gameLV == 3)
         {
            _loc4_ = " / 难度:★★★";
         }
         else if(GameData.gameLV == 4)
         {
            _loc4_ = " / 难度:★★★★";
         }
         else if(GameData.gameLV == 5)
         {
            _loc4_ = " / 难度:挑战模式";
         }
         skin.XX_txt.text = "版本" + Main.varX / 100 + _loc2_ + _loc3_ + _loc4_;
      }
   }
}

