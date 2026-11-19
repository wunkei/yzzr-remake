package src
{
   import com.*;
   import com.hotpoint.braveManIII.repository.skill.*;
   import com.hotpoint.braveManIII.views.suppliesShopPanel.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import src.other.*;
   import src.tool.*;
   
   public class PlayerShow extends MovieClip
   {
      
      public var dataArr:Array = [1,1,1,[0],[0]];
      
      public var skin:Skin;
      
      public var skin_W:Skin_WuQi;
      
      public var skin_Z:Skin_ZhuangBei;
      
      public var skin_Z2:Skin_ZhuangBei;
      
      public var skin_Z3:Skin_ZhuangBei;
      
      public var skin_Z2_V:Boolean = true;
      
      public var skin_Z3_V:Boolean = true;
      
      public var headFrame:int = 1;
      
      public function PlayerShow()
      {
         super();
         mouseEnabled = mouseChildren = false;
      }
      
      public function Loading(param1:Array = null) : Boolean
      {
         if(TiaoZhanPaiHang_Interface.selTypeX != 0)
         {
            return true;
         }
         dataArr = param1;
         if(!dataArr || dataArr.length < 5)
         {
            return true;
         }
         var _loc2_:int = int(dataArr[0]);
         var _loc3_:int = int(dataArr[4][0]);
         var _loc4_:int = int(dataArr[3][0]);
         if(_loc4_ != 0 && dataArr[3][2] == 53)
         {
            dataArr[3][2] = 12;
         }
         if(_loc4_ != 0 && !NewLoad.zhuangBeiSkin[_loc2_][_loc4_] || _loc3_ != 0 && !NewLoad.zhuangBeiSkin[_loc2_][_loc3_])
         {
            NewLoad.PaiHangLoad(dataArr);
            return false;
         }
         return true;
      }
      
      public function AddSkin() : *
      {
         var _loc5_:Class = null;
         var _loc6_:String = null;
         if(skin_Z3)
         {
            skin_Z3.parent.removeChild(skin_Z3);
            skin_Z3 = null;
         }
         if(skin)
         {
            skin.parent.removeChild(skin);
            skin = null;
         }
         if(skin_Z)
         {
            skin_Z.parent.removeChild(skin_Z);
            skin_Z = null;
         }
         if(skin_W)
         {
            skin_W.parent.removeChild(skin_W);
            skin_W = null;
         }
         if(!dataArr || dataArr.length < 5)
         {
            return;
         }
         this.visible = true;
         var _loc1_:int = int(dataArr[0]);
         var _loc2_:int = int(dataArr[4][0]);
         headFrame = dataArr[1];
         var _loc3_:int = int(dataArr[3][0]);
         if(_loc2_ != 0)
         {
            _loc6_ = dataArr[4][2];
            _loc5_ = NewLoad.zhuangBeiSkin[_loc1_][_loc2_].getClass(_loc6_) as Class;
            skin_Z3 = new _loc5_();
            skin_Z3.gotoAndStop("站");
            skin_Z3.mouseChildren = skin_Z3.mouseEnabled = false;
            addChild(skin_Z3);
         }
         var _loc4_:int = int(dataArr[0]);
         _loc5_ = Player.PlayerMcArr[_loc4_].getClass("src.Skin.Skin_player" + _loc4_) as Class;
         this.skin = new _loc5_();
         skin.skinNum = _loc4_;
         skin.Xml = Skin.PlayerXml[_loc4_];
         skin.playX = this;
         skin.Stop();
         skin.mouseChildren = skin.mouseEnabled = false;
         addChild(skin);
         if(_loc3_ != 0)
         {
            _loc6_ = dataArr[3][2];
            _loc5_ = NewLoad.zhuangBeiSkin[_loc1_][_loc3_].getClass(_loc6_) as Class;
            skin_Z = new _loc5_();
            skin_Z.gotoAndStop("站");
            skin_Z.mouseChildren = skin_Z.mouseEnabled = false;
            addChild(skin_Z);
         }
         _loc5_ = Skin_WuQi.PlayerMcArr[_loc1_].getClass(dataArr[2]) as Class;
         this.skin_W = new _loc5_();
         skin_W.gotoAndStop("站");
         skin_W.mouseChildren = skin_W.mouseEnabled = false;
         addChild(skin_W);
      }
   }
}

