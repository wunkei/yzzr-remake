package src
{
   import com.*;
   import com.efnx.fps.*;
   import com.hotpoint.braveManIII.models.container.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.itemsTooltip.*;
   import com.hotpoint.braveManIII.views.setKeyPanel.*;
   import com.hotpoint.braveManIII.views.taskPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class GongHui_Interface extends MovieClip
   {
      
      private static var loadData:ClassLoader;
      
      private static var _this:GongHui_Interface;
      
      public static var LoadingYN:Boolean;
      
      public static var playerInfo:Object;
      
      public static var ListInfo:Object;
      
      private static var init:MovieClip;
      
      private static var senQing:MovieClip;
      
      private static var chuangJian:MovieClip;
      
      private static var gongHui:MovieClip;
      
      private static var senHe:MovieClip;
      
      private static var OpenYN:Boolean = false;
      
      private static var loadName:String = "GongHui.swf";
      
      public static var senHeListInfo:Array = new Array();
      
      public static var senHeListNum:int = 1;
      
      public static var openType:String = "init";
      
      public function GongHui_Interface()
      {
         super();
         _this = this;
      }
      
      private static function Init() : *
      {
         var _loc1_:GongHui_Interface = new GongHui_Interface();
         Main._stage.addChild(_loc1_);
         LoadSkin();
         LoadPlayerInfo();
         OpenYN = true;
      }
      
      private static function LoadSkin() : *
      {
         if(!loadData)
         {
            loadData = new ClassLoader(loadName);
            loadData.addEventListener(Event.COMPLETE,onSkinOK);
         }
      }
      
      public static function LoadPlayerInfo() : *
      {
         if(!playerInfo)
         {
            Api_4399_GongHui.SelUserInfo();
         }
      }
      
      private static function onSkinOK(param1:*) : *
      {
         var _loc2_:Class = loadData.getClass("Init") as Class;
         init = new _loc2_();
         var _loc3_:Class = loadData.getClass("SenQing") as Class;
         senQing = new _loc3_();
         var _loc4_:Class = loadData.getClass("ChuangJian") as Class;
         chuangJian = new _loc4_();
         var _loc5_:Class = loadData.getClass("GongHui") as Class;
         gongHui = new _loc5_();
         var _loc6_:Class = loadData.getClass("SenHe") as Class;
         senHe = new _loc6_();
         init.close_btn.addEventListener(MouseEvent.CLICK,onClose);
         senQing.close_btn.addEventListener(MouseEvent.CLICK,onClose);
         chuangJian.close_btn.addEventListener(MouseEvent.CLICK,onClose);
         gongHui.close_btn.addEventListener(MouseEvent.CLICK,onClose);
         senHe.close_btn.addEventListener(MouseEvent.CLICK,onClose);
         LoadingYN = true;
         TiaoShi.txtShow("加载图形完成");
         Show();
      }
      
      public static function PlayerInfoOk(param1:Object = null) : *
      {
         playerInfo = param1;
         TiaoShi.txtShow("加载玩家信息完成");
         Show();
      }
      
      public static function ListOk(param1:Object = null) : *
      {
         if(param1)
         {
            ListInfo = param1;
            TiaoShi.txtShow("加载公会列表完成");
            Show("senQing");
         }
         else
         {
            TiaoShi.txtShow("加载公会列表失败");
         }
      }
      
      public static function SenHeListOk(param1:Object = null) : *
      {
         if(param1)
         {
            senHeListInfo[senHeListNum] = param1;
            TiaoShi.txtShow("加载待审核列表完成");
            Show("senHe");
         }
         else
         {
            TiaoShi.txtShow("加载待审核列表失败");
         }
      }
      
      private static function onClose(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = param1.target.parent;
         _loc2_.x = _loc2_.y = -5000;
         _loc2_.visible = false;
         openType = "init";
      }
      
      public static function Open() : *
      {
         if(_this)
         {
            _this.visible = true;
            _this.x = _this.y = 0;
            Show();
         }
         else
         {
            Init();
         }
      }
      
      public static function CloseX() : *
      {
         if(_this)
         {
            _this.visible = false;
            _this.x = _this.y = 5000;
         }
      }
      
      public static function InitOpen(param1:Boolean = false) : *
      {
         if(param1)
         {
            init.x = init.y = -5000;
            senQing.x = senQing.y = -5000;
            chuangJian.x = chuangJian.y = -5000;
            gongHui.x = gongHui.y = -5000;
            senHe.x = senHe.y = -5000;
         }
         _this.x = _this.y = 0;
         _this.addChild(init);
         init.visible = true;
         init.x = init.y = 0;
         init.jiaRu_btn.addEventListener(MouseEvent.CLICK,JiaRu_Fun);
         init.chuanjian_btn.addEventListener(MouseEvent.CLICK,Chuanjian_Open);
      }
      
      public static function SenQingOpen() : *
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         _this.x = _this.y = 0;
         senQing.visible = true;
         senQing.x = senQing.y = 0;
         _this.addChild(senQing);
         var _loc1_:Array = ListInfo.unionList;
         for(_loc3_ in _loc1_)
         {
            _loc2_ = senQing["t" + (_loc3_ + 1)];
            _loc2_.x1.text = _loc3_;
            _loc2_.x2.text = _loc1_[_loc3_].title;
            _loc2_.x3.text = _loc1_[_loc3_].level;
            _loc2_.x4.text = _loc1_[_loc3_].username;
            _loc2_.x5.text = _loc1_[_loc3_].count;
            _loc2_.x6_btn.addEventListener(MouseEvent.CLICK,senQingFun);
         }
      }
      
      public static function ChuangJianOpen() : *
      {
         _this.x = _this.y = 0;
         chuangJian.visible = true;
         chuangJian.x = chuangJian.y = 0;
         _this.addChild(chuangJian);
         chuangJian.chuangJian_btn.addEventListener(MouseEvent.CLICK,Chuanjian_Fun);
      }
      
      public static function GongHuiOpen() : *
      {
         _this.x = _this.y = 0;
         gongHui.visible = true;
         gongHui.x = gongHui.y = 0;
         _this.addChild(gongHui);
         gongHui.senhe_btn.addEventListener(MouseEvent.CLICK,senHeFun);
      }
      
      public static function SenHeOpen() : *
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         _this.x = _this.y = 0;
         senHe.visible = true;
         senHe.x = gongHui.y = 0;
         _this.addChild(senHe);
         var _loc1_:Array = senHeListInfo[senHeListNum].applyList;
         for(_loc3_ in _loc1_)
         {
            _loc4_ = _loc1_[_loc3_].extra.split("|");
            _loc2_ = senQing["t" + (_loc3_ + 1)];
            _loc2_.x1.text = _loc1_[_loc3_].nickName;
            _loc2_.x2.text = _loc4_[0];
            _loc2_.x3.text = _loc4_[1];
         }
      }
      
      public static function senQingFun(param1:MouseEvent) : *
      {
         var _loc5_:String = null;
         var _loc2_:int = int((param1.target as SimpleButton).parent.name.substr(1,1));
         TiaoShi.txtShow("申请加入公会请求" + _loc2_);
         var _loc3_:Array = ListInfo.unionList;
         var _loc4_:int = int(_loc3_[_loc2_ - 1].unionId);
         TiaoShi.txtShow("申请加入公会ID" + _loc3_[_loc2_ - 1].unionId);
         var _loc6_:String = BagItemsShow.zyShow(1);
         if(Main.P1P2)
         {
            _loc5_ = Main.player1.getLevel() + "/" + Main.player2.getLevel();
            _loc6_ += "/" + BagItemsShow.zyShow(2);
         }
         else
         {
            _loc5_ = Main.player1.getLevel();
         }
         var _loc7_:String = _loc5_ + "|" + _loc6_;
         Api_4399_GongHui.SenQing(_loc4_,_loc7_);
      }
      
      public static function JiaRu_Fun(param1:*) : *
      {
         if(!ListInfo)
         {
            Api_4399_GongHui.getList();
         }
         else
         {
            SenQingOpen();
         }
      }
      
      public static function Chuanjian_Open(param1:*) : *
      {
         ChuangJianOpen();
      }
      
      public static function Chuanjian_Fun(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = param1.target.parent;
         Api_4399_GongHui.AddGongHui(_loc2_.name_txt.text);
      }
      
      public static function senHeFun(param1:MouseEvent) : *
      {
         senHeListNum = 1;
         var _loc2_:MovieClip = param1.target.parent;
         Api_4399_GongHui.getSenHe(senHeListNum);
      }
      
      public static function Show(param1:String = "") : *
      {
         if(!LoadingYN || !playerInfo)
         {
            return;
         }
         if(param1 != "")
         {
            openType = param1;
         }
         if(openType == "init")
         {
            if(playerInfo.unionInfo == null)
            {
               TiaoShi.txtShow("当前用户 未加入任何公会! \n");
               InitOpen();
            }
            else
            {
               GongHuiOpen();
            }
         }
         else if(openType == "senQing")
         {
            if(Boolean(ListInfo) && ListInfo.unionList.length > 0)
            {
               SenQingOpen();
            }
         }
         else if(openType == "senHe")
         {
            if(Boolean(senHeListInfo[senHeListNum]) && senHeListInfo[senHeListNum].applyList.length > 0)
            {
               SenHeOpen();
            }
            else
            {
               TiaoShi.txtShow("该页列表无信息! \n");
            }
         }
      }
      
      private function Close(param1:* = null) : *
      {
         this.visible = false;
         this.x = this.y = 5000;
      }
   }
}

