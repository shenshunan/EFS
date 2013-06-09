<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PipeList.aspx.cs" Inherits="PipeList" %>
<!--#include file="../checkLog.inc" -->
<!--
//*******************************
//** 设计人员：   Enjsky
//** 设计日期：   2009-10-28
//** 联系邮箱：   enjsky@163.com
//*******************************
-->
<HTML>
<head>
<title>事务类型列表</title>
<link rel="stylesheet" type="text/css" href="../css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../css/efs-all.css" />
<script type="text/javascript" src="../js/loadmask.js"></script>
<script type="text/javascript" src="../js/efs-all.js"></script>

<SCRIPT language="JavaScript">
Efs.onReady(function () {
    Efs.getDom("affList").setAttribute("txtXML", Efs.Common.getQryXml());
    Efs.getExt("affgrid").getStore().reload();
});
var PIPEID = "";
function onEditEx()
{
  if(PIPEID != "")
      location.href = "PipeEdit.aspx?PIPEID=" + PIPEID;
}

function onAddEx()
{
    location.href = "PipeAdd.aspx";
}
function Look3D() {
    location.href = "../MyTestPage.html";
}


var g_XML = Efs.Common.getQryXml();

function doGridClick(data){
    PIPEID = data["PIPEID"];
    if (PIPEID != "") {
    Efs.getExt("cmdEdit").enable();
    Efs.getExt("cmdDel").enable();
  }
}

function onDel()
{
    if(confirm("确定删除吗？"))
    {
        var strXml = Efs.getExt("affgrid").getDelXml();
        //var strXml = Efs.getExt("affgrid").getSelectedXml();
         //alert(strXml);
         Efs.getExt("frmDel").submit(strXml);

    }
  
}
// 获取异步提交的返回监听函数
function frmPostSubBack(bln,from,action)
{
  if(bln)
  {
    Efs.getExt("affgrid").store.reload();
  }
  else
  {
    var xml_http = action.response;
    if(xml_http != null )
    {
      var strRet = xml_http.responseText;
      var objXML = Efs.Common.createDocument(strRet);
      
      alert("加载失败：" + Efs.Common.getNodeValue(objXML,"//FUNCERROR",0));
      objXML = null;
    }
    xml_http = null;
  }
}

function doQry() {
    var strXml = Efs.Common.getQryXml(Efs.getExt("frmQry"))

    Efs.getDom("affList").setAttribute("txtXML", strXml);
    Efs.getExt("affgrid").store.load();
}
function doExcel() {
    Efs.getExt("winExcel").show();
}
function doExcelSubmit() {
    Efs.getExt("frmExcel").submit();
}
//excel导入返回
function frmExcelSubBack(bln, frm, action) {
    var xml_http = action.response;
    if (xml_http != null) {
        var obj = Ext.decode(xml_http.responseText);
        if (obj.success) {
            alert("上传成功");
            Efs.getExt("winExcel").hide();
            Efs.getExt("affgrid").store.reload();
        }
        else {
            alert("上传失败:" + obj.message);
        }
    }
    xml_http = null;
}
//导出excel
function doExpExcel() {
    Efs.Msg.wait();
    Efs.Common.ajax("../sysadmin/baseRefWeb.aspx?method=ExpExcel", "", function (succ, xml_http, options) {
        if (succ) { // 是否成功
            var xmlReturnDoc = xml_http.responseXML;

            Efs.Msg.alert("信息提示", "导出Excel成功，<a href='upload_files/" + xmlReturnDoc.selectSingleNode("//FUNCERROR").text + "' target='_blank'>请点击下载.</a>");

        }
        else {
            alert("加载数据失败!");
        }
    });

}
function doRet() {
    Efs.getExt("frmQry").reset();
}
</SCRIPT>
</HEAD>
<BODY>
<div id="roleTab" region="north" height="80" xtype="panel" border="false" title="海底管道数据列表">
   <form id="frmQry" method="post">
    <TABLE class="formAreaTop" width="100%" height="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td width="60">管道名称</td>
          <td width="100"><input type="text" class="Edit" fieldname="DATA1" operation="like" hint="模糊查询"></td>
          <td width="60">所属油田</td>
          <td width="100"><input type="text" class="Edit" fieldname="DATA2"></td>   
          <td width="60">所属海域</td>
          <td width="100"><INPUT type="text" kind="dic" src="DIC_DATA3" fieldname="DATA3" >           
          <td><input iconCls="icon-qry" type="button" value="查 询" onEfsClick="doQry()"></td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td width="60">所属公司</td>
          <td width="100"><input type="text" kind="dic" src="DIC_DATA4" fieldname="DATA4" ></td>
          <td width="60">设计单位</td>
          <td width="100"><input type="text" kind="dic" src="DIC_DATA5" fieldname="DATA5" ></td>   
          <td width="60">评估单位</td>
          <td width="100"><input type="text" kind="dic" src="DIC_DATA8" fieldname="DATA8" ></td>            
          <td><input type="button" value="清 空" onEfsClick="doRet()"></div></td>
          <td>&nbsp;</td>
        </tr>
        
      </TABLE>
    </form>
