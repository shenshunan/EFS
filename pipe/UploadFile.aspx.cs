using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Data.OleDb;
using Efsframe.cn.declare;
using Efsframe.cn.baseCls;
using Efsframe.cn.func;
using Efsframe.cn.db;

public partial class UploadFile : System.Web.UI.Page
{
    public string jSONString = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        try
        {
            string saveFoler = Server.MapPath("upload_files/");
            string savePath, fileName,newName = "";
            //遍历File表单元素  
            for (int iFile = 0; iFile < Request.Files.Count; iFile++)
            {
                HttpPostedFile postedFile = Request.Files[iFile];
                fileName = Path.GetFileName(postedFile.FileName);
                if (fileName != "")
                {
                    string fileType = fileName.Substring(fileName.LastIndexOf("."));
                    if (!fileType.ToLower().Equals(".xls"))
                    {
                        throw (new Exception("文件类型错误"));
                    }
                    // newName = "dbtask001" + fileType;
                    newName = Guid.NewGuid().ToString("N") + fileType;
                    savePath = saveFoler + newName;
                    //检查是否在服务器上已经存在用户上传的同名文件
                    if (File.Exists(savePath))
                    {
                        File.Delete(savePath);
                    }
                    postedFile.SaveAs(savePath);

                    // 文件保存完成了，现在开始分析Excel 导入到数据库中

                    string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + savePath + "; Extended Properties=Excel 8.0;";
                    OleDbConnection oleConn = new OleDbConnection(strConn);
                    oleConn.Open();
                    OleDbCommand mdo = new OleDbCommand("select * from  [sheet1$]", oleConn);
                    Boolean rsOpen = false;
                    OleDbDataReader rst = mdo.ExecuteReader();
                    DicCache obj_DicCache = DicCache.getInstance();
                    DataStorage obj_Storage = new DataStorage();

                    while (rst.Read())
                    {
                        //string dbdate = rst["打标日期"].ToString().Trim();

                        //string customid = obj_DicCache.getCode("DIC_CUSTOM", rst["客户"].ToString().Trim());

                        //if(dbdate != "" && customid != "")
                        //{

                            //string strtaskid = NumAssign.assignID_B("200001", General.curYear2() + General.curMonth());
                            //string strtasksubid = NumAssign.assignID_B("200005", customid + General.cDateStr(dbdate));
                        string PIPEID= NumAssign.assignID_B("100004", General.curYear2() + General.curMonth() + General.curDay());
                        string DATA1 = rst["管道名称"].ToString().Trim();
                        string sql = "insert into PIPELINE(PIPEID,DATA1) VALUES('"+PIPEID+"','"+DATA1+"')";

                            //string sql = "insert into BARCODETASK (TASKID,DQ,CUSTOMID,DBDATE,WRITETIME,TASKSUBID,SELLNO,XS,JB,DCTYPE,MODEL,ZPLX,CDZH,DBJDM,ZY,GROUPNUM,ORDNUM,STATUS,BAK) values ('" + strtaskid
                            //             + "','" + obj_DicCache.getCode("DIC_DQ", rst["地区"].ToString().Trim()) + "','"
                            //             + customid + "'," + General.formatDate(dbdate) + "," + General.formatDate(rst["任务下达日期"].ToString().Trim()) + ",'" + strtasksubid + "','"
                            //             + rst["销售单据号"].ToString().Trim() + "'," + rst["系数"].ToString().Trim() + ",'"
                            //             + obj_DicCache.getCode("DIC_JB", rst["极板"].ToString().Trim()) + "','"
                            //             + obj_DicCache.getCode("DIC_DCTYPE", rst["电池类型"].ToString().Trim()) + "','"
                            //             + obj_DicCache.getCode("DIC_MODEL", rst["型号"].ToString().Trim()) + "','"
                            //             + obj_DicCache.getCode("DIC_ZPLX", rst["装配类型"].ToString().Trim()) + "','"
                            //             + obj_DicCache.getCode("DIC_CDZH", rst["充电组号"].ToString().Trim()) + "','"
                            //             + obj_DicCache.getCode("DIC_DBJDM", rst["打码机器"].ToString().Trim()) + "','"
                            //             + obj_DicCache.getCode("DIC_ZY", rst["专用"].ToString().Trim()) + "'," + rst["组数"].ToString().Trim() + ",0,'0','"
                            //             + rst["备注"].ToString().Trim() + "')";
                            obj_Storage.addSQL(sql);
                        //}

                        rsOpen = true;
                    }

                    /// 执行
                    string str_Return = obj_Storage.runSQL();

                    if (!General.empty(str_Return))
                    {
                        throw (new Exception(str_Return));
                    }

                    if (rsOpen)
                        rst.Close();

                    oleConn.Close();

                }
            }

            jSONString = "{success:true,message:'上传完成!',filename:'" + newName + "'}";
        }//try
        catch(Exception ex)
        {
          jSONString = "{success:false,message:'" + ex.Message.Replace('\'','"') + "'}";
        }//catch
        Response.Write(jSONString);
        Response.Flush();
    }
}
