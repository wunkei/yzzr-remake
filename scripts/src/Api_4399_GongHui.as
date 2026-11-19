package src
{
   import com.ByteArrayXX.*;
   import com.adobe.serialization.json.*;
   import com.hotpoint.braveManIII.views.elvesPanel.*;
   import com.hotpoint.braveManIII.views.itemsPanel.*;
   import com.hotpoint.braveManIII.views.makePanel.*;
   import com.hotpoint.braveManIII.views.petPanel.*;
   import com.hotpoint.braveManIII.views.stampPanel.*;
   import com.hotpoint.braveManIII.views.wantedPanel.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import src._data.*;
   import src.tool.*;
   import unit4399.events.*;
   
   public class Api_4399_GongHui
   {
      
      public function Api_4399_GongHui()
      {
         super();
      }
      
      public static function Init(param1:Stage) : *
      {
         param1.addEventListener(UnionEvent.UNION_VISITOR_SUCCESS,onVisitorSuccess);
         param1.addEventListener(UnionEvent.UNION_MEMBER_SUCCESS,onMemberSuccess);
         param1.addEventListener(UnionEvent.UNION_GROW_SUCCESS,onGrowSuccess);
         param1.addEventListener(UnionEvent.UNION_MASTER_SUCCESS,onMasterSuccess);
         param1.addEventListener(UnionEvent.UNION_VARIABLES_SUCCESS,onVariablesSuccess);
         param1.addEventListener(UnionEvent.UNION_ERROR,unionCreateError);
      }
      
      public static function SelUserInfo() : *
      {
         var _loc1_:int = int(Main.saveNum);
         Main.serviceHold.getOwnUnion(_loc1_);
      }
      
      public static function AddGongHui(param1:String, param2:String = "测试用") : *
      {
         var _loc3_:int = int(Main.saveNum);
         Main.serviceHold.unionCreate(_loc3_,param1,param2);
      }
      
      public static function getList(param1:int = 1, param2:int = 24) : *
      {
         var _loc3_:int = int(Main.saveNum);
         Main.serviceHold.getUnionList(_loc3_,param1,param2);
      }
      
      public static function upNum(param1:int = 15) : *
      {
         var _loc2_:int = int(Main.saveNum);
         Main.serviceHold.doVariable(_loc2_,param1);
      }
      
      public static function getNum(param1:Array) : *
      {
         var _loc2_:int = int(Main.saveNum);
         Main.serviceHold.getVariables(_loc2_,param1);
      }
      
      public static function getSenHe(param1:int = 1, param2:int = 10) : *
      {
         var _loc3_:int = int(Main.saveNum);
         Main.serviceHold.getApplyList(_loc3_,param1,param2);
         TiaoShi.txtShow("获取待审核列表 请求\n");
      }
      
      public static function SenQing(param1:int, param2:String = "") : *
      {
         var _loc3_:int = int(Main.saveNum);
         Main.serviceHold.applyUnion(_loc3_,param1,param2);
      }
      
      private static function onVisitorSuccess(param1:UnionEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc2_:Object = param1.data;
         TiaoShi.txtShow("游客模块apiName:" + _loc2_.apiName + "\n");
         _loc3_ = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_BHCJ:
               TiaoShi.txtShow("帮会创建结果:" + String(_loc3_) + "\n");
               if(_loc3_ == true)
               {
                  GongHui_Interface.playerInfo.unionInfo = null;
                  GongHui_Interface.openType = "init";
                  Api_4399_GongHui.SelUserInfo();
               }
               break;
            case UnionEvent.UNI_API_BHLB:
               TiaoShi.txtShow("帮会列表:\n" + String(_loc3_) + "\n");
               _loc4_ = _loc3_;
               _loc5_ = JSONs.decode(_loc4_,true);
               _loc6_ = _loc5_.unionList;
               for(_loc7_ in _loc6_)
               {
                  TiaoShi.txtShow(_loc7_ + " : " + _loc6_[_loc7_].title + ", " + _loc6_[_loc7_].unionId + "\n");
               }
               GongHui_Interface.ListOk(_loc5_);
               break;
            case UnionEvent.UNI_API_BHSQ:
               if(Boolean(_loc3_))
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"申请提交成功, 请耐心等待审核结果");
               }
               else
               {
                  NewMC.Open("文字提示",Main._stage,480,400,30,0,true,2,"申请提交失败了!");
               }
               break;
            case UnionEvent.UNI_API_SSBH:
               _loc4_ = _loc3_;
               _loc5_ = JSONs.decode(_loc4_,true);
               GongHui_Interface.PlayerInfoOk(_loc5_);
               if(_loc5_.unionInfo == null)
               {
               }
         }
      }
      
      private static function onMemberSuccess(param1:UnionEvent) : *
      {
         var _loc2_:Object = param1.data;
         TiaoShi.txtShow("成员模块apiName:" + _loc2_.apiName + "\n");
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_BHMX:
            case UnionEvent.UNI_API_BHCY:
            case UnionEvent.UNI_API_CYTZBG:
            case UnionEvent.UNI_API_BHTZBG:
            case UnionEvent.UNI_API_BHRZ:
            case UnionEvent.UNI_API_TCBH:
         }
      }
      
      private static function onGrowSuccess(param1:UnionEvent) : *
      {
         var _loc2_:Object = param1.data;
         TiaoShi.txtShow("成长模块apiName:" + _loc2_.apiName + "\n");
         var _loc3_:* = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_BHRW:
            case UnionEvent.UNI_API_BHDH:
            case UnionEvent.UNI_API_BHRWWC:
         }
      }
      
      private static function onMasterSuccess(param1:UnionEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc2_:Object = param1.data;
         TiaoShi.txtShow("帮主模块apiName:" + _loc2_.apiName + "\n");
         _loc3_ = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_DSHLB:
               TiaoShi.txtShow("获取待审核列表:\n" + String(_loc3_) + "\n");
               _loc4_ = _loc3_;
               _loc5_ = JSONs.decode(_loc4_,true);
               GongHui_Interface.SenHeListOk(_loc5_);
               break;
            case UnionEvent.UNI_API_CYSH:
            case UnionEvent.UNI_API_CYYC:
            case UnionEvent.UNI_API_JSBH:
         }
      }
      
      private static function onVariablesSuccess(param1:UnionEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Object = param1.data;
         TiaoShi.txtShow("公共变量模块apiName:" + _loc2_.apiName + "\n");
         _loc3_ = _loc2_.data;
         switch(_loc2_.apiName)
         {
            case UnionEvent.UNI_API_HQBL:
               TiaoShi.txtShow("公共变量列表:\n" + String(_loc3_) + "\n");
               _loc4_ = _loc3_;
               _loc5_ = JSONs.decode(_loc4_,true);
               TiaoShi.txtShow("公共变量列表数组长度:" + _loc5_.length);
               _loc6_ = 0;
               _loc7_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc5_.length)
               {
                  TiaoShi.txtShow(_loc8_ + " : " + _loc5_[_loc8_].id + ", " + _loc5_[_loc8_].value);
                  if(_loc5_[_loc8_].id == 57)
                  {
                     _loc6_ = int(_loc5_[_loc8_].value);
                  }
                  if(_loc5_[_loc8_].id == 58)
                  {
                     _loc7_ = int(_loc5_[_loc8_].value);
                  }
                  _loc8_++;
               }
               if(_loc6_ != 0)
               {
                  GengXin.Go(_loc6_,_loc7_);
               }
               break;
            case UnionEvent.UNI_API_XGBL:
               TiaoShi.txtShow("公共变量修改信息:\n" + Boolean(_loc3_));
         }
      }
      
      private static function unionCreateError(param1:UnionEvent) : *
      {
         TiaoShi.txtShow("帮会错误返回 eId:" + param1.data.eId + "  message:" + param1.data.msg + "\n");
      }
   }
}