</div>
<div iconCls="icon-panel" id="affgrid" region="center" xtype="grid" pagingBar="true" pageSize="25" onEfsRowClick="doGridClick()" onEfsRowDblClick="onEditEx()">
     <div xtype="tbar">
       <div text="->"></div>
       <div iconCls="icon-qry" id="Div1" text="查看三维模型" onEfsClick="Look3D()"></div>
       <div text="->"></div>
       <div iconCls="icon-excel" id="cmdExcel" text="导入Excel" onEfsClick="doExcel()"></div>
       <div text="-"></div>
       <div iconCls="icon-excel" id="cmdExpExcel" text="导出Excel" onEfsClick="doExpExcel()"></div>
       <div text="-"></div>
       <div iconCls="icon-add" text="添加" onEfsClick="onAddEx()"></div>
      <div text="-"></div>
       <div iconCls="icon-edit" id="cmdEdit" text="编辑" onEfsClick="onEditEx()" disabled="true"></div>
      <div text="-"></div>
       <div iconCls="icon-del" id="cmdDel" text="删除" onEfsClick="onDel()" disabled="true"></div>
     </div>
    <div id="affList" xtype="store" url="../sysadmin/baseRefWeb.aspx?method=OrdersList" txtXML="" autoLoad="false">
      <div xtype="xmlreader" fieldid="PIPEID" record="ROW" tabName="PIPELINE" totalRecords="QUERYINFO@records">
         <div name="PIPEID"></div>
        <div name="DATA1"></div>
        <div name="DATA2"></div>
        <div name="DATA3"></div>
        <div name="DATA4"></div>
        <div name="DATA5"></div>
        <div name="DATA6"></div>
        <div name="DATA7"></div>
        <div name="DATA8"></div>
        <div name="DATA9"></div>
        <div name="DATA10"></div>
        <div name="DATA11"></div>
        <div name="DATA12"></div>
      </div>
    </div>
    <div xtype="colmodel">
    <div type="checkbox"></div>
      <div header="管道名称" width="80" sortable="true" dataIndex="DATA1"></div>
      <div header="所属油田" width="80" sortable="true" dataIndex="DATA2"></div>
      <div header="所属海域" width="80" sortable="true" dataIndex="DATA3"></div>
      <div header="所属公司" width="80" sortable="true" dataIndex="DATA4"></div>
      <div header="设计单位" width="40" sortable="true" dataIndex="DATA5"></div>
      <div header="建造单位" width="80" sortable="true" dataIndex="DATA6"></div>
      <div header="安装单位" width="80" sortable="true" dataIndex="DATA7"></div>
      <div header="评估单位" width="80" sortable="true" dataIndex="DATA8"></div>
      <div header="安装日期" width="80" sortable="true" dataIndex="DATA9"></div>
      <div header="调试日期" width="40" sortable="true" dataIndex="DATA10"></div>
      <div header="评估日期" width="80" sortable="true" dataIndex="DATA11"></div>
      <div header="录入日期" width="80" sortable="true" dataIndex="DATA12"></div>
    </div>
  </div>
<FORM id="frmPost" name="frmPost" url="" method="post" style="display:none;" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
    <INPUT type="hidden" name="txtDicName" value="AFFAIRTYPE">
  </FORM>

     <form id="frmDel" class="efs-box" method="post" url="../sysadmin/baseRefWeb.aspx?method=dealWithXml" onEfsSuccess="frmPostSubBack(true)" onEfsFailure="frmPostSubBack(false)">
     </form>
  <div xtype="window" id="winExcel" height="200" width="500" title="批量导入信息(Excel)">

  <form id="frmExcel" class="efs-box" method="post" url="UploadFile.aspx" method="post" onEfsSuccess="frmExcelSubBack(true)" onEfsFailure="frmExcelSubBack(false)" fileUpload="true">
    请选中一个Excel：<input type="file" name="file" style="width:300px">
  </form>

  <div xtype="buttons">
    <div text="确  定" onEfsClick="doExcelSubmit()"></div>
  </div>
  
</div>
</BODY>
</HTML>