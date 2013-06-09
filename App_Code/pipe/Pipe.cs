using System;
using System.Xml;
using System.Data;
using System.Data.OleDb;
using Efsframe.cn.db;
using Efsframe.cn.declare;
using Efsframe.cn.func;
using Efsframe.cn.baseCls;

namespace Efsframe.cn.Orders
{
  /// <summary>
  /// Orders 的摘要说明
  /// </summary>
  public class Pipe
  {

    /// <summary>
    /// 添加订单
    /// </summary>
    /// <param name="strXml"></param>
    /// <returns></returns>
    public static string OrdersAdd(string strXml)
    {
      XmlDocument obj_Doc = XmlFun.CreateNewDoc(strXml);

      // 循环遍历所有的订单编号节点，为其分配统一的订单编码
      // 分配订单编码
      string strOrdID = NumAssign.assignID_B("100004", General.curYear2() + General.curMonth() + General.curDay());

      for (int i = 0; i < obj_Doc.SelectNodes("//PIPEID").Count; i++)
      {
        // obj_Doc.SelectNodes("//ORDID").Item(i).InnerText = strOrdID;
          XmlFun.setNodeValue(obj_Doc, "//PIPEID", i, strOrdID);
      }

      /// 调用统一的标准操作型xml的处理方法
      return Operation.dealWithXml(obj_Doc.InnerXml);
    }

    /// <summary>
    /// 删除订单信息
    /// </summary>
    /// <param name="strOrdID">订单编码</param>
    /// <returns></returns>
    public static string ordersDel(string strOrdID)
    {
      /// 创建执行对象
      DataStorage obj_Storage = new DataStorage();
      ReturnDoc obj_ReturnDoc = new ReturnDoc();

      // 手工构造sql语句
      string str_SQL = "DELETE FROM PIPELINE WHERE PIPEID='" + strOrdID + "'";
      obj_Storage.addSQL(str_SQL);

      str_SQL = "DELETE FROM PIPELINEDETAIL WHERE PIPEID='" + strOrdID + "'";
      obj_Storage.addSQL(str_SQL);

      str_SQL = "DELETE FROM PIPELINEDETAIL1 WHERE PIPEID='" + strOrdID + "'";
      obj_Storage.addSQL(str_SQL);

      /// 执行sql
      string str_Return = obj_Storage.runSQL();


      if (!General.empty(str_Return))
      {
        obj_ReturnDoc.addErrorResult(Common.RT_FUNCERROR);
        obj_ReturnDoc.setFuncErrorInfo(str_Return);
      }
      else
      {
        obj_ReturnDoc.addErrorResult(Common.RT_SUCCESS);
      }

      return obj_ReturnDoc.getXml();
    }

    /// <summary>
    /// 订单基本信息列表查询
    /// </summary>
    /// <param name="strXML"></param>
    /// <returns></returns>
    public static string ordersList(string strXML)
    {
      QueryDoc obj_Query = new QueryDoc(strXML);
      // 每页查询多少条记录
      int int_PageSize = obj_Query.getIntPageSize();
      // 查询第几页
      int int_CurrentPage = obj_Query.getIntCurrentPage();

      // 将xml分析成标准的where语句
      string str_Where = obj_Query.getConditions();

      str_Where = General.empty(str_Where) ? str_Where : Common.WHERE + str_Where;

      string str_Select = "*";

      string str_From = "PIPELINE s";


      return CommonQuery.basicListQuery(str_Select,
                                  str_From,
                                  str_Where,
                                  "PIPEID DESC",
                                  int_PageSize,
                                  int_CurrentPage);
    }



    /// <summary>
    /// 明细列表
    /// </summary>
    /// <param name="strOrderID">订单编号</param>
    /// <returns></returns>
    public static string ordersProList(string strOrderID)
    {
      string str_Where = "WHERE PIPEID='" + strOrderID + "'";

      string str_Select = "*";

      string str_From = "PIPELINEDETAIL s";

      string strProXml = CommonQuery.basicListQuery(str_Select,
                                  str_From,
                                  str_Where,
                                  "PIPEID",
                                  9999,
                                  1,
                                  "PIPELINEDETAIL");
      XmlDocument objProDom = XmlFun.CreateNewDoc(strProXml);

      for (int i = 0; i < objProDom.SelectNodes("//PIPELINEDETAIL").Count; i++)
      {
         XmlElement ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL").Item(i);
        ele.SetAttribute("operation", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA1").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA2").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA3").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "1");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA4").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "1");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA5").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA6").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA7").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA8").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");

        ele = (XmlElement)objProDom.SelectNodes("//PIPELINEDETAIL/DATA9").Item(i);
        ele.SetAttribute("state", "0");
        ele.SetAttribute("datatype", "0");
      }

      return objProDom.InnerXml;

    }


    public static string ordersDetail(string strOrderID)
    {

      string str_Where = "WHERE PIPEID='" + strOrderID + "'";

      string str_Select = "*";

      string str_From = "PIPELINE s";


      return CommonQuery.basicListQuery(str_Select,
                                  str_From,
                                  str_Where,
                                  "PIPEID DESC",
                                  1,
                                  1,
                                  "PIPELINE");

    }

    public static string ExpExcel(string path)
    {
        ReturnDoc obj_ReturnDoc = new ReturnDoc();
        try
        {


            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

            Microsoft.Office.Interop.Excel.Workbooks workbooks = xlApp.Workbooks;
            Microsoft.Office.Interop.Excel.Workbook workbook = workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);
            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];//取得sheet1 

            worksheet.Cells[1, 1] = "管道名称";


            // 数据查询

            OleDbDataReader rst = null;
            string ret = CommonQuery.qryRst("select * from PIPELINE", ref rst);
            Int16 i = 2;

            DicCache dic = DicCache.getInstance();

            if (ret.Equals("0"))
            {
                while (rst.Read())
                {
                    worksheet.Cells[i, 1] = rst["DATA1"].ToString();
                    i++;
                }

                rst.Close();
            }


            string sPath = path;
            string filename = "海底管道数据导出.xls";

            workbook.Saved = true;
            workbook.SaveCopyAs(sPath + filename);

            xlApp.Quit();


            obj_ReturnDoc.addErrorResult(Common.RT_SUCCESS);
            obj_ReturnDoc.setFuncErrorInfo(filename);


        }
        catch (Exception e)
        {
            obj_ReturnDoc.addErrorResult(Common.RT_FUNCERROR);
            obj_ReturnDoc.setFuncErrorInfo(e.Message);
        }

        return obj_ReturnDoc.getXml();



    }


  }
}
