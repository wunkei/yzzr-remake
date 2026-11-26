#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
勇者之刃 (Blade of Bravery / YZZR) 存档解密与加密工具
------------------------------------------------------
功能特性：
1. 全格式自动识别与解密 (decode)：
   - 支持 4399 云端导出的 JSON 存档文件（包含 index, title, data, datetime 等，支持自动脱壳与 zlib 解压）
   - 支持 zlib 压缩的 Base64 文本 (eNrs...)
   - 支持游戏原生导出的纯 Base64 文本 (CgsB...)
   - 自动处理路径两端包含的各种引号 (" 或 ')
2. 万能存档一键转换 (patch / make-universal)：
   - 可将【任意存档】（无论是谁的号、哪个槽位）一键注入 XiuZheng 异常放行特征，转为任何 4399 账号通用的万能存档！
3. 全流程循环引用破除与完美还原：
   - 优雅处理 ActionScript 3 中 EquipSlot.who -> PlayerData 的对象自循环引用
   - 解密输出为高可读性、可直接编辑的明文 JSON
   - 加密时自动重构 AMF3 对象引用表 (Object Table) 与特征表 (Trait Table)
4. 存档加密回写 (encode)：
   - 支持打包回 4399 云存档 JSON 格式（自动更新标题等级如 P1:Lv99、更新时间戳与 zlib 压缩）
   - 也支持导出为纯原生 Base64 字符串
5. 账号防盗签名重算 (sign)：
   - 还原原版 MD5contrast 算法，可为指定 4399 用户名与槽位生成合法 logNameSave。
"""

import sys
import os
import io
import json
import base64
import zlib
import struct
import hashlib
import random
import datetime
import argparse
from typing import Any, Dict, List, Tuple, Optional


# ==============================================================================
# AMF3 核心编解码引擎 (支持对象引用与循环破除)
# ==============================================================================

class AMF3Decoder:
    """AMF3 协议解码器"""
    def __init__(self, data: bytes):
        if len(data) > 0 and data[0] == 0x11:
            data = data[1:]
        self.stream = io.BytesIO(data)
        self.string_table: List[str] = []
        self.object_table: List[Any] = []
        self.trait_table: List[Dict[str, Any]] = []
        self.active_stack: List[int] = []

    def read_u29(self) -> int:
        b = self.stream.read(1)
        if not b:
            raise EOFError("读取 U29 遇到流末尾")
        val = b[0]
        if not (val & 0x80):
            return val
        val = (val & 0x7F) << 7
        b = self.stream.read(1)[0]
        if not (b & 0x80):
            return val | b
        val = (val | (b & 0x7F)) << 7
        b = self.stream.read(1)[0]
        if not (b & 0x80):
            return val | b
        val = (val | (b & 0x7F)) << 8
        b = self.stream.read(1)[0]
        return val | b

    def read_string(self) -> str:
        header = self.read_u29()
        if (header & 1) == 0:
            ref_idx = header >> 1
            if ref_idx >= len(self.string_table):
                raise ValueError(f"无效的字符串引用: {ref_idx}")
            return self.string_table[ref_idx]
        length = header >> 1
        if length == 0:
            return ""
        data = self.stream.read(length)
        s = data.decode("utf-8", errors="replace")
        self.string_table.append(s)
        return s

    def read_value(self) -> Any:
        marker_b = self.stream.read(1)
        if not marker_b:
            raise EOFError("读取类型标记时遇到流末尾")
        marker = marker_b[0]

        if marker == 0x00:  # undefined
            return None
        elif marker == 0x01:  # null
            return None
        elif marker == 0x02:  # false
            return False
        elif marker == 0x03:  # true
            return True
        elif marker == 0x04:  # integer (29位带符号整数)
            u29 = self.read_u29()
            if u29 >= (1 << 28):
                return u29 - (1 << 29)
            return u29
        elif marker == 0x05:  # double
            raw = self.stream.read(8)
            return struct.unpack(">d", raw)[0]
        elif marker == 0x06:  # string
            return self.read_string()
        elif marker == 0x07:  # xml doc
            header = self.read_u29()
            if (header & 1) == 0:
                return self.object_table[header >> 1]
            length = header >> 1
            xml_str = self.stream.read(length).decode("utf-8", errors="replace")
            res = {"__type__": "XMLDoc", "xml": xml_str}
            self.object_table.append(res)
            return res
        elif marker == 0x08:  # date
            header = self.read_u29()
            if (header & 1) == 0:
                return self.object_table[header >> 1]
            raw = self.stream.read(8)
            ms = struct.unpack(">d", raw)[0]
            res = {"__type__": "Date", "ms": ms}
            self.object_table.append(res)
            return res
        elif marker == 0x09:  # array
            header = self.read_u29()
            if (header & 1) == 0:
                ref_idx = header >> 1
                if ref_idx in self.active_stack:
                    return {"__ref_idx__": ref_idx}
                return self.object_table[ref_idx]

            dense_len = header >> 1
            assoc: Dict[str, Any] = {}
            dense: List[Any] = []
            
            placeholder: List[Any] = []
            cur_idx = len(self.object_table)
            self.object_table.append(placeholder)
            self.active_stack.append(cur_idx)

            while True:
                key = self.read_string()
                if key == "":
                    break
                assoc[key] = self.read_value()

            for _ in range(dense_len):
                dense.append(self.read_value())

            self.active_stack.pop()

            if assoc:
                if dense:
                    res_obj = {"__type__": "Array", "__dense__": dense, **assoc}
                else:
                    # 保全 Array 标记，确保 (obj is Array) 判定成立
                    res_obj = {"__type__": "Array", **assoc}
            else:
                res_obj = dense

            self.object_table[cur_idx] = res_obj
            return res_obj

        elif marker == 0x0A:  # object
            header = self.read_u29()
            if (header & 1) == 0:
                ref_idx = header >> 1
                if ref_idx in self.active_stack:
                    return {"__ref_idx__": ref_idx}
                return self.object_table[ref_idx]

            trait_header = header >> 1
            if (trait_header & 1) == 0:
                trait_idx = trait_header >> 1
                traits = self.trait_table[trait_idx]
            else:
                is_externalizable = bool(trait_header & 2)
                is_dynamic = bool(trait_header & 4)
                num_sealed = trait_header >> 3
                class_name = self.read_string()
                sealed_props = [self.read_string() for _ in range(num_sealed)]
                traits = {
                    "class_name": class_name,
                    "sealed_props": sealed_props,
                    "dynamic": is_dynamic,
                    "externalizable": is_externalizable
                }
                self.trait_table.append(traits)

            obj: Dict[str, Any] = {}
            cur_idx = len(self.object_table)
            self.object_table.append(obj)
            self.active_stack.append(cur_idx)

            if traits["externalizable"]:
                obj["__type__"] = "Externalizable"
                obj["__class__"] = traits["class_name"]
                self.active_stack.pop()
                return obj

            if traits["class_name"]:
                obj["__class__"] = traits["class_name"]
            if traits["sealed_props"]:
                obj["__props__"] = list(traits["sealed_props"])
            if traits["dynamic"]:
                obj["__dynamic__"] = True

            for prop in traits["sealed_props"]:
                obj[prop] = self.read_value()

            if traits["dynamic"]:
                while True:
                    key = self.read_string()
                    if key == "":
                        break
                    obj[key] = self.read_value()

            self.active_stack.pop()
            return obj

        elif marker == 0x0B:  # XML
            header = self.read_u29()
            if (header & 1) == 0:
                return self.object_table[header >> 1]
            length = header >> 1
            xml_str = self.stream.read(length).decode("utf-8", errors="replace")
            res = {"__type__": "XML", "xml": xml_str}
            self.object_table.append(res)
            return res

        elif marker == 0x0C:  # ByteArray
            header = self.read_u29()
            if (header & 1) == 0:
                return self.object_table[header >> 1]
            length = header >> 1
            raw_bytes = self.stream.read(length)
            res = {"__type__": "ByteArray", "b64": base64.b64encode(raw_bytes).decode("ascii")}
            self.object_table.append(res)
            return res
        else:
            raise ValueError(f"未知的 AMF3 数据类型标记: 0x{marker:02X}")


class AMF3Encoder:
    """AMF3 协议编码器 (支持对象引用表与显式引用映射)"""
    def __init__(self):
        self.stream = io.BytesIO()
        self.string_table: Dict[str, int] = {}
        self.trait_table: Dict[Tuple[str, Tuple[str, ...], bool], int] = {}
        self.object_table: Dict[int, int] = {}
        self.named_targets: Dict[str, Any] = {}
        self.obj_count = 0

    def register_target(self, name: str, obj: Any):
        self.named_targets[name] = obj

    def write_u29(self, val: int):
        val &= 0x1FFFFFFF
        if val < 0x80:
            self.stream.write(bytes([val]))
        elif val < 0x4000:
            self.stream.write(bytes([(val >> 7 & 0x7F) | 0x80, val & 0x7F]))
        elif val < 0x200000:
            self.stream.write(bytes([(val >> 14 & 0x7F) | 0x80, (val >> 7 & 0x7F) | 0x80, val & 0x7F]))
        else:
            self.stream.write(bytes([(val >> 22 & 0x7F) | 0x80, (val >> 15 & 0x7F) | 0x80, (val >> 8 & 0x7F) | 0x80, val & 0xFF]))

    def write_string(self, s: str):
        if s == "":
            self.write_u29(1)
            return
        if s in self.string_table:
            ref_idx = self.string_table[s]
            self.write_u29(ref_idx << 1)
        else:
            ref_idx = len(self.string_table)
            self.string_table[s] = ref_idx
            encoded = s.encode("utf-8")
            self.write_u29((len(encoded) << 1) | 1)
            self.stream.write(encoded)

    def write_value(self, val: Any, parent_key: Optional[str] = None):
        if val is None:
            self.stream.write(bytes([0x01]))
        elif isinstance(val, bool):
            self.stream.write(bytes([0x03 if val else 0x02]))
        elif isinstance(val, int):
            if -268435456 <= val <= 268435455:
                self.stream.write(bytes([0x04]))
                u29_val = val if val >= 0 else val + (1 << 29)
                self.write_u29(u29_val)
            else:
                self.stream.write(bytes([0x05]))
                self.stream.write(struct.pack(">d", float(val)))
        elif isinstance(val, float):
            self.stream.write(bytes([0x05]))
            self.stream.write(struct.pack(">d", val))
        elif isinstance(val, str):
            self.stream.write(bytes([0x06]))
            self.write_string(val)
        elif isinstance(val, list):
            oid = id(val)
            if oid in self.object_table:
                ref_idx = self.object_table[oid]
                self.stream.write(bytes([0x09]))
                self.write_u29(ref_idx << 1)
                return

            self.object_table[oid] = self.obj_count
            self.obj_count += 1

            self.stream.write(bytes([0x09]))
            self.write_u29((len(val) << 1) | 1)
            self.write_string("")
            for item in val:
                self.write_value(item)

        elif isinstance(val, dict):
            # 1. 显式回路引用标志
            if "__ref__" in val:
                target_key = val["__ref__"]
                target_obj = self.named_targets.get(target_key)
                if target_obj is not None and id(target_obj) in self.object_table:
                    ref_idx = self.object_table[id(target_obj)]
                    self.stream.write(bytes([0x0A]))
                    self.write_u29(ref_idx << 1)
                    return
            if "__ref_idx__" in val:
                ref_idx = int(val["__ref_idx__"])
                self.stream.write(bytes([0x0A]))
                self.write_u29(ref_idx << 1)
                return

            # 2. 检查是否为 AMF3 数组 (或者字段名为 NoLogInfo)
            # 必须输出为 0x09 (Array)，以确保 AS3 的 (obj is Array) 成立并保全 XiuZheng() 豁免
            is_array_type = (val.get("__type__") == "Array") or (parent_key == "NoLogInfo")

            if is_array_type:
                oid = id(val)
                if oid in self.object_table:
                    ref_idx = self.object_table[oid]
                    self.stream.write(bytes([0x09]))
                    self.write_u29(ref_idx << 1)
                    return

                self.object_table[oid] = self.obj_count
                self.obj_count += 1

                dense = val.get("__dense__", [])
                self.stream.write(bytes([0x09]))
                self.write_u29((len(dense) << 1) | 1)
                for k, v in val.items():
                    if not k.startswith("__"):
                        self.write_string(str(k))
                        self.write_value(v)
                self.write_string("")
                for item in dense:
                    self.write_value(item)
                return

            # 3. 特殊包装处理
            if val.get("__type__") == "ByteArray":
                oid = id(val)
                if oid in self.object_table:
                    ref_idx = self.object_table[oid]
                    self.stream.write(bytes([0x0C]))
                    self.write_u29(ref_idx << 1)
                    return
                self.object_table[oid] = self.obj_count
                self.obj_count += 1
                raw = base64.b64decode(val.get("b64", ""))
                self.stream.write(bytes([0x0C]))
                self.write_u29((len(raw) << 1) | 1)
                self.stream.write(raw)
                return
            elif val.get("__type__") == "Date":
                oid = id(val)
                if oid in self.object_table:
                    ref_idx = self.object_table[oid]
                    self.stream.write(bytes([0x08]))
                    self.write_u29(ref_idx << 1)
                    return
                self.object_table[oid] = self.obj_count
                self.obj_count += 1
                self.stream.write(bytes([0x08, 0x01]))
                self.stream.write(struct.pack(">d", float(val.get("ms", 0))))
                return
            elif val.get("__type__") == "XMLDoc":
                oid = id(val)
                if oid in self.object_table:
                    ref_idx = self.object_table[oid]
                    self.stream.write(bytes([0x07]))
                    self.write_u29(ref_idx << 1)
                    return
                self.object_table[oid] = self.obj_count
                self.obj_count += 1
                xml_raw = val.get("xml", "").encode("utf-8")
                self.stream.write(bytes([0x07]))
                self.write_u29((len(xml_raw) << 1) | 1)
                self.stream.write(xml_raw)
                return

            # 4. 普通 AMF3 对象 (0x0A)
            oid = id(val)
            if oid in self.object_table:
                ref_idx = self.object_table[oid]
                self.stream.write(bytes([0x0A]))
                self.write_u29(ref_idx << 1)
                return

            self.object_table[oid] = self.obj_count
            self.obj_count += 1

            self.stream.write(bytes([0x0A]))
            class_name = val.get("__class__", "")
            sealed_props = val.get("__props__", [])
            is_dynamic = val.get("__dynamic__", True if not sealed_props else False)

            trait_key = (class_name, tuple(sealed_props), is_dynamic)
            if trait_key in self.trait_table:
                trait_idx = self.trait_table[trait_key]
                self.write_u29((trait_idx << 2) | 0x01)
            else:
                trait_idx = len(self.trait_table)
                self.trait_table[trait_key] = trait_idx
                trait_header = (len(sealed_props) << 3) | (4 if is_dynamic else 0) | 1
                self.write_u29((trait_header << 1) | 1)
                self.write_string(class_name)
                for prop in sealed_props:
                    self.write_string(prop)

            for prop in sealed_props:
                self.write_value(val.get(prop, None), parent_key=prop)

            if is_dynamic:
                for k, v in val.items():
                    if not k.startswith("__") and k not in sealed_props:
                        self.write_string(str(k))
                        self.write_value(v, parent_key=str(k))
                self.write_string("")
        else:
            raise TypeError(f"无法序列化类型为 {type(val)} 的对象: {val}")

    def get_bytes(self) -> bytes:
        return self.stream.getvalue()


# ==============================================================================
# 万能免验证补丁核心逻辑
# ==============================================================================

def apply_universal_patch(save_obj: Dict[str, Any]) -> None:
    """
    一键注入万能全账号免验证补丁：
    1. 清除 NoLog 异常计数。
    2. 将 NoLogInfo 设置为包含 '4': None 的特殊 AMF3 稀疏数组，
       使得游戏在 Main.as: XiuZheng() 中触发 (NoLogInfo[4] < 1000) 恒为 true，
       从而在 JiaoYan2() 中强行放行，彻底无视任何账号 MD5 与槽位比对！
    3. 校准版本号 var，确保在合理版本区间 (1020 ~ 1920)。
    """
    save_obj["NoLog"] = 0
    save_obj["NoLogInfo"] = {
        "__type__": "Array",
        "2": None,
        "3": None,
        "4": None,  # 关键触发键：null < 1000 隐式转换为 0 < 1000 为 true
        "5": None,
        "7": None,
        "8": None,
        "9": None,
        "10": None,
        "11": None,
        "12": None,
        "13": None, # 辅助触发键
        "15": None
    }

    # 版本号校准
    cur_var = save_obj.get("var", 1503)
    if isinstance(cur_var, (int, float)):
        if cur_var < 1020:
            save_obj["var"] = 1503
        elif cur_var > 1920:
            save_obj["var"] = 1920


def is_universal_save(save_obj: Dict[str, Any]) -> bool:
    """检测当前存档是否已经具备万能免验证适配特征"""
    nolog_info = save_obj.get("NoLogInfo")
    if isinstance(nolog_info, dict):
        if "4" in nolog_info:
            v = nolog_info["4"]
            if v is None:
                return True
            if isinstance(v, (int, float)) and v < 1000:
                return True
        if "13" in nolog_info and nolog_info["13"]:
            return True
    return False


# ==============================================================================
# 存档多层解包与打包逻辑
# ==============================================================================

def clean_input_path(path_str: str) -> str:
    """清理用户输入路径两端的空白和各种中英文引号"""
    s = path_str.strip()
    while len(s) >= 2 and (
        (s[0] == '"' and s[-1] == '"') or
        (s[0] == "'" and s[-1] == "'") or
        (s[0] == '“' and s[-1] == '”') or
        (s[0] == '‘' and s[-1] == '’')
    ):
        s = s[1:-1].strip()
    return s


def unpack_save_content(raw_text: str) -> Tuple[Dict[str, Any], Optional[Dict[str, Any]], str]:
    text = raw_text.strip()
    cloud_meta: Optional[Dict[str, Any]] = None
    data_payload = text

    first_b = text.find("{")
    last_b = text.rfind("}")
    if first_b != -1 and last_b != -1 and last_b > first_b:
        try:
            parsed = json.loads(text[first_b:last_b+1])
            if isinstance(parsed, dict) and "data" in parsed:
                cloud_meta = {k: v for k, v in parsed.items() if k != "data"}
                data_payload = parsed["data"].strip()
            elif isinstance(parsed, dict) and "p1" in parsed:
                # 已经是明文 JSON 存档
                return parsed, parsed.get("__cloud_meta__"), "decrypted_json"
        except Exception:
            pass

    raw_bytes = base64.b64decode(data_payload)

    if len(raw_bytes) > 2 and raw_bytes[0] == 0x78:
        try:
            raw_bytes = zlib.decompress(raw_bytes)
        except Exception:
            pass

    if len(raw_bytes) > 1 and raw_bytes[0] == 0x06:
        dec_wrapper = AMF3Decoder(raw_bytes)
        inner_val = dec_wrapper.read_value()
        if isinstance(inner_val, str):
            raw_bytes = base64.b64decode(inner_val.strip())

    dec_final = AMF3Decoder(raw_bytes)
    save_obj = dec_final.read_value()
    if not isinstance(save_obj, dict):
        raise ValueError(f"反序列化得到的数据不是有效的存档字典: {type(save_obj)}")

    p1 = save_obj.get("p1")
    if isinstance(p1, dict):
        equip_slot = p1.get("equipSlot")
        if isinstance(equip_slot, dict):
            who = equip_slot.get("who")
            if who is p1 or (isinstance(who, dict) and "__ref_idx__" in who):
                equip_slot["who"] = {"__ref__": "root.p1"}

    p2 = save_obj.get("p2")
    if isinstance(p2, dict):
        equip_slot = p2.get("equipSlot")
        if isinstance(equip_slot, dict):
            who = equip_slot.get("who")
            if who is p2 or (isinstance(who, dict) and "__ref_idx__" in who):
                equip_slot["who"] = {"__ref__": "root.p2"}

    fmt = "4399_cloud_save" if cloud_meta is not None else "raw_base64"
    return save_obj, cloud_meta, fmt


def pack_save_content(save_obj: Dict[str, Any], cloud_meta: Optional[Dict[str, Any]] = None, force_cloud_format: bool = False, universal: bool = False) -> str:
    """
    将存档字典打包并编码：
    - universal=True: 自动注入万能免验证补丁。
    """
    if universal:
        apply_universal_patch(save_obj)

    encoder = AMF3Encoder()
    if "p1" in save_obj:
        encoder.register_target("root.p1", save_obj["p1"])
    if "p2" in save_obj:
        encoder.register_target("root.p2", save_obj["p2"])

    encoder.write_value(save_obj)
    core_amf3_bytes = encoder.get_bytes()
    core_b64_str = base64.b64encode(core_amf3_bytes).decode("ascii")

    if not cloud_meta and not force_cloud_format:
        return core_b64_str

    wrapper_encoder = AMF3Encoder()
    wrapper_encoder.write_value(core_b64_str)
    wrapper_bytes = wrapper_encoder.get_bytes()
    compressed_bytes = zlib.compress(wrapper_bytes)
    cloud_payload_b64 = base64.b64encode(compressed_bytes).decode("ascii")

    p1 = save_obj.get("p1", {})
    p1_lvl = extract_vt_value(p1.get("level")) if isinstance(p1, dict) else 1
    if p1_lvl is None:
        p1_lvl = 1
    
    title_str = f"P1:Lv{int(p1_lvl)}"
    if save_obj.get("P1P2"):
        p2 = save_obj.get("p2", {})
        p2_lvl = extract_vt_value(p2.get("level")) if isinstance(p2, dict) else 1
        title_str += f" / P2:Lv{int(p2_lvl) if p2_lvl else 1}"

    now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    meta_dict = cloud_meta.copy() if cloud_meta else {}
    if "index" not in meta_dict:
        meta_dict["index"] = "0"
    meta_dict["title"] = title_str
    meta_dict["data"] = cloud_payload_b64
    if "datetime" in meta_dict:
        meta_dict["datetime"] = now_str

    return json.dumps(meta_dict, ensure_ascii=False) + "\n0\n"


def calculate_log_name_save(username: str, slot: int) -> str:
    prefix = f"{random.randint(10000, 99999)}"
    slot_str = str(slot)
    user_hash = hashlib.md5(username.strip().lower().encode("utf-8")).hexdigest()[:8]
    return f"{prefix}{slot_str}{user_hash}"


def extract_vt_value(vt_obj: Any) -> Optional[float]:
    if isinstance(vt_obj, dict) and "value" in vt_obj and isinstance(vt_obj["value"], dict):
        inner = vt_obj["value"]
        if "num" in inner and "random" in inner:
            return inner["num"] - inner["random"]
    return None


def print_save_summary(data: Dict[str, Any], meta: Optional[Dict[str, Any]] = None):
    print("\n" + "=" * 60)
    print("【勇者之刃 存档数据概览】")
    print("=" * 60)
    if meta:
        print(f"云端槽位 (index)        : 第 {meta.get('index')} 槽位")
        print(f"云端标题 (title)        : {meta.get('title')}")
        print(f"最后存档时间 (datetime) : {meta.get('datetime')}")
        print("-" * 60)

    print(f"游戏版本号 (var)        : {data.get('var')}")
    print(f"游戏模式 (P1P2)         : {'双人模式' if data.get('P1P2') else '单人模式'}")
    print(f"防盗签名 (logNameSave)  : {data.get('logNameSave')}")
    print(f"存档日期 (saveTimeX)    : {data.get('saveTimeX')}")

    is_univ = is_universal_save(data)
    print(f"全账号免验证适配状态   : {'【已激活】(XiuZheng 逻辑自动放行任何账号)' if is_univ else '【未激活】(依赖 logNameSave 账号校验)'}")

    p1 = data.get("p1")
    if isinstance(p1, dict):
        print("-" * 60)
        print("【玩家 1 属性】")
        lvl = extract_vt_value(p1.get("level"))
        exp = extract_vt_value(p1.get("Exp"))
        gold = extract_vt_value(p1.get("gold"))
        pts = extract_vt_value(p1.get("points"))
        kp = extract_vt_value(p1.get("killPoint"))
        print(f"  等级 (Level)          : {int(lvl) if lvl is not None else p1.get('level')}")
        print(f"  经验 (Exp)            : {int(exp) if exp is not None else p1.get('Exp')}")
        print(f"  金币 (Gold)           : {int(gold) if gold is not None else p1.get('gold')}")
        print(f"  属性点 (Points)       : {int(pts) if pts is not None else p1.get('points')}")
        print(f"  击杀点 (KillPoint)    : {int(kp) if kp is not None else p1.get('killPoint')}")
        print(f"  当前时装代号 (skinNum): {p1.get('skinNum')}")

    p2 = data.get("p2")
    if data.get("P1P2") and isinstance(p2, dict):
        print("-" * 60)
        print("【玩家 2 属性】")
        lvl = extract_vt_value(p2.get("level"))
        gold = extract_vt_value(p2.get("gold"))
        print(f"  等级 (Level)          : {int(lvl) if lvl is not None else p2.get('level')}")
        print(f"  金币 (Gold)           : {int(gold) if gold is not None else p2.get('gold')}")

    guanka = data.get("guanKa")
    if isinstance(guanka, list):
        cleared = sum(1 for g in guanka if g and g > 0)
        print("-" * 60)
        print(f"关卡已通关数量          : {cleared} / {len(guanka)}")

    print("=" * 60 + "\n")


# ==============================================================================
# 命令交互与执行
# ==============================================================================

def cmd_decode(args):
    raw_path_or_str = clean_input_path(args.input)
    if os.path.exists(raw_path_or_str):
        with open(raw_path_or_str, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    else:
        content = raw_path_or_str

    print(f"[+] 正在解密存档数据 (输入长度: {len(content)} 字符)...")
    save_obj, meta, fmt = unpack_save_content(content)

    out_path = clean_input_path(args.output) if args.output else "save_decrypted.json"

    output_dict = save_obj.copy()
    if meta:
        output_dict["__cloud_meta__"] = meta

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(output_dict, f, ensure_ascii=False, indent=2)

    print(f"[✓] 解密成功！格式类型: [{fmt}]")
    print(f"[✓] 明文 JSON 文件已保存至: {os.path.abspath(out_path)}")
    print_save_summary(save_obj, meta)


def cmd_encode(args):
    json_path = clean_input_path(args.input)
    if not os.path.exists(json_path):
        print(f"[!] 找不到输入 JSON 文件: {json_path}", file=sys.stderr)
        sys.exit(1)

    print(f"[+] 正在从明文 JSON 加载数据: {json_path}...")
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    cloud_meta = data.pop("__cloud_meta__", None)

    if args.username is not None and args.slot is not None:
        new_sig = calculate_log_name_save(args.username, args.slot)
        data["logNameSave"] = new_sig
        print(f"[*] 已根据用户 '{args.username}' (槽位 {args.slot}) 更新签名: {new_sig}")

    # 万能补丁开关
    do_univ = not args.no_universal
    if do_univ:
        print("[*] 正在自动注入【万能全账号免验证补丁】(XiuZheng 放行逻辑)...")

    out_str = pack_save_content(data, cloud_meta=cloud_meta, force_cloud_format=args.cloud, universal=do_univ)

    out_path = clean_input_path(args.output) if args.output else ("save_encoded.txt" if not cloud_meta else "save_cloud.txt")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(out_str)

    print(f"[✓] 加密完成！目标文件: {os.path.abspath(out_path)} (长度: {len(out_str)} 字符)")


def cmd_patch(args):
    """一键将任意存档打上万能免验证补丁"""
    raw_path_or_str = clean_input_path(args.input)
    if os.path.exists(raw_path_or_str):
        with open(raw_path_or_str, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    else:
        content = raw_path_or_str

    print(f"[+] 正在读取并解密原存档数据...")
    save_obj, meta, fmt = unpack_save_content(content)

    print(f"[+] 正在注入【万能全账号免验证补丁】...")
    apply_universal_patch(save_obj)

    # 如果指定了目标槽位，同步修改 cloud_meta
    if args.slot is not None and meta:
        meta["index"] = str(args.slot)
        print(f"[*] 已更新云端槽位为第 {args.slot} 槽位")

    # 导出文件类型判断：如果以 .json 结尾则输出明文，否则默认打包回加密存档
    out_path = clean_input_path(args.output) if args.output else "save_universal.txt"
    if out_path.lower().endswith(".json"):
        out_dict = save_obj.copy()
        if meta:
            out_dict["__cloud_meta__"] = meta
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(out_dict, f, ensure_ascii=False, indent=2)
        print(f"[✓] 万能补丁注入成功！明文已保存至: {os.path.abspath(out_path)}")
    else:
        out_str = pack_save_content(save_obj, cloud_meta=meta, force_cloud_format=True)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(out_str)
        print(f"[✓] 万能补丁注入成功！已生成可在任何账号直接导入的云存档: {os.path.abspath(out_path)}")

    print_save_summary(save_obj, meta)


def cmd_info(args):
    raw_path_or_str = clean_input_path(args.input)
    if os.path.exists(raw_path_or_str):
        with open(raw_path_or_str, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    else:
        content = raw_path_or_str

    save_obj, meta, _ = unpack_save_content(content)
    print_save_summary(save_obj, meta)


def interactive_mode():
    print("=" * 60)
    print("  勇者之刃 存档加解密与编辑工具 (交互模式)")
    print("=" * 60)
    print("1. 解密存档 (输入/拖入存档文件或粘贴数据 -> 输出 JSON)")
    print("2. 加密存档 (读取修改后的 JSON -> 重新打包加密)")
    print("3. 一键制作万能存档 (输入任意存档 -> 直接转为全账号通用存档)")
    print("4. 重新计算账号防盗签名 (logNameSave)")
    print("0. 退出")
    print("=" * 60)

    choice = input("请输入功能序号 (0-4): ").strip()
    if choice == "1":
        print("\n请输入 Base64 存档文本，或者直接拖入存档文件路径:")
        user_input = clean_input_path(input("> "))
        if not user_input:
            print("输入为空，操作取消。")
            return
        if os.path.exists(user_input):
            with open(user_input, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        else:
            content = user_input

        try:
            save_obj, meta, fmt = unpack_save_content(content)
            out_file = clean_input_path(input("请输入保存明文的文件名 [默认 save_decrypted.json]: "))
            if not out_file:
                out_file = "save_decrypted.json"

            output_dict = save_obj.copy()
            if meta:
                output_dict["__cloud_meta__"] = meta

            with open(out_file, "w", encoding="utf-8") as f:
                json.dump(output_dict, f, ensure_ascii=False, indent=2)

            print(f"\n[✓] 解密完成！格式类型: [{fmt}]")
            print(f"[✓] 明文已保存至: {os.path.abspath(out_file)}")
            print_save_summary(save_obj, meta)
        except Exception as e:
            print(f"\n[!] 解密失败: {e}")

    elif choice == "2":
        json_file = clean_input_path(input("\n请输入修改后的明文 JSON 文件路径 [默认 save_decrypted.json]: "))
        if not json_file:
            json_file = "save_decrypted.json"
        if not os.path.exists(json_file):
            print(f"[!] 找不到文件: {json_file}")
            return
        try:
            with open(json_file, "r", encoding="utf-8") as f:
                data = json.load(f)

            cloud_meta = data.pop("__cloud_meta__", None)

            # 询问万能补丁
            ans_univ = input("是否启用【万能全账号免验证】补丁？(Y/n) [推荐直接回车]: ").strip().lower()
            do_univ = (ans_univ != "n")

            out_str = pack_save_content(data, cloud_meta=cloud_meta, universal=do_univ)
            default_out = "save_cloud.txt" if cloud_meta else "save_encoded.txt"
            out_file = clean_input_path(input(f"请输入保存密文的文件名 [默认 {default_out}]: "))
            if not out_file:
                out_file = default_out

            with open(out_file, "w", encoding="utf-8") as f:
                f.write(out_str)
            print(f"\n[✓] 加密完成，已保存至: {os.path.abspath(out_file)}")
        except Exception as e:
            print(f"\n[!] 加密失败: {e}")

    elif choice == "3":
        print("\n【一键制作万能存档】")
        print("说明：输入任意存档（如别人的 2.txt 或任意文本），直接生成可在任何账号加载的万能存档文件！")
        user_input = clean_input_path(input("请输入源存档文件路径或 Base64 文本: "))
        if not user_input:
            print("输入为空，操作取消。")
            return
        if os.path.exists(user_input):
            with open(user_input, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        else:
            content = user_input

        try:
            save_obj, meta, fmt = unpack_save_content(content)
            apply_universal_patch(save_obj)

            slot_str = input("是否指定云端槽位号 (0-7)？[直接回车保持原样]: ").strip()
            if slot_str and slot_str.isdigit() and meta:
                meta["index"] = slot_str

            out_file = clean_input_path(input("请输入生成的万能存档文件名 [默认 save_universal.txt]: "))
            if not out_file:
                out_file = "save_universal.txt"

            out_str = pack_save_content(save_obj, cloud_meta=meta, force_cloud_format=True)
            with open(out_file, "w", encoding="utf-8") as f:
                f.write(out_str)

            print(f"\n[✓] 转换成功！万能存档已保存至: {os.path.abspath(out_file)}")
            print("[*] 提示：该文件已通过 XiuZheng 异常放行逻辑打上免检补丁，可在任意 4399 账号的任意槽位直接导入！")
            print_save_summary(save_obj, meta)
        except Exception as e:
            print(f"\n[!] 转换失败: {e}")

    elif choice == "4":
        uname = input("\n请输入 4399 用户名: ").strip()
        slot = int(input("请输入存档槽位 (0-7): ").strip())
        sig = calculate_log_name_save(uname, slot)
        print(f"\n生成的合法 logNameSave: {sig}")


def main():
    if len(sys.argv) == 1:
        interactive_mode()
        return

    parser = argparse.ArgumentParser(description="勇者之刃 存档解密与加密工具")
    subparsers = parser.add_subparsers(dest="command", help="子命令")

    # decode
    p_decode = subparsers.add_parser("decode", help="解密 Base64/4399 云存档为 JSON")
    p_decode.add_argument("-i", "--input", required=True, help="Base64 字符串或存档文件路径")
    p_decode.add_argument("-o", "--output", default="save_decrypted.json", help="输出 JSON 文件路径")
    p_decode.set_defaults(func=cmd_decode)

    # encode
    p_encode = subparsers.add_parser("encode", help="将明文 JSON 加密回存档")
    p_encode.add_argument("-i", "--input", required=True, help="明文 JSON 文件路径")
    p_encode.add_argument("-o", "--output", default=None, help="输出文件路径")
    p_encode.add_argument("-u", "--username", default=None, help="目标 4399 用户名 (可选)")
    p_encode.add_argument("-s", "--slot", type=int, default=None, help="目标存档槽位 0-7 (可选)")
    p_encode.add_argument("--cloud", action="store_true", help="强制输出为 4399 云存档格式")
    p_encode.add_argument("--no-universal", action="store_true", help="关闭自动注入万能免验证补丁")
    p_encode.set_defaults(func=cmd_encode)

    # patch (一键万能化)
    p_patch = subparsers.add_parser("patch", help="一键将任意存档转换为万能全账号免验证存档")
    p_patch.add_argument("-i", "--input", required=True, help="源存档文件路径或 Base64 文本")
    p_patch.add_argument("-o", "--output", default="save_universal.txt", help="输出目标文件路径 (txt 或 json)")
    p_patch.add_argument("-s", "--slot", type=int, default=None, help="可选：指定云端槽位 0-7")
    p_patch.set_defaults(func=cmd_patch)

    # info
    p_info = subparsers.add_parser("info", help="查看存档概要信息")
    p_info.add_argument("-i", "--input", required=True, help="Base64 字符串或存档文件路径")
    p_info.set_defaults(func=cmd_info)

    args = parser.parse_args()
    if hasattr(args, "func"):
        args.func(args)
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
