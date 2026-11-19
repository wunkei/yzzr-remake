package src
{
   import com.hotpoint.braveManIII.models.player.*;
   import com.hotpoint.braveManIII.repository.pet.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import src.tool.*;
   
   public class NewLoad extends MovieClip
   {
      
      public static var OtherData:ClassLoader;
      
      public static var XiaoGuoData:ClassLoader;
      
      public static var chongZhiData:ClassLoader;
      
      public static var zhuangBeiSkin:Array = [new Array(),new Array(),new Array()];
      
      public static var loadArr:Array = new Array();
      
      public static var loadTypeArr:Array = new Array();
      
      public static var loadType:uint = 1;
      
      public static var who:uint = 1;
      
      public static var loadingYN:Boolean = true;
      
      public static var enemySkill:Array = [new Array()];
      
      public static var loadLR:Array = new Array();
      
      private static var boolYN:Boolean = true;
      
      public function NewLoad()
      {
         super();
      }
      
      public static function Loading(param1:uint = 1, param2:uint = 1) : *
      {
         LoadingX(param1,param2);
         LoadEquipGo();
         LoadSkillGo();
      }
      
      public static function LoadingX(param1:uint = 1, param2:uint = 1) : *
      {
         var _loc4_:uint = 0;
         loadType = param1;
         who = param2;
         var _loc3_:uint = 1;
         if(Main.P1P2)
         {
            _loc3_ = 2;
         }
         if(loadType == 1)
         {
            _loc4_ = 1;
            while(_loc4_ <= _loc3_)
            {
               if(!Main["player" + _loc4_])
               {
                  Main["player" + _loc4_] = PlayerData.creatPlayerData(_loc4_);
               }
               Loading_Equip(Main["player" + _loc4_]);
               Loading_Skill(Main["player" + _loc4_]);
               _loc4_++;
            }
         }
         else if(loadType == 2 || loadType == 3)
         {
            Loading_Equip(Main["player" + param2]);
            Loading_Skill(Main["player" + param2]);
         }
         else if(loadType == 4)
         {
            Loading_Equip(PK_UI.whoData);
         }
      }
      
      private static function Loading_Equip(param1:PlayerData) : *
      {
         var _loc4_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc2_:PlayerData = param1;
         var _loc3_:uint = uint(_loc2_.skinArr[_loc2_.skinNum]);
         var _loc5_:String = "0";
         var _loc6_:Array = [1,6,7,9];
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_ = uint(_loc6_[_loc7_]);
            if(_loc2_.getEquipSlot().getEquipFromSlot(_loc8_) != null)
            {
               _loc4_ = _loc2_.getEquipSlot().getEquipFromSlot(_loc8_).getClassName3();
               _loc5_ = _loc2_.getEquipSlot().getEquipFromSlot(_loc8_).getClassName4();
            }
            else if(_loc7_ == 0 || _loc7_ == 3)
            {
               _loc4_ = 1;
               _loc5_ = "1_v2";
            }
            _loc9_ = zhuangBeiSkin[_loc3_][_loc4_];
            if(!_loc9_ && _loc5_ != "0")
            {
               _loc10_ = "equip_" + _loc3_ + "_" + _loc5_ + ".swf";
               _loc11_ = [_loc3_,_loc4_,_loc10_];
               loadArr.push(_loc11_);
            }
            _loc7_++;
         }
      }
      
      public static function PaiHangLoad(param1:Array) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc2_:int = 3;
         while(_loc2_ <= 4)
         {
            if(param1[_loc2_][0] != 0)
            {
               _loc3_ = int(param1[0]);
               _loc4_ = int(param1[_loc2_][0]);
               _loc5_ = param1[_loc2_][1];
               _loc6_ = param1[_loc2_][2];
               _loc7_ = zhuangBeiSkin[_loc3_][_loc4_];
               if(!_loc7_ && _loc5_ != "0")
               {
                  if(_loc5_ == 53)
                  {
                     _loc5_ = 12;
                  }
                  _loc8_ = "equip_" + _loc3_ + "_" + _loc5_ + ".swf";
                  _loc9_ = [_loc3_,_loc4_,_loc8_,_loc6_];
                  loadArr.push(_loc9_);
               }
            }
            _loc2_++;
         }
         loadType = 5;
         LoadEquipGo();
      }
      
      private static function LoadEquipGo() : *
      {
         Main._this._stage_txt.text += "loadArr.length = " + loadArr.length + "\n";
         Main._this._stage_txt.text += "loadArr = " + loadArr + "\n";
         if(loadArr.length > 0)
         {
            if(loadingYN)
            {
               zhuangBeiSkin[loadArr[0][0]][loadArr[0][1]] = new ClassLoader(loadArr[0][2]);
               zhuangBeiSkin[loadArr[0][0]][loadArr[0][1]].addEventListener(Event.COMPLETE,LoadEquipEnd);
               loadingYN = false;
            }
            if(Boolean(Play_Interface.interfaceX) && loadType != 5)
            {
               Play_Interface.interfaceX["load_mc"].visible = true;
            }
         }
         else
         {
            if(loadType == 1)
            {
               Main._this._stage_txt.text += "Load.newLoad_Ok()\n";
               Load.newLoad_Ok();
            }
            else if(loadType == 2)
            {
               Main.player_1.newSkin_LoadEnd();
               Main._this._stage_txt.text += "loadType 2\n";
            }
            else if(loadType == 3)
            {
               Main.player_2.newSkin_LoadEnd();
               Main._this._stage_txt.text += "loadType 3\n";
            }
            else if(loadType == 4)
            {
               PK_UI.LoadEnd_And_AddPlayer2();
            }
            else if(loadType == 5)
            {
               TiaoZhanPaiHang_Interface.ShowPlayer();
            }
            if(Play_Interface.interfaceX)
            {
               Play_Interface.interfaceX["load_mc"].visible = false;
            }
         }
      }
      
      private static function LoadEquipEnd(param1:*) : *
      {
         ++Load.loadName;
         loadArr.splice(0,1);
         loadingYN = true;
         LoadEquipGo();
      }
      
      private static function Loading_Skill(param1:PlayerData) : *
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:PlayerData = param1;
         var _loc3_:uint = 0;
         while(_loc3_ < 2)
         {
            _loc4_ = -1;
            if(_loc2_.getEquipSkillSlot().getGemFromSkillSlot(_loc3_))
            {
               if(int(_loc2_.getEquipSkillSlot().getGemFromSkillSlot(_loc3_).getClassName()) > 0)
               {
                  _loc4_ = int(_loc2_.getEquipSkillSlot().getGemFromSkillSlot(_loc3_).getClassName());
               }
            }
            if(_loc4_ != -1)
            {
               _loc5_ = "skill_" + _loc4_ + ".swf";
               loadLR.push([_loc4_,_loc5_]);
            }
            _loc3_++;
         }
      }
      
      private static function LoadSkillGo() : *
      {
         if(loadLR.length > 0)
         {
            if(boolYN)
            {
               enemySkill[loadLR[0][0]] = new ClassLoader(loadLR[0][1]);
               enemySkill[loadLR[0][0]].addEventListener(Event.COMPLETE,LoadSkillEnd);
               boolYN = false;
            }
         }
      }
      
      private static function LoadSkillEnd(param1:*) : *
      {
         ++Load.loadName;
         boolYN = true;
         loadLR.splice(0,1);
         LoadSkillGo();
      }
   }
}

